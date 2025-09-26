CLASS zclmm_cs_check_dte DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-DATA: gt_cab TYPE TABLE OF zclmm_tb_cabdte,
                gt_det TYPE TABLE OF zclmm_tb_detdte,
                gt_ref TYPE TABLE OF zclmm_tb_refdte,
                gt_pro TYPE TABLE OF zclmm_tb_procdte,
                gt_log TYPE TABLE OF zclmm_tb_logdte.

    CLASS-METHODS: set_data
      IMPORTING it_cab TYPE zclmm_tt_cabdte
                it_det TYPE zclmm_tt_detdte
                it_ref TYPE zclmm_tt_refdte
                it_pro TYPE zclmm_tt_procdte.

    CLASS-METHODS get_data
      EXPORTING et_cab TYPE zclmm_tt_cabdte
                et_det TYPE zclmm_tt_detdte
                et_ref TYPE zclmm_tt_refdte
                et_pro TYPE zclmm_tt_procdte
                et_log TYPE zclmm_tt_logdte.

    CLASS-METHODS save_log
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_msgty     TYPE symsgty
        i_msg       TYPE bapi_msg
        i_table     TYPE abap_boolean.

    CLASS-METHODS check_contab
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    METHODS check_dte
      IMPORTING
        i_bukrs     TYPE bukrs
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_tables    TYPE abap_boolean
      EXPORTING
        e_check     TYPE zclmm_ed_checks_dte
        e_rechauto  TYPE zclmm_ed_rechauto
        e_motmail   TYPE zclmm_ed_codmot .

    CLASS-METHODS check_factvsrec
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS check_ncvsfact
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS check_oclib
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS check_ordenc
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS check_procfact
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS check_proveed
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS check_recept
      IMPORTING
        i_iddte_sap TYPE zclmm_ed_iddte_sap
        i_bukrs     TYPE bukrs
        i_tables    TYPE abap_bool DEFAULT abap_false
      EXPORTING
        e_check     TYPE zclmm_ed_char1.

    CLASS-METHODS get_proveedor
      IMPORTING i_rut          TYPE zclmm_ed_rutemis_dte
      RETURNING VALUE(e_lifnr) TYPE lifnr.

    CLASS-DATA: lo_exchange_rates TYPE REF TO cl_exchange_rates.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA c_classname TYPE c LENGTH 18 VALUE 'ZCLMM_CS_CHECK_DTE' ##NO_TEXT.
ENDCLASS.



