USE TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @StartDate DATETIME = '2022-08-04'
DECLARE @EndDate DATETIME = '2023-08-04'
SELECT
    p.CompanyId,
    p.LegalName,
    COUNT(DISTINCT pr.ExternalPayeeKey) AS CarrierCount,
    COUNT(DISTINCT i.ExternalInvoiceKey) AS InvoiceCount,
    SUM(CASE WHEN i.IsQuickpay = 1 THEN 1 ELSE 0 END) AS QuickPayCount,
    AVG(i.NetAmount) AS AverageInvoiceAmount,
    MAX(i.NetAmount) AS MaxNetAmount,
    MIN(i.NetAmount) AS MinNetAmount,
    SUM(i.NetAmount) AS NetAmountPaid
FROM Payor AS p
    INNER JOIN Invoice AS i ON i.PayorCompanyId = p.CompanyId
    INNER JOIN PayeeRelationship AS pr ON p.CompanyId = pr.PayorCompanyId
WHERE p.IsActive = 1
    AND p.PayorTypeId = 1
GROUP BY p.CompanyId,
         p.LegalName
HAVING COUNT(DISTINCT i.ExternalInvoiceKey) > 1000
ORDER BY SUM(i.NetAmount) DESC,
         COUNT(DISTINCT i.ExternalInvoiceKey) DESC