@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_EQSII'
}
@AccessControl.authorizationCheck: #MANDATORY
@Search.searchable: true
define root view entity ZCDS_P__EQSII
  provider contract transactional_query
  as projection on ZCDS_C__EQSII
  association [1..1] to ZCDS_C__EQSII as _BaseEntity on $projection.Blart = _BaseEntity.Blart
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Clase documento'
      @ObjectModel.text.element: ['Blart']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
         entity: {
            name: 'zcds_c_hv_blart',
            element: 'ClaseDoc'
          }
        } ]
  key Blart,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Docsii']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
         entity: {
            name: 'zcds_i_hv_tipodte',
            element: 'tipodte'
          }
        } ]
      Docsii,
//      CodDesc,
      Indimp,
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
