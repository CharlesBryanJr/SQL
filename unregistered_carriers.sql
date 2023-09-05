use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @PayorCompanyId INT = 161984 -- WORLDWIDE INTEGRATED SUPPLY CHAIN SOLUTIONS, INC.
SELECT
    pr.ExternalPayeeKey,
    COUNT(i.ExternalInvoiceKey) AS InvoiceCountRemaining,
    SUM(i.NetAmount) AS NetAmountRemaining

FROM PayeeRelationship pr
    INNER JOIN Invoice i on pr.PayeeRelationshipId = i.PayeeRelationshipId

WHERE pr.PayorCompanyId = @PayorCompanyId
    AND pr.PayeeRelationshipStatusId = 1 -- unregistered
    AND i.PayoutId IS NULL -- NOT Paid

GROUP BY pr.ExternalPayeeKey
ORDER BY SUM(i.NetAmount) DESC