CLASS zclmm_cs_check_dte IMPLEMENTATION.


  METHOD check_contab.

    " Verifica si el documento no se encuentra contabilizado en SAP.
    " 0 = Contabilizado
    " 1 = No contabilizado

    DATA: l_belnr TYPE I_SupplierInvoiceAPI01-SupplierInvoice,
          l_belnc TYPE belnr_d,
          l_gjahr TYPE gjahr.
    DATA: l_lifnr   TYPE lifnr.
    DATA: l_msg     TYPE bapi_msg.
    DATA: l_retcode TYPE sy-subrc.

    DATA: ls_procdte TYPE zclmm_tb_procdte.

    CLEAR: l_lifnr,
           l_belnr,
           l_belnc,
           l_msg.

    IF i_tables EQ abap_false.
      SELECT iddte_sap, tipodte, folio, fchemis, rutemisor, rutrecep
       FROM zclmm_tb_cabdte WHERE iddte_sap EQ @i_iddte_sap ORDER BY PRIMARY KEY
        INTO @DATA(ls_cabdte_s)  UP TO 1 ROWS .
      ENDSELECT.
    ELSE.
      READ TABLE zclmm_cs_check_dte=>gt_cab INTO DATA(ls_cabdte) WITH KEY iddte_sap = i_iddte_sap.
    ENDIF.

    IF ls_cabdte IS INITIAL.
      ls_cabdte = CORRESPONDING #( ls_cabdte_s ).
    ENDIF.

    l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = ls_cabdte-rutemisor ).

    IF l_lifnr IS NOT INITIAL.

      SELECT SINGLE r~supplierInvoice,
                    a~accountingDocument,
                    a~ledgerfiscalyear
        FROM I_SupplierInvoiceAPI01 WITH PRIVILEGED ACCESS AS r
        INNER JOIN I_JournalEntryItem AS a ON r~CompanyCode     EQ a~CompanyCode
                                          AND r~SupplierInvoice EQ a~ReferenceDocument
                                          AND r~InvoicingParty  EQ a~supplier
        WHERE r~SupplierInvoiceIDByInvcgParty EQ @ls_cabdte-folio
          AND r~InvoicingParty                EQ @l_lifnr
          AND r~CompanyCode                   EQ @i_bukrs
          AND r~ReverseDocument IS INITIAL
        INTO ( @l_belnr, @l_belnc, @l_gjahr ).

      IF sy-subrc NE 0.
        SELECT SINGLE b~AccountingDocument,
                      b~FiscalYear
        FROM I_OperationalAcctgDocItem WITH PRIVILEGED ACCESS AS b
        INNER JOIN I_JournalEntry AS k ON b~CompanyCode        EQ k~CompanyCode
                                      AND b~AccountingDocument EQ k~AccountingDocument
                                      AND b~FiscalYear         EQ k~FiscalYear
                                      AND k~IsReversed         EQ @abap_false
                                      AND k~IsReversal         EQ @abap_false
        WHERE b~Supplier                  EQ @l_lifnr
          AND b~OriginalReferenceDocument EQ @ls_cabdte-folio
          AND b~CompanyCode               EQ @i_bukrs
          AND b~ClearingDate IS INITIAL  " Para BSIK (partidas abiertas)
        INTO ( @l_belnc, @l_gjahr ).

        IF sy-subrc NE 0.
          SELECT SINGLE b~AccountingDocument,
                        b~FiscalYear
          FROM I_OperationalAcctgDocItem WITH PRIVILEGED ACCESS AS b
          INNER JOIN I_JournalEntry AS k ON b~CompanyCode        EQ k~CompanyCode
                                        AND b~AccountingDocument EQ k~AccountingDocument
                                        AND b~FiscalYear         EQ k~FiscalYear
                                        AND k~IsReversed         EQ @abap_false
          WHERE b~Supplier                  EQ @l_lifnr
            AND b~OriginalReferenceDocument EQ @ls_cabdte-folio
            AND b~CompanyCode               EQ @i_bukrs
            AND b~ClearingDate IS NOT INITIAL  " Para BSAK (partidas compensadas)
          INTO ( @l_belnc, @l_gjahr ).
        ENDIF.
      ENDIF.
    ENDIF.

    IF l_belnc IS INITIAL.
      e_check = '1'.
    ELSE.
      e_check = '0'.

      CONCATENATE 'Folio contabilizado, Doc. Contable:' l_belnr INTO l_msg SEPARATED BY space.

      CALL METHOD zclmm_cs_check_dte=>save_log
        EXPORTING
          i_iddte_sap = i_iddte_sap
          i_msgty     = 'E'
          i_msg       = l_msg
          i_table     = i_tables.

      CLEAR: ls_procdte.

      IF i_tables EQ abap_false.
        SELECT SINGLE *
          FROM zclmm_tb_procdte
          WHERE iddte_sap EQ @i_iddte_sap
          INTO @ls_procdte.
        IF sy-subrc EQ 0.
          ls_procdte-status_cont = '03'.
          ls_procdte-belnr       = l_belnr.
          ls_procdte-belnc       = l_belnc.
          ls_procdte-gjahr       = l_gjahr.

          UPDATE zclmm_tb_procdte FROM @ls_procdte.
          COMMIT WORK.
        ENDIF.
      ELSE.
        READ TABLE zclmm_cs_check_dte=>gt_pro ASSIGNING FIELD-SYMBOL(<fs_procdte>) WITH KEY iddte_sap = i_iddte_sap.
        IF sy-subrc EQ 0.
          <fs_procdte>-status_cont = '03'.
          <fs_procdte>-belnr       = l_belnr.
          <fs_procdte>-belnc       = l_belnc.
          <fs_procdte>-gjahr       = l_gjahr.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_dte.
    DATA: lt_checks    TYPE STANDARD TABLE OF zclmm_tb_checks,
          ls_checks    LIKE LINE OF lt_checks,
          lv_check     TYPE c LENGTH 1,
          lv_method    TYPE c LENGTH 30, "rs38l_fnam.
          lv_rechazado TYPE abap_boolean.

    CLEAR: lv_rechazado.

    SELECT *
      FROM zclmm_tb_checks
      WHERE bukrs EQ @i_bukrs
      INTO TABLE @lt_checks.

    SORT lt_checks BY code ASCENDING.

    LOOP AT lt_checks INTO ls_checks.

      IF ls_checks-activo EQ 'X'.
        CLEAR: lv_method.

        CONCATENATE 'CHECK_' ls_checks-codet INTO lv_method.

        CALL METHOD (c_classname)=>(lv_method)
          EXPORTING
            i_iddte_sap = i_iddte_sap
            i_bukrs     = i_bukrs
            i_tables    = i_tables
          IMPORTING
            e_check     = lv_check.

        e_check+ls_checks-code = lv_check.
        " Habilitacion rechazo automatico
        IF ls_checks-rechau IS NOT INITIAL AND e_rechauto IS INITIAL.
          e_rechauto = abap_true.
          e_motmail = ls_checks-motmail.
        ENDIF.
      ELSE.
        e_check+ls_checks-code = '0'.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_factvsrec.

    " Verifica si monto factura <= recepciones.
    " 0 = Factura > recepciones
    " 1 = Factura <= recepciones
    DATA: lt_ref    TYPE RANGE OF i_purchaseorderapi01-PurchaseOrder. "ekko-ebeln.
    DATA: ls_ref    LIKE LINE OF lt_ref.
    DATA: lt_referencias TYPE TABLE OF zclmm_tb_refdte.
    DATA: l_oc      TYPE ebeln.
    DATA: l_recep   TYPE dmbtr,                         " Recepciones
          l_anul    TYPE dmbtr,                         " anulaciones EM
          l_fact    TYPE dmbtr,                         " Facturado
          l_pdtetol TYPE dmbtr,                         " Pendiente + tolerancia
          l_pdte    TYPE dmbtr.                         " Saldo Pendiente facturar

    DATA: l_totrecep TYPE dmbtr,                      " Recepciones
          l_totanul  TYPE dmbtr,                      " anulaciones EM
          l_totfact  TYPE dmbtr,                      " Facturado
          l_montotol TYPE dmbtr,                      " Monto Total
          l_totpdte  TYPE dmbtr.                      " Saldo Pendiente facturar

    DATA: l_neto       TYPE zclmm_tb_cabdte-mntneto.    " Neto factura
    DATA: l_exento     TYPE zclmm_tb_cabdte-mntexe.     " Exento factura
    DATA: l_total      TYPE zclmm_tb_cabdte-mnttotal.   " Total factura
    DATA: l_waers     TYPE zclmm_tb_cabdte-waers,      " Moneda
          l_valor_usd TYPE dmbtr,                      " Valor en USD
          l_mnttolusd TYPE zclmm_tb_parglob-parametro.

    DATA: l_tolerancia TYPE zclmm_tb_parglob-porc_tol.  " % Tolerancia factura sobre OC
    DATA: l_tipodte    TYPE zclmm_tb_cabdte-tipodte.    " Tipo DTE
    DATA: l_retcode    TYPE sy-subrc.
    DATA: l_excep      TYPE lifnr.     " Proveedor
    DATA: l_rutemi     TYPE zclmm_tb_cabdte-rutemisor.  " Rut Emisor
    DATA: l_lifnr      TYPE lifnr.     " Proveedor
    DATA: lt_socneto  TYPE RANGE OF i_purchaseorderapi01-CompanyCode, "ekko-bukrs,
          lt_centneto TYPE RANGE OF i_purchaseorderitemapi01-Plant. "ekpo-werks.

    DATA: lt_belnr TYPE RANGE OF i_purchaseorderhistoryapi01-PurchasingHistoryDocument. "ekbe-belnr.
    DATA: l_selrec TYPE abap_boolean.

    CLEAR: lt_ref,
           ls_ref,
           l_neto,
           l_exento,
           l_total,
           l_totrecep,
           l_totanul ,
           l_totfact ,
           l_pdte,
           l_tipodte,
           l_waers,
           l_valor_usd,
           l_mnttolusd,
           lt_referencias.


    CLEAR: l_excep.
    SELECT rutemisor
     FROM zclmm_tb_cabdte WHERE iddte_sap EQ @i_iddte_sap ORDER BY PRIMARY KEY
    INTO @l_rutemi
     UP TO 1 ROWS .
    ENDSELECT.

    l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = l_rutemi ).
    lt_referencias[] = zclmm_cs_check_dte=>gt_ref[].

    SELECT SINGLE lifnr  FROM zclmm_tb_excecoc
      WHERE lifnr EQ @l_lifnr
      INTO @l_excep.
    IF l_excep IS NOT INITIAL.
      e_check = '1'.       "--> No se valida recepciones.  Es proveedor exceptuado
    ELSE.
      IF i_tables EQ abap_false.
        SELECT 'I',
               'EQ',
                ebeln
          FROM zcds_i_refoc_dte
          WHERE iddte_sap EQ @i_iddte_sap
          INTO TABLE @lt_ref.
      ELSE.
        lt_ref = VALUE #( BASE lt_ref FOR ref IN lt_referencias (  sign = 'I'
                                                                    option = 'EQ'
                                                                    low = |{ ref-folioref ALPHA = IN }| ) ).
      ENDIF.

      " Ini. Mod. - EM seleccionada por usuario - Recepciones m ltiples
      CLEAR: l_selrec.
      SELECT SINGLE activo
        FROM zclmm_tb_parglob
        WHERE bukrs EQ @i_bukrs AND
              parametro EQ 'SELREC'
        INTO @l_selrec.

