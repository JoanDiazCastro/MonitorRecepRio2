@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OC referencia DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_refoc_dte as select from zclmm_tb_refdte as ref
left outer join zclmm_tb_cabdte as cab on ref.iddte_sap = cab.iddte_sap
{
  key ref.iddte_sap ,
  key ref.nrolinref ,
      ref.tpodocref ,
      lpad((cast( left(ref.folioref, 10) as ebeln )),10,'0') as ebeln,
      cab.fchemis as FechaEmision 
}
where
  ref.tpodocref = '801'
