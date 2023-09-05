use TriumphPay

DECLARE @PayorId INT = 48193 -- ILG LOGISTICS
DECLARE @StartDate DATETIME = '2022-12-01'
DECLARE @EndDate DATETIME = '2023-06-07'
DECLARE @InvoiceStatusId INT = 3 -- Paid
DECLARE @IsQuickpay INT = 1 -- True

SELECT
    i.ExternalInvoiceKey AS 'External Key',
    i.ExternalPayeeKey AS 'Payee Key',
    pr.CompanyName AS 'Carrier',
    i.ReferenceNo AS 'Reference #',
    i.InvoiceNo AS 'Carrier Invoice #',
    i.NetAmount AS 'Net Amount',
    FORMAT(i.ScheduledDraftDate, 'MM/dd/yyyy') AS 'Draft Date',
    FORMAT(i.ScheduledPaymentDate, 'MM/dd/yyyy') AS 'Payment Date',
    id.InvoiceDraftId as 'Draft Id'

FROM Invoice AS i
    LEFT JOIN PayeeRelationship AS pr ON pr.PayeeRelationshipId = i.PayeeRelationshipId
    LEFT JOIN InvoiceDraft AS id ON id.InvoiceDraftId = i.InvoiceDraftId

WHERE i.PayorCompanyId = @PayorId
    AND i.UploadedDate BETWEEN @StartDate AND @EndDate
    AND i.InvoiceStatusId = @InvoiceStatusId
    AND i.IsQuickpay = @IsQuickpay

