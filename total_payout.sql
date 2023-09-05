use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @PayorCompanyId INT = 142022 -- BCB
DECLARE @NetAmount INT = 100000
DECLARE @InvoiceCount INT = 200
SELECT
    pr.MCNumber,
    pr.DOTNumber,
    COUNT(DISTINCT i.ExternalInvoiceKey) AS InvoiceCount,
    SUM(i.NetAmount) AS TotalNetAmount
FROM Invoice AS i
    INNER JOIN PayeeRelationship AS pr on pr.PayeeRelationshipId = i.PayeeRelationshipId
WHERE i.PayorCompanyId = @PayorCompanyId
GROUP BY pr.MCNumber,
         pr.DOTNumber
HAVING SUM(i.NetAmount) > @NetAmount
    AND COUNT(DISTINCT i.ExternalInvoiceKey) > @InvoiceCount
ORDER BY SUM(i.NetAmount) DESC,
         COUNT(DISTINCT i.ExternalInvoiceKey) DESC