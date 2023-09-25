create procedure [dbo].[usp_L_LaundryDetails_SaveLaundryDetails]
@lmasterid int,
@clothid int,
@materialid int,
@color nvarchar(max),
@descrip nvarchar(max),
@ltypeid int,
@quantity int

as

insert into dbo.L_LaundryDetails(LaundryMasterID,ClothID,MaterialID,Color,Description,LaundryTypeID,Quantity)
values(@lmasterid,@clothid,@materialid,@color,@descrip,@ltypeid,@quantity)
