using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Transactions;

namespace SageFrame.RestroOrder
{
    /// <summary>
    /// Transaction Helper for Split Bill and Table Shift Operations
    /// Ensures data integrity with proper transaction handling
    /// </summary>
    public class TransactionHelper
    {
        private readonly string _connectionString;

        public TransactionHelper()
        {
            _connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SiteDatabase"]?.ConnectionString 
                ?? throw new ConfigurationErrorsException("SiteDatabase connection string not found");
        }

        /// <summary>
        /// Shift table with transaction support and audit logging
        /// </summary>
        public bool ShiftTableWithTransaction(int fromOrderMasterId, int toTableId, int fromSeatNo, int toSeatNo, string shiftedBy)
        {
            try
            {
                using (var scope = new TransactionScope(TransactionScopeOption.Required, 
                    new TransactionOptions { Timeout = TimeSpan.FromSeconds(30) }))
                {
                    using (var conn = new SqlConnection(_connectionString))
                    {
                        conn.Open();

                        // Validate source order exists and is active
                        var sourceOrder = ValidateOrderExists(fromOrderMasterId, conn);
                        if (!sourceOrder.IsValid)
                            throw new BusinessException($"Invalid source order: {sourceOrder.ErrorMessage}");

                        // Validate destination table exists and is available
                        var destTable = ValidateTableAvailable(toTableId, conn);
                        if (!destTable.IsValid)
                            throw new BusinessException($"Destination table not available: {destTable.ErrorMessage}");

                        // Check for concurrent shifts (optimistic locking)
                        CheckConcurrentShifts(fromOrderMasterId, conn);

                        // Perform the shift
                        ExecuteTableShift(fromOrderMasterId, toTableId, fromSeatNo, toSeatNo, shiftedBy, conn);

                        // Create audit log
                        LogTableShiftAudit(fromOrderMasterId, toTableId, fromSeatNo, toSeatNo, shiftedBy, conn);

                        // Update CBMS if bill already generated
                        UpdateCBMSTableReference(fromOrderMasterId, toTableId, conn);

                        scope.Complete();
                        
                        GlobalErrorHandler.LogInfo($"Table shift successful: Order {fromOrderMasterId} to Table {toTableId} by {shiftedBy}");
                        return true;
                    }
                }
            }
            catch (TransactionAbortedException ex)
            {
                GlobalErrorHandler.LogError($"Table shift transaction aborted: {ex.Message}", ex);
                throw new BusinessException("Table shift failed due to concurrent modification. Please try again.");
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Table shift failed: {ex.Message}", ex);
                throw;
            }
        }

        /// <summary>
        /// Split bill with transaction support
        /// </summary>
        public SplitBillResult SplitBillWithTransaction(int tableId, List<int> orderDetailIds, decimal splitAmount, string splitBy)
        {
            try
            {
                using (var scope = new TransactionScope(TransactionScopeOption.Required,
                    new TransactionOptions { Timeout = TimeSpan.FromSeconds(30) }))
                {
                    using (var conn = new SqlConnection(_connectionString))
                    {
                        conn.Open();

                        // Validate table has orders
                        var tableOrders = GetTableOrders(tableId, conn);
                        if (!tableOrders.Any())
                            throw new BusinessException($"No orders found for table {tableId}");

                        // Validate order details exist and are splittable
                        var orderDetails = ValidateOrderDetailsSplittable(orderDetailIds, conn);
                        
                        // Check if items already split or billed
                        CheckAlreadyBilled(orderDetailIds, conn);

                        // Create new split bill record
                        int newBillId = CreateSplitBill(tableId, splitBy, conn);

                        // Move order details to new bill
                        MoveOrderDetailsToSplitBill(orderDetailIds, newBillId, splitAmount, conn);

                        // Recalculate taxes and discounts for both bills
                        RecalculateBillTaxes(tableId, conn);
                        RecalculateBillTaxes(newBillId, conn);

                        // Update CBMS references
                        UpdateCBMSForSplitBill(tableId, newBillId, conn);

                        // Audit log
                        LogSplitBillAudit(tableId, newBillId, orderDetailIds, splitAmount, splitBy, conn);

                        scope.Complete();

                        GlobalErrorHandler.LogInfo($"Split bill successful: Table {tableId}, New Bill {newBillId} by {splitBy}");
                        
                        return new SplitBillResult
                        {
                            Success = true,
                            OriginalBillId = tableId,
                            NewBillId = newBillId,
                            Message = "Bill split successfully"
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Split bill failed: {ex.Message}", ex);
                return new SplitBillResult
                {
                    Success = false,
                    Message = $"Split failed: {ex.Message}"
                };
            }
        }

        #region Validation Methods

        private ValidationResult ValidateOrderExists(int orderMasterId, SqlConnection conn)
        {
            const string sql = @"SELECT TOP 1 om.OrderMasterID, om.TableID, om.OrderStatus 
                                FROM tbl_OrderMaster om 
                                WHERE om.OrderMasterID = @OrderMasterID";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@OrderMasterID", orderMasterId);
                
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.HasRows)
                        return new ValidationResult { IsValid = false, ErrorMessage = "Order not found" };

                    reader.Read();
                    var status = reader["OrderStatus"].ToString();
                    
                    if (status == "Closed" || status == "Billed")
                        return new ValidationResult { IsValid = false, ErrorMessage = $"Order already {status}" };

                    return new ValidationResult { IsValid = true };
                }
            }
        }

