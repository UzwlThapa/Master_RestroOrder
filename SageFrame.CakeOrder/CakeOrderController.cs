using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SageFrame.CakeOrder
{
    public class CakeOrderController
    {
        private CakeOrderProvider cakeOrderProvider;
        public CakeOrderController()
        {
            cakeOrderProvider = new CakeOrderProvider();
        }

        public int SaveCakeOrderIntoDatabase(CakeOrderMaster cakeOrderMaster,List<CakeOrderList> cakeOrderDetailList)
        {
            return cakeOrderProvider.CakeOrderMasterSaveToDatabase(cakeOrderMaster,cakeOrderDetailList);
        }

        public List<CakeOrderMaster> GetCakeOrders(string lookupName)
        {
            return cakeOrderProvider.GetCakeOrders(lookupName);
        }

        public List<WholeSaleOrderMaster> GetWholesaleOrders(string lookupName)
        {
            return cakeOrderProvider.GetWholesaleOrders(lookupName);
        }
        public List<CakeOrderList> getCakeOrderDetailByOrderMasterId(int orderMasterId,string SalesType)
        {
            return cakeOrderProvider.getOrderDetailByOrderMasterId(orderMasterId, SalesType);
        }
        public List<CustomerBilling> getActiveBILLTERM()
        {
            return cakeOrderProvider.getActiveBILLTERM();
        }

        public List<CakeOrderItems> GetPreviousCakeOrderById(int Id)
        {
            return cakeOrderProvider.GetPreviousCakeOrderById(Id);
        }

        public int saveCakeSalesBill(CakeSalesMaster sm, List<CakeSalesDetails> sd, List<CustomerBilling> bt, SalesPayMode spm, Cakeflatorperdiscount flatorperdiscount)
        {
            return cakeOrderProvider.saveCakeSalesBill(sm, sd, bt,spm,flatorperdiscount);
        }
        public void UpdateSalesPayMode(SalesPayMode spm)
        {
            cakeOrderProvider.UpdateSalesPayMode(spm);
        }

        public void CancelOrder(CakeOrderMaster orderMaster)
        {
            cakeOrderProvider.CancelOrder(orderMaster);
        }

        public List<CakeOrderList> GetOrderDetailsByMaster(int orderMasterId)
        {
            return cakeOrderProvider.GetOrderDetailsByMaster(orderMasterId);
        }
        public List<OrderExtraItems> GetOrderedExtraItemByOrderMaster(int orderMasterID)
        {
            return cakeOrderProvider.GetOrderedExtraItemByOrderMaster(orderMasterID);
        }
        public void SaveExtraOrderedItem(List<OrderExtraItems> addedExtra, List<OrderExtraItems> removedExtra)
        {
            cakeOrderProvider.SaveExtraOrderedItem(addedExtra, removedExtra);
        }
        public Tokens getOrderNobyOrderMasterId(int orderMasterId)
        {
            return cakeOrderProvider.getOrderNobyOrderMasterId(orderMasterId);
        }
    }
}