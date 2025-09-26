@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Devoluciones mcía.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_devoluciones
  as select distinct from I_PurchaseOrderHistoryAPI01 as eb
    inner join            I_PurchaseOrderItemAPI01    as ep on  eb.PurchaseOrder     = ep.PurchaseOrder
                                                            and eb.PurchaseOrderItem = ep.PurchaseOrderItem
    inner join            I_PurchaseOrderAPI01        as ek on eb.PurchaseOrder = ek.PurchaseOrder
    left outer join       zcds_i_anulac_devoluciones  as an on  eb.PurchaseOrder                 = an.ebeln
                                                            and eb.PurchaseOrderItem             = an.ebelp
                                                            and eb.PurchasingHistoryDocument     = an.smbln
                                                            and eb.PurchasingHistoryDocumentItem = an.smblp
    left outer join       zcds_i_devoluc_fact         as fa on  eb.PurchasingHistoryDocumentYear = fa.lfgja
                                                            and eb.PurchasingHistoryDocument     = fa.lfbnr
                                                            and eb.PurchasingHistoryDocumentItem = fa.lfpos
    left outer join       I_ServiceEntrySheetAPI01    as es on  eb.PurchaseOrder = es.PurchaseOrder // es.ebeln
    //and eb.PurchaseOrderItem = es.PurchaseOrder      //es.ebelp
                                                            and es.IsDeleted     is initial //es.loekz             is initial
{
  key eb.PurchaseOrder                     as ebeln,
  key eb.PurchaseOrderItem                 as ebelp,
  key eb.PurchasingHistoryDocumentYear     as gjahr,
  key eb.PurchasingHistoryDocument         as belnr,
  key eb.PurchasingHistoryDocumentItem     as buzei,
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      eb.Quantity                          as menge,
      @Semantics.amount.currencyCode: 'HSWAE'
      eb.PurOrdAmountInCompanyCodeCrcy     as dmbtr,
      @Semantics.amount.currencyCode: 'WAERS'
      eb.PurchaseOrderAmount               as wrbtr,
      eb.Currency                          as hswae, // No encontre el hswae en la tabla I_PurchaseOrderHistoryAPI01
      eb.DebitCreditCode                   as shkzg,
      eb.GoodsMovementType                 as bwart,
      eb.ReferenceDocument                 as lfbnr,
      eb.ReferenceDocumentItem             as lfpos,
      ep.PurchaseOrderQuantityUnit         as meins,
      eb.Currency                          as waers,
      //      es.lblni                             as hes,
      es.ServiceEntrySheet                 as hes,
      ek.PurchaseOrderType                 as bsart,
      ep.TaxCode                           as mwskz,
      ep.PurchaseOrderItemText             as txz01,
      ep.OrderPriceUnit,
      ep.InvoiceIsGoodsReceiptBased,
      @Semantics.amount.currencyCode: 'MONCLP'
      cast(
      ( case
      when eb.Currency = 'CLP' then cast(eb.PurOrdAmountInCompanyCodeCrcy as abap.dec( 13, 2 ))
      when eb.Currency = 'CLP' then cast(eb.PurchaseOrderAmount as abap.dec( 13, 2 ))
      else 0 end  ) as abap.curr( 13, 2 )) as mntclp,
      cast( 'CLP' as abap.cuky( 5 ))       as monclp
}
where
      eb.GoodsMovementType         = '161'
  and eb.PurchasingHistoryCategory = 'E'
  and an.belnr                     is null
  and fa.belnr                     is null
