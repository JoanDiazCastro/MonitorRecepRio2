@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'N° total EM factura pendiente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_total_em_pdte as select from zcds_i_em_fact_pdte as em
inner join zcds_i_refoc_dte as oc on em.ebeln = oc.ebeln   
{
    key oc.iddte_sap,
    count(distinct em.belnr ) as TotalEM
    
}
group by oc.iddte_sap
