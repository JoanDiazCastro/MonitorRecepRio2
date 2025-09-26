@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Codet'
define view entity zcds_i_hv_tipodte
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_TIPODTE' ) as dom
{
      @UI.textArrangement: #TEXT_FIRST
      @ObjectModel.text.element: [ 'descripcion' ]
  key dom.value_low as tipodte,
      dom.text      as descripcion
}
where
  dom.language = $session.system_language
