use TriumphPay

DECLARE @PayorId INTEGER = 36173
DECLARE @StartDate DATETIME = '2023-05-01'
DECLARE @EndDate DATETIME = '2023-05-31'
DECLARE @InvoiceStatusId INT = 8 -- 'Removed'

SELECT
    i.ExternalInvoiceKey AS 'External Key',
    i.ExternalPayeeKey AS 'Payee',
    i.PayorCompanyId as 'Payor',
    pr.CompanyName AS 'Payee Company',
    i.ReferenceNo AS 'Reference #',
    i.InvoiceNo AS 'Payor Invoice #',
    i.GrossAmount AS 'Gross Amount',
    i.PayorAdjustmentAmount AS 'Payor Adjustments',
    i.NetAmount AS 'Net Amount',
    i.NetAmountAfterPayeeTermFee AS 'New Amount Due',
    FORMAT(i.ApprovedDate, 'MM/dd/yyyy') AS 'Approved Date',
    FORMAT(i.ScheduledDraftDate, 'MM/dd/yyyy') AS 'Draft Date',
    FORMAT(i.ScheduledPaymentDate, 'MM/dd/yyyy') AS 'Payment Date',
    id.ReconciledDateTime AS 'Draft Reconciled On',
    CAST(i.StatusChangeDate AS DATE) AS 'Removed On',
    i.ActualPayoutTermId AS 'Payout Term',
    ba.DestinationDescription AS 'Pay By',
    CASE WHEN i.ReverseReasonId IS NOT NULL THEN 'Yes' ELSE 'No' END AS 'Was Paid'

FROM dbo.Invoice AS i
    LEFT JOIN PayeeRelationship AS pr ON pr.PayeeRelationshipId = i.PayeeRelationshipId
    LEFT JOIN dbo.PayorIntegration AS pi ON pi.PayorCompanyId = i.PayorCompanyId

    LEFT JOIN InvoiceStatus i_status ON i_status.InvoiceStatusId = i.InvoiceStatusId
    LEFT JOIN InvoiceDraft AS id ON id.InvoiceDraftId = i.InvoiceDraftId

    LEFT JOIN CreditNoteInvoice cni ON cni.InvoiceId = i.InvoiceId
    LEFT JOIN CreditNote cn ON cn.Id = cni.InvoiceId
    LEFT JOIN CreditNoteStatus cns on cns.Id = cn.CreditNoteStatusId

    LEFT JOIN Payout p ON p.PayoutId = i.PayoutId
    LEFT JOIN TransactionLineItem tli ON tli.InvoiceId = i.InvoiceId
    LEFT JOIN [Transaction] t ON t.Id = tli.TransactionId
    LEFT JOIN TransactionType tt on tt.Id = t.TransactionTypeId
    LEFT JOIN dbo.PayoutTerm as pt on pt.PayoutTermId = i.ActualPayoutTermId
    LEFT JOIN BankAccount AS ba ON ba.BankAccountId = i.BankAccountId

WHERE i.PayorCompanyId = @PayorId
    AND i.InvoiceStatusId = @InvoiceStatusId
    AND i.UploadedDate < getdate();
