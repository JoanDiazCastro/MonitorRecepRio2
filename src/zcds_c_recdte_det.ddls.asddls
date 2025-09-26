@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recepción FEL: Detalle DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'Detalle'
//@OData.publish: true

/*extension metadata for fiori element */
@Metadata.allowExtensions: true
define view entity zcds_c_recdte_det
  as select from zclmm_tb_detdte
  association to parent zcds_c_recdte_cab as _Header on $projection.IdDTE = _Header.IdDTE
{
  key iddte_sap   as IdDTE,
  key nrolindet   as NroLinea,
      @EndUserText.label: 'Código Material'
      vlrcodigo   as CodigoMaterial,
      nmbitem     as DescMaterial,
      qtyitem     as Cantidad,
      unmditem    as UnidadMedida,
      prcitem     as Precio,
      nmbitem     as NombreItem,
      montoitem   as MontoItem,
      centrocosto as CentroCosto,
      cuentamayor as CuentaMayor,
      _Header
}
