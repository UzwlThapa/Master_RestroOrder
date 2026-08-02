SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_COMBOSAVE]    
@ComboID INT,    
@Name NVARCHAR(250),    
@Description NVARCHAR(MAX),    
@ComboCode NVARCHAR(250),    
@ImagePath NVARCHAR(250),    
@StartDate DATETIME,    
@EndDate DATETIME,  
@CostCenter INT,    
@SalesPrice DECIMAL(14, 4),    
@ItemsSalesCost DECIMAL(14, 4),    
@IsActive BIT,    
@AddedBy NVARCHAR(250)      
AS 
 DECLARE @ItemID INT;   
IF (@ComboID = 0)
BEGIN
 INSERT INTO RO_Combo (    
 Name,    
 Description,    
 ComboCode,    
 ImagePath,    
 StartDate,    
 EndDate,  
 CostCenterID,   
 SalesPrice,    
 ItemsSalesCost,    
 IsActive,    
 AddedBy,    
 IsDeleted) VALUES(    
 @Name,    
 @Description,    
 @ComboCode,    
 @ImagePath,    
 @StartDate,    
 @EndDate,   
 @CostCenter ,  
 @SalesPrice,    
 @ItemsSalesCost,    
 @IsActive,    
 @AddedBy,    
 0)

 SELECT @ItemID= @@IDENTITY  
 INSERT INTO [dbo].[ROI_ItemRateHistory]
           ([ItemID]
           ,[IsCombo]
           ,[AddedBy],OPERATION,Rate)
     VALUES
           (@ItemID
           ,1
           ,@AddedBy,1,@SalesPrice);
		   SELECT @ItemID  
END
ELSE
BEGIN
update RO_Combo
set
 Name=@Name,    
 Description=@Description,    
 ComboCode=@ComboCode,    
 ImagePath=@ImagePath,    
 StartDate=@StartDate,    
 EndDate=@EndDate,   
 CostCenterID=@CostCenter,  
 SalesPrice=@SalesPrice,    
 ItemsSalesCost=@ItemsSalesCost,    
 IsActive=@IsActive,    
UpdatedBy=@AddedBy
,UpdatedOn=GETDATE() 
where ComboID =@ComboID 

	SELECT cast(@ComboID  AS INT)

 SELECT @ItemID= @ComboID 
 INSERT INTO [dbo].[ROI_ItemRateHistory]
           ([ItemID]
           ,[IsCombo]
           ,[AddedBy],OPERATION,Rate)
     VALUES
           (@ItemID
           ,1
           ,@AddedBy,1,@SalesPrice);
		   SELECT @ItemID  
END




GO
