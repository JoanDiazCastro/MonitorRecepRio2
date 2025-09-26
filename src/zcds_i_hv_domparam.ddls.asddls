@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parametro'
define view entity zcds_i_hv_DOMPARAM
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_PARAMETROS_DTE' ) as dom
{

      @UI.textArrangement: #TEXT_FIRST
      @ObjectModel.text.element: [ 'descripcion' ]
  key dom.value_low as parametro,
      dom.text      as descripcion
}
where
  dom.language = $session.system_language
