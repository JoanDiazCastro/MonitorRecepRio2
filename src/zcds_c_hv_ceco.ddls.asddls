@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda centro de costo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'CentroCosto'
//@OData.publish: true
define view entity zcds_c_hv_ceco
  as select distinct from I_CompanyCode as tk
    inner join             I_CostCenterText as ct on  tk.ControllingArea = ct.ControllingArea
                                      and ct.Language = $session.system_language
{
  key tk.CompanyCode as Sociedad,
  key ct.CostCenter as CentroCosto,
      ct.CostCenterDescription as DescripcionCeCo

}
