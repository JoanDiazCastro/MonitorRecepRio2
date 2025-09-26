@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLFEL_TB_TPDTE000'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_TIPODTE
  provider contract transactional_query
  as projection on ZCDS_C_TIPODTE
  association [1..1] to ZCDS_C_TIPODTE as _BaseEntity on  $projection.Language = _BaseEntity.Language
                                                      and $projection.DteType  = _BaseEntity.DteType
{
      @EndUserText.label: 'Lenguaje'
      @ObjectModel.text.element: ['Language']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
        entity: {
          name: 'I_Language',
          element: 'Language'
        }
      } ]

  key Language,
      @EndUserText.label: 'Tipo Dte'
  key DteType,
      DteDesc,
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
