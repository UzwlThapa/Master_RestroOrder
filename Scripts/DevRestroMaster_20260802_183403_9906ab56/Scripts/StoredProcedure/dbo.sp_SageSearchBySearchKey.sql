SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- truncate table cachesearch
--  [dbo].[sp_SageSearchBySearchKey] 'lorem','superuser',1,'en-US',1,1,10
CREATE PROCEDURE [dbo].[sp_SageSearchBySearchKey]
 @Searchword nvarchar(500),
 @SearchBy nvarchar(256),
 @IsUseFriendlyUrls bit,
 @CultureName nvarchar(256),
 @PortalID INT,
 @offset INT,
 @limit INT
As
Begin

  IF( EXISTS(SELECT SearchWord FROM CacheSearch WHERE SearchWord=@Searchword and CultureName=@CultureName and RowNumber>=@offset and RowNumber<=(@offset+@limit-1) and PortalID=@PortalID))
  BEGIN
   SELECT SearchWord, PageName,UserModuleID,UserModuleTitle,HTMLContent,URL,convert(nvarchar,UpdatedContentOn,106) AS UpdatedContentOn,RowTotal 
   FROM CacheSearch WHERE SearchWord=@Searchword AND RowNumber>=@offset AND RowNumber<=(@offset+@limit-1) and PortalID=@PortalID
   UPDATE CacheSearch SET Counter=Counter+1 WHERE SearchWord=@Searchword and PortalID=@PortalID
  END
    ELSE
Begin
 /* Time Calculation Initilization */

 SET STATISTICS TIME OFF
 Declare @CurrentExecuitionTime float
 SET @CurrentExecuitionTime = 0
 DECLARE @start_time DATETIME, @end_time DATETIME, @dif int
 SET @start_time = CURRENT_TIMESTAMP 

 /* Time Calculation Initilization End */

 --Initilization for Table to hold resut
  Declare @RowTotal INT
  Declare @tblSageSearchResult table
  ( 
   RowNum int identity(1,1),
   CultureName nvarchar(200),   
   PageName nvarchar(256),
   UserModuleID int,
   UserModuleTitle nvarchar(256),
   HTMLContent nvarchar(max),
   URL nvarchar(1000),
   UpdatedContentOn datetime
  )
 --End of Initilization for Table to hold resut

 --Get All Search Extensions from SageSearch Extenson
  Declare @tblSageExtensions table
  (
   RowNum int identity(1,1),
   ProcedureID int,
   SearchTitle nvarchar(100),
   ProcedureName nvarchar(256),
   ExecuteAs nvarchar(50)
  )
  Insert into @tblSageExtensions
  Select
   SageFrameSearchProcedureID,SageFrameSearchTitle,
   SageFrameSearchProcedureName,
   SageFrameSearchProcedureExecuteAs
  From
   dbo.SageFrameSearchProcedure
  Where
   IsActive = 1 And IsDeleted = 0 And PortalID = @PortalID

 --End of Get All Search Extensions from SageSearch Extenson
  --Select * From @tblSageExtensions
  Declare @Counter int
  Declare @RowCounter int
  Set @Counter = 1
  Set @RowCounter = 0
  Select @RowCounter=Count(RowNum) From @tblSageExtensions
  
  --Now Execute one bye one and Filll in Search Result Table
  While (@RowCounter >= @Counter)
  Begin
   Declare @SearchTitle nvarchar(100)
   Declare @ProcedureName nvarchar(256)
   Declare @ExecuteAs nvarchar(50)
   Select @SearchTitle=SearchTitle, @ProcedureName=ProcedureName, @ExecuteAs=ExecuteAs 
   From @tblSageExtensions Where RowNum=@counter
   Declare @ReadyProcedureName nvarchar(500)
   Set @ReadyProcedureName = ''
   Set @ReadyProcedureName = @ExecuteAs + '.' + @ProcedureName + ' ' + 'N''' + @Searchword + ''',' + '''' + @SearchBy + '''' + ',' + Cast(@IsUseFriendlyUrls as nvarchar(10)) + ',' + '''' + @CultureName + '''' + ',' + Cast(@PortalID as nvarchar(10))
   
   
   Insert into @tblSageSearchResult
   Exec(@ReadyProcedureName)
      
   --Incrising Counter
   SET @counter = @counter + 1
  End
 

 --End of Execution
 --Select * from @tblSageSearchResult Order by UpdatedContentOn desc

 --Select distinct PageName from @tblSageSearchResult

 /* Time Calculation End Start */
 --SET @end_time = CURRENT_TIMESTAMP
 --SELECT @CurrentExecuitionTime = DATEDIFF(millisecond, @start_time, @end_time)
 --Select  @CurrentExecuitionTime as CurrentExecuitionTime
 /* Time Calculation End */

 SELECT @RowTotal=COUNT(*) FROM @tblSageSearchResult
    
    SELECT 
     @SearchWord as SearchWord, 
     @RowTotal as RowTotal,
     s.RowNum,
     s.CultureName,
     s.PageName,
     s.UserModuleID,
     s.UserModuleTitle,
     s.HTMLContent,
     s.URL,
     convert(nvarchar,s.UpdatedContentOn,106) AS UpdatedContentOn
     from @tblSageSearchResult as s  
     WHERE  RowNum>=@offset AND RowNum<=(@offset+@limit-1) ORDER BY UpdatedContentOn  DESC

    DECLARE @TotalList int 
  SET @TotalList= (SELECT ISNULL(max(RowTotal),0) FROM CacheSearch WHERE SearchWord=@Searchword and PortalID=@PortalID)
   IF (@TotalList!='')
     BEGIN 
     INSERT into CacheSearch(SearchWord,PageName,UserModuleID,UserModuleTitle,HTMLContent,URL,CultureName,UpdatedContentOn,RowTotal,RowNumber,counter,SearchedDate,PortalID)
      SELECT @Searchword, tb.PageName,tb.UserModuleID,tb.UserModuleTitle ,tb.HTMLContent ,tb.URL,tb.CultureName , convert(nvarchar, UpdatedContentOn , 106) AS UpdatedContentOn, @TotalList AS RowTotal ,RowNum,1,getdate(),@PortalID FROM @tblSageSearchResult AS tb 
       WHERE  RowNum>=@offset AND RowNum<=(@offset+@limit-1) ORDER BY UpdatedContentOn  DESC

     -- DELETE FROM CacheSearch WHERE DATEDIFF(day,getdate(),SearchedDate) < -1
     END
   ELSE

     BEGIN 
      INSERT into CacheSearch(SearchWord,PageName,UserModuleID,UserModuleTitle,HTMLContent,URL,CultureName,UpdatedContentOn,RowTotal,RowNumber,counter,SearchedDate,PortalID)
      SELECT @Searchword, tb.PageName,tb.UserModuleID,tb.UserModuleTitle ,tb.HTMLContent ,tb.URL,tb.CultureName , convert(nvarchar, UpdatedContentOn , 106) AS UpdatedContentOn, @RowTotal AS RowTotal ,RowNum,1,getdate(),@PortalID FROM @tblSageSearchResult AS tb 
       WHERE  RowNum>=@offset AND RowNum<=(@offset+@limit-1) ORDER BY UpdatedContentOn  DESC
       --DELETE FROM CacheSearch WHERE DATEDIFF(day,getdate(),SearchedDate) < -1
     END
  
ENd

End





GO
