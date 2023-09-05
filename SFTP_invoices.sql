-- Broker Invoice Information
use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @StartDate DATETIME = '2023-08-24'
DECLARE @EndDate DATETIME = GETDATE()
SELECT DISTINCT i.ExternalInvoiceKey
FROM Invoice as i
    LEFT JOIN PayorIntegration as pi on i.PayorCompanyId = pi.PayorCompanyId
WHERE (i.UploadedDate BETWEEN @StartDate AND @EndDate)
    AND pi.PayorIntegrationId = 1

use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT pi.PayorIntegrationTypeId
FROM PayorIntegration as pi
WHERE pi.PayorCompanyId = 78041