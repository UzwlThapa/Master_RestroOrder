SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 12/3/2023
====================================

-- EXEC  USP_ROI_SaveTableReservation

*/
CREATE PROCEDURE [dbo].[USP_ROI_SaveTableReservation]
    @CustomerName NVARCHAR (250) ,
    @ReservedDateTime DATETIME ,
    @People INT ,
    @ReservedBy NVARCHAR (250) ,
    @Phone NVARCHAR (50) ,
    @Note NVARCHAR (500) ,
    @NotifyBefore INT
AS
    BEGIN
        INSERT INTO RO_TableReservation ( CustomerName ,
                                          ReservedDateTime ,
                                          NoOfPeople ,
                                          ReservedOn ,
                                          ReservedBy ,
                                          Phone ,
                                          NotifyBefore ,
                                          Note )
        VALUES ( @CustomerName, @ReservedDateTime, @People, GETDATE (), @ReservedBy, @Phone, @NotifyBefore, @Note );

        SELECT CAST(@@IDENTITY AS INT);
    END;

GO
