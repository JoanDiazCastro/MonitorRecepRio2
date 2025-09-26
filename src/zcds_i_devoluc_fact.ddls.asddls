@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Devoluciones facturadas (NC)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_devoluc_fact
  as select from    I_PurchaseOrderHistoryAPI01 as eb
    left outer join I_SupplierInvoiceAPI01      as rk on  eb.PurchasingHistoryDocument     = rk.SupplierInvoice
                                                      and eb.PurchasingHistoryDocumentYear = rk.FiscalYear
{
  key eb.PurchaseOrder                 as ebeln,
  key eb.PurchaseOrderItem             as ebelp,
  key eb.PurchasingHistoryDocumentYear as gjahr,
  key eb.PurchasingHistoryDocument     as belnr,
  key eb.PurchasingHistoryDocumentItem as buzei,
      eb.ReferenceDocumentFiscalYear   as lfgja,
      eb.ReferenceDocument             as lfbnr,
      eb.ReferenceDocumentItem         as lfpos

}
where
      eb.PurchasingHistoryDocumentType = '2'
  and eb.DebitCreditCode               = 'S'
  and rk.ReverseDocument               is initial
