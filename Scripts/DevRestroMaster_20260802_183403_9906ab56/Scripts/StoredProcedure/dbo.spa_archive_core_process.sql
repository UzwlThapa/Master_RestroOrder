SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spa_archive_core_process] AS 
BEGIN
	

DECLARE @archtable VARCHAR(120)
DECLARE @thresholdfreq INT
DECLARE @crosscheckfreq INT
DECLARE @totalrow INT 
DECLARE @finaltransferrow INT
DECLARE @keycolumn VARCHAR(50)
IF OBJECT_ID('tempdb..#copied') IS NOT NULL
    DROP TABLE #copied
CREATE TABLE #copied
(
	id BIGINT
)

SELECT @archtable = archtable,
       @thresholdfreq      = thresholdfreq,
       @crosscheckfreq     = crosscheckfreq,
       @keycolumn = keycolumn
FROM   arch_configuration

SELECT @totalrow = COUNT(*)
FROM   sessiontracker

--PRINT @totalrow
SET @finaltransferrow = @totalrow - @thresholdfreq
IF @totalrow > @thresholdfreq
BEGIN 
    IF @totalrow > @crosscheckfreq
    BEGIN
        EXEC (
                 'INSERT INTO '+@archtable+'_arch1 OUTPUT  INSERTED.'+@keycolumn+' 
INTO     #copied  SELECT TOP ' +  @finaltransferrow  + 
                 ' * FROM '+ @archtable+' ORDER BY 1  '
        )
        
                
        
        EXEC (
                 ' DELETE  '+@archtable+' FROM '+@archtable+' st INNER JOIN #copied cp ON st.'+@keycolumn+' = cp.id '
        )
        PRINT ' DELETE  '+@archtable+' FROM '+@archtable+' st INNER JOIN #copied cp ON st.'+@keycolumn+' = cp.id '
    END
END

DROP TABLE #copied	

END




GO
