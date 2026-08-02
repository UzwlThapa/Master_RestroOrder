SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    Function [dbo].[fConvertDigit](@decNumber decimal)
returns varchar(6)
as
Begin
declare
@strWords varchar(6)
 Select @strWords = Case @decNumber
     When '1' then 'One'
     When '2' then 'Two'
     When '3' then 'Three'
     When '4' then 'Four'
     When '5' then 'Five'
     When '6' then 'Six'
     When '7' then 'Seven'
     When '8' then 'Eight'
     When '9' then 'Nine'
     Else ''
 end
return @strWords
end




GO
