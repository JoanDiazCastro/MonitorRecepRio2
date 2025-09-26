@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_APIS'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_APIS
  provider contract transactional_query
  as projection on ZCDS_I_APIS
  association [1..1] to ZCDS_I_APIS as _BaseEntity on $projection.Idend = _BaseEntity.Idend
{
      @EndUserText.label: 'ID Endpoint'
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Idend']
      @Consumption.valueHelpDefinition: [ {
              entity: {
                name: 'zcds_i_idend',
                element: 'Idend'
              }
            } ]
  key Idend,
      Endpoint,
      Zzuser,
      Zzpassword,
      Zzmethod,
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
