use TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @PayorId_1 INT = 49205 -- Amstrong USD
DECLARE @PayorId_2 INT = 77023 -- Amstrong CAD
DECLARE @StartDate DATETIME = '2023-01-01'
DECLARE @EndDate DATETIME = GETDATE()

-- BQP ActualPayoutTermIds
-- USD: 9070, 9074, 3768
-- CAD: 9076

SELECT DISTINCT
    i.UploadedDate,
    i.ExternalInvoiceKey,
    i.ExternalPayeeKey,
    p.CompanyName,
    p.MCNumber,
    i.ReferenceNo,
    i.InvoiceNo,
    i.NetAmount,
    t.Code as PayoutTerm,
    t.PayorFlatFee,
    i.ScheduledDraftDate,
    i.ScheduledPaymentDate

FROM Invoice i
    INNER JOIN PayeeRelationship as p on p.PayeeRelationshipId = i.PayeeRelationshipId
    INNER JOIN PayoutTerm as t on t.PayoutTermId = i.ActualPayoutTermId

WHERE (i.PayorCompanyId = @PayorId_1 OR i.PayorCompanyId = @PayorId_2)
    AND (i.ActualPayoutTermId = 9070
             OR i.ActualPayoutTermId = 9074
             OR i.ActualPayoutTermId = 3768
             OR i.ActualPayoutTermId = 9076
        )
    AND (i.ScheduledPaymentDate BETWEEN @StartDate AND @EndDate)
ORDER BY i.UploadedDate