@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_PARGLOB'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_PARGLOB
  as select from zclmm_tb_parglob
{
  key bukrs as Bukrs,
  key parametro as Parametro,
  porc_tol as PorcTol,
  activo as Activo,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
