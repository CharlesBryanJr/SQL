use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @PayorCompanyId INT = 142022
DECLARE @StartDate DATETIME = '2022-05-01'
DECLARE @EndDate DATETIME = GETDATE()
SELECT DISTINCT
    prcp.CreatedDateTime,
    -- prcp.PayorCompanyId,
    prcp.id,
    prcp.Name AS 'Carrier Name',
    prcp.McNumber,
    prcp.DotNumber,
    prcp.Scac,
    c.Name AS 'Factor Name',
    f.FactorGuid
    -- prcp.IsQuickPay,
    -- prcp.AchRoutingNumberSecure,
    -- prcp.AchAccountNumberSecure,
    -- prcp.IntermediaryRoutingNumberSecure,
    -- prcp.FactorName,
    -- prcp.FactorCompanyId,
    -- pr.CompanyName 'Carrier Name'
FROM PayeeRelationshipCarrierPacket AS prcp
    INNER JOIN Factor f ON prcp.FactorCompanyId = f.CompanyId
    INNER JOIN Company c ON c.CompanyId = f.CompanyId
    INNER JOIN PayeeRelationship pr ON pr.PayorCompanyId = prcp.PayorCompanyId
WHERE prcp.CreatedDateTime BETWEEN @StartDate AND @EndDate
    AND prcp.PayorCompanyId = @PayorCompanyId
ORDER BY prcp.CreatedDateTime

