SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Note_Insert]
@note int,
@iscoin bit
as
insert into tbl_ROVaultNote
(
Note,
IsCoin
)
values(
@note,
@iscoin
)




GO
