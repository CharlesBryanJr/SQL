with company_load_count as (
    select payorcompanyid, 
        count(*) load_count
        from prod_tpay_data_lake_snapshot_triumphpay_lf_latest.triumphpay_dbo_load
        group by payorcompanyid
        )

select
    company.name,
    company_load_count.load_count company_load_count,
    count(case when core_loads.referenceno is not null then 1 end) found_load,
    count(case when core_loads.referenceno is not null 
    and core_loads.createddatetime < paperwork_submission.created_at 
    and paperwork_submission.created_at < paperwork_submission_payment.created_at 
    then 1
    end
    ) load_then_submission_then_payment

from "paymentsnetwork_public_paperwork_submission_payment_read_models" paperwork_submission_payment
    join "paymentsnetwork_public_paperwork_submission_read_models"  paperwork_submission on paperwork_submission.id = paperwork_submission_payment.paperwork_submission_id
    join "paymentsnetwork_public_core_payor_guid_lookups" core_payor_guid_lookups on core_payor_guid_lookups.broker_data_source_id = paperwork_submission.broker_data_source_id
    join prod_tpay_data_lake_snapshot_triumphpay_lf_latest."triumphpay_dbo_company" company on lower(core_payor_guid_lookups.core_payor_guid) = lower(company.companyguid)
    join company_load_count on company.companyid = company_load_count.payorcompanyid
    join "paymentsnetwork_public_load_read_models" loads on loads.id = paperwork_submission.load_network_id
    left join prod_tpay_data_lake_snapshot_triumphpay_lf_latest."triumphpay_dbo_load" core_loads on loads.load_id = core_loads.referenceno and core_loads.payorcompanyid = company.companyid
group by company.name, company_load_count.load_count