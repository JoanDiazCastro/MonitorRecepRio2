@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_CODIMPT'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_CODIMP
  as select from ZCLMM_TB_CODIMPT
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
