@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Resultado validaciones DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'Validaciones'
define view entity zcds_c_checks_dte
  as select distinct from zcds_i_validaciones_activas
{
  key bukrs as Sociedad,
  key code  as PosicString,
      text  as DescrValidacion

}
