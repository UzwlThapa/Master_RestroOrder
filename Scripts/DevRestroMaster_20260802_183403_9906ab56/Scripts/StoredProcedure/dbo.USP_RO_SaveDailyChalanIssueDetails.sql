SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [USP_RO_SaveDailyChalanIssueDetails] 123,'superuser','Customer',25
CREATE PROCEDURE [dbo].[USP_RO_SaveDailyChalanIssueDetails]  @issueID int,
  @IssuedAmount decimal(18,2),   
     @IssuedBy nvarchar(256),   
      @For nvarchar(256),  
   @DailyChalanId int  
AS  
BEGIN  
   If (@issueID=0)
   begin
 Insert into DailyChalanIssueDetails   
 (  
IssuedAmount,  
IssuedBy,  
[For],  
DailyChalanId  
  
 )  
 Values  
 (@IssuedAmount,   
     @IssuedBy,   
     @For,  
  @DailyChalanId  
     --@ReturnedBalance    
 )  
   
END  
else
begin

UPDATE DailyChalanIssueDetails SET
            IssuedAmount =  @IssuedAmount, IssuedBy = @IssuedBy, [For] = @For,
            DailyChalanId   = @DailyChalanId  
      WHERE issueID = @issueID

end
end



GO
