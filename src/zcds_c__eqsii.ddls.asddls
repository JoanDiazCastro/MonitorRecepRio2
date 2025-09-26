@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_EQSII'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C__EQSII 
  as select from zclmm_tb_eqsii
{
  key blart as Blart,
  indimp as Indimp,
  docsii as Docsii,
//  concat(blart, concat(' -  ', docsii)) as CodDesc,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
