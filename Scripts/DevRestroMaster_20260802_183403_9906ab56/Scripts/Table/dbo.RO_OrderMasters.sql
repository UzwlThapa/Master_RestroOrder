SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RO_OrderMasters](
	[OrderMasterID] [int] IDENTITY(1,1) NOT NULL,
	[RoomId] [int] NOT NULL,
	[TableId] [nvarchar](50) NULL,
	[BillNo] [nvarchar](128) NULL,
	[Date] [datetime] NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[TermAmount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[Remarks] [nvarchar](512) NULL,
	[IsCancelled] [bit] NULL,
	[UserName] [varchar](150) NULL,
	[BillPaid] [bit] NULL,
	[IsSplit] [bit] NULL,
	[GuestNo] [int] NULL,
	[IsPrinted] [bit] NULL,
	[OID] [int] NULL,
	[OrderStatus] [int] NULL,
	[CancelReason] [nvarchar](max) NULL,
	[CancelBy] [nvarchar](250) NULL,
	[CancelDate] [datetime] NULL,
	[OrderNo] [int] NULL,
	[OrderTypeID] [int] NULL,
	[HsCode] [nvarchar](250) NULL,
 CONSTRAINT [PK_RO_OrderMasters_1] PRIMARY KEY CLUSTERED 
(
	[OrderMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_RO_OrderMasters_OrderMasterID_OrderTypeID] ON [dbo].[RO_OrderMasters]
(
	[OrderMasterID] ASC,
	[OrderTypeID] ASC
)
INCLUDE([GuestNo],[TableId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RO_OrderMasters] ADD  CONSTRAINT [DF_RO_OrderMasters_OrderTypeID]  DEFAULT ((1)) FOR [OrderTypeID]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_RO_OrderMasters_GuestNo] ON [dbo].[RO_OrderMasters]
FOR INSERT, UPDATE
AS
IF (SELECT count(1) FROM  INSERTED AS i Where GuestNo=0 or GuestNo is null or GuestNo <0)>0
BEGIN
 UPDATE a
    SET GuestNo=1
    FROM RO_OrderMasters a
    JOIN inserted i ON a.OrderMasterID = i.OrderMasterID

END
ELSE IF (SELECT count(1) FROM  INSERTED AS i Where GuestNo>1)>0
BEGIN
 UPDATE a
    SET IsSplit=1
    FROM RO_OrderMasters a
    JOIN inserted i ON a.OrderMasterID = i.OrderMasterID

END


GO
ALTER TABLE [dbo].[RO_OrderMasters] ENABLE TRIGGER [trg_RO_OrderMasters_GuestNo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_UpdateTableStatus_OnOrderClose]
ON [dbo].[RO_OrderMasters]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF (UPDATE(IsCancelled) OR UPDATE(BillPaid))
    BEGIN
        DECLARE @TableId INT;
        SELECT @TableId = i.TableId
        FROM inserted i
        WHERE (
                  i.IsCancelled = 1
                  OR i.BillPaid = 1
              )
              AND NOT EXISTS
        (
            SELECT 1
            FROM RO_OrderMasters om
            WHERE om.TableId = i.TableId
                  AND om.IsCancelled = 0
                  AND om.BillPaid = 0
        );
        IF @TableId IS NOT NULL
        BEGIN
            UPDATE RO_restroTable
            SET restrotablesStatusID = 1
            WHERE restrotableId = @TableId
                  AND restrotablesStatusID != 1;
        END;
    END;
END;

GO
ALTER TABLE [dbo].[RO_OrderMasters] ENABLE TRIGGER [trg_UpdateTableStatus_OnOrderClose]
GO
