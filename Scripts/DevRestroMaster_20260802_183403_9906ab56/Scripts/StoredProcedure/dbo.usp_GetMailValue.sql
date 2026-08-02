SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetMailValue]
@MailValue NVARCHAR(500)
AS
BEGIN
 SELECT SettingValue FROM [dbo].[NL_SettingValue] WHERE SettingKey=@MailValue
END

INSERT [dbo].[NL_SettingValue] ([NL_SettingValueID], [UserModuleID], [SettingKey], [SettingValue], [IsActive], [IsDeleted], [IsModified], [AddedOn], [UpdatedOn], [DeletedOn], [PortalID], [AddedBy], [UpdatedBy], [DeletedBy]) VALUES (6, 67, N'MailKey', N'k7yhnYF0JVyw++YhBu1IXbaH+1W2nBBE4KeND33Yu2QA5DQUvgx5ZOQMehQniLTM', NULL, 1, 0, NULL, CAST(N'2023-02-13T00:00:00.000' AS DateTime), CAST(N'2023-02-13T10:45:04.920' AS DateTime), NULL, N'1', N'superuser', NULL)
INSERT [dbo].[NL_SettingValue] ([NL_SettingValueID], [UserModuleID], [SettingKey], [SettingValue], [IsActive], [IsDeleted], [IsModified], [AddedOn], [UpdatedOn], [DeletedOn], [PortalID], [AddedBy], [UpdatedBy], [DeletedBy]) VALUES (7, 67, N'MailValue', N'7KptrkMPBVxxG4qsdeXVhCyIqikUd0mn27WXg/4rpQW9SK6cOg7QG/b/VH+M0eCousAGfLXMBa/gX/0ZvUrfKQ==', NULL, 1, 0, NULL, CAST(N'2023-02-13T00:00:00.000' AS DateTime), CAST(N'2023-02-13T10:45:04.920' AS DateTime), NULL, N'1', N'superuser', NULL)


GO
