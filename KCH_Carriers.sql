use TriumphPay

DECLARE @PayorId INT = 171964 -- KCH TRANSPORTATION, INC.

SELECT
    pr.ExternalPayeeKey AS 'ExternalPayeeKey',
    pr.CompanyName AS 'CompanyName'

FROM PayeeRelationship as pr