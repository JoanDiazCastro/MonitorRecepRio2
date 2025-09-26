@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda cuentas de mayor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData:{
//entitySet.name: 'CuentaMayor',
//publish: true
//}
define view entity zcds_c_hv_ctamayor
  as select from I_CompanyCode            as t0
    inner join   I_GLAccountText          as sk on t0.ChartOfAccounts = sk.ChartOfAccounts
    inner join   I_GLAccountInCompanyCode as sb on  sb.CompanyCode = t0.CompanyCode
                                                and sb.GLAccount   = sk.GLAccount
{
  key  t0.CompanyCode   as Sociedad,
  key  sk.GLAccount     as CuentaMayor,
       sk.GLAccountName as Descripcion

}
where
      sk.Language                  = $session.system_language
  and sb.ReconciliationAccountType = ''
