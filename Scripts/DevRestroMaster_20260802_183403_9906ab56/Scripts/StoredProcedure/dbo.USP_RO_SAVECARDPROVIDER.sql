SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_SAVECARDPROVIDER]
@ProviderID int,
@ProviderName varchar(128),
@Description nvarchar(256)
as
begin
	if(@ProviderID=0)
	begin

	declare @financialAcId int

			insert into Ac_FinancialAc (Name, PFinancialAcID, FinancialSysID, AddedBy, AddedOn, IsArchived, OpeningBalance)
			values (@ProviderName
					,11
					,4
					,'system'
					,GETDATE()
					,0
					,0)
			set @financialAcId = CAST(@@IDENTITY as int)

	insert into RO_CardProvider (ProviderName, Description,FinancialAcId) values (@ProviderName, @Description,@financialAcId)
--	insert into RO_CardProvider(Pro, restroRoomId, Seatcap, restrotablesStatusID) values(@restrotableTitle, @restroRoomId, @SeatNo, 6)
	end
	else
	begin
		update RO_CardProvider set
		ProviderName=@ProviderName,
		Description = @Description
		where ProviderID=@ProviderID
	end
end



GO
