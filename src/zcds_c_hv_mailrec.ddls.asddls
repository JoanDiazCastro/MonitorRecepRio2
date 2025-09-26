@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda motivo mail rechazo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS //permite desplegar los datos en una select

define view entity zcds_c_hv_mailrec
  as select from zclmm_tb_mailrec
{
      @UI.textArrangement: #TEXT_FIRST
      @ObjectModel.text.element: [ 'Descripcion' ]

  key codmot      as CodigoMotivo,
      descripcion as Descripcion

}
