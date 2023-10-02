
 if exists SELECT compatibility_level FROM sys.databases WHERE name = 'Restro_Master_Chicken';
 ALTER DATABASE Restro_Master_Chicken SET COMPATIBILITY_LEVEL = 130