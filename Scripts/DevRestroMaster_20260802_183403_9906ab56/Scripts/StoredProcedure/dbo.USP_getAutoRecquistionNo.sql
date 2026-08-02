SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_getAutoRecquistionNo]
AS
BEGIN
	DECLARE @prefix VARCHAR(128) = 'Req_'
	DECLARE @code VARCHAR(max)
	DECLARE @val VARCHAR(MAX)

	IF (
			(
				SELECT COUNT(*)
				FROM dbo.Req_Recquistion
				where IsDeleted=0
				) > 0
			)
	BEGIN
		SELECT @val = CAST(MAX(CAST(SUBSTRING(RecqNo, LEN(1) + 4, LEN(RecqNo) - LEN('Req_')) AS INT)) + 1 AS VARCHAR(100))
		FROM dbo.Req_Recquistion
		WHERE IsDeleted = 0

		SET @code = @prefix + @val

		SELECT @code
	END
	ELSE
	BEGIN
		SET @code = @prefix + CAST(1 AS VARCHAR)

		SELECT @code
	END
END

-----------------------------------------------------------------------------------------------------

GO
