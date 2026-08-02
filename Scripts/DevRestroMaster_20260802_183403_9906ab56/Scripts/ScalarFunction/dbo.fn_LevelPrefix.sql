SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Dinesh Hona
-- Create date: <Create Date, ,>
-- Description: <Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_LevelPrefix]
(
 @Level int,
 @Prefix nvarchar(10)
)
RETURNS nvarchar(500)
AS
BEGIN
 DECLARE @ReturnValue nvarchar(255),@Counter int
 SET @ReturnValue=''
 SET @Counter=1
 WHILE(@Counter<=@Level)
 BEGIN
  SET @ReturnValue=@ReturnValue+@Prefix;
  SET @Counter=@Counter+1
 END
 RETURN @ReturnValue

END





GO
