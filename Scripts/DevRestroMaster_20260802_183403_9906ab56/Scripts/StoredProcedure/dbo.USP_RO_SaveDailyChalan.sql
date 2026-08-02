SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[USP_RO_SaveDailyChalan] 5005,'Ashok',300,120
CREATE PROCEDURE [dbo].[USP_RO_SaveDailyChalan]
	-- Add the parameters for the stored procedure here
	@DailyChalanId int,
	 @TotalAmount decimal(18,2),
     @AssignedBy nvarchar(256), 
      @IssuedBalance decimal(18, 2),
     @ReturnedBalance decimal(18, 2) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from DailyChalanMaster
	SET NOCOUNT ON;
	if (@DailyChalanId = 0)
	begin
	Insert into DailyChalanMaster 
	(
TotalAmount,
AssignedBy,
IssuedBalance,
ReturnedBalance
	)
	Values
	(
	 @TotalAmount, 
     @AssignedBy, 
     @IssuedBalance,
     @ReturnedBalance  
	)
	SELECT cast(@@IDENTITY AS INT)
END
else
Begin

UPDATE DailyChalanMaster SET
            TotalAmount =  @TotalAmount, AssignedBy = @AssignedBy, IssuedBalance = @IssuedBalance,
            ReturnedBalance = @ReturnedBalance
      WHERE DailyChalanId = @DailyChalanId
	  SELECT cast(@DailyChalanId AS INT)  
end

end



GO
