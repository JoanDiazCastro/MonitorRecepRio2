@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda de búsqueda proveedor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'Proveedor'
//@OData.publish: true
define view entity zcds_c_hv_proveedor
  as select from I_Supplier as supp
{
      @Search.defaultSearchElement: true
  key supp.Supplier              as Proveedor,
      case supp.SupplierName
      when ' ' then supp.SupplierFullName
      else supp.SupplierName end as Nombre
}
