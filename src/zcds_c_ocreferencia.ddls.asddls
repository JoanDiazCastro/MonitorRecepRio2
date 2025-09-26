@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ordenes de compra referencia DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'OrdenCompra'
//@OData.publish: true
define view entity zcds_c_ocreferencia
  as select distinct from zcds_i_em_fact_pdte
{
  key ebeln as OrdenCompra,
      lifnr as Proveedor

}
