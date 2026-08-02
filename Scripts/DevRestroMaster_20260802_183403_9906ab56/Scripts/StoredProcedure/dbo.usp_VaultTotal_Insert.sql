SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from tbl_ROVaultTotal

CREATE PROCEDURE [dbo].[usp_VaultTotal_Insert]
@TotalID int output,
@Balance decimal(16,2),
@IsClosing bit,
@Date datetime,
@CCID int,
@DiffAmount decimal(16,2),
@ApprovedBy nvarchar(256)
as
if(@TotalID=0)
begin
insert into tbl_ROVaultTotal
(
Balance,
IsClosing,
[Date],
CCID,
DiffAmount,
ApprovedBy
) Values(
@Balance,
@IsClosing,
@Date,
@CCID,
@DiffAmount,
@ApprovedBy
)Select @@IDENTITY
end
else
begin
update tbl_ROVaultTotal
set Balance=@Balance,
IsClosing=@IsClosing,
[Date]=@Date,
CCID=@CCID,
DiffAmount=@DiffAmount,
ApprovedBy=@ApprovedBy
where @TotalID=TotalID
Select @TotalID
end





GO
