SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-06-02
-- Description:  ContactUs Module
-- =============================================  
CREATE PROCEDURE [dbo].[sp_ContactUsAdd] 
                                        @Name        NVARCHAR(256),
                                        @Email       NVARCHAR(256),
                                        @Message     NVARCHAR(4000),
                                        @IsActive    BIT,
                                        @PortalID    INT,
                                        @AddedBy     NVARCHAR(256)
AS
  BEGIN
      INSERT INTO dbo.contactus
                  ([name],
                   [email],
                   [message],
                   [isactive],
                   [addedon],
                   [portalid],
                   [addedby])
      VALUES      ( @Name,
                    @Email,
                    @Message,
                    @IsActive,
                    GETDATE(),
                    @PortalID,
                    @AddedBy )
  END





GO