*      SELECT SINGLE recepmultiple
*        FROM zcds_c_recdte_cab
*        WHERE iddte EQ @i_iddte_sap
*        INTO @DATA(l_recmult).
*      IF l_selrec IS NOT INITIAL AND l_recmult IS NOT INITIAL.
*        CLEAR: lt_belnr.
*        SELECT 'I',
*               'EQ',
*               doctomaterial
*          FROM zcds_c_recdte_ref_em
*          WHERE iddte EQ @i_iddte_sap
*          INTO TABLE @lt_belnr.
*      ENDIF.
      " Fin Mod.
      IF i_tables EQ abap_false.
        SELECT mntneto ,
 mntexe , tipodte , mnttotal , waers FROM zclmm_tb_cabdte WHERE iddte_sap EQ @i_iddte_sap ORDER BY PRIMARY KEY
 INTO ( @l_neto , @l_exento , @l_tipodte , @l_total , @l_waers )
 UP TO 1 ROWS .
        ENDSELECT.
      ELSE.
        READ TABLE zclmm_cs_check_dte=>gt_cab INTO DATA(ls_cab) WITH KEY iddte_sap = i_iddte_sap.
        IF sy-subrc EQ 0.
          l_neto    = ls_cab-mntneto.
          l_exento  = ls_cab-mntexe.
          l_tipodte = ls_cab-tipodte.
          l_total   = ls_cab-mnttotal.
          l_waers   = ls_cab-waers.
        ENDIF.
      ENDIF.

      l_total = l_neto + l_exento.

      IF lt_ref[] IS INITIAL.
        IF l_excep IS NOT INITIAL.
          e_check = '1'.       "--> No tiene OC, pero es proveedor exceptuado
        ELSE.
          e_check = '0'.
        ENDIF.
      ELSE.
        IF l_tipodte EQ '33' OR l_tipodte EQ '34' OR
          l_tipodte EQ '033' OR l_tipodte EQ '034'. " Aplica sólo para facturas

          IF i_tables EQ abap_false.
            SELECT SUM( mntclp ) AS pdte
              FROM zcds_i_em_fact_pdte AS em
              INNER JOIN  zcds_i_refoc_dte AS oc
              ON em~ebeln EQ oc~ebeln AND
                 oc~iddte_sap EQ em~iddte_sap
              WHERE oc~iddte_sap EQ @i_iddte_sap AND
                    em~belnr IN @lt_belnr
              INTO @l_pdte.
          ELSE.
            SELECT SUM( mntclp ) AS pdte
              FROM zcds_i_em_fact_pdte AS em
              INNER JOIN @lt_referencias AS oc ON em~ebeln EQ oc~folioref
                                              AND oc~iddte_sap EQ em~iddte_sap
              WHERE oc~iddte_sap EQ @i_iddte_sap
                AND em~belnr IN @lt_belnr
              INTO @l_pdte.
          ENDIF.

          IF l_pdte IS NOT INITIAL.

            CLEAR: l_tolerancia.

            SELECT SINGLE porc_tol
              FROM zclmm_tb_parglob
              WHERE bukrs     EQ @i_bukrs
                AND parametro EQ 'TOLER'
                AND activo    EQ 'X'
                INTO @l_tolerancia.

            IF l_tolerancia IS NOT INITIAL. "(+) MSEPULVEDA 19.03.2025 - NUEVA LOGICA PARA DOLARES

*            IF sy-subrc EQ 0.
              l_montotol = l_total * ( l_tolerancia / 100 ).
