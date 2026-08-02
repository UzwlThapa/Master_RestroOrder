SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SAVEPRODUCITONMASTER]
@ProductionInstantID INT,
@RawAssignAt datetime,
@ProductReleaseAt datetime,
@MainChef nvarchar(250),
@State int,
@AddedBy nvarchar(250),
@AddedOn datetime,
@ProductCompletedBy nvarchar(250)
AS
BEGIN
	insert into PR_ProductionInstant (
	RawAssignAt,
	ProductReleaseAt,
	MainChef,
	State,
	AddedBy,
	AddedOn,
	ProductCompletedBy)
	values(
	@RawAssignAt,
	@ProductReleaseAt,
	@MainChef,
	@State,
	@AddedBy,
	@AddedOn,
	@ProductCompletedBy
	)
	select CAST(@@IDENTITY  AS int)
	
END



GO
