SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ENUMSAVE]
(
@EnumId int,
@CValue nvarchar(150),
@Type nvarchar(150),
@Order nvarchar(10)

)
AS

if(@EnumId = 0)
BEGIN
INSERT INTO RO_Enum(CValue, Typee, [Order]) values(@EnumId, @CValue, @Order)
END
else
begin
Update dbo.RO_Enum Set

CValue = @CValue,
Typee= @Type,
[Order] = @Order
WHERE EnumId = @EnumId

 end









GO
