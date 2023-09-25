


CREATE VIEW [dbo].[Country]
AS
SELECT     EntryID, ListName, Value, Text, ParentID, [Level], CurrencyCode, DisplayLocale, DisplayOrder, DefinitionID, Description, PortalID, SystemList, IsActive, 
                      AddedBy, AddedOn, UpdatedBy, UpdatedOn, Culture
FROM         dbo.Lists
WHERE     (ListName = 'Country')



GO


