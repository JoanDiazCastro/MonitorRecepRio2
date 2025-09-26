@AbapCatalog.sqlViewName: 'ZV_I_HV_SOC'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HV encontrar OC al contabilizar Sin OC'
define view ZCDS_I_HV_AYUDA_SINOC
  as select distinct from I_PurchaseOrderAPI01
{   
  key PurchaseOrder,
      Supplier       
}
