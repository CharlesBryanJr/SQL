/*

Problem: When a payment fails and an invoice goes into Pending Reissue, the broker is typically not aware of the issue until too late. If they're proactive, this data can be pulled by exporting Invoices under Pending Reissue, but they typically find out from a disgruntled carrier. 
Major brokers are currently receiving this report manually from our Ops team. 

Solution: Generate a report of pending-reissue invoices at a specific time period, with the reason they are in that status, so it can be sent automatically to the broker. 

As a payor, 
I would like to receive pending-reissue invoices (with credit notes handled as an accounting software wants to)
so that I can open and close my books at a general ledger level.

ATG/BNSF are currently receiving the attached report. This report will be configurable on the Admin UI to be sent daily/weekly/monthly to a specific S3 bucket. 
This should result in a report that:
pulls all invoices marked pending-reissue during the time period in a csv
includes the fields specified in the SQL 
includes Terms, Status, and Additional Data Items (for future shipper support) 
Additional Data Items should be included as additional columns
names the fields as ATG and BNSF expect 
See naming convention in SQL 
is configurable in the UI to be sent daily, weekly, or monthly to an S3 bucket

SQL Query Adjustments: 
,i.PayorPayeeTermFeeAmount AS 'ArmstrongQPRev' - should read "[Payor]QPRev"
,(-1 * i.TriumphPayorTermFeeAmount) AS 'ArmstrongQPFee' - should read "[Payor]QPFee"
Add Terms
Add Status Notes
Add Additional Data Items 
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
    LEFT JOIN TransactionLineItem TLI ON i.InvoiceId = TLI.InvoiceId
    LEFT JOIN [Transaction] t ON tli.TransactionId = t.Id
    LEFT JOIN TransactionType TT on t.TransactionTypeId = TT.Id

WHERE i.PayorCompanyId = @PayorId
    AND i.InvoiceStatusId = 10 --Pending Reissue
    AND t.TransactionTypeId = 4
    AND t.TransactionDate BETWEEN @StartDate AND @EndDate
    AND tli.AccountingEntryTypeId = 0