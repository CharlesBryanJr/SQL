/*
This should result in a report that:
pulls all invoices uploaded during the time period in a csv
includes the fields specified in the SQL 
includes ScheduledDraftDate and ScheduledPaymentDate
includes Terms and Additional Data Items (for future shipper support) 
Additional Data Items should be included as additional columns
names the fields as ATG and BNSF expect 
See naming convention in SQL
is configurable in the UI to be sent daily, weekly, or monthly to an S3 bucket

SQL Query Adjustments: 
,i.PayorPayeeTermFeeAmount AS 'ArmstrongQPRev' - should read "[Payor]QPRev"
,(-1 * i.TriumphPayorTermFeeAmount) AS 'ArmstrongQPFee' - should read "[Payor]QPFee"
Add Terms
Add ScheduledDraftDate and ScheduledPaymentDate (see updated SQL in comment) 
Add Additional Data Items 
*/

-- Database and transaction setup:
use TriumphPay -- selects the TriumphPay database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- allowing the query to access uncommitted data.

-- Variable declaration:
-- These variables will be used in the query to filter the data based on the specified payor ID, start date, and end date.
DECLARE @PayorId INTEGER = '49205'
DECLARE @StartDate DATETIME = '2021-11-01';
DECLARE @EndDate DATETIME = '2021-12-09';

-- Main SELECT statement:
-- this SELECT statement retrieves data from the InvoiceLineItem table, 
-- joining it with other related tables (Invoice, PayeeRelationship, and InvoiceStatus) 
-- based on specified conditions.
SELECT
    i.ExternalInvoiceKey AS 'ExternalKey'
    ,i.ExternalPayeeKey
    ,r.CompanyName AS 'CarrierName'
    ,r.MCNumber
    ,r.DOTNumber
    ,'False' AS 'IsCreditNote'
    ,i.ReferenceNo
    ,i.InvoiceNo
    ,i.NetAmount AS 'OriginalAmount'
    ,ili.[Description]
    ,ili.Amount
    ,s.Name AS 'Status'
    ,FORMAT(i.UploadedDate, 'MM/dd/yyyy') AS 'UploadedDate'
    ,FORMAT(i.ScheduledPaymentDate, 'MM/dd/yyyy') AS 'ScheduledPaymentDate'
    ,FORMAT(i.ScheduledDraftDate, 'MM/dd/yyyy') AS 'ScheduledDraftDate'
    
FROM InvoiceLineItem ili --  specifies the which table in the database to retrieves data from
    LEFT JOIN Invoice i ON ili.InvoiceId = i.InvoiceId
    LEFT JOIN PayeeRelationship r ON i.PayeeRelationshipId = r.PayeeRelationshipId
    LEFT JOIN InvoiceStatus s ON i.InvoiceStatusId = s.InvoiceStatusId

-- The WHERE clause filters the data based on the payor company ID, uploaded date range, and active invoice line items
WHERE i.PayorCompanyId = @PayorId
    AND i.UploadedDate BETWEEN @StartDate AND @EndDate
    AND ili.IsActive = 1

-- This UNION ALL statement appends additional rows to the result set, 
-- selecting data from the CreditNote table 
-- and joining it with the PayeeRelationship and CreditNoteStatus tables.
UNION ALL

SELECT TOP 100
    c.ExternalKey
    ,c.ExternalPayeeKey
    ,r.CompanyName AS 'CarrierName'
    ,r.MCNumber
    ,r.DOTNumber
    ,'True' AS 'IsCreditNote'
    ,c.ReferenceNo
    ,c.InvoiceNo
    ,(-1* c.GrossAmount)
    ,NULL
    ,NULL
    ,NULL
    ,cns.Name
    ,FORMAT(c.CreatedDateTime, 'MM-dd-yyyy') AS 'UploadedDate'

FROM CreditNote c
    LEFT JOIN PayeeRelationship r ON c.PayeeRelationshipId = r.PayeeRelationshipId
    LEFT JOIN CreditNoteStatus cns on c.CreditNoteStatusId = cns.Id

-- The WHERE clause filters the data based on the payor company ID and created date range
WHERE c.PayorCompanyId = @PayorId
    AND c.CreatedDateTime BETWEEN @StartDate AND @EndDate