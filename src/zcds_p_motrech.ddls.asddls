@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZCLMM_TB_MOTRECH'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_MOTRECH
  provider contract TRANSACTIONAL_QUERY
  as projection on ZCDS_C_MOTRECH
  association [1..1] to ZCDS_C_MOTRECH as _BaseEntity on $projection.CODIGO = _BaseEntity.CODIGO
{
  key Codigo,
  Descripcion,
  Createdby,
  Changedby,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  Lastmod,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  Lastmodloc,
  _BaseEntity
}
