-- Data source:
-- Database: prod_tpay_data_lake_snapshot_hubtran_lf_latest
SELECT
    car.external_id as PrimaryKey,
    car.name as CompanyName,
    car.mc_number as MCNumber,
    car.dot_number as DOTNumber,
    car.scac as SCAC,
    car.address_line_1 as Addr1,
    car.address_line_2 as Addr2,
    car.city as City,
    car.state as State,
    car.postal_code as PostalCode,
    '' as PrimaryPhoneNumber,
    car.email_domain as PrimaryContactEmail,
    ad.name as RemitName,
    ad.address_line_1 as RemitAddr1,
    ad.address_line_2 as RemitAddr2,
    ad.city as RemitCity,
    ad.state as RemitState,
    ad.postal_code as RemitPostalCode
FROM hubtran_production_public_tms_carriers car
    JOIN hubtran_production_public_account_roles rol on car.broker_id = rol.id
    JOIN hubtran_production_public_accounts acc on rol.account_id = acc.id
    JOIN hubtran_production_public_addresses ad on ad.id = car.tms_payment_address_id
Where acc.id = 1027
    -- AND car.external_id = 'JACSACA'