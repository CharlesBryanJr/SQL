use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @StartDate DATETIME = '2023-01-01'
DECLARE @EndDate DATETIME = GETDATE()
SELECT DISTINCT
    i.NetAmount,
    l.Distance,
    l.PickupDate,
    l.OriginState,
    l.DeliveryDate,
    l.DestinationState,
    p.MCNumber 'PayorMC',
    p.DOTNumber 'PayorDOT',
    pr.MCNumber 'PayeeMC',
    pr.DOTNumber 'PayeeDOT'
FROM invoice AS i
    INNER JOIN PayeeRelationship pr on i.PayeeRelationshipId = pr.PayeeRelationshipId
    INNER JOIN Payor p on i.PayorCompanyId = p.CompanyId
    INNER JOIN Load l on i.ExternalLoadKey = l.ExternalLoadKey
    INNER JOIN Payout on p.CompanyId = Payout.PayorCompanyId
WHERE i.UploadedDate BETWEEN @StartDate AND @EndDate
    AND i.IsQuickpay = 1
    AND l.Distance > 0
    AND l.NetAmount IS NOT NULL
    AND l.Distance IS NOT NULL
    AND l.PickupDate IS NOT NULL
    AND l.OriginState IS NOT NULL
    AND l.DeliveryDate IS NOT NULL
    AND l.DestinationState IS NOT NULL
    AND p.MCNumber IS NOT NULL
    AND p.DOTNumber IS NOT NULL
    AND pr.MCNumber IS NOT NULL
    AND pr.DOTNumber IS NOT NULL
-- ORDER BY i.NetAmount DESC