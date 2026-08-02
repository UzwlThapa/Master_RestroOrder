SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_VaultData_InsertForCounterTransaction]
@NoteID int,
@Number int,
@TID int,
@CTID int,
@CTcID int

as

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




GO
