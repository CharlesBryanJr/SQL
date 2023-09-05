use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @PayorId INT = 161984 -- WORLDWIDE INTEGRATED SUPPLY CHAIN SOLUTIONS, INC.
DECLARE @StartDate DATETIME = '2023-07-24'
DECLARE @EndDate DATETIME = '2023-07-25'

SELECT
    Payout.PayoutId,
    -- Payout.PayoutGuid,
    Payout.CreatedDateTime,
    -- Payout.PayorCompanyId,
    --Payor.LegalName,
    -- PayeeRelationship.ExternalPayeeKey,
    -- PayeeRelationship.CompanyName,
    Invoice.ExternalInvoiceKey,
    Invoice.ReferenceNo,
    Invoice.NetAmount,
    Invoice.IsQuickpay
FROM Payout
    FULL JOIN Invoice on Payout.PayoutId = Invoice.PayoutId
    -- FULL JOIN Payor ON Payout.PayorCompanyId = Payor.CompanyId
    -- LEFT JOIN PayeeRelationship ON Payor.CompanyId = PayeeRelationship.PayorCompanyId
WHERE (Payout.CreatedDateTime BETWEEN @StartDate AND @EndDate)
    AND Invoice.IsQuickpay = 1
    AND Payout.PayorCompanyId = @PayorId
ORDER BY PayoutId
