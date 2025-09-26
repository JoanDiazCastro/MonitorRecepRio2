@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recepción FEL: Impuestos DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'Impuestos'
//@OData.publish: true
/*extension metadata for fiori element */
@Metadata.allowExtensions: true
define view entity zcds_c_recdte_impto
  as select from zclmm_tb_imptdte as imp
    inner join   zclmm_tb_codimpt as cod on imp.tipoimp = cod.codigo
{
  key    imp.iddte_sap   as IdDTE,
  key    imp.nrolinimp   as NroLinea,
         imp.tipoimp     as CodImpuesto,
         cod.descripcion as DescImpuesto,
         imp.tasaimp     as TasaImpuesto,
         imp.montoimp    as MontoImpuest
}
