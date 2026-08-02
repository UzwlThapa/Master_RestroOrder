SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryType_SaveLaundryType]
@type nvarchar(max)
as

insert into dbo.L_LaundryType(Type) values(@type)



GO
