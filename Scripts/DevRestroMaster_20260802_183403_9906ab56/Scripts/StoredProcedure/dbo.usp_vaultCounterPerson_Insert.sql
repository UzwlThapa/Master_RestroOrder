SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_vaultCounterPerson_Insert]
@CPName nvarchar(200),
@CPCode nvarchar(100)
as
insert into tblCounterPerson(
CPName,
CPCode
)values
(
@CPName,
@CPCode)




GO
