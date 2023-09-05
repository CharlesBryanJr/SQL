-- Broker Invoice Query
use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT
    PR.CompanyName
    ,PI.Division
    ,i.ExternalPayeeKey
    ,i.ExternalInvoiceKey
    ,i.NetAmount
    ,i.ReferenceNo
    ,i.InvoiceNo
    ,i.UploadedDate
    ,i.ScheduledDraftDate
    ,i.ScheduledPaymentDate
    ,i.InvoiceStatusId

FROM dbo. Invoice AS i
    LEFT JOIN dbo.PayeeRelationship AS PR ON i.PayeeRelationshipId = PR.PayeeRelationshipId
    LEFT JOIN dbo.PayorIntegration AS PI ON i.PayorCompanyId = PI.PayorCompanyId

WHERE i.PayorCompanyId IN ('124966','124975','124939','124922')
    AND i.InvoiceStatusId IN ('2','6','10','11')
    AND i.ScheduledPaymentDate = '2022-05-10'