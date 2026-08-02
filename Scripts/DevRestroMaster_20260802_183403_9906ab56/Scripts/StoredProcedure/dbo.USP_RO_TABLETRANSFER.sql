SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_TABLETRANSFER] 
(

@OldTable int,
@NewTable int
)
AS

BEGIN



declare @val varchar(90)
	set @val= dbo.fn_getMaxMasterId(@OldTable)

Update dbo.RO_OrderMasters Set

TableId = @NewTable
where OrderMasterID = @val

 
 update dbo.RO_restroTable Set
 restrotablesStatusID = 6 where restrotableId = @OldTable-- or RO_restroTable.restrotableId = @val;

 update dbo.RO_restroTable Set
 restrotablesStatusID = 7 where restrotableId = @NewTable

 end






GO
