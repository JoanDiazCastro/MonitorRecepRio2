@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Codet'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS //permite esplegar los datos en una select
@UI.textArrangement: #TEXT_FIRST

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity zcds_i_hv_codet
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_CHECK_DTE' ) as dom
{
      @ObjectModel.text.element: [ 'Codet' ]
      @Semantics.text: true
  key cast( dom.value_low as abap.char( 10 ) ) as Codet,
      dom.text                                 as DescrCodet
}
