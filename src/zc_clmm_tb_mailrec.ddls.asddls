@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_MAILREC'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_CLMM_TB_MAILREC
  provider contract transactional_query
  as projection on ZR_CLMM_TB_MAILREC
  association [1..1] to ZR_CLMM_TB_MAILREC as _BaseEntity on $projection.Codmot = _BaseEntity.Codmot
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
  key Codmot,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descripcion'
      Descripcion,
//      CodDesc,
      Createdby,
      Changedby,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      Lastmod,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      Lastmodloc,
      _BaseEntity
}
