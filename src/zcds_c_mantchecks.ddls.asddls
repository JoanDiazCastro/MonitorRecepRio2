@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_CHECKS'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_MANTCHECKS
  as select from ZCLMM_TB_CHECKS
{
  key bukrs as Bukrs,
  key code as Code,
  codet as Codet,
  activo as Activo,
  rechau as Rechau,
  motmail as Motmail,
  motrech as Motrech,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
