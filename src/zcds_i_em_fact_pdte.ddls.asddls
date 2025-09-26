@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EM pendientes por facturar'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zcds_i_em_fact_pdte
  as select from    I_PurchaseOrderHistoryAPI01  as em
    inner join      I_PurchaseOrderAPI01         as ek on em.PurchaseOrder = ek.PurchaseOrder
    inner join      I_PurchaseOrderItemAPI01     as ep on  em.PurchaseOrder     = ep.PurchaseOrder
                                                      and em.PurchaseOrderItem = ep.PurchaseOrderItem
    left outer join I_ServiceEntrySheetItemAPI01 as es on  em.PurchaseOrder     = es.PurchaseOrder
                                                      and em.PurchaseOrderItem = es.PurchaseOrderItem
                                                      and es.IsDeleted         = ''
    left outer join zcds_i_an_em                 as an on  em.PurchaseOrder                 = an.ebeln
                                                      and em.PurchaseOrderItem             = an.ebelp
                                                      and em.PurchasingHistoryDocument     = an.smbln
                                                      and em.PurchasingHistoryDocumentItem = an.smblp
    left outer join zcds_i_em_fact               as fa on  em.PurchasingHistoryDocumentYear = fa.lfgja
                                                      and em.PurchasingHistoryDocument     = fa.lfbnr
                                                      and em.PurchasingHistoryDocumentItem = fa.lfpos
  //    left outer join zcds_i_factor_iva_c4 as fi on ep.mwskz = fi.indicador
    left outer join zcds_i_refoc_dte             as rf on ek.PurchaseOrder = rf.ebeln



{
  key rf.iddte_sap,
  key em.PurchaseOrder                     as ebeln,
  key em.PurchaseOrderItem                 as ebelp,
  key em.PurchasingHistoryDocumentYear     as gjahr,
  key em.PurchasingHistoryDocument         as belnr,
  key em.PurchasingHistoryDocumentItem     as buzei,
      ek.PurchaseOrderType                 as bsart,
      ek.Supplier                          as lifnr,
      em.ReferenceDocument                 as lfbnr,
      em.ReferenceDocumentItem             as lfpos,
      //      @Semantics.amount.currencyCode: 'MONCLP'
      //      cast ( (
      //      case
      //      when ep.mwskz = 'C4' and em.hswae = 'CLP' then
      //      (division( (cast(em.dmbtr as abap.dec( 13, 2 ))), fi.factor, 2 ))
      //      when ep.mwskz = 'C4' and em.waers = 'CLP' then
      //       (division( (cast(em.wrbtr as abap.dec( 13, 2 ))), fi.factor, 2 ))
      //      when ep.mwskz != 'C4' and em.hswae = 'CLP' then
      //      (division( (cast(em.dmbtr as abap.dec( 13, 2 ))), fi.factor, 2 ))
      //      when ep.mwskz != 'C4' and em.waers = 'CLP' then
      //       (division( (cast(em.wrbtr as abap.dec( 13, 2 ))), fi.factor, 2 ))
      //      else   0 end ) as  abap.curr( 13, 2 ) ) as neto,
      @Semantics.amount.currencyCode: 'WAERS'
      em.PurOrdAmountInCompanyCodeCrcy     as dmbtr,
      //      em.hswae, // No lo encontre
      @Semantics.amount.currencyCode: 'WAERS'
      em.PurchaseOrderAmount               as wrbtr,
      em.Currency                          as waers,
      es.ServiceEntrySheet                 as hes,
      ep.TaxCode                           as mwskz,
      ep.PurchaseOrderItemText             as txz01,
      ep.PurchaseOrderQuantityUnit         as meins,
      ep.OrderPriceUnit                    as bprme,
      ep.InvoiceIsGoodsReceiptBased        as webre,
      ep.ProductType,
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      em.Quantity                          as menge,
      @Semantics.amount.currencyCode: 'MONCLP'
      cast(
      ( case
      //      when em.hswae = 'CLP' then cast(em.PurOrdAmountInCompanyCodeCrcy as abap.dec( 13, 2 ))
      when em.Currency = 'CLP' then cast(em.PurchaseOrderAmount as abap.dec( 13, 2 ))
      when em.Currency = 'UF' and rf.FechaEmision is not null then
      cast((currency_conversion( amount => em.PurchaseOrderAmount,
      source_currency => em.Currency,
      round => 'X',
      target_currency => cast( 'CLP' as abap.cuky( 5 )) ,
      exchange_rate_date => rf.FechaEmision,
      error_handling => 'SET_TO_NULL',
      client => $session.client ) ) as abap.dec( 13, 2 ))
      when em.Currency = 'UF' and rf.FechaEmision is null then
      cast((currency_conversion( amount => em.PurchaseOrderAmount,
      source_currency => em.Currency,
      round => 'X',
      target_currency => cast( 'CLP' as abap.cuky( 5 )) ,
      exchange_rate_date => em.PostingDate,
      error_handling => 'SET_TO_NULL',
      client => $session.client ) ) as abap.dec( 13, 2 ))
      else 0 end  ) as abap.curr( 13, 2 )) as mntclp,
      cast( 'CLP' as abap.cuky( 5 ))       as monclp

}
where
  (
       em.GoodsMovementType              = '101' // bwart
    or em.GoodsMovementType              = '161' // bwart
  )
  and  an.belnr                          is null
  and  fa.belnr                          is null
  and  ep.PurchasingDocumentDeletionCode is initial
