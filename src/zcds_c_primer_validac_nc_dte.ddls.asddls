@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Primera validación no cumplida DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_c_primer_validac_nc_dte
  as select from zcds_i_validaciones_dte
{
  key IdDTE,
      min( PosValidac ) as PosValidac
}
where
  ValorEsperado != ValorDTE
group by
  IdDTE