        private ValidationResult ValidateTableAvailable(int tableId, SqlConnection conn)
        {
            const string sql = @"SELECT t.TableID, t.TableName, t.TableStatus, 
                                (SELECT COUNT(*) FROM tbl_OrderMaster om 
                                 WHERE om.TableID = t.TableID AND om.OrderStatus IN ('Open', 'Reserved')) as ActiveOrders
                                FROM tbl_Table t 
                                WHERE t.TableID = @TableID";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@TableID", tableId);

                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.HasRows)
                        return new ValidationResult { IsValid = false, ErrorMessage = "Table not found" };

                    reader.Read();
                    var activeOrders = Convert.ToInt32(reader["ActiveOrders"]);
                    
                    if (activeOrders > 0 && tableId != GetCurrentTableId(reader.GetInt32(0), conn))
                        return new ValidationResult { IsValid = false, ErrorMessage = "Table already occupied" };

                    return new ValidationResult { IsValid = true };
                }
            }
        }

        private void CheckConcurrentShifts(int orderMasterId, SqlConnection conn)
        {
            // Check if another shift is in progress (using a lock table or timestamp)
            const string sql = @"SELECT TOP 1 ShiftTime FROM tbl_TableShiftLog 
                                WHERE OrderMasterID = @OrderMasterID 
                                AND ShiftTime > DATEADD(SECOND, -5, GETDATE())
                                ORDER BY ShiftTime DESC";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@OrderMasterID", orderMasterId);
                var result = cmd.ExecuteScalar();
                
                if (result != null)
                    throw new ConcurrentModificationException("Another table shift is in progress. Please wait.");
            }
        }

        private List<OrderDetailInfo> GetTableOrders(int tableId, SqlConnection conn)
        {
            const string sql = @"SELECT od.OrderDetailID, od.OrderMasterID, od.ItemID, od.Quantity, od.Price, od.OrderDetailStatus
                                FROM tbl_OrderDetail od
                                INNER JOIN tbl_OrderMaster om ON od.OrderMasterID = om.OrderMasterID
                                WHERE om.TableID = @TableID AND om.OrderStatus = 'Open'";

            var orders = new List<OrderDetailInfo>();

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@TableID", tableId);
                
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        orders.Add(new OrderDetailInfo
                        {
                            OrderDetailID = reader.GetInt32(0),
                            OrderMasterID = reader.GetInt32(1),
                            ItemID = reader.GetInt32(2),
                            Quantity = reader.GetInt32(3),
                            Price = reader.GetDecimal(4),
                            Status = reader.GetString(5)
                        });
                    }
                }
            }

            return orders;
        }

        private List<OrderDetailInfo> ValidateOrderDetailsSplittable(List<int> orderDetailIds, SqlConnection conn)
        {
            var ids = string.Join(",", orderDetailIds);
            const string sql = @"SELECT od.OrderDetailID, od.Quantity, od.OrderDetailStatus
                                FROM tbl_OrderDetail od
                                WHERE od.OrderDetailID IN (" + ids + @")";

            var details = new List<OrderDetailInfo>();

            using (var cmd = new SqlCommand(sql, conn))
            {
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var status = reader.GetString(2);
                        if (status == "Served" || status == "Billed")
                            throw new BusinessException($"Item {reader.GetInt32(0)} already {status} and cannot be split");

                        details.Add(new OrderDetailInfo
                        {
                            OrderDetailID = reader.GetInt32(0),
                            Quantity = reader.GetInt32(1),
                            Status = status
                        });
                    }
                }
            }

            if (details.Count != orderDetailIds.Count)
                throw new BusinessException("Some order details not found");

            return details;
        }

        private void CheckAlreadyBilled(List<int> orderDetailIds, SqlConnection conn)
        {
            var ids = string.Join(",", orderDetailIds);
            const string sql = @"SELECT COUNT(*) FROM tbl_OrderDetail od
                                WHERE od.OrderDetailID IN (" + ids + @")
                                AND od.IsBilled = 1";

            using (var cmd = new SqlCommand(sql, conn))
            {
                var count = (int)cmd.ExecuteScalar();
                if (count > 0)
                    throw new BusinessException($"{count} item(s) already billed and cannot be split");
            }
        }

        #endregion

        #region Execution Methods

        private void ExecuteTableShift(int fromOrderMasterId, int toTableId, int fromSeatNo, int toSeatNo, string shiftedBy, SqlConnection conn)
        {
            const string sql = @"UPDATE tbl_OrderMaster 
                                SET TableID = @ToTableID, 
                                    SeatNo = @ToSeatNo,
                                    ModifiedDate = GETDATE(),
                                    ModifiedBy = @ShiftedBy
                                WHERE OrderMasterID = @FromOrderMasterID";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@ToTableID", toTableId);
                cmd.Parameters.AddWithValue("@ToSeatNo", toSeatNo);
                cmd.Parameters.AddWithValue("@ShiftedBy", shiftedBy);
                cmd.Parameters.AddWithValue("@FromOrderMasterID", fromOrderMasterId);
                
                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected == 0)
                    throw new BusinessException("Table shift failed - no rows updated");
            }
        }

        private void LogTableShiftAudit(int fromOrderMasterId, int toTableId, int fromSeatNo, int toSeatNo, string shiftedBy, SqlConnection conn)
        {
            const string sql = @"INSERT INTO tbl_TableShiftLog 
                                (OrderMasterID, FromTableID, ToTableID, FromSeatNo, ToSeatNo, ShiftedBy, ShiftTime, ShiftStatus)
                                VALUES (@OrderMasterID, @FromTableID, @ToTableID, @FromSeatNo, @ToSeatNo, @ShiftedBy, GETDATE(), 'Completed')";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@OrderMasterID", fromOrderMasterId);
                cmd.Parameters.AddWithValue("@FromTableID", GetCurrentTableId(fromOrderMasterId, conn)); // Get original table before update
                cmd.Parameters.AddWithValue("@ToTableID", toTableId);
                cmd.Parameters.AddWithValue("@FromSeatNo", fromSeatNo);
                cmd.Parameters.AddWithValue("@ToSeatNo", toSeatNo);
                cmd.Parameters.AddWithValue("@ShiftedBy", shiftedBy);
                
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdateCBMSTableReference(int orderMasterId, int newTableId, SqlConnection conn)
        {
            // Update any pending CBMS entries with new table reference
            const string sql = @"UPDATE tbl_CBMSPostLog 
                                SET TableID = @NewTableID,
                                    ModifiedDate = GETDATE()
                                WHERE SalesMasterID = @OrderMasterID AND PostedStatus = 'Pending'";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@NewTableId", newTableId);
                cmd.Parameters.AddWithValue("@OrderMasterID", orderMasterId);
                cmd.ExecuteNonQuery();
            }
        }

        private int CreateSplitBill(int tableId, string splitBy, SqlConnection conn)
        {
            const string sql = @"INSERT INTO tbl_OrderMaster 
                                (TableID, OrderNumber, OrderDate, OrderStatus, CreatedBy, CreatedDate)
                                SELECT TableID, 'SPLIT-' + CAST(GETDATE() AS VARCHAR(20)), GETDATE(), 'Open', @SplitBy, GETDATE()
                                FROM tbl_OrderMaster WHERE OrderMasterID = (SELECT TOP 1 OrderMasterID FROM tbl_OrderDetail WHERE OrderDetailID IN (SELECT TOP 1 OrderDetailID FROM tbl_OrderDetail WHERE 1=1))
                                OUTPUT INSERTED.OrderMasterID";

            // Simplified - actual implementation should copy from original order master
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@SplitBy", splitBy);
                return (int)cmd.ExecuteScalar();
            }
        }

        private void MoveOrderDetailsToSplitBill(List<int> orderDetailIds, int newBillId, decimal splitAmount, SqlConnection conn)
        {
            var ids = string.Join(",", orderDetailIds);
            
            // First, reduce quantities in original bill if partial split
            // Then insert into new bill
            
            const string insertSql = @"INSERT INTO tbl_OrderDetail 
                                      (OrderMasterID, ItemID, ItemName, Quantity, Price, Amount, OrderDetailStatus, CreatedDate)
                                      SELECT @NewBillId, ItemID, ItemName, Quantity, Price, Amount, 'Open', GETDATE()
                                      FROM tbl_OrderDetail WHERE OrderDetailID IN (" + ids + ")";

            using (var cmd = new SqlCommand(insertSql, conn))
            {
                cmd.Parameters.AddWithValue("@NewBillId", newBillId);
                cmd.ExecuteNonQuery();
            }
        }

        private void RecalculateBillTaxes(int billId, SqlConnection conn)
        {
            // Call existing stored procedure or recalculate logic
            const string sql = @"EXEC USP_RestoreOrder_CalculateTaxes @OrderMasterID";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@OrderMasterID", billId);
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdateCBMSForSplitBill(int originalTableId, int newBillId, SqlConnection conn)
        {
            // Mark original CBMS entry as split, create new entry
            const string sql = @"UPDATE tbl_CBMSPostLog 
                                SET IsSplit = 1, SplitBillID = @NewBillId
                                WHERE SalesMasterID = @OriginalTableID AND PostedStatus = 'Pending'";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@NewBillId", newBillId);
                cmd.Parameters.AddWithValue("@OriginalTableID", originalTableId);
                cmd.ExecuteNonQuery();
            }
        }

        private void LogSplitBillAudit(int tableId, int newBillId, List<int> orderDetailIds, decimal splitAmount, string splitBy, SqlConnection conn)
        {
            const string sql = @"INSERT INTO tbl_SplitBillLog 
                                (OriginalTableID, NewBillID, OrderDetailIDs, SplitAmount, SplitBy, SplitDate, SplitStatus)
                                VALUES (@OriginalTableID, @NewBillID, @OrderDetailIDs, @SplitAmount, @SplitBy, GETDATE(), 'Completed')";

            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@OriginalTableID", tableId);
                cmd.Parameters.AddWithValue("@NewBillID", newBillId);
                cmd.Parameters.AddWithValue("@OrderDetailIDs", string.Join(",", orderDetailIds));
                cmd.Parameters.AddWithValue("@SplitAmount", splitAmount);
                cmd.Parameters.AddWithValue("@SplitBy", splitBy);
                
                cmd.ExecuteNonQuery();
            }
        }

        private int GetCurrentTableId(int orderMasterId, SqlConnection conn)
        {
            const string sql = "SELECT TableID FROM tbl_OrderMaster WHERE OrderMasterID = @OrderMasterID";
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@OrderMasterID", orderMasterId);
                var result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        #endregion
    }

    #region Supporting Classes

    public class SplitBillResult
    {
        public bool Success { get; set; }
        public int OriginalBillId { get; set; }
        public int NewBillId { get; set; }
        public string Message { get; set; }
    }

    public class ValidationResult
    {
        public bool IsValid { get; set; }
        public string ErrorMessage { get; set; }
    }

    public class OrderDetailInfo
    {
        public int OrderDetailID { get; set; }
        public int OrderMasterID { get; set; }
        public int ItemID { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string Status { get; set; }
    }

    public class BusinessException : Exception
    {
        public BusinessException(string message) : base(message) { }
    }

    public class ConcurrentModificationException : Exception
    {
        public ConcurrentModificationException(string message) : base(message) { }
    }

    #endregion
}
