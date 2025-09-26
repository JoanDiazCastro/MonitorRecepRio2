@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recepción FEL: Cabecera DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity zcds_c_recdte_cab
  as select distinct from  zcds_i_cabdte                as cab
    inner join             zclmm_tb_procdte             as proc on cab.iddte_sap = proc.iddte_sap

    left outer join        ZCDS_I_TIPODTE               as edo  on(
       edo.tipodte    = cab.tipodte
       or edo.tipodte = concat(
         '0', cab.tipodte
       )
     )

    left outer join        ZCDS_I_STATUS_CONTDTE        as sta  on(
       sta.status_id = proc.status_cont
     )
    left outer join        zclmm_tb_excecoc             as ex   on proc.lifnr = ex.lifnr
    left outer join        zcds_c_stringval_soc         as cs   on proc.bukrs = cs.Sociedad
    left outer to one join zcds_i_refoc_dte             as oc   on cab.iddte_sap = oc.iddte_sap
    left outer to one join zcds_c_primer_validac_nc_dte as val  on cab.iddte_sap = val.IdDTE
    left outer to one join zcds_i_validaciones_activas  as chk  on  proc.bukrs     = chk.bukrs
                                                                and val.PosValidac = chk.code
    left outer join        ZCDS_C_MOTRECH               as mot  on(
       mot.Codigo = proc.cod_rechazo
     )
    left outer join        zcds_i_status_fact           as tf   on proc.stat_fact = tf.CodStatusFactoring
    left outer join        ZCDS_C__EQSII                as eq   on eq.Docsii = cab.tipodte
  composition [0..*] of zcds_c_recdte_det       as _Detalle
  composition [0..*] of zcds_c_recdte_ref       as _Referencias
  association [0..*] to zcds_c_recdte_impto     as _Impuestos         on $projection.IdDTE = _Impuestos.IdDTE
  association [0..*] to zcds_c_checks_dte       as _Validaciones      on $projection.Sociedad = _Validaciones.Sociedad
  association [0..*] to zcds_c_parglob_dte      as _Parametrizaciones on $projection.Sociedad = _Parametrizaciones.Sociedad
  composition [0..*] of zcds_c_recdte_log       as _Log
  association [0..*] to zcds_c_recdte_factoring as _Factoring         on $projection.IdDTE = _Factoring.IdDTE
{

  key cab.iddte_sap                                           as IdDTE,

      --  @Search.defaultSearchElement: true -- indica si se realizaran busquedas por este campo
      @EndUserText.label: 'Tipo DTE'
      @ObjectModel.text.element: ['TipoDteDesc']
      @Consumption.valueHelpDefinition: [ { //permite agregar un value help en la vista
        entity: {
          name: 'ZCDS_I_TIPODTE',
          element: 'tipodte'
        }
      } ]
      cab.tipodte                                             as TipoDte,
      edo.tipodte_desc                                        as DescTipoDte,
      concat(cab.tipodte , concat(' -  ', edo.tipodte_desc) ) as TipoDteDesc,

      @Search.defaultSearchElement: true
      cab.folio                                               as Folio,
      concat('Folio: ', cab.folio)                            as FolioDes,
      @EndUserText.label: 'Fecha de Emisión'
      cab.fchemis                                             as FechaEmision,
      cab.rutemisor                                           as RutEmisor,
      cab.rutrecep                                            as RutReceptor,
      cab.rznsoc                                              as RazonSocial,
      @Semantics.amount.currencyCode: 'Moneda'
      cab.mntneto                                             as MontoNeto,
      @Semantics.amount.currencyCode: 'Moneda'
      cab.mntexe                                              as MontoExento,
      @Semantics.amount.currencyCode: 'Moneda'
      cab.iva                                                 as MontoIva,
      @Semantics.amount.currencyCode: 'Moneda'
      cab.mnttotal                                            as MontoTotal,
      cab.waers                                               as Moneda,
      cab.febosid                                             as FebosId,
      eq.Blart                                                as TipoDocumento,

      @EndUserText.label: 'Sociedad'
      @ObjectModel.text.element: ['Sociedad']

      // Permite agregar un value help en la vista
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'ZCDS_I_bukrs',
          element: 'bukrs'
        }
      } ]

      proc.bukrs                                              as Sociedad,

      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @EndUserText.label: 'Fecha Recepción'
      proc.fchrec                                             as FechaRecepcion,
      proc.lifnr                                              as CodProveedor,

      @EndUserText.label: 'Estado Contabilización'
      @ObjectModel.text.element: ['StatusContabText']

      // Permite agregar un value help en la vista
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'ZCDS_I_STATUS_CONTDTE',
          element: 'status_id'
        }
      } ]

      proc.status_cont                                        as StatusContab,
      sta.status_text                                         as StatusContabText,
      proc.budat                                              as FechaContab,

      proc.fecha_evto                                         as FechaEvento,
      proc.checks                                             as Checks,
      proc.belnr                                              as NroDocMaterial,
      proc.belnc                                              as NroDocContable,
      proc.gjahr                                              as AnioDocCont,
      case
      when ex.lifnr is not null
      then 'X' else '' end                                    as ProvExcepOC,

      cs.ChecksSoc                                            as CheckSociedad,
      // Mostrar campo critico color
      case
        when cs.ChecksSoc = proc.checks and proc.status_cont != '03' and proc.tipo_evto != 'R' then 3 -- 'Verde'
       else 1 -- rojo
      end                                                     as reglasOkStatus,
      // Mostrar campo critico color
      case
        when cs.ChecksSoc = proc.checks and proc.status_cont != '03' and proc.tipo_evto != 'R' then 'Habilitado' -- 'Open'
        else 'No Habilitado'
      end                                                     as reglasOk,
      proc.blart                                              as TipoDocCont,
      cab.urlpdf                                              as urlPDF,
      case
      when oc.ebeln is not null
      then 'X' else '' end                                    as RefOC,
      chk.text                                                as PrimerNoCumple,

      dats_days_between(cab.fecharecsii,$session.system_date) as diasVctoRechazo,

      // Mostrar campo critico diasVctoRechazo
      case
        when dats_days_between(cab.fecharecsii,$session.system_date)  < 6  then 0 -- 'negativo'
        else 1 -- rojo
      end                                                     as diasVctoRechazoStatus,


      mot.Descripcion                                         as descMotRechazo,

      @EndUserText.label: 'Motivo rechazo'
      @ObjectModel.text.element: ['MotRechazoDesc']

      // Permite agregar un value help en la vista
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'ZCDS_C_MOTRECH',
          element: 'codigo'
        }
      } ]
      mot.Codigo                                              as MotRechazoCod,
      mot.Descripcion                                         as MotRechazoDesc,

      @EndUserText.label: 'Estado Doc. SII'

      // Permite agregar un value help en la vista
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'ZCDS_I_estado_doc_sii',
          element: 'status_id'
        }
      } ]

      proc.tipo_evto                                          as Evento,

      @EndUserText.label: 'Estado Factoring'

      // Permite agregar un value help en la vista
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'zcds_i_status_fact',
          element: 'CodStatusFactoring'
        }
      } ]
      proc.stat_fact                                          as StatusFactoring,
      tf.DescrStatusFact                                      as StatFactoringText,
      @EndUserText.label: 'Recepción Múltiple'
      //     case
      //      when ( tem.TotalEM > 1 )
      //      then 'X' else ' ' end                                   as RecepMultiple,
      //     proc.zzarea                                             as AreaAsignacion,
      proc.hkont                                              as CuentaMayor,
      proc.kostl                                              as CentroCosto,
      proc.modulo                                             as Modulo,
      _Detalle,
      _Referencias,
      _Impuestos,
      _Validaciones,
      _Parametrizaciones,
      _Log,
      //      _EntradaMercancia,
      _Factoring

}
