SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_StripHTML] (@HTMLText VARCHAR(MAX))  
RETURNS VARCHAR(MAX) AS  
BEGIN  
    DECLARE @Start INT  
    DECLARE @End INT  
    DECLARE @Length INT  
    SET @Start = CHARINDEX('<',@HTMLText)  
    SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))  
    SET @Length = (@End - @Start) + 1  
    WHILE @Start > 0 AND @End > 0 AND @Length > 0  
    BEGIN  
        SET @HTMLText = STUFF(@HTMLText,@Start,@Length,'')  
        SET @Start = CHARINDEX('<',@HTMLText)  
        SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))  
        SET @Length = (@End - @Start) + 1  
    END  
    
 -- SET @HTMLText = REPLACE (@HTMLText,'&nbsp;',' ')
    -- SET @HTMLText = REPLACE (@HTMLText,'&copy;','&#169;')
    RETURN LTRIM(RTRIM(@HTMLText))  
END





GO
