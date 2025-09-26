@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLFEL_TB_TPDTE000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_C_TIPODTE
  as select from zclfel_tb_tpdte
{

      @EndUserText.label: 'Lenguaje'
      @ObjectModel.text.element: ['Language']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
        entity: {
          name: 'I_Language',
          element: 'Language'
        }
      } ]
  key language   as Language,
  @EndUserText.label: 'Tipo DTE'
  key dte_type   as DteType,
      dte_desc   as DteDesc,
      createdby  as Createdby,
      changedby  as Changedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastmod    as Lastmod,
      @Semantics.systemDateTime.lastChangedAt: true
      lastmodloc as Lastmodloc
}
