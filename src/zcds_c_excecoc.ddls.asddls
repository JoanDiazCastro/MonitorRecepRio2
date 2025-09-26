@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_EXCECOC'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_EXCECOC
  as select from ZCLMM_TB_EXCECOC
{
  key lifnr as Lifnr,
  hkont as Hkont,
  kostl as Kostl,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
