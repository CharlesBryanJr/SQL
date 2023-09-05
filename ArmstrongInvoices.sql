-- Broker Invoice Information
use TriumphPay

SELECT i.UploadedDate,
       i.ApprovedDate,
       i.ScheduledDraftDate as DraftDate,
       p.CompanyName as Carrier,
       p.MCNumber,
       i.ReferenceNo,
       i.InvoiceNo,
       i.NetAmount,
       i.GrossAmount,
       pt.Code as PayoutTerm,
       pt.PayorFlatFee,
       pt.PayeeFlatFee,
       i.ScheduledPaymentDate,
       i.InvoiceImportedStatusId,
       i.ExternalInvoiceKey,
       i.ExternalPayeeKey,
FROM dbo.Invoice as i
    LEFT JOIN dbo.PayeeRelationship as p on p.PayeeRelationshipId = i.PayeeRelationshipId
    LEFT JOIN dbo.PayoutTerm as pt on t.PayoutTermId = i.ActualPayoutTermId

WHERE i.PayorCompanyId = '49205'
    AND i.UploadedDate
    BETWEEN '03/01/21' AND '08/31/22';