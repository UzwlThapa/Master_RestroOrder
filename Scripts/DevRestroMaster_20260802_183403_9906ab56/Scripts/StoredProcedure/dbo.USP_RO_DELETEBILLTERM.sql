SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_DELETEBILLTERM]
@billtermId INT
AS
BEGIN
DELETE FROM dbo.RO_BillTerm WHERE RO_BillTerm.BilingID= @billtermId

DECLARE @maxsequences INT 
SELECT @maxsequences = MAX(SequenceOrder) FROM dbo.RO_BillTerm WHERE Name!='VAT'


UPDATE dbo.RO_BillTerm Set SequenceOrder =(@maxsequences + 1) WHERE Name='VAT'

end




GO
