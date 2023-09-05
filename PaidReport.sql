/*
This should result in a report that:
pulls all invoices paid during the time period
includes the fields specified in the SQL 
includes Terms and Additional Data Items (for future shipper support) 
Additional Data Items should be included as additional columns
names the fields as ATG and BNSF expect 
See naming convention in SQL
is configurable in the UI to be sent daily, weekly, or monthly to an S3 bucket

Changes to SQL:
,i.PayorPayeeTermFeeAmount AS 'ArmstrongQPRev' - should read "[Payor]QPRev"
,(-1 * i.TriumphPayorTermFeeAmount) AS 'ArmstrongQPFee' - should read "[Payor]QPFee"
Add Terms 
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
    ,i.NetAmountAfterPayeeTermFee AS 'PaidAmount'
    ,i.PayorPayeeTermFeeAmount AS 'ArmstrongQPRev'
    ,i.TriumphPayeeTermFeeAmount AS 'TriumphQPFee'
    ,(-1 * i.TriumphPayorTermFeeAmount) AS 'ArmstrongQPFee'
    ,CASE
        WHEN p.ConfirmationCode = '' THEN 'C' + CAST(p.ConsolidatedId AS varchar)
        ELSE p.ConfirmationCode
        END AS 'ConfirmationCode'
    ,FORMAT(i.UploadedDate, 'MM/dd/yyyy') AS 'UploadedDate'
    ,FORMAT(i.ApprovedDate, 'MM-dd-yyyy') AS 'ApprovedDate'
    ,FORMAT(i.RequestedDueDate, 'MM-dd-yyyy') AS 'RequestedDueDate'
    ,FORMAT(p.ActualPaidDate, 'MM/dd/yyyy') AS 'ActualPaidDate'
    ,s.Name AS 'Status'

FROM Invoice i
    LEFT JOIN PayeeRelationship r ON i.PayeeRelationshipId = r.PayeeRelationshipId
    LEFT JOIN InvoiceStatus s ON i.InvoiceStatusId = s.InvoiceStatusId
    LEFT JOIN Payout p ON i.PayoutId = p.PayoutId
    WHERE i.PayorCompanyId = @PayorId
    AND p.ConsolidatedId IS NOT NULL
    AND p.ActualPaidDate BETWEEN @StartDate AND @EndDate

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
    ,(-1 * c.GrossAmount)
    ,(-1 * ci.ApplicationAmount)
    ,NULL
    ,NULL
    ,NULL
    ,NULL
    ,CASE
        WHEN p.ConfirmationCode = '' THEN 'C' + CAST(p.ConsolidatedId AS varchar)
        ELSE p.ConfirmationCode
        END AS 'ConfirmationCode'
    ,FORMAT(c.CreatedDateTime, 'MM-dd-yyyy')
    ,FORMAT(c.CreditDate, 'MM-dd-yyyy')
    ,NULL
    ,FORMAT(p.ActualPaidDate, 'MM-dd-yyyy')
    ,cns.Name

FROM CreditNote c
    LEFT JOIN PayeeRelationship r ON c.PayeeRelationshipId = r.PayeeRelationshipId
    LEFT JOIN CreditNoteInvoice ci ON c.Id = ci.CreditNoteId
    LEFT JOIN Invoice i ON ci.InvoiceId = i.InvoiceId
    LEFT JOIN Payout p ON i.PayoutId = p.PayoutId
    LEFT JOIN CreditNoteStatus cns ON c.CreditNoteStatusId = cns.Id
    WHERE c.PayorCompanyId = @PayorId
    AND p.ConsolidatedId IS NOT NULL
    AND p.ActualPaidDate BETWEEN @StartDate AND @EndDate