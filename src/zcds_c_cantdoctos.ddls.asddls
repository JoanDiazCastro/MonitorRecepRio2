@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cantidad documentos procesamiento masivo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'CantDoctos'
//@OData.publish: true
define view entity zcds_c_cantdoctos
  as select from zclmm_tb_tvarvc
{
  key value as CantidadDocumentos
}
where
  name = 'ZCLMM_CANT_AREA'
//  and type = 'P'
