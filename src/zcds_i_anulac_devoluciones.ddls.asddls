@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Anulaciones Devolución'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_anulac_devoluciones
  as select from    I_PurchaseOrderHistoryAPI01 as eb
    left outer join I_MaterialDocumentItem_2    as ms on  eb.PurchasingHistoryDocumentYear = ms.MaterialDocumentYear
                                                      and eb.PurchasingHistoryDocument     = ms.MaterialDocument
                                                      and eb.PurchasingHistoryDocumentItem = ms.MaterialDocumentItem
{
  key eb.PurchaseOrder                 as ebeln,
  key eb.PurchaseOrderItem             as ebelp,
  key eb.PurchasingHistoryDocumentYear as gjahr,
  key eb.PurchasingHistoryDocument     as belnr,
  key eb.PurchasingHistoryDocumentItem as buzei,
      eb.GoodsMovementType             as bwart,
      eb.ReferenceDocument             as lfbnr,
      eb.ReferenceDocumentItem         as lfpos,
      ms.ReversedMaterialDocument      as smbln,
      ms.ReversedMaterialDocumentItem  as smblp

}
where
      eb.GoodsMovementType         = '123' // Devoluciones
  and eb.PurchasingHistoryCategory = 'E'
