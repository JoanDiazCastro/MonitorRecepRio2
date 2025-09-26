@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Anulaciones EM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_an_em
  as select from    I_PurchaseOrderHistoryAPI01 as eb

    left outer join I_MaterialDocumentItem_2    as ms on  eb.PurchasingHistoryDocumentYear = ms.MaterialDocumentYear
                                                      and eb.PurchasingHistoryDocument     = ms.MaterialDocument
                                                      and eb.PurchasingHistoryDocumentItem = ms.MaterialDocumentItem
{
  key eb.PurchaseOrder                 as ebeln,
  key eb.PurchaseOrderItem             as ebelp,
  key eb.PurchasingHistoryDocument     as belnr,
  key eb.PurchasingHistoryDocumentItem as buzei,
      ms.ReversedMaterialDocument      as smbln, // Equivalente a smbln
      ms.ReversedMaterialDocumentItem  as smblp // Equivalente a smblp
}
where
     eb.GoodsMovementType = '102'
  or eb.GoodsMovementType = '162'
