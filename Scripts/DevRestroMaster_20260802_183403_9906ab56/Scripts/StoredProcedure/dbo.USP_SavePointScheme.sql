SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SavePointScheme]
@PSchemeId int,
@IsPercentage bit,
@PercentageValue int,
@ValueFrom decimal(10,2),
@ValueTo decimal(10,2),
@Point decimal(10,2)
as
declare @CompanyID int 
select @CompanyID=ID from RO_CompanyInfo

declare @Company int 
declare @Percent int
set @Company = (select count(*) from RO_PointScheme)
select @Company
IF(@Company != 0)
BEGIN
set @Percent = (Select CAST(MIN(CAST(IsPercentage as INT)) AS BIT) from RO_PointScheme)
IF(@Percent != @IsPercentage)
Delete RO_PointScheme where CompanyID=@CompanyID

END
IF (@PSchemeId= 0)
BEGIN

INSERT INTO RO_PointScheme(
CompanyID,
IsPercentage,
PercentageValue,
ValueFrom,
ValueTo,
Point)
values
(
@CompanyID,
@IsPercentage,
@PercentageValue,
@ValueFrom,
@ValueTo,
@Point)
END
ELSE
BEGIN
update RO_PointScheme
set
CompanyID = @CompanyID,
IsPercentage = @IsPercentage,
PercentageValue = @PercentageValue,
ValueFrom = @ValueFrom,
ValueTo = @ValueTo,
Point = @Point
where PSchemeId=@PSchemeId	
END



GO
