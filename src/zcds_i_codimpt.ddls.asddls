@EndUserText.label: 'vista codigos de impuesto'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZCDS_I_CODIMPT
  as select from zclmm_tb_codimpt
{
  key codigo,
      descripcion,
      concat(codigo, concat(' -  ', descripcion)) as CodDesc
}
