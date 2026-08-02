SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
--[usp_MsgTempTypeUniquenessCheck] 'account Activation - Email',1,0
CREATE PROCEDURE [dbo].[usp_MsgTempTypeUniquenessCheck]
 @MsgTemplateTypeName nvarchar(256),
 @PortalID int,
 @IsUnique bit output
 
AS
BEGIN
IF(EXISTS(SELECT * FROM [dbo].[MessageTemplateType] WHERE (IsDeleted=0 OR IsDeleted IS NULL) AND 
 PortalID = @PortalID AND Name = @MsgTemplateTypeName ))
  BEGIN
   SET @IsUnique = CAST(0 as bit) 
  END
  ELSE
  BEGIN
   SET @IsUnique = CAST(1 as bit)
  END

END





GO
