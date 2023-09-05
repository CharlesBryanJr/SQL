Select 
    p.legalname as "Broker Name" ,
    co.name as "Factor Name",
    SUM(invoicecount) as "Invoices", 
    SUM("net amount usd") as "Invoice Amount",
    (case when lower(p.payorguid) in (Select lower(substr(bds.core_payor_guids,3,36)) from 
                                        "prod_tpay_data_lake_snapshot_paymentsnetwork_lf_latest"."paymentsnetwork_public_broker_account_read_models" ba
                                        join "prod_tpay_data_lake_snapshot_paymentsnetwork_lf_latest"."paymentsnetwork_public_broker_data_source_read_models" bds ON bds.broker_account_id = ba.id
                        ) then 1 else 0 end
    ) as "Broker In Network",
    (case when fc.innetwork = false then 0 else 1 end) as "Factor In Network"

From transactionhistory a
    Join triumphpay_dbo_payor p on a.payorcompanyid = p.companyid
    Left Join triumphpay_dbo_payeerelationship py on a.payeerelationshipid = py.payeerelationshipid and a.payeebankaccountcompanyid = py.requestedfactorcompanyid 
    Left Join triumphpay_dbo_company co on py.requestedfactorcompanyid = co.companyid
    Left Join triumphpay_dbo_factor fc on a.payeebankaccountcompanyid = fc.companyid and py.requestedfactorcompanyid = fc.companyid

Where p.payortypeid in (1,2) and year(a."transaction date") = 2023 and month(a."transaction date") in (1,2,3) and a.payorcompanyid = 34168
    Group by p.legalname, p.payorguid, co.name, fc.innetwork