SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_VaultData_Insert]
@NoteID int,
@Number int,
@TID int,
@CTID int,
@CTcID int

as

--Declare @ERRMsg varchar(1000)
----IF EXISTS (SELECT * FROM tbl_ROVaultTotal rvt WHERE rvt.Date=GETDATE())
----begin
--	IF EXISTS (SELECT * FROM tbl_ROVaultTotal rvt WHERE rvt.IsClosing =0)
--		begin
--				set @ERRMsg=  'ERROR! Open Drawer is entered Already!'
--				raiserror (@ERRMsg, 16,1)
--				return @ERRMsg
--	    end
--    else
--		begin
declare @check int;
select @check= COUNT(*) FROM tbl_Roi_Data WHERE TID = @TID;
--select @check
if(@check<=0)
begin
			insert into tbl_Roi_Data
			(
			NoteID,
			Number,
			TID,
			CTID,
		    CTcID
			) Values(
			@NoteID,
			@Number,
			@TID,
			@CTID,
			@CTcID
			)
			end
		else 
			begin 
			delete tbl_Roi_Data where TID = @TID and NoteID=@NoteID;
			insert into tbl_Roi_Data
			(
			NoteID,
			Number,
			TID,
			CTID,
		    CTcID
			) Values(
			@NoteID,
			@Number,
			@TID,
			@CTID,
			@CTcID
			)
			end
	   --end
--end


--select * from tbl_Roi_Data




GO
