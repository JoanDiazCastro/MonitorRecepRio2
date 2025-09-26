@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_PARGLOB'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_PARGLOB
  provider contract transactional_query
  as projection on ZCDS_C_PARGLOB
  association [1..1] to ZCDS_C_PARGLOB as _BaseEntity on  $projection.Bukrs     = _BaseEntity.Bukrs
                                                      and $projection.Parametro = _BaseEntity.Parametro
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Sociedad'
      @ObjectModel.text.element: ['Bukrs']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
         entity: {
            name: 'ZCDS_I_bukrs',
            element: 'bukrs'
          }
        } ]
  key Bukrs,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Parametro'
      @ObjectModel.text.element: ['Parametro']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
         entity: {
            name: 'zcds_i_hv_DOMPARAM',
            element: 'parametro'
          }
        } ]
  key Parametro,
      @EndUserText.label: 'Porcentaje tolerancia'
      PorcTol,
      @EndUserText.label: 'Activo'
      Activo,
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
