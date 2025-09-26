@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status aceptación/rechazo DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_status_acrech_dte
  as select from zclmm_tb_cabdte  as cab
    inner join   zclmm_tb_procdte as pro on cab.iddte_sap = pro.iddte_sap
{
  key cab.iddte_sap,
      pro.tipo_evto,
      dats_days_between( cab.fchemis, $session.system_date ) as dias


}
