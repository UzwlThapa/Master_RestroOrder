SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[split_string]
(
    @in_string VARCHAR(MAX),
    @delimeter VARCHAR(1)
)
RETURNS @list TABLE(tuple VARCHAR(100))
AS
BEGIN
        WHILE LEN(@in_string) > 0
        BEGIN
            INSERT INTO @list(tuple)
            SELECT left(@in_string, charindex(@delimeter, @in_string+',') -1) as tuple
    
            SET @in_string = stuff(@in_string, 1, charindex(@delimeter, @in_string + @delimeter), '')
        end
    RETURN 
END
GO
