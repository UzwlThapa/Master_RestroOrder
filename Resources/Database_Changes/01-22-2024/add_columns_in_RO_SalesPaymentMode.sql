ALTER TABLE RO_SalesPaymentMode
ADD IsCancelled bit,
cancelledBy NVARCHAR(256),
cancelledDate NVARCHAR(256),
cancelledReasons NVARCHAR(max);