SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--author: Sushil Sapkota 
--Date:s/4/2013 
CREATE PROCEDURE [dbo].[sp_ListSortOrderUpdate] (@EntryID INT, 
                                                @MoveUp  BIT, 
                                                @Culture NVARCHAR(256)) 
AS 
  BEGIN 
      DECLARE @CurrentOrder INT, 
              @ListName     NVARCHAR(250), 
              @NewOrder     INT, 
              @parentId     int 

      SELECT @ListName = ListName 
      FROM   Lists 
      WHERE  EntryID = @EntryID 

      set @parentId=(select ParentID 
                     from   Lists 
                     where  EntryID = @EntryID) 

      SELECT @CurrentOrder = DisplayOrder 
      FROM   Lists 
      WHERE  EntryID = @EntryID 
             AND ListName = @ListName 

      IF @MoveUp = 1 
        BEGIN 
            DECLARE @UpEntryOrder INT, 
                    @UpID         INT 

            if( @CurrentOrder - 1 != 0 ) 
              begin 
                  set @UpID=(select EntryID 
                             from   Lists 
                             where  ListName = @ListName 
                                    and ParentID = @parentId 
                                    and DisplayOrder = ( @CurrentOrder - 1 )) 

                  print @upId 

                  print @CurrentOrder 

                  print @CurrentOrder - 1 

                  Update Lists 
                  SET    DisplayOrder = ( @CurrentOrder - 1 ) 
                  where  EntryID = @EntryID 

                  UPDATE Lists 
                  SET    DisplayOrder = ( @CurrentOrder ) 
                  where  EntryID = @UpID 
              end 
        END 
      ELSE 
        BEGIN 
            DECLARE @DownEntryOrder INT, 
                    @DownID         INT 

            set @DownEntryOrder=(SELECT MAX(DisplayOrder) 
                                 from   Lists 
                                 where  ListName = @ListName 
                                        and ParentID = @parentId) 

            if( @CurrentOrder < @DownEntryOrder ) 
              begin 
                  set @DownID=(select EntryID 
                               from   Lists 
                               where  ListName = @ListName 
                                      and ParentID = @parentId 
                                      and DisplayOrder = ( @CurrentOrder + 1 )) 

                  Update Lists 
                  SET    DisplayOrder = ( @CurrentOrder + 1 ) 
                  where  EntryID = @EntryID 

                  UPDATE Lists 
                  SET    DisplayOrder = ( @CurrentOrder ) 
                  where  EntryID = @DownID 
              end 
        END 
  END





GO
