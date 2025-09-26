@EndUserText.label: 'String validacion DTE Sociedad'
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
define table function zclmm_tf_stringval_soc
returns
{
  client    : mandt;
  bukrs     : bukrs;
  stringVal : zclmm_ed_checks_dte;
}
implemented by method
  zclmm_cs_get_checks_soc=>get_checks;