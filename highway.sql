use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @PayorCompanyId INT = 1420222
DECLARE @StartDate DATETIME = '2023-05-26'
DECLARE @EndDate DATETIME = '2023-08-02'
SELECT
    cp.PayorCompanyId,
    cp.id,
    cp.Name,
    cp.McNumber,
    cp.DotNumber,
    cp.Scac,
    cp.IsQuickPay,
    cp.AchRoutingNumberSecure,
    cp.AchAccountNumberSecure,
    cp.IntermediaryRoutingNumberSecure,
    cp.FactorName,
    cp.FactorCompanyId,
    cp.CreatedDateTime
FROM dbo.PayeeRelationshipCarrierPacket as CP
WHERE CreatedDateTime BETWEEN @StartDate AND @EndDate
    AND cp.PayorCompanyId = @PayorCompanyId
ORDER BY cp.id