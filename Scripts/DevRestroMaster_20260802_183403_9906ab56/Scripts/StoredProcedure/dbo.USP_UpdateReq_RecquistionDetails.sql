SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateReq_RecquistionDetails]
@RecqDetailId INT,
@RecqId INT,
@IssueQuantity decimal(10,2)
As
declare @statusid INT,@Issued decimal(10,2),@RequestedQnty decimal(10,2)

select @RequestedQnty=Quantity,@Issued=isnull(IssuedQuantity,0) from Req_RecquistionDetails where RecqDetailId=@RecqDetailId

if((@Issued +@IssueQuantity) < @RequestedQnty)
begin
set @statusid=2
end

else
begin
set @statusid=4 
end

update Req_RecquistionDetails set IssuedQuantity=(isnull(IssuedQuantity,0) + @IssueQuantity), StatusId = @statusid where RecqDetailId=@RecqDetailId

	DECLARE @inpCount INT
		,@reqCount INT

	SET @reqCount = (
			SELECT count(*)
			FROM Req_RecquistionDetails
			WHERE StatusId = 8
				AND RecqId = @RecqId
			)
	SET @inpCount = (
			SELECT count(*)
			FROM Req_RecquistionDetails
			WHERE StatusId = 2
				AND RecqId = @RecqId
			)


	UPDATE Req_Recquistion
	SET StatusId = (
			CASE 
				WHEN @reqCount = 0
					AND @inpCount = 0
					THEN 4
				ELSE 2
				END
			)
	WHERE RecqId = @RecqId

GO
