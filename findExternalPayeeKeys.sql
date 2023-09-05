use TriumphPay

SELECT i.UploadedDate,
       i.ApprovedDate,
       i.ScheduledDraftDate as DraftDate,
       p.CompanyName as Carrier,
       p.MCNumber,
       i.ReferenceNo,
       i.InvoiceNo as CarrierInvoiceNo,
       i.NetAmount,
       i.GrossAmount,
       t.Code as PayoutTerm,
       t.PayorFlatFee,
       t.PayeeFlatFee,
       i.ScheduledPaymentDate,
       i.InvoiceImportedStatusId,
       i.ExternalInvoiceKey,
       i.ExternalPayeeKey

FROM dbo.Invoice as i
     LEFT JOIN dbo.PayeeRelationship as p on p.PayeeRelationshipId = i.PayeeRelationshipId
     LEFT JOIN dbo.PayoutTerm as t on t.PayoutTermId = i.ActualPayoutTermId

WHERE i.PayorCompanyId = '29274'
     AND ((i.ReferenceNo = '964594' AND i.InvoiceNo = 'RE19847A-1')
          OR
          (i.ReferenceNo = '443413' AND i.InvoiceNo = '1D-000282')
     );