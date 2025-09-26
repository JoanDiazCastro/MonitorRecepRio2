@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Interfaz parametros tvarvc'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_I_PARAM_TVARVC
  as select from zclmm_tb_tvarvc
{
  key id    as Id,
  key name  as Name,
      value as Value
}
