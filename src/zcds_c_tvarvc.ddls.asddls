@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_TVARVC'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_TVARVC
  as select from ZCLMM_TB_TVARVC
{
  key id as ID,
  key name as Name,
  value as Value,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
