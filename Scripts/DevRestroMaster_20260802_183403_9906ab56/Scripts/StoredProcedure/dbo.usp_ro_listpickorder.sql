SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_listpickorder]  
AS  
BEGIN  
DECLAre @temp table(OrderID int,Name nvarchar(256),OrderDate varchar(10),OrderTime nvarchar(20),AppoinmentReceiveDate nvarchar(20)
,AppoinmentReceiveTime nvarchar(256),itemName nvarchar(500))
insert into @temp 
select distinct co.OrderID, co.Name,co.OrderDate,  
 co.OrderTime,  
 case when co.AppoinmentReceiveDate= '0' then '-' else co.AppoinmentReceiveDate end AppoinmentReceiveDate,  
 case when co.AppoinmentReceiveTime= '0' then '-' else co.AppoinmentReceiveTime end AppoinmentReceiveTime,  
 it.ITName +' ('+ Cast(od.Quantity as varchar(5))+')' itemName
 FROM dbo.RO_OrderMasters om   
 JOIN dbo.RO_Order_Detail od ON od.OrderMasterId = om.OrderMasterID   
 JOIN dbo.tbl_CusOrder co ON co.OrderID=om.OID   
 JOIN dbo.ROI_ITEMMain it ON it.ITId = od.ROI_ItemId    
 where om.BillPaid=0 AND OD.IsCombo=0 AND om.OID IS NOT NULL  
 union all
 select distinct co.OrderID, co.Name,co.OrderDate,  
 co.OrderTime,  
 case when co.AppoinmentReceiveDate= '0' then '-' else co.AppoinmentReceiveDate end AppoinmentReceiveDate,  
 case when co.AppoinmentReceiveTime= '0' then '-' else co.AppoinmentReceiveTime end AppoinmentReceiveTime,  
 ' '+it.Name +' ('+ Cast(od.Quantity as varchar(5))+')' itemName
 FROM dbo.RO_OrderMasters om   
 JOIN dbo.RO_Order_Detail od ON od.OrderMasterId = om.OrderMasterID   
 JOIN dbo.tbl_CusOrder co ON co.OrderID=om.OID   
 JOIN dbo.RO_Combo it ON it.ComboID = od.ROI_ItemId    
 where om.BillPaid=0 AND OD.IsCombo=1  AND om.OID IS NOT NULL


 select OrderID,[Name],OrderDate,OrderTime,AppoinmentReceiveDate,AppoinmentReceiveTime,STUFF(
         (SELECT DISTINCT ',' + itemName
          FROM @temp
          WHERE OrderID = a.[OrderID] 
          FOR XML PATH (''))
          , 1, 1, '') as itemName from @temp as a
		  group by  OrderID,[Name],OrderDate,OrderTime,AppoinmentReceiveDate,AppoinmentReceiveTime
END   
  



GO
