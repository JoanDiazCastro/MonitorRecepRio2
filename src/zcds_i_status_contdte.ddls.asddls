@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estados de contabilizacion'
@ObjectModel.resultSet.sizeCategory: #XS //permite esplegar los datos en una select

define view entity ZCDS_I_STATUS_CONTDTE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_STATUS_CONTDTE' ) as dom
{

      @ObjectModel.text.element: [ 'status_text' ]
  key dom.value_low as status_id,

      @Semantics.text: true
      dom.text      as status_text
}
where
  dom.language = $session.system_language
