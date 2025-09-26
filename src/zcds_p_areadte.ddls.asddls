@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_AREADTE'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_AREADTE
  provider contract transactional_query
  as projection on ZCDS_C_AREADTE
  association [1..1] to ZCDS_C_AREADTE as _BaseEntity on $projection.Codarea = _BaseEntity.Codarea
{
      @Search.defaultSearchElement: true
  key Codarea,
      Descarea,
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
