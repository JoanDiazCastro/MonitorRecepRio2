@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_CODIMPT'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_CODIMP
  provider contract transactional_query
  as projection on ZCDS_C_CODIMP
  association [1..1] to ZCDS_C_CODIMP as _BaseEntity on $projection.Codigo = _BaseEntity.Codigo
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
  key Codigo,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descripcion'
      Descripcion,
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
