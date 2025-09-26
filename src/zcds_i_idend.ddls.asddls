@AbapCatalog.sqlViewName: 'ZV_I_IDEND'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tipos de Identificación Endpoint'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view zcds_i_idend
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZCLMM_DM_ENDPOINT' )
{
  key cast(value_low as abap.numc( 1 ) ) as Idend, // Identificador del Endpoint
      text                               as DescEndpoint // Texto del Endpoint
}
