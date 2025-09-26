@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Validaciones DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_validaciones_dte
  as select from zclmm_tb_checks  as vsoc
    inner join   zclmm_tb_procdte as vdte on vsoc.bukrs = vdte.bukrs
{
  key vdte.iddte_sap                                  as IdDTE,
  key vsoc.code                                       as PosValidac,
      vsoc.codet                                      as CodValidac,
      case
      when vsoc.activo = 'X'
      then '1'
      else '0' end                                    as ValorEsperado,
      (substring(vdte.checks,1, 1 ) ) as ValorDTE,
      vsoc.rechau as RechazoAuto,
      vsoc.motmail,
      vsoc.motrech

}
