@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_MOTRECH'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_MOTRECH
  as select from ZCLMM_TB_MOTRECH
{
  key codigo as Codigo,
  descripcion as Descripcion,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
