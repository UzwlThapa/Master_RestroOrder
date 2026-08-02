SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertCashDenomination]
@Date datetime,
@thousand int,
@fivehundred int, 
@hundred int,
@fifty int, 
@twenty int,
@ten int,
@five int,
@two int,
@one int
as 
begin

DECLARE @NowDate datetime,
@CashDate datetime,
@ForCheck datetime

set @CashDate= (select TOP 1 cast([Date] as date)  from CashDenomination  order by [Date] desc)
set @NowDate= cast(isnull(@CashDate, 0000-00-00)  as date)
set @ForCheck= cast(@Date as date)

if(@NowDate != @ForCheck)
insert into CashDenomination
(
[Date],
thousand,
fivehundred,
hundred,
fifty,
twenty,
ten,
five,
two,
one
)
values
(
@Date,
@thousand,
@fivehundred,
@hundred,
@fifty,
@twenty,
@ten,
@five,
@two,
@one
)
else
update CashDenomination
set 
thousand = @thousand,
fivehundred = @fivehundred,
hundred = @hundred,
fifty = @fifty,
twenty = @twenty,
ten = @ten,
five = @five,
two = @two,
one = @one
where 
cast([Date] as date) = @ForCheck
END

GO
