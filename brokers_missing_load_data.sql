use TriumphPay

SELECT p.companyid, 
    ct.Name, 
    p.legalname, 
    ptt.name as 'Tier', 
    pt.name as 'PayorType', 
    pst.name as 'PayorSubType', 
    p.GoLiveDateTime

FROM [TriumphPay].[dbo].[Payor] p
    left join payortype pt on pt.payortypeid = p.payortypeid
    left join payorsubtype pst on pst.id = p.PayorSubTypeId
    left join CurrencyType ct on ct.CurrencyTypeId = p.CurrencyTypeId
    left join PayorTierType ptt on ptt.id = p.PayorTierTypeId
    
WHERE 
    p.payortypeid = 1 
    and p.IsActive = 1
    and not exists (select 1 from load l where l.PayorCompanyId = p.companyid)