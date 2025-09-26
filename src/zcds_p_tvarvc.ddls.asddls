@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZCLMM_TB_TVARVC'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_TVARVC
  provider contract TRANSACTIONAL_QUERY
  as projection on ZCDS_C_TVARVC
  association [1..1] to ZCDS_C_TVARVC as _BaseEntity on $projection.ID = _BaseEntity.ID and $projection.NAME = _BaseEntity.NAME
{
  key ID,
  key Name,
  Value,
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
