SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_saveAdjustmentMain]
@AMNo INT ,
@STId INT,
@Remarks VARCHAR(MAX) ,
@FYId INT ,
@PostedOn DATETIME ,
@PostedBy VARCHAR(128)
AS
BEGIN
INSERT INTO dbo.AdjustmentMain
        ( AMNo ,
          STId ,
          Remarks ,
          FYId ,
          PostedOn ,
          PostedBy
        )
VALUES  ( @AMNo ,
         @STId ,
		  @Remarks ,
		  @FYId ,
		  @PostedOn ,
		  @PostedBy)SELECT @@IDENTITY
END	




GO
