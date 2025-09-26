@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista de proyeccion ZCDS_C_RECDTE_CAB'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_P_RECDTE_CAB
  provider contract transactional_query
  as projection on zcds_c_recdte_cab
{
  key IdDTE,
     TipoDte,
      Folio,
      FolioDes,
      FechaEmision,
      RutEmisor,
      RutReceptor,
      RazonSocial,
      @Semantics.amount.currencyCode: 'MONEDA'
      MontoNeto,
      @Semantics.amount.currencyCode: 'MONEDA'
      MontoExento,
      @Semantics.amount.currencyCode: 'MONEDA'
      MontoIva,
      @Semantics.amount.currencyCode: 'MONEDA'
      MontoTotal,
      Moneda,
      FebosId,
      TipoDocumento,
      Sociedad,
      FechaRecepcion,
      CodProveedor,
      StatusContab,
      StatusContabText,
      FechaContab,
      FechaEvento,
      Checks,
      NroDocMaterial,
      NroDocContable,
      AnioDocCont,
      ProvExcepOC,
      reglasOkStatus,
      reglasOk,
      TipoDocCont,
      urlPDF,
      RefOC,
      diasVctoRechazo,
      diasVctoRechazoStatus,
      descMotRechazo,
      MotRechazoCod,
      MotRechazoDesc,
      Evento,
      StatusFactoring,
      StatFactoringText,
      CuentaMayor,
      CentroCosto,
      Modulo,
      /* Associations */
      _Detalle,
      _Log,
      _Parametrizaciones,
      _Referencias,
      _Validaciones

}
