SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetListEntrybyParentId]
  
 @EntryID INT,
 @Culture NVARCHAR(256)
AS
BEGIN

 SELECT *
 FROM dbo.vw_Lists
 WHERE 
  ([ParentID]=@EntryID AND Culture=@Culture)
END 
/****** Object:  StoredProcedure [dbo].[sp_GetListsByPortalID]    Script Date: 12/02/2012 12:26:22 ******/
SET ANSI_NULLS ON





GO
