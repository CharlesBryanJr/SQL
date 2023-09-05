-- Broker Carrier Information
use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @PayorCompanyId INT = 142022 -- BCB
SELECT DISTINCT
    r.ExternalPayeeKey as ExternalPayeeKey
    ,r.CompanyName
    ,r.MCNumber
    ,r.DOTNumber
    ,r.SCAC
    ,r.Addr1
    ,r.Addr2
    ,r.City
    ,r.State
    ,r.PostalCode
    ,r.Country
    ,r.PhoneNumber
    ,r.PrimaryEmail
    ,c.Name as FactorName
    ,a.Name as RemitName
    ,a.Addr1 as RemitAddr1
    ,a.Addr2 as RemitAddr2
    ,a.City as RemitCity
    ,a.State as RemitState
    ,a.PostalCode as RemitPostalCode
    ,a.Country as RemitCountry
FROM PayeeRelationship r
    LEFT JOIN Company c ON r.OverrideFactorCompanyId = c.CompanyId
    LEFT JOIN PayeeRemitAddressRequest a ON r.PayeeRelationshipId = a.PayeeRelationshipId
    LEFT JOIN invoice i on i.PayorCompanyId = r.PayorCompanyId
WHERE r.PayorCompanyId = @PayorCompanyId
ORDER BY r.ExternalPayeeKey DESC