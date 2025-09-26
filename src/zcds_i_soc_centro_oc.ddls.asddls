@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sociedad/Centro OC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_soc_centro_oc
  as select distinct from I_PurchaseOrderAPI01     as ek // ekko as ek
    inner join            I_PurchaseOrderItemAPI01 as ep on ek.PurchaseOrder = ep.PurchaseOrder
{
  key ek.PurchaseOrder,
  key ep.Plant,
      ek.CompanyCode
}
