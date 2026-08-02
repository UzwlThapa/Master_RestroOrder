SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  


CREATE function [dbo].[fNumToWords] (@decNumber decimal(12, 2), @BigCurrency nvarchar(50), @SmallCurrency nvarchar(50))  
returns varchar(300)  
As  
Begin  
Declare  
 @strNumber varchar(100),  
 @strRupees varchar(200),  
 @strPaise varchar(100),  
 @strWords varchar(300),  
 @intIndex integer,  
 @intAndFlag integer  
  
Select @strNumber = Cast(@decNumber as varchar(100))  
Select @intIndex = CharIndex('.', @strNumber)  
if(@decNumber>99999999.99)  
BEGIN   
 RETURN ''  
END  
If @intIndex > 0  
begin  
 Select @strPaise = dbo.fConvertTens(Right(@strNumber, Len(@strNumber) - @intIndex))  
 Select @strNumber = SubString(@strNumber, 1, Len(@strNumber) - 3)  
 If Len(@strPaise) > 0 Select @strPaise = @strPaise + ' ' + @SmallCurrency --' cent '  
end  
Select @strRupees = ''  
Select @intIndex=len(@strNumber)  
Select @intAndFlag=2  
while(@intIndex>0)  
begin  
 if(@intIndex=8)  
 begin  
  Select @strRupees=@strRupees+dbo.fConvertDigit(left(@decNumber,1))+' Crore '  
  Select @strNumber=substring(@strNumber,2,len(@strNumber))  
  Select @intIndex=@intIndex-1  
    
 end  
 else if(@intIndex=7)  
 begin  
  if(substring(@strNumber,1,1)='0')  
  begin  
   if substring(@strNumber,2,1)<>'0'  
   begin   
    if (@strRupees<>NULL and substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0' and substring(@strNumber,6,1)='0' and substring(@strNumber,7,1)='0' and @intAndFlag=2 and @strPaise=NULL)  
    begin  
     Select @strRupees=@strRupees+' and ' +dbo.fConvertDigit(substring(@strNumber,2,1))+' Lakh '  
     Select @intAndFlag=1  
    end  
    else  
    begin  
     Select @strRupees=@strRupees+dbo.fConvertDigit(substring(@strNumber,2,1))+' Lakh '  
    end  
      
    Select @strNumber=substring(@strNumber,3,len(@strNumber))  
    Select @intIndex=@intIndex-2  
   end  
   else  
   begin  
    Select @strNumber=substring(@strNumber,3,len(@strNumber))  
    Select @intIndex=@intIndex-2  
   end  
  end   
  else  
  begin  
   if(substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0' and substring(@strNumber,6,1)='0' and substring(@strNumber,7,1)='0'  and @intAndFlag=2 and @strPaise='')  
   begin     
    Select @strRupees=@strRupees+' and ' + dbo.fConvertTens(substring(@strNumber,1,2))+' Lakhs '  
    Select @intAndFlag=1  
   end  
   else  
   begin  
    Select @strRupees=@strRupees+dbo.fConvertTens(substring(@strNumber,1,2))+' Lakhs '  
   end  
   Select @strNumber=substring(@strNumber,3,len(@strNumber))  
   Select @intIndex=@intIndex-2  
  end  
 end   
 else if(@intIndex=6)  
  begin  
   if(substring(@strNumber,2,1)<>'0' or substring(@strNumber,3,1)<>'0' and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0' and substring(@strNumber,6,1)='0' and @intAndFlag=2 and @strPaise='')  
   begin  
      
    if len(@strRupees) <= 0  
    begin  
     if convert(int,substring(@strNumber,1,1)) = 1  
     begin  
      Select @strRupees=@strRupees+'' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lakh '  
      Select @intAndFlag=2  
     end  
     else  
     begin  
      Select @strRupees=@strRupees+'' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lakhs '  
      Select @intAndFlag=2  
     end  
    end  
    else  
    begin  
     if convert(int,substring(@strNumber,1,1)) = 1  
     begin  
      Select @strRupees=@strRupees+' and' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lakh '  
      Select @intAndFlag=1  
     end  
     else  
     begin  
      Select @strRupees=@strRupees+' and' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lakhs '  
      Select @intAndFlag=1  
     end   
    end  
   end  
   else  
   begin  
    if convert(int,substring(@strNumber,1,1)) = 1  
    begin  
     Select @strRupees=@strRupees+dbo.fConvertDigit(substring(@strNumber,1,1))+' Lakh '  
    end  
    else  
    begin   
     Select @strRupees=@strRupees+dbo.fConvertDigit(substring(@strNumber,1,1))+' Lakhs '  
    end   
   end  
   Select @strNumber=substring(@strNumber,2,len(@strNumber))  
   Select @intIndex=@intIndex-1  
  end  
 else if(@intIndex=5)  
  begin  
   if(substring(@strNumber,1,1)='0')  
   begin  
    if substring(@strNumber,2,1)<>'0'  
    begin  
     if(substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0' and @intAndFlag=2 and @strPaise='')  
     begin  
      Select @strRupees=@strRupees+' and ' +dbo.fConvertDigit(substring(@strNumber,2,1))+' Thousand '  
      Select @intAndFlag=1  
     end  
     else  
     begin  
      Select @strRupees=@strRupees+dbo.fConvertDigit(substring(@strNumber,2,1))+' Thousand '  
     end  
     Select @strNumber=substring(@strNumber,3,len(@strNumber))  
     Select @intIndex=@intIndex-2  
    end  
    else  
    begin  
     Select @strNumber=substring(@strNumber,3,len(@strNumber))  
     Select @intIndex=@intIndex-2  
    end  
   end   
   else  
   begin  
    if(substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0' and @intAndFlag=2 and @strPaise='')  
    begin  
     Select @strRupees=@strRupees+' and '+dbo.fConvertTens(substring(@strNumber,1,2))+' Thousand '  
     Select @intAndFlag=1  
    end  
    else  
    begin  
     Select @strRupees=@strRupees+dbo.fConvertTens(substring(@strNumber,1,2))+' Thousand '  
    end  
    Select @strNumber=substring(@strNumber,3,len(@strNumber))  
    Select @intIndex=@intIndex-2  
   end  
  end   
 else if(@intIndex=4)  
  begin  
   if ( (substring(@strNumber,3,1)<>'0' or substring(@strNumber,4,1)<>'0') and substring(@strNumber,2,1)='0' and  @intAndFlag=2 and @strPaise='')  
   begin  
    Select @strRupees=@strRupees+' and' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Thousand '  
    Select @intAndFlag=1  
   end  
   else  
   begin  
   Select @strRupees=@strRupees+dbo.fConvertDigit(substring(@strNumber,1,1))+' Thousand '  
   end  
   Select @strNumber=substring(@strNumber,2,len(@strNumber))  
   Select @intIndex=@intIndex-1  
  end  
 else if(@intIndex=3)  
  begin  
   if  substring(@strNumber,1,1)<>'0'  
   begin  
    Select @strRupees=@strRupees+dbo.fConvertDigit(substring(@strNumber,1,1))+' Hundred '  
    Select @strNumber=substring(@strNumber,2,len(@strNumber))  
      
    if( (substring(@strNumber,1,1)<>'0' or  substring(@strNumber,2,1)<>'0') and @intAndFlag=2 )  
    begin  
     Select @strRupees=@strRupees+' and '  
     Select @intAndFlag=1  
    end  
    Select @intIndex=@intIndex-1  
   end  
   else  
   begin  
    Select @strNumber=substring(@strNumber,2,len(@strNumber))  
    Select @intIndex=@intIndex-1  
   end  
  end   
 else if(@intIndex=2)  
  begin  
   if substring(@strNumber,1,1)<>'0'  
   begin  
    Select @strRupees=@strRupees+dbo.fConvertTens(substring(@strNumber,1,2))  
    Select @intIndex=@intIndex-2  
   end  
   else  
   begin  
    Select @intIndex=@intIndex-1  
   end  
  end  
 else if(@intIndex=1)  
  begin  
   if(@strNumber<>'0')  
   begin  
    Select @strRupees=@strRupees+dbo.fConvertDigit(@strNumber)  
   end  
   Select @intIndex=@intIndex-1  
      
  end  
continue  
end  
if len(@strRupees)>0 Select @strRupees=@strRupees+' ' + @BigCurrency--' Dollor '  
IF(len(@strPaise)<>0)  
BEGIN  
 if len(@strRupees)>0 Select @strRupees=@strRupees + ' and '  
END  
Select @strWords = IsNull(@strRupees, '') + IsNull(@strPaise, '')  
select @strWords = @strWords + ' only'  
Return UPPER(@strWords)  
End  




GO
