@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'String validacion DTE Sociedad'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_c_stringval_soc
  as select from zclmm_tf_stringval_soc //( p_clnt:$session.client )
{
  key
      bukrs     as Sociedad,
      stringVal as ChecksSoc
}
