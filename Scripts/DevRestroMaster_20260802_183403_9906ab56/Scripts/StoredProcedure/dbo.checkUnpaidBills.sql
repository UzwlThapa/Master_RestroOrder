SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[checkUnpaidBills] 
@salesMasterId int 
as
BEGIN
DECLARE @IsArchived bit
,@IsUpdated bit
,@code int

select @IsArchived=IsArchived, @IsUpdated=IsUpdated from RO_SalesMaster where salesMasterId = @salesMasterId 

if(@IsUpdated = 1)
set @code = 200 
else if(@IsArchived = 1)
set @code = 200 
else
set @code =  100 


select @code
END

GO
