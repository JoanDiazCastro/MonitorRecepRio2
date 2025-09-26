@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entradas Mcía. factura pendientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'DoctosMaterial'
//@OData.publish: true
define view entity zcds_c_em_fact_pdte
  as select from zcds_i_em_fact_pdte as em
{
  key em.iddte_sap as IdDTE,
  key ebeln        as OrdenCompra,
  key belnr        as DoctoMaterial,
      @Semantics.amount.currencyCode: 'Moneda'
      //     sum(wrbtr) as Total,
      //      waers       as Moneda
      sum(mntclp)  as Total,
      monclp       as Moneda

}
group by
  ebeln,
  belnr,
  monclp,
  iddte_sap
