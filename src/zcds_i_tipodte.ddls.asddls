@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tipos DTE'
define view entity ZCDS_I_TIPODTE
  as select distinct from ZCDS_C_TIPODTE                                                     as edo //edocldtetypet
//    inner join            zclmm_tb_eqsii                                                     as eqs on edo.DteType = eqs.docsii
    left outer join       DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_TIPO_DTE' ) as dd  on  edo.DteType = dd.value_low
                                                                                                    and dd.language = $session.system_language
{
      @UI.textArrangement: #TEXT_SEPARATE
      @ObjectModel.text.element: [ 'tipodte_desc' ]
  key edo.DteType as tipodte,
      edo.DteDesc as tipodte_desc
}
where
  edo.Language = $session.system_language
