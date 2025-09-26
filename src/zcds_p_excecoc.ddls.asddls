@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_EXCECOC'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_EXCECOC
  provider contract transactional_query
  as projection on ZCDS_C_EXCECOC
  association [1..1] to ZCDS_C_EXCECOC as _BaseEntity on $projection.Lifnr = _BaseEntity.Lifnr
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Proveedor'
      @ObjectModel.text.element: ['Lifnr']
      @Consumption.valueHelpDefinition: [ {
      entity: {
          name: 'zcds_c_hv_proveedor',
          element: 'Proveedor'
      },
      useForValidation: true
      }]
  key Lifnr,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'CuentaMayor'
      @ObjectModel.text.element: ['Hkont']
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'zcds_c_hv_ctamayor',
              element: 'CuentaMayor'
          },
          useForValidation: true
      }]
      Hkont,
      @EndUserText.label: 'CentroCosto'
      @ObjectModel.text.element: ['Kostl']
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'zcds_c_hv_ceco',
              element: 'CentroCosto'
          },
          useForValidation: true
      }]
      Kostl,
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
