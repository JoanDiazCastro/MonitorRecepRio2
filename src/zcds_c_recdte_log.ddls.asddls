@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*extension metadata for fiori element */
@Metadata.allowExtensions: true
define view entity zcds_c_recdte_log
  as select from zclmm_tb_logdte
  association to parent zcds_c_recdte_cab as _Header on $projection.IdDTE = _Header.IdDTE
{
  key iddte_sap   as IdDTE,
  key correlativo as Correlativo,
      fecha       as Fecha,
      hora        as Hora,
      uname       as Usuario,
      tipo        as Tipo,
      mensaje     as Mensaje,
      //mostrar campo critico color
      case
        when tipo = 'S' then 3
        when tipo = 'E' then 1
        else 2
      end         as mensajeStatus,      
      _Header     
      
}
