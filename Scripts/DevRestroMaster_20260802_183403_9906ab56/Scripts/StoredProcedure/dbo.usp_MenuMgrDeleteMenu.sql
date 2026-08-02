SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrDeleteMenu]
@MenuID INT

AS
BEGIN
 DECLARE @CheckDefault BIT
 SET @CheckDefault = (SELECT IsDefault FROM Menu  WHERE MenuID =  @MenuID)
  IF(@CheckDefault <> 1)
   BEGIN
    DELETE FROM 
     MenuItem 
    WHERE 
     MenuID = @MenuID
    DELETE FROM 
     MenuPermission 
    WHERE 
     MenuID = @MenuID
    DELETE FROM 
     Menu 
    WHERE 
     MenuID = @MenuID
    DELETE FROM 
     MenuMgrSettingValue 
    WHERE 
     MenuID=@MenuID
    DELETE FROM 
     SageMenuSettingValue 
    WHERE 
      SettingKey='MenuID' 
     AND CAST(SettingValue AS INT)=@MenuID
   END
END





GO
