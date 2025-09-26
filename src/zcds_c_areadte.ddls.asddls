@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_AREADTE'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_AREADTE
  as select from ZCLMM_TB_AREADTE
{
  key codarea as Codarea,
  descarea as Descarea,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
