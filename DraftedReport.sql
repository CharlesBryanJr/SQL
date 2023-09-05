/*
his should result in a report that:
pulls all invoices drafted during the time period
includes the fields specified in the SQL 
includes Terms and Additional Data Items (for future shipper support) 
Additional Data Items should be included as additional columns
names the fields as ATG and BNSF expect 
See naming convention in SQL
is configurable in the UI to be sent daily, weekly, or monthly to an S3 bucket

Changes to SQL:
,i.PayorPayeeTermFeeAmount AS 'ArmstrongQPRev' - should read "[Payor]QPRev"
,(-1 * i.TriumphPayorTermFeeAmount) AS 'ArmstrongQPFee' - should read "[Payor]QPFee"
Add Terms to the end 
Add Additional Data Items (as additional columns on the end of the table)
*/
use TriumphPay

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @PayorId INTEGER = '49205'
DECLARE @StartDate DATETIME = '2021-10-01';
DECLARE @EndDate DATETIME = '2021-11-01';

SELECT
    i.ExternalInvoiceKey AS 'ExternalKey'
    ,i.ExternalPayeeKey
    ,r.CompanyName AS 'CarrierName'
    ,r.MCNumber
    ,r.DOTNumber
    ,'False' AS 'IsCreditNote'
    ,NULL AS 'CreditNoteApplication'
    ,i.ReferenceNo
    ,i.InvoiceNo
    ,i.NetAmount AS 'OriginalAmount'
    ,i.CreditNoteApplicationAmount
    ,FORMAT(i.UploadedDate, 'MM/dd/yyyy') AS 'UploadedDate'
    ,FORMAT(i.ApprovedDate, 'MM-dd-yyyy') AS 'ApprovedDate'
    ,FORMAT(i.RequestedDueDate, 'MM-dd-yyyy') AS 'RequestedDueDate'
    ,FORMAT(d.ReconciledDateTime, 'MM/dd/yyyy') AS 'ActualDraftDate'
    ,i.InvoiceDraftId AS 'DraftId'
    ,s.Name AS 'Status'

FROM Invoice i
    LEFT JOIN PayeeRelationship r ON i.PayeeRelationshipId = r.PayeeRelationshipId
    LEFT JOIN InvoiceStatus s ON i.InvoiceStatusId = s.InvoiceStatusId
    LEFT JOIN InvoiceDraft d ON i.InvoiceDraftId = d.InvoiceDraftId

WHERE i.PayorCompanyId = @PayorId
    AND d.ReconciledDateTime BETWEEN @StartDate AND @EndDate


UNION ALL

SELECT
    c.ExternalKey
    ,c.ExternalPayeeKey
    ,r.CompanyName
    ,r.MCNumber
    ,r.DOTNumber
    ,'True' AS 'IsCreditNote'
    ,i.ExternalInvoiceKey
    ,c.ReferenceNo
    ,c.InvoiceNo
    ,c.GrossAmount
    ,(-1 * ci.ApplicationAmount)
    ,FORMAT(c.CreatedDateTime, 'MM-dd-yyyy')
    ,FORMAT(c.CreditDate, 'MM-dd-yyyy')
    ,NULL
    ,FORMAT(d.ReconciledDateTime, 'MM-dd-yyyy')
    ,ci.InvoiceDraftId
    ,cns.Name

FROM CreditNote c
    LEFT JOIN PayeeRelationship r ON c.PayeeRelationshipId = r.PayeeRelationshipId
    LEFT JOIN CreditNoteInvoice ci ON c.Id = ci.CreditNoteId
    LEFT JOIN InvoiceDraft d ON ci.InvoiceDraftId = d.InvoiceDraftId
    LEFT JOIN Invoice i ON ci.InvoiceId = i.InvoiceId
    LEFT JOIN CreditNoteStatus cns on c.CreditNoteStatusId = cns.Id

WHERE c.PayorCompanyId = @PayorId
    AND d.ReconciledDateTime BETWEEN @StartDate AND @EndDate