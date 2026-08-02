SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveDBLog]
@Operation varchar(1),
@FilePath varchar(500),
@UserName nvarchar(256)
as
begin
insert into DBLog (Operation,OperationTime,FileNameAndPath,OperationBy)
values(@Operation,GETDATE(),@FilePath,@UserName);
end




GO
