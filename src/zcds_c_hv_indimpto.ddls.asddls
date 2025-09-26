@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda indicador impuesto'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData:{
//entitySet.name: 'IndImpto',
//publish: true
//}
define view entity zcds_c_hv_indimpto
  as select from    I_TaxCode     as t007s
    left outer join I_TaxCodeText as t007a on  t007s.TaxCode  = t007a.TaxCode
                                           and t007a.Language = $session.system_language
  //    inner join   t007a on  t007a.mwskz = t007s.mwskz
  //                       and t007a.kalsm = 'TAXCL'

{
  key t007s.TaxCode     as IndicadoImpto,
      t007a.TaxCodeName as Descripcion
}
where
      t007s.TaxCalculationProcedure = 'TAXCL'
  and t007s.TaxType                 = 'V'
