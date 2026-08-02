SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_currency_Note_list] 1
CREATE PROCEDURE [dbo].[usp_currency_Note_list]
@iscoin int
as
select dbc.CurrencyName, dbc.CurrencyIcon, dbc.SubCurrencyName,dbi.CurrencyID,dbn.IsCoin,dbn.Note,dbn.NoteID from 
dbo.RO_Currency dbc inner join
dbo.RO_CompanyInfo dbi on dbc.CurrencyID=dbi.CurrencyID, dbo.tbl_ROVaultNote dbn where dbn.IsCoin=@iscoin order by Note desc






GO
