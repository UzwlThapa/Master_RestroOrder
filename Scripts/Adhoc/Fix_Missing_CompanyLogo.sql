SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

UPDATE dbo.RO_CompanyInfo
SET Logo = 'logo.png'
WHERE ID = 5
  AND Logo = 'white-color-solid-background-1920x1080.png';

IF @@ROWCOUNT <> 1
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR('Company logo setting did not match the verified missing filename; no update applied.', 16, 1);
    RETURN;
END;

COMMIT TRANSACTION;