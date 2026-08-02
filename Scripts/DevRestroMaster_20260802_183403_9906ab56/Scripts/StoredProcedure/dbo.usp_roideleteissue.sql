SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_roideleteissue]
@IMId int
as
begin
delete from dbo.ROI_IssueDetails where  IMId=@IMId
delete from dbo.ROI_IssueMain where  IMId=@IMId
end




GO
