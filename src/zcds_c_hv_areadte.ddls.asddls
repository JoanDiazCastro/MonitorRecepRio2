@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda asignación área DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'AreaAsignacion'
define view entity zcds_c_hv_areadte
  as select from zclmm_tb_areadte
{
  key  codarea  as CodigoArea,
       descarea as Decripcion
}
