@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Imputaciones material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_imputaciones_mat
  as select from I_PurchaseOrderHistoryAPI01 as em
    inner join   I_PurchaseOrderItemAPI01    as ep on  em.PurchaseOrder     = ep.PurchaseOrder
                                                   and em.PurchaseOrderItem = ep.PurchaseOrderItem
    inner join   I_OperationalAcctgDocItem   as bs on  em.PurchaseOrder             = bs.PurchasingDocument
                                                   and bs.PurchasingDocumentItem    = em.PurchaseOrderItem
                                                   and bs.OriginalReferenceDocument = concat(
      em.PurchasingHistoryDocument, em.PurchasingHistoryDocumentYear
    )
{
  key em.PurchaseOrder,
  key em.PurchaseOrderItem,
  key em.PurchasingHistoryDocument,
  key em.PurchasingHistoryDocumentYear,
  key em.PurchasingHistoryDocumentItem,
      case when bs.AccountAssignmentNumber is not initial
      then bs.AccountAssignmentNumber else '01' end as zekkn,
      @Semantics.amount.currencyCode: 'WAERS_CLP'
      cast( (
      case when bs.TransactionCurrency = 'CLP'
      then cast(bs.AbsoluteAmountInTransacCrcy as abap.dec( 13, 2 ))
      else
      cast((currency_conversion( amount => bs.AbsoluteAmountInTransacCrcy,
      source_currency => bs.TransactionCurrency,
      round => 'X',
      target_currency => cast( 'CLP' as abap.cuky( 5 )) ,
      exchange_rate_date => em.PostingDate,
      error_handling => 'SET_TO_NULL',
      client => $session.client ) ) as abap.dec( 13, 2 ))
      end ) as abap.curr( 13, 2 ))                  as netwr_clp,
      cast( 'CLP' as abap.cuky( 5 ))                as waers_clp,
      bs.CostCenter,
      bs.ProfitCenter,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      bs.AbsoluteAmountInTransacCrcy,
      bs.TransactionCurrency,
      ep.TaxCode,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      bs.Quantity,
      bs.BaseUnit
}
where
      bs.FinancialAccountType = 'S'
  and bs.CostCenter           is not initial
