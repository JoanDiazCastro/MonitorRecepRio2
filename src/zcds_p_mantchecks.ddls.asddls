@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCLMM_TB_CHECKS'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZCDS_P_MANTCHECKS
  provider contract transactional_query
  as projection on ZCDS_C_MANTCHECKS
  association [1..1] to ZCDS_C_MANTCHECKS as _BaseEntity on  $projection.Bukrs = _BaseEntity.Bukrs
                                                         and $projection.Code  = _BaseEntity.Code
{
      @EndUserText.label: 'Sociedad'
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Bukrs']
      @Consumption.valueHelpDefinition: [ {
         entity: {
            name: 'ZCDS_I_bukrs',
            element: 'bukrs'
          }
        } ]
  key Bukrs,
      @EndUserText.label: 'Código'
  key Code,
      @EndUserText.label: 'Descripción código'
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Codet']
      @Consumption.valueHelpDefinition: [ { 
         entity: {
            name: 'zcds_i_hv_codet',
            element: 'Codet'
          }
        } ]
      Codet,
      @EndUserText.label: 'Activo'
      Activo,
      Rechau,
      Motmail,
      Motrech,
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
