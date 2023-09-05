Use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @PayorCompanyId INT = 161984
DECLARE @StartDate DATETIME = '2023-07-25'
DECLARE @EndDate DATETIME = '2023-07-26'

SELECT
    r.ExternalPayeeKey,
    r.CompanyName,
    prar.Name RemitTo,
    prar.Addr1,
    prar.Addr2,
    prar.City,
    prar.State,
    prar.PostalCode,
    (CASE
        WHEN prar.IsReviewed = 1
            THEN 1
        ELSE 0
    END) as IsReviewd,
    c.Name

FROM PayeeRemitAddressRequest prar
JOIN PayeeRelationship r ON r.PayeeRelationshipId = prar.PayeeRelationshipId
    LEFT JOIN Company c ON r.OverrideFactorCompanyId = c.CompanyId
WHERE prar.PayorCompanyId = @PayorCompanyId
    AND prar.IsReviewed = 1
    AND c.CreatedDateTime BETWEEN @StartDate AND @EndDate
ORDER BY r.ExternalPayeeKey