*            ENDIF.

            ELSE.
              SELECT SINGLE porc_tol,
                            parametro
                FROM zclmm_tb_parglob
                WHERE bukrs     EQ @i_bukrs AND
                      parametro EQ 'MNTTOLUSD' AND
                      activo    EQ 'X'
                INTO ( @l_tolerancia, @l_mnttolusd ).

              IF l_tolerancia IS NOT INITIAL.

                CLEAR: l_valor_usd.
                l_valor_usd = l_tolerancia.
                " Crear instancia de la clase de conversión de monedas
                " Realizar la conversión
                TRY.
                    cl_exchange_rates=>convert_to_local_currency(
                      EXPORTING
                        date                 = cl_abap_context_info=>get_system_date( )
                        foreign_amount       = l_valor_usd
                        foreign_currency     = 'USD'
                        local_currency       = l_waers
                        rate_type            = 'M'
                      IMPORTING
                      local_amount = l_montotol
                    ).
                  CATCH cx_exchange_rates INTO DATA(lo_rates).
                    DATA(lv_msg) = lo_rates->get_longtext(  ).
                    "handle exception
                ENDTRY.

              ENDIF.

            ENDIF. "(+) MSEPULVEDA 19.03.2025 - NUEVA LOGICA PARA DOLARES

            IF l_total NE l_pdte.
              IF ( l_total  LT ( l_pdte - l_montotol ) ) . "(+) MSEPULVEDA 10.04.2024
                e_check = '0'.
                CALL METHOD zclmm_cs_check_dte=>save_log
                  EXPORTING
                    i_iddte_sap = i_iddte_sap             " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                    i_msgty     = 'E'                     " Tipo de mensaje
                    i_msg       = 'Monto factura menor a recepciones'
                    i_table     = i_tables.


              ELSEIF l_total  GT ( l_pdte + l_montotol ).    "(+) MSEPULVEDA 10.04.2024
                e_check = '0'.
                CALL METHOD zclmm_cs_check_dte=>save_log
                  EXPORTING
                    i_iddte_sap = i_iddte_sap             " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                    i_msgty     = 'E'                     " Tipo de mensaje
                    i_msg       = 'Monto factura supera a recepciones'
                    i_table     = i_tables.
              ENDIF.
            ELSE. " No aplica validaci n, cumple regla.
              e_check = '1'.
            ENDIF.

          ELSE.
            e_check = '0'.
            CALL METHOD zclmm_cs_check_dte=>save_log
              EXPORTING
                i_iddte_sap = i_iddte_sap             " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                i_msgty     = 'E'                     " Tipo de mensaje
                i_msg       = 'OC sin recepciones'
                i_table     = i_tables.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_ncvsfact.
    " Verifica si NC tiene factura en referencia.
    " 0 = NC sin referencia a factura
    " 1 = OK - NC con referencia o documento validado no es NC

    CONSTANTS lc_34 TYPE zclmm_tb_refdte-tpodocref  VALUE '34'.
    CONSTANTS lc_33 TYPE zclmm_tb_refdte-tpodocref  VALUE '33'.
    CONSTANTS lc_034 TYPE zclmm_tb_refdte-tpodocref VALUE '034'.
    CONSTANTS lc_033 TYPE zclmm_tb_refdte-tpodocref VALUE '033'.

    DATA: l_neto       TYPE zclmm_tb_cabdte-mntneto.    " Neto factura
    DATA: l_lifnr TYPE zclmm_tb_procdte-lifnr.          " Cliente
    DATA: l_bukrs TYPE zclmm_tb_procdte-bukrs.          " Sociedad
    DATA: l_rmwwr TYPE zcds_c_recdte_cab-MontoTotal.    " Monto Favtura
    DATA: l_folioref  TYPE zclmm_tb_refdte-folioref.
    DATA: l_tipodte TYPE zclmm_tb_cabdte-tipodte.
    DATA: l_retcode TYPE sy-subrc.

    CLEAR: l_tipodte.

    SELECT SINGLE tipodte
      FROM zclmm_tb_cabdte
      WHERE iddte_sap EQ @i_iddte_sap
      INTO @l_tipodte.

    IF l_tipodte EQ '061' OR l_tipodte EQ '61'.

      SELECT SINGLE folioref
        FROM zclmm_tb_refdte
        WHERE iddte_sap EQ @i_iddte_sap
          AND ( tpodocref EQ @lc_33 OR tpodocref EQ @lc_34 OR tpodocref EQ @lc_033 OR tpodocref EQ @lc_034 )
          INTO @l_folioref.
      IF sy-subrc NE 0.
        e_check = '0'.
        CALL METHOD zclmm_cs_check_dte=>save_log
          EXPORTING
            i_iddte_sap = i_iddte_sap             " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
            i_msgty     = 'E'                     " Tipo de mensaje
            i_msg       = 'NC sin referencia a factura'
            i_table     = i_tables.

        RETURN.
      ENDIF.

*    Factura debe estar contabilizada
      SELECT SINGLE lifnr,
                    bukrs
        FROM zclmm_tb_procdte
        WHERE iddte_sap  EQ @i_iddte_sap
              INTO (@l_lifnr, @l_bukrs).

      IF sy-subrc EQ 0.
        SELECT SINGLE InvoiceGrossAmount
        FROM I_SupplierInvoiceAPI01
        WHERE SupplierInvoiceIDByInvcgParty = @l_folioref
          AND InvoicingParty                = @l_lifnr
          AND CompanyCode                   = @l_bukrs
        INTO @l_rmwwr.

        IF sy-subrc NE 0.
          e_check = '0'.
          CALL METHOD zclmm_cs_check_dte=>save_log
            EXPORTING
              i_iddte_sap = i_iddte_sap             " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
              i_msgty     = 'E'                     " Tipo de mensaje
              i_msg       = 'Factura debe estar contabilizada'
              i_table     = i_tables.
          RETURN.
        ENDIF.
      ENDIF.

