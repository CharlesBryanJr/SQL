-- Loads added to network brokers (in Audit) in the past 30 days = 612,678

select count(*) 
    
From prod_tpay_data_lake_snapshot_paymentsnetwork_lf_latest."paymentsnetwork_public_broker_data_source_read_models" broker_data_source
    join prod_tpay_data_lake_snapshot_hubtran_lf_latest."hubtran_production_public_accounts" accounts on broker_data_source.hubtran_account_id = accounts.id
    join prod_tpay_data_lake_snapshot_hubtran_lf_latest."hubtran_production_public_tms_loads" loads on loads.account_id = accounts.id

where loads.created_at > now() - interval '30' day