@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parametrizaciones globales Recep. DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'Parametrizaciones'
@Metadata.allowExtensions: true
define root view entity zcds_c_parglob_dte
  as select from zcds_i_parglob_dte
{
  key Sociedad,
  key Parametro,
      Descripcion,
      activo

}
