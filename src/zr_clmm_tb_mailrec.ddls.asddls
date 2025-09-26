@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_MAILREC'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_CLMM_TB_MAILREC
  as select from zclmm_tb_mailrec
{
  key codmot as Codmot,
  descripcion as Descripcion,
//  concat(codmot, concat(' -  ', descripcion)) as CodDesc,
  createdby as Createdby,
  changedby as Changedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmod as Lastmod,
  @Semantics.systemDateTime.lastChangedAt: true
  lastmodloc as Lastmodloc
}
