Athena w/ triumphpay_lf_latest active:
select 
    company.name,
    payorbrokerdatasource.payorcompanyid is not null as already_in_network,
    count(*) invoices_last_30_days,
    count(load.id) invoices_with_loads_last_30_days,
    count(case when load.referenceno = invoice.referenceno and load.payorcompanyid = invoice.payorcompanyid and load.externalpayeekey = invoice.externalpayeekey then 1 end) loads_matched_by_referenceno,
    count(case when load.externalloadkey = invoice.externalloadkey and load.payorcompanyid = invoice.payorcompanyid and load.externalpayeekey = invoice.externalpayeekey then 1 end) loads_matched_by_externalloadkey,
    (select count(*) from triumphpay_dbo_load where payorcompanyid = payor.companyid) total_loads

from "triumphpay_dbo_invoice" invoice 
    join "triumphpay_dbo_company" company on invoice.payorcompanyid = company.companyid
    join "triumphpay_dbo_payor" payor on company.companyid = payor.companyid
    left join "triumphpay_dbo_load"  load on (load.referenceno = invoice.referenceno 
        and load.referenceno is not null or load.externalloadkey = invoice.externalloadkey and load.externalloadkey is not null) 
        and (load.payorcompanyid = invoice.payorcompanyid) 
        and (load.externalpayeekey = invoice.externalpayeekey)
    left join "triumphpay_dbo_payorbrokerdatasource" payorbrokerdatasource on payorbrokerdatasource.payorcompanyid = company.companyid

where invoice.createddatetime > now() - interval '30' day
    and payor.isactive = true
    group by company.name, payor.companyid, payorbrokerdatasource.payorcompanyid
    order by count(*) desc