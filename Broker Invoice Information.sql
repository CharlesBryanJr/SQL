-- Broker Invoice Information
use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @StartDate DATETIME = '2023-08-24'
DECLARE @EndDate DATETIME = GETDATE()

SELECT i.UploadedDate,
       i.ApprovedDate,
       p.CompanyName,
       p.MCNumber,
       i.ReferenceNo,
       i.InvoiceNo,
       i.NetAmount,
       t.Code as PayoutTerm,
       t.PayorFlatFee,
       i.ScheduledDraftDate,
       i.ScheduledPaymentDate,
       i.InvoiceImportedStatusId,
       i.ExternalInvoiceKey,
       i.ExternalPayeeKey,
       i.IsDraftDateLocked
FROM dbo.Invoice as i
    LEFT JOIN dbo.PayeeRelationship as p on p.PayeeRelationshipId = i.PayeeRelationshipId
    LEFT JOIN dbo.PayoutTerm as t on t.PayoutTermId = i.ActualPayoutTermId

WHERE i.PayorCompanyId = '49205'
    AND i.UploadedDate BETWEEN @StartDate AND @EndDate;