*Monto NC <= Monto factura
*Si MNTNETO l nea seleccionada alv > RBKP-RMWWR no se puede contabilizar, actualizar log

      SELECT SINGLE ( mntneto + mntexe )
        FROM zclmm_tb_cabdte
        WHERE iddte_sap EQ @i_iddte_sap
        INTO @l_neto.

      IF l_neto >  l_rmwwr  .
        e_check = '0'.

        CALL METHOD zclmm_cs_check_dte=>save_log
          EXPORTING
            i_iddte_sap = i_iddte_sap             " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
            i_msgty     = 'E'                     " Tipo de mensaje
            i_msg       = 'Monto de NC mayor a la factura'
            i_table     = i_tables.
        RETURN.
      ENDIF.

      e_check = '1'.
    ELSE. " Documento no es NC
      e_check = '1'.
    ENDIF.
  ENDMETHOD.


  METHOD check_oclib.

    " Verifica si el documento hace referencia a una orden de compra liberada.
    " 0 = OC no liberada
    " 1 = OC liberada

    TYPES: BEGIN OF ty_status,
             frgke TYPE frgke,
           END OF ty_status.
    TYPES: BEGIN OF ty_ref,
             folioref TYPE zclmm_tb_refdte-folioref,
           END OF ty_ref.
    DATA: lt_ref    TYPE STANDARD TABLE OF ty_ref.
    DATA: lt_status TYPE STANDARD TABLE OF ty_status.
    DATA: ls_ref    LIKE LINE OF lt_ref.
    DATA: ls_status LIKE LINE OF lt_status.
    DATA: l_frgke   TYPE frgke.
    DATA: l_frgsx   TYPE c LENGTH 2.
    DATA: l_oc      TYPE ebeln.
    DATA: l_retcode TYPE sy-subrc.
    DATA: l_excep      TYPE lifnr.     " Proveedor
    DATA: l_rutemi     TYPE zclmm_tb_cabdte-rutemisor.  " Rut Emisor
    DATA: l_lifnr      TYPE lifnr.     " Proveedor
    DATA lt_referencias TYPE TABLE OF zclmm_tb_refdte.

    CLEAR: lt_ref, lt_referencias.
    CLEAR: ls_ref,
           l_rutemi.
    CLEAR: l_excep.

    lt_referencias[] = zclmm_cs_check_dte=>gt_ref[].

    IF i_tables EQ abap_false.
      SELECT folioref
        FROM zclmm_tb_refdte
        WHERE iddte_sap EQ @i_iddte_sap AND
              tpodocref EQ '801'
        INTO TABLE @lt_ref.

      SELECT SINGLE rutemisor
       FROM zclmm_tb_cabdte
      WHERE iddte_sap EQ @i_iddte_sap
       INTO @l_rutemi.

    ELSE.

      IF lt_ref[] IS INITIAL.
        e_check = '1'.
      ELSE.
        SELECT folioref
          FROM @lt_referencias AS ref
          WHERE ref~iddte_sap EQ @i_iddte_sap
            AND ref~tpodocref EQ '801'
          INTO TABLE @lt_ref.
        READ TABLE zclmm_cs_check_dte=>gt_cab INTO DATA(ls_cab) WITH KEY iddte_sap = i_iddte_sap.
        IF sy-subrc EQ 0.
          l_rutemi = ls_cab-rutemisor.
        ENDIF.
      ENDIF.

      l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = l_rutemi ).

      SELECT SINGLE lifnr  FROM zclmm_tb_excecoc
        WHERE lifnr EQ @l_lifnr
        INTO @l_excep.
      IF l_excep IS NOT INITIAL.
        e_check = '1'.       "--> No valida OC, es proveedor exceptuado
      ELSE.
        IF lt_ref[] IS INITIAL.
          e_check = '1'.
        ELSE.
          LOOP AT lt_ref INTO ls_ref.

            l_oc = |{ ls_ref-folioref ALPHA = IN }|.

            SELECT SINGLE purchasingprocessingstatus
             FROM I_PurchaseOrderAPI01 WITH PRIVILEGED ACCESS
              WHERE PurchaseOrder              EQ @l_oc
                AND purchasingprocessingstatus EQ '05'
              INTO @DATA(lv_stat).
            IF sy-subrc EQ 0.
              e_check = '1'.
            ELSE.
              e_check = '0'.
              CALL METHOD zclmm_cs_check_dte=>save_log
                EXPORTING
                  i_iddte_sap = i_iddte_sap                   " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                  i_msgty     = 'E'                           " Tipo de mensaje
                  i_msg       = 'OC no liberada.'             " Variable de mensaje 1
                  i_table     = i_tables.                      " Indica si el mensaje es de tabla
            ENDIF.
          ENDLOOP.

          IF lt_ref[] IS INITIAL.
            e_check = '1'.  " Sin referencia a OC.
            CALL METHOD zclmm_cs_check_dte=>save_log
              EXPORTING
                i_iddte_sap = i_iddte_sap                       " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                i_msgty     = 'E'                               " Tipo de mensaje
                i_msg       = 'Documento sin referencia a OC'   " Variable de mensaje 1
                i_table     = i_tables.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_ordenc.

    " Verifica si el documento hace referencia a una orden de compra existente en SAP.
    " 0 = No referencia a OC v lida
    " 1 = Hace referencia a OC v lida
    TYPES: BEGIN OF ty_ref,
             folioref TYPE zclmm_tb_refdte-folioref,
           END OF ty_ref.
    DATA: lt_ref    TYPE STANDARD TABLE OF ty_ref.
    DATA: ls_ref    LIKE LINE OF lt_ref.
    DATA: l_ebeln   TYPE I_PurchaseOrderAPI01-PurchaseOrder.
    DATA: l_oc      TYPE ebeln.
    DATA: l_lifnr   TYPE lifnr.
    DATA: l_rutemi  TYPE zclmm_tb_cabdte-rutemisor.
    DATA: l_excep   TYPE lifnr.
    DATA: l_retcode TYPE sy-subrc.
    DATA: lt_procdte TYPE TABLE OF zclmm_tb_procdte.
    DATA: lt_referencias TYPE TABLE OF zclmm_tb_refdte.

    CLEAR: lt_ref.
    CLEAR: ls_ref,
           l_lifnr,
           l_rutemi.

    IF i_tables EQ space.

      SELECT folioref
       FROM zclmm_tb_refdte
        WHERE iddte_sap EQ @i_iddte_sap AND
              tpodocref EQ '801'
        INTO TABLE @lt_ref.

      SELECT SINGLE *                         "#EC CI_ALL_FIELDS_NEEDED
       FROM zclmm_tb_procdte
        WHERE iddte_sap EQ @i_iddte_sap
       INTO @DATA(ls_procdte).

      CLEAR: l_excep.
      SELECT SINGLE rutemisor
        FROM zclmm_tb_cabdte
        WHERE iddte_sap EQ @i_iddte_sap
        INTO @l_rutemi.

      l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = l_rutemi ).

      SELECT SINGLE lifnr  FROM zclmm_tb_excecoc
        WHERE lifnr EQ @l_lifnr
        INTO @l_excep.
      IF lt_ref[] IS INITIAL.
        IF l_excep IS NOT INITIAL.
          e_check = '1'.       "--> No tiene OC, pero es proveedor exceptuado
          ls_procdte-modulo = 'FI'.
          APPEND ls_procdte TO lt_procdte.

          CALL METHOD zclmm_cs_check_dte=>save_log
            EXPORTING
              i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
              i_msgty     = 'W'                             " Tipo de mensaje
              i_msg       = 'Proveedor con excepción OC'    " Variable de mensaje 1
              i_table     = i_tables.
        ELSE.
          e_check = '0'.

          CALL METHOD zclmm_cs_check_dte=>save_log
            EXPORTING
              i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
              i_msgty     = 'E'                             " Tipo de mensaje
              i_msg       = 'Documento sin referencia a OC'
              i_table     = i_tables.

          ls_procdte-modulo = 'FI'.
          APPEND ls_procdte TO lt_procdte.
        ENDIF.
      ELSE.
        LOOP AT lt_ref INTO ls_ref.
          CLEAR: l_ebeln.

          l_oc = |{ ls_ref-folioref ALPHA = IN }|.

          SELECT SINGLE PurchaseOrder
            FROM I_PurchaseOrderAPI01 WITH PRIVILEGED ACCESS
            WHERE PurchaseOrder EQ @l_oc
              AND CompanyCode EQ @i_bukrs
            INTO @l_ebeln.

          IF sy-subrc EQ 0.
            e_check = '1'.
          ELSE.                  "--> No tiene OC v lida
            IF l_excep IS NOT INITIAL.
              e_check = '1'.
              ls_procdte-modulo = 'FI'.
              APPEND ls_procdte TO lt_procdte.
              CALL METHOD zclmm_cs_check_dte=>save_log
                EXPORTING
                  i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                  i_msgty     = 'W'                             " Tipo de mensaje
                  i_msg       = 'Proveedor con excepción OC'    " Variable de mensaje 1
                  i_table     = i_tables.
            ELSE.
              e_check = '0'.
              CALL METHOD zclmm_cs_check_dte=>save_log
                EXPORTING
                  i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                  i_msgty     = 'E'                             " Tipo de mensaje
                  i_msg       = 'OC no existe en SAP'           " Variable de mensaje 1
                  i_table     = i_tables.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF e_check EQ '1' AND ls_procdte-modulo NE 'FI'.
          ls_procdte-modulo = 'MM'.
          CLEAR: ls_procdte-hkont,
                ls_procdte-kostl.
          APPEND ls_procdte TO lt_procdte.
        ENDIF.
      ENDIF.

    ELSE." OC desde Validaciones
      CLEAR: lt_referencias[], l_excep.

      lt_referencias[] = zclmm_cs_check_dte=>gt_ref[].
      DELETE lt_referencias WHERE tpodocref NE '801'.

      IF lt_referencias[] IS INITIAL.
        e_check = '1'.
      ELSE.
        READ TABLE zclmm_cs_check_dte=>gt_pro ASSIGNING FIELD-SYMBOL(<fs_proc>) WITH KEY iddte_sap = i_iddte_sap.
        READ TABLE zclmm_cs_check_dte=>gt_cab INTO DATA(ls_cab) WITH KEY iddte_sap = i_iddte_sap.
        IF sy-subrc EQ 0.
          l_rutemi = ls_cab-rutemisor.
        ENDIF.
        l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = l_rutemi ).

        IF l_lifnr NE space.
          SELECT SINGLE lifnr  FROM zclmm_tb_excecoc
            WHERE lifnr EQ @l_lifnr
            INTO @l_excep.
          IF lt_referencias[] IS INITIAL.
            IF l_excep IS NOT INITIAL.
              e_check = '1'.       "--> No tiene OC, pero es proveedor exceptuado
              <fs_proc>-modulo = 'FI'.

              CALL METHOD zclmm_cs_check_dte=>save_log
                EXPORTING
                  i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                  i_msgty     = 'W'                             " Tipo de mensaje
                  i_msg       = 'Proveedor con excepción OC'    " Variable de mensaje 1
                  i_table     = i_tables.
            ELSE.
              e_check = '0'.

              CALL METHOD zclmm_cs_check_dte=>save_log
                EXPORTING
                  i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                  i_msgty     = 'W'                             " Tipo de mensaje
                  i_msg       = 'Documento sin referencia a OC'
                  i_table     = i_tables.
              <fs_proc>-modulo = 'FI'.
            ENDIF.
          ELSE.
            LOOP AT lt_referencias INTO DATA(ls_referencias).
              CLEAR: l_ebeln.

              l_oc = |{ ls_referencias-folioref ALPHA = IN }|.

              SELECT SINGLE PurchaseOrder
               FROM I_PurchaseOrderAPI01 WITH PRIVILEGED ACCESS
              WHERE purchaseorder EQ @l_oc
               INTO @DATA(ls_purchord_data).

              IF sy-subrc EQ 0.
                e_check = '1'.
              ELSE.                  "--> No tiene OC v lida
                IF l_excep IS NOT INITIAL.
                  e_check = '1'.
                  <fs_proc>-modulo = 'FI'.
                  CALL METHOD zclmm_cs_check_dte=>save_log
                    EXPORTING
                      i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                      i_msgty     = 'W'                             " Tipo de mensaje
                      i_msg       = 'Proveedor con excepción OC'    " Variable de mensaje 1
                      i_table     = i_tables.
                ELSE.
                  e_check = '0'.
                  CALL METHOD zclmm_cs_check_dte=>save_log
                    EXPORTING
                      i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                      i_msgty     = 'E'                             " Tipo de mensaje
                      i_msg       = 'OC no existe en SAP'           " Variable de mensaje 1
                      i_table     = i_tables.
                ENDIF.
              ENDIF.
            ENDLOOP.

            IF e_check EQ '1' AND ls_procdte-modulo NE 'FI' AND i_tables EQ abap_false.

              ls_procdte-modulo = 'MM'.
              CLEAR: ls_procdte-hkont,
                    ls_procdte-kostl.
              APPEND ls_procdte TO lt_procdte.
            ELSEIF e_check EQ '1' AND ls_procdte-modulo NE 'FI' AND i_tables EQ abap_true.
              <fs_proc>-modulo = 'MM'.
              CLEAR: <fs_proc>-hkont,
                    <fs_proc>-kostl.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_procfact.

    " Verifica que el proveedor de la factura es igual al proveedor de orden de compra
    " o que corresponda a prov. costos indirectos incluidos en orden de compra
    " 0 = Proveedor distinto
    " 1 = Proveedor igual en ambos documentos
    TYPES: BEGIN OF ty_ref,
             folioref TYPE zclmm_tb_refdte-folioref,
           END OF ty_ref.

    DATA: lt_ref      TYPE STANDARD TABLE OF ty_ref. " Tabla Referencias
    DATA: ls_ref      LIKE LINE OF lt_ref.                    " Area trabajo referencias
    DATA: ls_procdte TYPE zclmm_tb_procdte.
    DATA: l_lifnr_oc  TYPE lifnr.
    DATA: l_oc        TYPE ebeln.
    DATA: l_lifnr     TYPE lifnr.
    DATA: l_rutemi    TYPE zclmm_tb_cabdte-rutemisor.
    DATA: l_retcode TYPE sy-subrc.
    DATA: l_excep      TYPE zclmm_tb_excecoc-lifnr.     " Proveedor
    DATA: lt_referencias TYPE TABLE OF zclmm_tb_refdte.

    CLEAR: lt_ref, lt_referencias.

    CLEAR: ls_ref,
           l_lifnr,
           l_rutemi,
           l_oc.

    CLEAR: l_excep.

    lt_referencias[] = zclmm_cs_check_dte=>gt_ref[].

    SELECT SINGLE rutemisor
      FROM zclmm_tb_cabdte
      WHERE iddte_sap EQ @i_iddte_sap
      INTO @l_rutemi.

    l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = l_rutemi ).

    SELECT SINGLE lifnr  FROM zclmm_tb_excecoc
      WHERE lifnr EQ @l_lifnr
      INTO @l_excep.

    IF l_excep IS NOT INITIAL.
      e_check = '1'.   " No valida proveedor OC, es proveedor exceptuado.
    ELSE.

      IF i_tables EQ abap_false.
        SELECT folioref
          FROM zclmm_tb_refdte
          WHERE iddte_sap EQ @i_iddte_sap AND
                tpodocref EQ '801'
          INTO TABLE @lt_ref. "--> S lo referencias a OC
      ELSE.
        SELECT DISTINCT folioref
          FROM @lt_referencias AS ref
          WHERE ref~iddte_sap EQ @i_iddte_sap
            AND ref~tpodocref EQ '801'
          INTO TABLE @lt_ref. "--> S lo referencias a OC
      ENDIF.

      SELECT SINGLE rutemisor
        FROM zclmm_tb_cabdte
        WHERE iddte_sap EQ @i_iddte_sap
        INTO @l_rutemi.
      IF lt_ref[] IS INITIAL.
        IF l_excep IS NOT INITIAL.
          e_check = '1'.       "--> No tiene OC, pero es proveedor exceptuado
        ELSE.
          e_check = '0'.
        ENDIF.
      ELSE.

        LOOP AT lt_ref INTO ls_ref .
          l_oc = |{ ls_ref-folioref ALPHA = IN }|.

          SELECT SINGLE Supplier
           FROM I_PurchaseOrderAPI01 WITH PRIVILEGED ACCESS
          WHERE PurchaseOrder = @l_oc
            AND CompanyCode   = @i_bukrs
          INTO @l_lifnr_oc.

          IF sy-subrc EQ 0.

            l_lifnr = zclmm_cs_check_dte=>get_proveedor( i_rut = l_rutemi ).

            IF l_lifnr EQ l_lifnr_oc.
              e_check = '1'.
            ELSE.
              e_check = '0'.
              CALL METHOD zclmm_cs_check_dte=>save_log
                EXPORTING
                  i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                  i_msgty     = 'E'                             " Tipo de mensaje
                  i_msg       = 'Proveedor OC no corresponde a proveedor factura'                " Variable de mensaje 1
                  i_table     = i_tables.                      " Indica si el mensaje es de tabla
            ENDIF.
          ELSE.                   "--> No tiene OC, no se puede validar proveedor igual en OC/Fact.
            e_check = '0'.

            CALL METHOD zclmm_cs_check_dte=>save_log
              EXPORTING
                i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
                i_msgty     = 'E'                             " Tipo de mensaje
                i_msg       = 'Documento sin OC válida'                " Variable de mensaje 1
                i_table     = i_tables.                      " Indica si el mensaje es de tabla
          ENDIF.

        ENDLOOP.

        IF lt_ref[] IS INITIAL.
          e_check = '0'.
          CALL METHOD zclmm_cs_check_dte=>save_log
            EXPORTING
              i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
              i_msgty     = 'E'                             " Tipo de mensaje
              i_msg       = 'Documento sin OC.'             " Variable de mensaje 1
              i_table     = i_tables.                      " Indica si el mensaje es de tabla
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_proveed.

    " Verifica si el proveedor del documento existe en SAP.
    " 0 = Proveedor no v lido
    " 1 = Proveedor v lido

    IF i_tables EQ abap_false.
      SELECT SINGLE rutemisor
        FROM zclmm_tb_cabdte
        WHERE iddte_sap EQ @i_iddte_sap
         INTO @DATA(lv_rutemi).
      IF sy-subrc EQ 0.
        DATA(lv_length) = strlen( lv_rutemi ).
      ENDIF.
    ELSE.
      READ TABLE zclmm_cs_check_dte=>gt_cab INTO DATA(ls_cab) WITH KEY iddte_sap = i_iddte_sap.
      IF sy-subrc EQ 0.
        lv_rutemi = ls_cab-rutemisor.
        lv_length = strlen( ls_cab-rutemisor ).
      ENDIF.
    ENDIF.

    SELECT SINGLE taxnumber1
     FROM I_Supplier WITH PRIVILEGED ACCESS
    WHERE TaxNumber1 EQ @lv_rutemi
      INTO @DATA(lv_stcd1) .

    IF sy-subrc NE 0 AND lv_length EQ 9.
      CONCATENATE '0' lv_rutemi INTO lv_rutemi.
      CONDENSE lv_rutemi NO-GAPS.

      SELECT SINGLE taxnumber1
       FROM i_supplier WITH PRIVILEGED ACCESS
      WHERE taxnumber1 EQ @lv_rutemi
        INTO @lv_stcd1.
    ENDIF.

    IF lv_stcd1 IS NOT INITIAL.
      e_check = '1'.
    ELSE.
      e_check = '0'.
      CALL METHOD zclmm_cs_check_dte=>save_log
        EXPORTING
          i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
          i_msgty     = 'E'                             " Tipo de mensaje
          i_msg       = 'Proveedor no existe en SAP'    " Variable de mensaje 1
          i_table     = i_tables.                      " Indica si el mensaje es de tabla
    ENDIF.
  ENDMETHOD.


  METHOD check_recept.

    " Verifica si receptor corresponde a sociedad SAP.
    " 0 = Proveedor no v lido
    " 1 = Proveedor v lido

    DATA: l_bukrs TYPE bukrs.
    DATA: l_rutrecep TYPE zclmm_tb_cabdte-rutrecep.
    DATA: l_retcode TYPE sy-subrc.
    DATA lv_dig TYPE zclmm_ed_char1.
    DATA lv_rut TYPE c LENGTH 12.
    DATA lv_num TYPE c LENGTH 8.

    CLEAR: l_bukrs,
           l_retcode,
           l_rutrecep.

    SELECT SINGLE rutrecep
       FROM zclmm_tb_cabdte
      WHERE iddte_sap EQ @i_iddte_sap
      INTO @l_rutrecep.
    IF sy-subrc EQ 0.

      SELECT SINGLE CompanyCode AS bukrs
        FROM I_AddlCompanyCodeInformation WITH PRIVILEGED ACCESS
        WHERE CompanyCodeParameterType  EQ 'TAXNR'
          AND CompanyCodeParameterValue EQ @l_rutrecep
        INTO @l_bukrs.
      IF sy-subrc NE 0.
        CLEAR lv_num.
        CLEAR lv_dig.
        CLEAR lv_rut.

        SPLIT l_rutrecep AT '-' INTO lv_num lv_dig.
        SHIFT lv_num RIGHT DELETING TRAILING ' '.

        lv_rut = lv_num(2) && '.' &&  lv_num+2(3) && '.' && lv_num+5(3) && '-' && lv_dig.

        SELECT SINGLE CompanyCode AS bukrs
          FROM I_AddlCompanyCodeInformation WITH PRIVILEGED ACCESS
          WHERE CompanyCodeParameterType  EQ 'TAXNR' AND
                CompanyCodeParameterValue EQ @lv_rut
          INTO @l_bukrs.

      ENDIF.
      IF l_bukrs IS NOT INITIAL.
        e_check = '1'.
      ELSE.
        e_check = '0'.
        CALL METHOD zclmm_cs_check_dte=>save_log
          EXPORTING
            i_iddte_sap = i_iddte_sap                     " IdDTE (Tipo, Folio, Rut Emisor, Fecha emisi n)
            i_msgty     = 'E'                             " Tipo de mensaje
            i_msg       = 'Rut receptor no corresponde a Sociedad'           " Variable de mensaje 1
            i_table     = i_tables.                      " Indica si el mensaje es de tabla

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_data.
    et_cab = zclmm_cs_check_dte=>gt_cab[].
    et_det = zclmm_cs_check_dte=>gt_det[].
    et_ref = zclmm_cs_check_dte=>gt_ref[].
    et_pro = zclmm_cs_check_dte=>gt_pro[].
    et_log = zclmm_cs_check_dte=>gt_log[].

  ENDMETHOD.


  METHOD get_proveedor.

    DATA: lv_length TYPE i,
          lv_taxnum TYPE bptaxnum.

    CLEAR: e_lifnr,
           lv_length.

    SELECT SINGLE BusinessPartner AS partner
     FROM i_businesspartnertaxnumber WITH PRIVILEGED ACCESS
    WHERE BPTaxNumber EQ @i_rut
     INTO @e_lifnr.

    IF sy-subrc NE 0.
      lv_length = strlen( i_rut ).
      IF lv_length EQ 9.
        CONCATENATE '0' i_rut INTO lv_taxnum.

        SELECT SINGLE BusinessPartner AS partner
         FROM i_businesspartnertaxnumber WITH PRIVILEGED ACCESS
          WHERE BPTaxNumber EQ @lv_taxnum
         INTO @e_lifnr.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD save_log.
    DATA: l_corr TYPE i.
    DATA: lt_log TYPE TABLE OF zclmm_tb_logdte.

    IF i_table EQ abap_true.
      lt_log[] = zclmm_cs_check_dte=>gt_log[].
      SELECT MAX( correlativo )
       FROM @lt_log AS log
        WHERE iddte_sap EQ @i_iddte_sap
        INTO @l_corr.

      APPEND INITIAL LINE TO zclmm_cs_check_dte=>gt_log ASSIGNING FIELD-SYMBOL(<fs_log>).
      <fs_log>-mandt       = sy-mandt.
      <fs_log>-iddte_sap   = i_iddte_sap.
      <fs_log>-correlativo = l_corr + 1.
      <fs_log>-fecha       = cl_abap_context_info=>get_system_date( ).
      <fs_log>-hora        = cl_abap_context_info=>get_system_time( ).
      <fs_log>-uname       = sy-uname.
      <fs_log>-tipo        = i_msgty.
      <fs_log>-mensaje     = i_msg.

    ELSE.

      SELECT MAX( correlativo )
        FROM zclmm_tb_logdte
        WHERE iddte_sap EQ @i_iddte_sap
        INTO @l_corr.

      CLEAR lt_log.
      APPEND INITIAL LINE TO lt_log ASSIGNING <fs_log>.
      <fs_log>-mandt       = sy-mandt.
      <fs_log>-iddte_sap   = i_iddte_sap.
      <fs_log>-correlativo = l_corr + 1.
      <fs_log>-fecha       = cl_abap_context_info=>get_system_date( ).
      <fs_log>-hora        = cl_abap_context_info=>get_system_time( ).
      <fs_log>-uname       = sy-uname.
      <fs_log>-tipo        = i_msgty.
      <fs_log>-mensaje     = i_msg.

      TRY .
          INSERT zclmm_tb_logdte FROM TABLE @lt_log.
          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
        CATCH cx_root INTO DATA(lo_catch).
          DATA(lv_msg) = lo_catch->get_longtext(  ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD set_data.

    zclmm_cs_check_dte=>gt_cab[] = it_cab[].
    zclmm_cs_check_dte=>gt_det[] = it_det[].
    zclmm_cs_check_dte=>gt_ref[] = it_ref[].
    zclmm_cs_check_dte=>gt_pro[] = it_pro[].

  ENDMETHOD.
ENDCLASS.
