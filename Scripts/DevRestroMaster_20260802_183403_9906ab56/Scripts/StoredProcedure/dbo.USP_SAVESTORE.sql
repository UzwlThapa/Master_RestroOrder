SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SAVESTORE]
@STId INT,
@StName varchar(50),
@PSTId INT,
@UserName nvarchar(256)
AS
BEGIN
	IF(@STId<1)
	BEGIN
	INSERT INTO DBO.ROI_Store  (StName,PSTId,AddedBy,AddedOn) VALUES (@StName,@PSTId,@UserName,GETDATE())
	END
	ELSE
	BEGIN
	UPDATE  DBO.ROI_Store  set StName = @StName, PSTId=@PSTId,ModifiedBy = @UserName,ModifiedOn = getdate() where STId=@STId
	END
END

select * from ROI_Store




GO
