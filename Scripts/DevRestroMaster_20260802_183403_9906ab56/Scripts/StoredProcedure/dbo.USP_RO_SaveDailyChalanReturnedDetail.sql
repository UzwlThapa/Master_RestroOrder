SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from DailyChalanReturnedDetail
CREATE PROCEDURE [dbo].[USP_RO_SaveDailyChalanReturnedDetail]
	-- Add the parameters for the stored procedure here
	@returnedID int,
	@DailyChalanId int,
	 @ReturnedAmount decimal(18,2), 
     @ReturnedBy nvarchar(256), 
      @Remarks nvarchar(500) 
AS
BEGIN
	if (@returnedID = 0)
	begin
	Insert into DailyChalanReturnedDetail 
	(
	DailyChalanId,
    ReturnedAmount,
    ReturnedBy,
    Remarks
	)
	Values
	(@DailyChalanId,
	 @ReturnedAmount, 
     @ReturnedBy, 
     @Remarks
	)
END
else
begin 
UPDATE DailyChalanReturnedDetail SET
            ReturnedAmount =  @ReturnedAmount, ReturnedBy = @ReturnedBy, Remarks = @Remarks,
            DailyChalanId = @DailyChalanId
      WHERE returnedID = @returnedID

end
end



GO
