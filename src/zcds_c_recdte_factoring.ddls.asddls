@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datos factoring DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity zcds_c_recdte_factoring
  as select from zclmm_tb_cesdte
{
  key iddte_sap             as IdDTE,
  key fechaevento           as FechaEvento,
  key rutcesionario         as RutCesionario,
      fechacesion           as FechaCesion,
      estadocesion          as EstadoCesion,
      razonsocialcesionario as RazonsocialCesionario,
      rutcedente            as RutCedente,
      url_cesion            as UrlCesion,
      @Semantics.amount.currencyCode: 'MONEDA'
      montocedido           as MontoCedido,
      waers                 as Moneda
}
