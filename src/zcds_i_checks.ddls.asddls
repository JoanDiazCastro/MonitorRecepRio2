@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Validac. disponibles Monitor Rec. DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED }
define view entity zcds_i_checks
  as select from zclmm_tb_checks as cab

{ 
  key cab.bukrs,
  key cab.code,
      cab.activo,
      cab.codet,
      case
      when cab.activo is not initial
      then '1'
      else '0' end as ValorString

}
