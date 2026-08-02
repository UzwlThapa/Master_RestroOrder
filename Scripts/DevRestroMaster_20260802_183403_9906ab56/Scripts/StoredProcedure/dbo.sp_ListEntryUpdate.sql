SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ListEntryUpdate]
 
 @EntryID INT, 
 @Value NVARCHAR(100), 
 @Text NVARCHAR(150), 
 @CurrencyCode NVARCHAR(50),
 @DisplayLocale NVARCHAR(50),
 @Description NVARCHAR(500),
 @IsActive BIT,
 @UpdatedBy NVARCHAR(256),
 @Culture NVARCHAR(256)

AS
 UPDATE dbo.Lists
  SET 
   [Value] = @Value,
   [Text] = @Text,   
   [CurrencyCode]=@CurrencyCode,
   [DisplayLocale]=@DisplayLocale,
   [Description] = @Description,
   [IsActive]=@IsActive,
   [UpdatedBy] = @UpdatedBy, 
   [UpdatedOn] = GETDATE()
  WHERE  [EntryID] = @EntryID AND Culture=@Culture





GO
