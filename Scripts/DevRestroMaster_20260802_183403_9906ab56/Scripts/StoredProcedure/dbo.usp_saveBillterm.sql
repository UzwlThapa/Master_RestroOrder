SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_saveBillterm]
@billtermId INT,
@Name VARCHAR(128), 
@IsAdd BIT, 
@Rate DECIMAL(12,2),
@Description VARCHAR(128)
AS
BEGIN
	IF(@billtermId=0)
	BEGIN
	INSERT INTO dbo.RO_BillTerm
			( Name, IsAdd, Rate, Description )
	VALUES  ( 
				
				@Name , 
				@IsAdd, 
				@Rate,
				@Description
			  )
	END	
	ELSE
	BEGIN
		UPDATE dbo.RO_BillTerm SET	
		Name=@Name,
		 IsAdd=@IsAdd,
		  Rate=@Rate, 
		  Description=@Description
		  WHERE BilingID=@billtermId
	END

END	




GO
