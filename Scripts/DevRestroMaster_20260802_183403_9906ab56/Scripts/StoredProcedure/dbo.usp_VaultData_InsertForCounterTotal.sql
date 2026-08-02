SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_VaultData_InsertForCounterTotal]
@NoteID int,
@Number int,
@TID int,
@CTID int,
@CTcID int

as

declare @check int;
select @check= COUNT(*) FROM tbl_Roi_Data WHERE CTID=@CTID;
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
			delete tbl_Roi_Data where CTID=@CTID and NoteID=@NoteID;
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




GO
