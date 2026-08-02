SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_saveAdjustmentDetails]
		  @AMId INT,
          @ITId INT ,
          @UsedUnitId INT,
          @Qnty INT,
          @QntyInText VARCHAR(128) ,
          @AdType INT ,
          @PDId INT
AS
BEGIN
INSERT INTO dbo.AdjustmentDetls
        ( AMId ,
          ITId ,
          UsedUnitId ,
          Qnty ,
          QntyInText ,
          AdType ,
          PDId
        )
VALUES  ( 
		  @AMId ,
          @ITId ,
          @UsedUnitId ,
          @Qnty ,
          @QntyInText ,
          @AdType ,
          @PDId
        )
END	





GO
