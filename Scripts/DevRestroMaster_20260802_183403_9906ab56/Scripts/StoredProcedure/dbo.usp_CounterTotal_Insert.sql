SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_CounterTotal_Insert]
			@CTID int output
		   ,@CID int output
		   ,@Balance decimal(18,2)
           ,@IsClosing bit
           ,@CCID int
           ,@DifAmount decimal(18,2)
           ,@Date date
		   ,@ApprovedBy int   
		   as
		   if(@CTID=0)
		   begin
INSERT INTO [dbo].[tbl_CounterTotal]
           ([CID]
		   ,[Balance]
           ,[IsClosing]
           ,[CCID]
           ,[DifAmount]
           ,[Date]
		   ,[ApprovedBy])
     VALUES
           (
		   @CID
		   ,@Balance
		   ,@IsClosing
           ,@CCID
           ,@DifAmount
           ,@Date
		   ,@ApprovedBy)
		   Select @@IDENTITY
		   end
		else
			begin
				update [dbo].[tbl_CounterTotal]
					set [CID]=@CID
					   ,[Balance]=@Balance
					   ,[IsClosing]=@IsClosing
					   ,[CCID]=@CCID
					   ,[DifAmount]=@DifAmount
					   ,[Date]=@Date
					   ,[ApprovedBy]=@ApprovedBy
					   where @CTID=CTID
				Select @CTID
			end




GO
