SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_UNITSAVE]
(
@UnitID int,
@UnitName nvarchar(200)
)
AS

if(@UnitID = 0)
BEGIN
INSERT INTO RO_Units(UnitName) values(@UnitName)
END
else
begin
Update dbo.RO_Units Set

UnitName = @UnitName
WHERE UnitID=@UnitID

 end









GO
