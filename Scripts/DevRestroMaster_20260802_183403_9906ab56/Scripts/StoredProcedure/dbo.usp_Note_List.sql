SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Note_List]
as
select *,case
        when IsCoin = 1 then 'YES'
        when IsCoin = 0 then 'NO'
        else 'UNDEFINED'
    end AS iscoins from tbl_ROVaultNote




GO
