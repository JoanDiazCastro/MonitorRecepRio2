@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Referencias Entrada de mercancía'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'RefEM'
//@OData.publish: true
@Metadata.allowExtensions: true
define view entity zcds_c_recdte_ref_em
  as select from zclmm_tb_refdte as ref
  //    left outer join zcds_c_em_fact_pdte as em on  em.IdDTE         = ref.iddte_sap
  //                                              and em.DoctoMaterial = ref.folioref
{
  key ref.iddte_sap                     as IdDTE,
  key ref.nrolinref                     as NroLinea,
      ref.folioref                      as DoctoMaterial,
      @Semantics.amount.currencyCode: 'Moneda'
      cast(1520 as abap.curr( 15, 2 ) ) as total,
      cast('CLP' as waers )             as Moneda
      //      em.Total      as Total,
      //      em.Moneda     as Moneda

}
where
  ref.tpodocref = 'EM'
