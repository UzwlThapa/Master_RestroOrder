SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleMessageAdd]
(
 @ModuleID INT,
 @Message NTEXT,
 @Culture NVARCHAR(50),
 @IsActive BIT,
 @MessageType INT,
 @MessageMode INT,
 @MessagePosition INT
)
AS
BEGIN
 IF(EXISTS
   (
    SELECT 
     * 
    FROM 
     ModuleMessage 
    WHERE 
      ModuleID=@ModuleID 
     AND Culture=@Culture
   )
  )
  BEGIN
   UPDATE 
    ModuleMessage 
   SET 
    [Message]=@Message,
    MessageType=@MessageType,
    MessageMode=@MessageMode,
    MessagePosition=@MessagePosition,
    IsActive=@IsActive
   WHERE 
     ModuleID=@ModuleID 
    AND Culture=@Culture
  END
 ELSE
  BEGIN
   INSERT INTO ModuleMessage
    (
     ModuleID,
     [Message],
     Culture,
     IsActive,
     MessageType,
     MessageMode,
     MessagePosition
    )
   VALUES
    (
     @ModuleID,
     @Message,
     @Culture,
     @IsActive,
     @MessageType,
     @MessageMode,
     @MessagePosition
    )
  END
END





GO
