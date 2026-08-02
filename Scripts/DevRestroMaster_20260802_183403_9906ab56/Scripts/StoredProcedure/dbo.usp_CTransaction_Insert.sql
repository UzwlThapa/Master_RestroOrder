SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_CTransaction_Insert]
			@CPBalID int output
           ,@CID int
           ,@IsOpening bit
           ,@Amount nchar(10)
           ,@NCPID int
           ,@Date datetime
           ,@CostCenterID int
           ,@OCPID int
		   as
INSERT INTO [dbo].[tbl_CTransaction]
           ([CID]
           ,[IsOpening]
           ,[Amount]
           ,[NCPID]
           ,[Date]
           ,[CostCenterID]
           ,[OCPID])
     VALUES
           (@CID
		   ,@IsOpening
		   ,@Amount
		   ,@NCPID
		   ,@Date
		   ,@CostCenterID
		   ,@OCPID
		   )
Select @@IDENTITY





GO
