@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Validaciones activas recep. DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_validaciones_activas
  as select from    zclmm_tb_checks                                                     as ch
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_CHECK_DTE' ) as dd on  ch.codet    = dd.value_low
                                                                                              and dd.language = $session.system_language
{
  key ch.bukrs,
  key ch.code,
      ch.codet,
      dd.text,
      ch.activo

}
where
  ch.activo is not initial
