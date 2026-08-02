SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_SaveFiscalYear]
@fyId INT,
@fyName NVARCHAR(256),
@StartDate DATETIME,
@EndDate DATETIME,
@AddedBy NVARCHAR(256),
@isActive BIT
AS
BEGIN
    IF (@fyId = 0)
    BEGIN
        INSERT INTO RO_fiscalYear(
            fyName,
            isActive,
            StartDate,
            EndDate,
            AddedBy,
            AddedOn,
            FirstSalesMasterID  -- explicitly handled
        )
        VALUES
        (
            @fyName,
            @isActive,
            @StartDate,
            @EndDate,
            @AddedBy,
            GETDATE(),
            NULL   -- upcoming year must always start with NULL
        )
    END
    ELSE
    BEGIN
        UPDATE RO_fiscalYear
        SET
            fyName = @fyName,
            isActive = @isActive,
            StartDate = @StartDate,
            EndDate = @EndDate,
            UpdatedBy = @AddedBy,
            UpdatedOn = GETDATE(),
            IsDeleted = 0
        WHERE fyId = @fyId
    END
END

GO
