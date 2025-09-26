@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda Orden CO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData:{
//publish: true,
entitySet.name: 'OrdenCO'
}

define view entity zcds_c_hv_orderid
  as select from I_Order             as au
    inner join   ZCDS_I_PARAM_TVARVC as tv on  au.OrderID = tv.Value
                                           and tv.Name    = 'ZCLMM_AUART_ORDEN'
  //    inner join   tvarvc as tv on  au.auart = tv.low
  //                              and tv.name  = 'ZCLMM_AUART_ORDEN'
{
  key au.OrderID          as OrderId,
      au.CompanyCode      as Sociedad,
      au.OrderDescription as Descripcion
      //      au.ResponsibleCostCenter as CeCo
}
//where
//  au.phas3 != 'X'
