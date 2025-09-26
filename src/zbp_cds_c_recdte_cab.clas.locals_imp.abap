CLASS lhc_monitordtelog DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ MonitorDteLog RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ MonitorDteLog\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_monitordtelog IMPLEMENTATION.

  METHOD read.

  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_monitordtereferencias DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ MonitorDteReferencias RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ MonitorDteReferencias\_Header FULL result_requested RESULT result LINK association_links.

    METHODS update.

ENDCLASS.

CLASS lhc_monitordtereferencias IMPLEMENTATION.

  METHOD read.

  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_monitordtedetails DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ MonitorDteDetails RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ MonitorDteDetails\_Header FULL result_requested RESULT result LINK association_links.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE MonitorDteDetails.
    METHODS updateCta FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDteDetails~updateCta.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MonitorDteDetails RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE monitordtedetails.

ENDCLASS.

CLASS lhc_monitordtedetails IMPLEMENTATION.

  METHOD read.
    "Rescatar los datos de las otras entidades relacionadas
    "Detalle
    SELECT *
     FROM zcds_c_recdte_det AS det
    FOR ALL ENTRIES IN @keys
      WHERE det~iddte = @keys-iddte
        AND det~NroLinea = @keys-NroLinea
      INTO TABLE @DATA(lt_det).

    LOOP AT lt_det INTO DATA(ls_det).
      " Verificar si esta instancia fue solicitada
      READ TABLE keys INTO DATA(ls_key) WITH KEY iddte = ls_det-IdDTE
                                                 NroLinea = ls_det-NroLinea.
      IF sy-subrc = 0.
        " Agregar el registro al resultado
        INSERT CORRESPONDING #( ls_det ) INTO TABLE result.
      ELSE.
        " Reportar error para instancias no encontradas
        INSERT VALUE #( %tky = ls_key-%tky
                        %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = |Registro no encontrado: { ls_key-iddte }| ) ) INTO TABLE reported-monitordte.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

  METHOD update.

  ENDMETHOD.

  METHOD updateCta.

    CLEAR: zbp_cds_c_recdte_cab=>gv_accion, zbp_cds_c_recdte_cab=>gs_detalle_upd.

    " Leer las entidades desde la vista CDS
    READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
      ENTITY MonitorDteDetails
      FROM CORRESPONDING #( keys )
      RESULT DATA(lt_entities).

    READ TABLE lt_entities INTO DATA(ls_entities) INDEX 1.
    IF sy-subrc EQ 0.
      zbp_cds_c_recdte_cab=>gv_accion = 'UDET'.
      MOVE-CORRESPONDING ls_entities TO zbp_cds_c_recdte_cab=>gs_detalle_upd.
      zbp_cds_c_recdte_cab=>gs_detalle_upd-CentroCosto = keys[ 1 ]-%param-CentroCosto.
      zbp_cds_c_recdte_cab=>gs_detalle_upd-CuentaMayor = keys[ 1 ]-%param-CuentaMayor.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_MonitorDte DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR MonitorDte RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MonitorDte RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE MonitorDte.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE MonitorDte.

    METHODS read FOR READ
      IMPORTING keys FOR READ MonitorDte RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK MonitorDte.

    METHODS contabilizar FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDte~contabilizar.

    METHODS pdf FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDte~pdf.

    METHODS procesarMultiple FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDte~procesarMultiple.

    METHODS rechazar FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDte~rechazar.

    METHODS contabilizar_fb60 FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDte~contabilizar_fb60.

    METHODS contabilizar_oc FOR MODIFY
      IMPORTING keys FOR ACTION MonitorDte~contabilizar_oc.

    METHODS rba_Detalle FOR READ
      IMPORTING keys_rba FOR READ MonitorDte\_Detalle FULL result_requested RESULT result LINK association_links.

    METHODS rba_Log FOR READ
      IMPORTING keys_rba FOR READ MonitorDte\_Log FULL result_requested RESULT result LINK association_links.

    METHODS rba_Referencias FOR READ
      IMPORTING keys_rba FOR READ MonitorDte\_Referencias FULL result_requested RESULT result LINK association_links.

    METHODS cba_Detalle FOR MODIFY
      IMPORTING entities_cba FOR CREATE MonitorDte\_Detalle.

    METHODS cba_Log FOR MODIFY
      IMPORTING entities_cba FOR CREATE MonitorDte\_Log.

    METHODS cba_Referencias FOR MODIFY
      IMPORTING entities_cba FOR CREATE MonitorDte\_Referencias.

    METHODS GetDefaultsForReferencia FOR READ
      IMPORTING keys FOR FUNCTION MonitorDte~GetDefaultsForReferencia RESULT result.

    METHODS GetDefaultsForMasiva FOR READ
      IMPORTING keys FOR FUNCTION MonitorDte~GetDefaultsForMasiva RESULT result.

    METHODS getdefaultsforitem FOR READ
      IMPORTING keys FOR FUNCTION MonitorDte~GetDefaultsForItems RESULT result.

ENDCLASS.

CLASS lhc_MonitorDte IMPLEMENTATION.

  METHOD get_instance_features.

    " Inicializar result con las claves recibidas
    result = VALUE #( FOR key IN keys ( %tky = key-%tky ) ).

    " Leer las entidades desde la vista CDS
    READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
      ENTITY MonitorDte
      FROM CORRESPONDING #( keys )
      RESULT DATA(lt_entities).


    " Iterar sobre cada resultado para configurar las características
    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs_feature>).

      " Buscar la entidad correspondiente
      READ TABLE lt_entities INTO DATA(ls_entity)  WITH KEY %tky = <fs_feature>-%tky.
      IF sy-subrc = 0.
        READ TABLE zbp_cds_c_recdte_cab=>gt_referencias INTO DATA(ls_ref) WITH KEY CodTipoDocRef = '801'.
        IF sy-subrc EQ 0.
          <fs_feature>-%action-contabilizar      = if_abap_behv=>fc-o-enabled.
          <fs_feature>-%action-contabilizar_oc   = if_abap_behv=>fc-o-disabled.
          <fs_feature>-%action-contabilizar_fb60 = if_abap_behv=>fc-o-disabled.
        ELSE.
          <fs_feature>-%action-contabilizar      = if_abap_behv=>fc-o-disabled.
          <fs_feature>-%action-contabilizar_oc   = if_abap_behv=>fc-o-enabled.
          <fs_feature>-%action-contabilizar_fb60 = if_abap_behv=>fc-o-enabled.
        ENDIF.

        IF ls_entity-urlPDF IS INITIAL.
          <fs_feature>-%action-pdf = if_abap_behv=>fc-o-enabled.
        ELSE.
          <fs_feature>-%action-pdf = if_abap_behv=>fc-o-disabled.
        ENDIF.

        IF ( Ls_entity-NroDocContable IS NOT INITIAL OR ls_entity-NroDocMaterial IS NOT INITIAL ).
          <fs_feature>-%action-contabilizar      = if_abap_behv=>fc-o-disabled.
          <fs_feature>-%action-contabilizar_oc   = if_abap_behv=>fc-o-disabled.
          <fs_feature>-%action-contabilizar_fb60 = if_abap_behv=>fc-o-disabled.
        ENDIF.

        IF ls_entity-reglasOkStatus NE '3'.
          <fs_feature>-%action-contabilizar      = if_abap_behv=>fc-o-disabled.
          <fs_feature>-%action-contabilizar_oc   = if_abap_behv=>fc-o-disabled.
          <fs_feature>-%action-contabilizar_fb60 = if_abap_behv=>fc-o-disabled.
        ENDIF.

      ENDIF.


    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD read.

    "Rescatar los datos de las otras entidades relacionadas
    "Cabecera
    SELECT *
     FROM zcds_c_recdte_cab AS dte
      FOR ALL ENTRIES IN @keys
     WHERE dte~iddte = @keys-iddte
      INTO CORRESPONDING FIELDS OF TABLE @zbp_cds_c_recdte_cab=>gt_cabecera.
    IF sy-subrc EQ 0.

      "Detalle
      SELECT *
       FROM zcds_c_recdte_det
        FOR ALL ENTRIES IN @zbp_cds_c_recdte_cab=>gt_cabecera
       WHERE iddte = @zbp_cds_c_recdte_cab=>gt_cabecera-iddte
        INTO CORRESPONDING FIELDS OF TABLE @zbp_cds_c_recdte_cab=>gt_detalle.

      "Referencias
      SELECT *
        FROM zcds_c_recdte_ref
        FOR ALL ENTRIES IN @zbp_cds_c_recdte_cab=>gt_cabecera
        WHERE iddte = @zbp_cds_c_recdte_cab=>gt_cabecera-iddte
        INTO TABLE @zbp_cds_c_recdte_cab=>gt_referencias.

      "Log
      SELECT *
       FROM zcds_c_recdte_log
       FOR ALL ENTRIES IN @zbp_cds_c_recdte_cab=>gt_cabecera
       WHERE iddte = @zbp_cds_c_recdte_cab=>gt_cabecera-iddte
       INTO TABLE @zbp_cds_c_recdte_cab=>gt_log.
    ENDIF.

    LOOP AT zbp_cds_c_recdte_cab=>gt_cabecera INTO DATA(ls_cabdte).
      " Verificar si esta instancia fue solicitada
      READ TABLE keys INTO DATA(ls_key) WITH KEY iddte = ls_cabdte-iddte.
      IF sy-subrc = 0.
        " Agregar el registro al resultado
        INSERT CORRESPONDING #( ls_cabdte ) INTO TABLE result.
      ELSE.
        " Reportar error para instancias no encontradas
        INSERT VALUE #( %tky = ls_key-%tky
                        %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = |Registro no encontrado: { ls_key-iddte }| ) ) INTO TABLE reported-monitordte.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD contabilizar_fb60.

    TYPES: BEGIN OF ty_message_header,
             CreationDateTime TYPE string,
           END OF ty_message_header.

    TYPES: BEGIN OF ty_jour_entry_create_conf_data,
             AccountingDocument  TYPE string,
             CompanyCode         TYPE string,
             EstadoContabilizado TYPE string,
             FiscalYear          TYPE string,
           END OF ty_jour_entry_create_conf_data.

    TYPES: BEGIN OF ty_jour_entry_create_conf,
             JournalEntryCreateConfirmation TYPE ty_jour_entry_create_conf_data,
             MessageHeader                  TYPE ty_message_header,
             Log                            TYPE zes_log_reponse,
           END OF ty_jour_entry_create_conf.

    TYPES: BEGIN OF ty_jour_entry_bulk_create_conf,
             ConfirmationInterfaceOrignName TYPE string,
             JournalEntryCreateConfirmation TYPE ty_jour_entry_create_conf,
             MessageHeader                  TYPE ty_message_header,
           END OF ty_jour_entry_bulk_create_conf.

    TYPES: BEGIN OF ty_root,
             JournalEntBulkCreaConfirmation TYPE ty_jour_entry_bulk_create_conf,
           END OF ty_root.

    DATA: lo_json TYPE REF TO /ui2/cl_json.

    DATA: lt_item             TYPE ztt_item_fb60,
          lt_tax              TYPE ztt_tax_fb60,
          lt_supplierinvoicei TYPE TABLE OF zes_supplierinvoiceitmacctassg,
          lt_result1          TYPE TABLE OF zes_result_to_suplrinvcitempur,
          lt_result2          TYPE TABLE OF zes_result_to_supplierinvoicei.

    DATA: ls_to_SuplrInvcItemPurOrdRef TYPE zes_result_to_suplrinvcitempur,
          ls_to_supplierinvoiceitmacct TYPE zes_result_to_supplierinvoicei,
          ls_item                      TYPE zes_item_fb60,
          ls_response                  TYPE ty_root,
          ls_creditoritem              TYPE zes_creditoritem_fb60,
          ls_res_supp                  TYPE zes_result_to_suplrinvcitempur,
          ls_journalentrycreatereq     TYPE zes_journalentrycreatereq_fb60.

    DATA: lv_url         TYPE string,
          lv_json_req    TYPE string,
          lv_user        TYPE string,
          lv_pass        TYPE string,
          lv_method      TYPE string,
          lv_token       TYPE string,
          lv_resp        TYPE string,
          lv_status_code TYPE string,
          lv_cookie      TYPE string,
          lv_number      TYPE n LENGTH 6,
          lv_item_c      TYPE c LENGTH 5,
          lv_fecha       TYPE datum.

    CLEAR: zbp_cds_c_recdte_cab=>gs_res_oc,
           zbp_cds_c_recdte_cab=>gs_req_contab_fact,
           zbp_cds_c_recdte_cab=>gs_res_contab_fact,
           zbp_cds_c_recdte_cab=>gs_log,
           lv_json_req,
           lv_user,
           lv_pass,
           lv_method,
           lv_token,
           lv_cookie,
           lt_supplierinvoicei,
           lt_item,
           lt_tax,
           lv_number,
           lv_status_code,
           ls_item,
           ls_to_SuplrInvcItemPurOrdRef.

    DATA(lo_api) = NEW zcl_api_consumption( ).
    " Comentar la siguiente línea porque NEW ya crea el objeto
    " CREATE OBJECT lo_api.

    zbp_cds_c_recdte_cab=>gv_accion = 'FB60'.

    " Obtener los datos de la conexión de consulta
    SELECT SINGLE Idend,
                  Endpoint,
                  Zzuser     AS Usuario,
                  Zzpassword AS Password,
                  Zzmethod   AS Method
        FROM zcds_i_apis
        WHERE Idend EQ '3'
        INTO @DATA(ls_param).

    IF sy-subrc EQ 0.

      " Leer la entidad para obtener la OC asociada que se debe consultar
      READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
        ENTITY MonitorDte
          FIELDS ( IdDTE )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_monitorDTE).

      LOOP AT lt_monitordte INTO DATA(ls_monitor_dte).

        " Obtener OC asociada a las referencias
        READ TABLE zbp_cds_c_recdte_cab=>gt_referencias INTO DATA(ls_refdte) WITH KEY CodTipoDocRef = '801'
                                                                                      IdDTE         = ls_monitor_dte-IdDTE.
*        IF sy-subrc NE 0.

        " Obtener los datos de la OC
        lv_user   = ls_param-Usuario.
        lv_pass   = ls_param-Password.
        lv_method = ls_param-Method.
        lv_url    = ls_param-Endpoint.

        TRY.
            lv_fecha = cl_abap_context_info=>get_system_date( ).

            IF ls_monitor_dte-Moneda IS INITIAL.
              ls_monitor_dte-Moneda = 'CLP'.
            ENDIF.

            " Mapeo de la estructura de contabilizacion FB60
            zbp_cds_c_recdte_cab=>gs_req_contab_fb60-journalentrybulkcreaterequest-messageheader-creationdatetime = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }T00:00:00.1234567Z|.

            " Cabecera
            ls_journalentrycreatereq-messageheader-creationdatetime             = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }T00:00:00.1234567Z|.
            ls_journalentrycreatereq-journalentry-originalreferencedocumenttype = zbp_cds_c_recdte_cab=>read_tvarv( iv_campo = 'FB60_DOCTYPE' ).
            ls_journalentrycreatereq-journalentry-businesstransactiontype       = zbp_cds_c_recdte_cab=>read_tvarv( iv_campo = 'FB60_TRAN_TYPE' )."'RFBU'.
            ls_journalentrycreatereq-journalentry-accountingdocumenttype        = zbp_cds_c_recdte_cab=>read_tvarv( iv_campo = 'FB60_CLASS_DOC' )."'KR'.
            ls_journalentrycreatereq-journalentry-documentreferenceid           = ls_monitor_dte-Folio.
            ls_journalentrycreatereq-journalentry-documentheadertext            = ls_monitor_dte-Folio.
            ls_journalentrycreatereq-journalentry-createdbyuser                 = cl_abap_context_info=>get_user_technical_name( ).
            ls_journalentrycreatereq-journalentry-companycode                   = ls_monitor_dte-Sociedad.
            ls_journalentrycreatereq-journalentry-documentdate                  = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }|.
            ls_journalentrycreatereq-journalentry-postingdate                   = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }|.
            ls_journalentrycreatereq-journalentry-taxdeterminationdate          = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }|.


            lv_number = 1.
            APPEND VALUE #( referencedocumentitem       = lv_number
                            taxcode                     = keys[ 1 ]-%param-TaxCode
                            debitcreditcode             = 'S'
                            amountintransactioncurrency = ls_monitor_dte-MontoIva
                            taxbaseamountintranscrcy    = ls_monitor_dte-MontoTotal
                            conditiontype               = zbp_cds_c_recdte_cab=>read_tvarv( iv_campo = 'FB60_COND_TYPE' )
                            currencyCode                = ls_monitor_dte-Moneda ) TO ls_journalentrycreatereq-journalentry-producttaxitem.

            APPEND VALUE #(
                taxcode = keys[ 1 ]-%param-TaxCode
                ) TO lt_tax.

            CLEAR lv_number.
            LOOP AT zbp_cds_c_recdte_cab=>gt_detalle INTO DATA(ls_detail).

              CLEAR:ls_item, ls_creditoritem.

              lv_number = lv_number + 1.

              ls_item-ReferenceDocumentItem         = lv_number.
              ls_item-GLAccount                     = keys[ 1 ]-%param-CuentaMayor.
              ls_item-amountintransactioncurrency   = ls_detail-MontoItem.
              ls_item-currencyCode                  = ls_monitor_dte-Moneda.
              ls_item-DebitCreditCode               = 'S'.
              ls_item-DocumentItemText              = keys[ 1 ]-%param-Text.
              ls_item-AccountAssignment-costcenter  = keys[ 1 ]-%param-CentroCosto.
              ls_item-tax = lt_tax.
              APPEND ls_item TO ls_journalentrycreatereq-journalentry-item.

            ENDLOOP.

            ls_creditoritem-referencedocumentitem       = lv_number.
            ls_creditoritem-creditor                    = ls_monitor_dte-CodProveedor.
            ls_creditoritem-amountintransactioncurrency = |-{ ls_monitor_dte-MontoTotal } |.
            ls_creditoritem-currencycode                = ls_monitor_dte-Moneda.
            ls_creditoritem-debitcreditcode             = 'H'.
            ls_creditoritem-documentitemtext            = keys[ 1 ]-%param-Text.
            APPEND ls_creditoritem TO ls_journalentrycreatereq-journalentry-creditoritem.

            APPEND ls_journalentrycreatereq TO zbp_cds_c_recdte_cab=>gs_req_contab_fb60-journalentrybulkcreaterequest-journalentrycreaterequest.

            " Serializa el JSON de consulta
            lv_json_req = /ui2/cl_json=>serialize( data        = zbp_cds_c_recdte_cab=>gs_req_contab_fb60
                                                   pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

            " PascalCase JSON transformations
            CALL METHOD zbp_cds_c_recdte_cab=>change_json( CHANGING cv_json = lv_json_req ).

            " Contabilizar datos de la OC
            lo_api->call_external_api( EXPORTING
                                          iv_url            = lv_url
                                          iv_user           = lv_user
                                          iv_pass           = lv_pass
                                          iv_method         = lv_method
                                          iv_request_body   = lv_json_req
                                          iv_token          = abap_false
                                       IMPORTING
                                          ev_response_text  = lv_resp
                                          ev_code           = lv_status_code  ).

            REPLACE ALL OCCURRENCES OF 'JournalEntryBulkCreateConfirmation' IN lv_resp WITH 'JournalEntBulkCreaConfirmation'.
            REPLACE ALL OCCURRENCES OF 'Log'                                IN lv_resp WITH 'log'.
            REPLACE ALL OCCURRENCES OF 'Item'                               IN lv_resp WITH 'item'.
            REPLACE ALL OCCURRENCES OF 'Note'                               IN lv_resp WITH 'note'.

            " Crear instancia del deserializador JSON
            /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                       CHANGING  data = ls_response ).

            IF lv_status_code EQ '200' OR lv_status_code EQ '201'.
              IF ls_response-journalentbulkcreaconfirmation-journalentrycreateconfirmation-journalentrycreateconfirmation-accountingdocument NE '0000000000'. " Factura contabilizada

                zbp_cds_c_recdte_cab=>gs_factura_fb60-belnc  = ls_response-journalentbulkcreaconfirmation-journalentrycreateconfirmation-journalentrycreateconfirmation-accountingdocument.
                zbp_cds_c_recdte_cab=>gs_factura_fb60-anio   = ls_response-journalentbulkcreaconfirmation-journalentrycreateconfirmation-journalentrycreateconfirmation-fiscalyear.
                zbp_cds_c_recdte_cab=>gs_factura_fb60-status = '03'.

                CALL METHOD zbp_cds_c_recdte_cab=>set_log
                  EXPORTING
                    iddte_sap = keys[ 1 ]-IdDTE
                    mensaje   = |Exito: Se ha generado la contabilizacion { zbp_cds_c_recdte_cab=>gs_factura_fb60-factura } Año { zbp_cds_c_recdte_cab=>gs_factura_fb60-anio }|
                    tipo      = 'S'.

                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                        text     = |Exito: Se ha generado la contabilizacion { zbp_cds_c_recdte_cab=>gs_factura_fb60-factura } Año { zbp_cds_c_recdte_cab=>gs_factura_fb60-anio }| ) ) TO reported-monitordte.

              ELSE. " Factura NO contabilizada

                zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte   = keys[ 1 ]-IdDTE.
                zbp_cds_c_recdte_cab=>gs_factura_fb60-status  = '01'.

                LOOP AT ls_response-journalentbulkcreaconfirmation-journalentrycreateconfirmation-log-item-note INTO DATA(ls_item_note).
                  CALL METHOD zbp_cds_c_recdte_cab=>set_log
                    EXPORTING
                      iddte_sap = keys[ 1 ]-IdDTE
                      mensaje   = |Error: { ls_item_note }|
                      tipo      = 'E'.
                ENDLOOP.
                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                        text     = |Error: { ls_item_note }| ) ) TO reported-monitordte.

              ENDIF.
            ELSE.

              /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                         CHANGING  data = zbp_cds_c_recdte_cab=>gs_error ).

              CALL METHOD zbp_cds_c_recdte_cab=>set_log
                EXPORTING
                  iddte_sap = keys[ 1 ]-IdDTE
                  mensaje   = |Error: { zbp_cds_c_recdte_cab=>gs_error-error-message-value }|
                  tipo      = 'E'.

              APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                      text     = |Error: { zbp_cds_c_recdte_cab=>gs_error-error-message-value }| ) ) TO reported-monitordte.

            ENDIF.
          CATCH cx_web_http_client_error cx_http_dest_provider_error.
            " Agregar manejo más específico del error
            CALL METHOD zbp_cds_c_recdte_cab=>set_log
              EXPORTING
                iddte_sap = keys[ 1 ]-IdDTE
                mensaje   = 'Error: Excepción al llamar la API externa'
                tipo      = 'E'.

            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                    text     = 'Error: Excepción al llamar la API externa' ) ) TO reported-monitordte.

        ENDTRY.

*        ELSE.
*
*          CALL METHOD zbp_cds_c_recdte_cab=>set_log
*            EXPORTING
*              iddte_sap = keys[ 1 ]-IdDTE
*              mensaje   = 'Error: No ha encontrado posición con referencia 801'
*              tipo      = 'E'.
*
*          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
*                                                        text     = 'Error: No se ha encontrado posición con referencia 801' ) ) TO reported-monitordte.
*
*        ENDIF.
      ENDLOOP.

    ELSE.

      CALL METHOD zbp_cds_c_recdte_cab=>set_log
        EXPORTING
          iddte_sap = keys[ 1 ]-IdDTE
          mensaje   = 'Error: Debe configurar mantenedor de Apis para procesar FB60'
          tipo      = 'E'.

      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                    text     = 'Error: Debe configurar mantenedor de Apis para procesar FB60' ) ) TO reported-monitordte.

    ENDIF.

  ENDMETHOD.

  METHOD pdf.

    zbp_cds_c_recdte_cab=>gv_accion = 'PDF'.

  ENDMETHOD.

  METHOD procesarMultiple.

    DATA: lt_suplrinvcitempur TYPE TABLE OF zes_suplrinvcitempurordref,
          lt_supplierinvoicei TYPE TABLE OF zes_supplierinvoiceitmacctassg,
          lt_result1          TYPE TABLE OF zes_result_to_suplrinvcitempur,
          lt_result2          TYPE TABLE OF zes_result_to_supplierinvoicei,
          lt_item             TYPE ztt_purchaseorderitem.

    DATA: ls_to_SuplrInvcItemPurOrdRef TYPE zes_result_to_suplrinvcitempur,
          ls_to_supplierinvoiceitmacct TYPE zes_result_to_supplierinvoicei,
          ls_item                      LIKE LINE OF lt_item,
          ls_res_supp                  TYPE zes_result_to_suplrinvcitempur.

    DATA: lv_url         TYPE string,
          lv_json_req    TYPE string,
          lv_user        TYPE string,
          lv_pass        TYPE string,
          lv_method      TYPE string,
          lv_token       TYPE string,
          lv_resp        TYPE string,
          lv_status_code TYPE string,
          lv_cookie      TYPE string,
          lv_number      TYPE n LENGTH 6,
          lv_item_c      TYPE c LENGTH 5,
          lv_fecha       TYPE datum.

    CLEAR: zbp_cds_c_recdte_cab=>gs_res_oc,
           zbp_cds_c_recdte_cab=>gs_req_contab_fact,
           zbp_cds_c_recdte_cab=>gs_res_contab_fact,
           zbp_cds_c_recdte_cab=>gs_log,
           lv_json_req,
           lv_user,
           lv_pass,
           lv_method,
           lv_token,
           lv_cookie,
           lt_suplrinvcitempur,
           lt_supplierinvoicei,
           lt_item,
           lv_number,
           lv_status_code,
           ls_item,
           ls_to_SuplrInvcItemPurOrdRef.

    DATA(lo_api) = NEW zcl_api_consumption( ).
    " Comentar la siguiente línea porque NEW ya crea el objeto
    " CREATE OBJECT lo_api.

    zbp_cds_c_recdte_cab=>gv_accion = 'OC'.

    " Leer la entidad para obtener la OC asociada que se debe consultar
    READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
    ENTITY MonitorDte
    FIELDS ( IdDTE )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_monitorDTE).

    READ TABLE lt_monitordte INTO DATA(ls_monitor_dte) INDEX 1."WITH KEY NroDocMaterial = space.
    IF ls_monitor_dte-NroDocMaterial NE space.
      LOOP AT lt_monitordte INTO ls_monitor_dte.
        DATA(ls_key) = keys[ IdDTE = ls_monitor_dte-IdDTE ].
        IF sy-subrc = 0.
          " Reportar error para instancias no encontradas
          INSERT VALUE #( %tky = ls_key-%tky
                          %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text     = |Registro Facturado: { ls_key-iddte }, Fact. { ls_monitor_dte-NroDocMaterial }| ) ) INTO TABLE reported-monitordte.
        ENDIF.
      ENDLOOP.
    ELSEIF ls_monitor_dte-NroDocContable NE space.
      LOOP AT lt_monitordte INTO ls_monitor_dte.
        ls_key = keys[ IdDTE = ls_monitor_dte-IdDTE ].
        IF sy-subrc = 0.
          " Reportar error para instancias no encontradas
          INSERT VALUE #( %tky = ls_key-%tky
                          %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text     = |Registro Contabilizado: { ls_key-iddte }, Doc.Contable { ls_monitor_dte-NroDocContable }| ) ) INTO TABLE reported-monitordte.
        ENDIF.
      ENDLOOP.
    ELSEIF ls_monitor_dte-reglasOkStatus NE '3'.
      LOOP AT lt_monitordte INTO ls_monitor_dte.
        ls_key = keys[ IdDTE = ls_monitor_dte-IdDTE ].
        IF sy-subrc = 0.
          " Reportar error para instancias no encontradas
          INSERT VALUE #( %tky = ls_key-%tky
                          %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text     = |Registro: { ls_key-iddte }, no habilitado para contabilización| ) ) INTO TABLE reported-monitordte.
        ENDIF.
      ENDLOOP.

    ELSE.

      LOOP AT lt_monitordte INTO ls_monitor_dte.

        " Obtener los datos de la conexión de consulta
        SELECT SINGLE Idend,
                      Endpoint,
                      Zzuser     AS Usuario,
                      Zzpassword AS Password,
                      Zzmethod   AS Method
            FROM zcds_i_apis
            WHERE Idend EQ '1'
            INTO @DATA(ls_param).


        IF sy-subrc EQ 0.

          " Obtener OC asociada a las referencias
          READ TABLE zbp_cds_c_recdte_cab=>gt_referencias INTO DATA(ls_refdte) WITH KEY CodTipoDocRef = '801'
                                                                                        IdDTE         = ls_monitor_dte-IdDTE.

          IF sy-subrc EQ 0.

            " Obtener los datos de la OC
            lv_user   = ls_param-Usuario.
            lv_pass   = ls_param-Password.
            lv_method = ls_param-Method.
            lv_url    = |{ ls_param-Endpoint }('{ ls_refdte-Folio }')?$expand=_PurchaseOrderItem,_PurchaseOrderNote,_PurchaseOrderPartner,_SupplierAddress|.

            TRY.

                " Consultar datos de la OC
                lo_api->call_external_api( EXPORTING
                                            iv_url            = lv_url
                                            iv_user           = lv_user
                                            iv_pass           = lv_pass
                                            iv_method         = lv_method
                                           IMPORTING
                                            ev_response_text  = lv_resp
                                            ev_code           = lv_status_code  ).

                /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                           CHANGING  data = zbp_cds_c_recdte_cab=>gs_res_oc ).

                "Realizar contabilizacion
                IF zbp_cds_c_recdte_cab=>gs_res_oc IS NOT INITIAL.

                  CLEAR: ls_param, lv_url, lv_user, lv_pass, lv_method, lv_fecha.

                  " Obtener los datos de la conexión de contabilizacion
                  SELECT SINGLE Idend,
                                Endpoint,
                                Zzuser     AS Usuario,
                                Zzpassword AS Password,
                                Zzmethod   AS method
                    FROM zcds_i_apis
                     WHERE Idend EQ '2'
                      INTO @ls_param.
                  IF sy-subrc EQ 0.

                    lv_url    = ls_param-Endpoint.
                    lv_user   = ls_param-Usuario.
                    lv_pass   = ls_param-Password.
                    lv_method = ls_param-Method.

                    lv_fecha = keys[ 1 ]-%param-fchcontab.

                    "Obtener parametrizaciones
                    SELECT SINGLE blart, indimp FROM zcds_c__eqsii
                     WHERE docsii EQ @ls_monitor_dte-TipoDte
                    INTO @DATA(ls_cont).
                    IF sy-subrc EQ 0.

                      " Mapeo de la estructura de contabilizacion
                      " Cabecera
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-companycode                   = zbp_cds_c_recdte_cab=>gs_res_oc-companycode.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-documentdate                  = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }T00:00:00|.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-postingdate                   = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }T00:00:00|.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicingparty                = zbp_cds_c_recdte_cab=>gs_res_oc-supplier.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-supplierinvoiceidbyinvcgparty = zbp_cds_c_recdte_cab=>gs_res_oc-purchaseorder.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-accountingdocumenttype        = ls_cont-blart.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-documentcurrency              = zbp_cds_c_recdte_cab=>gs_res_oc-documentcurrency.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount            = zbp_cds_c_recdte_cab=>gt_cabecera[ 1 ]-MontoTotal.

*                    SPLIT zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount AT '.' INTO DATA(lv_entero)
*                                                                                                  DATA(lv_decimal).
*
*                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount = |{ lv_entero }.000|.
*                    CONDENSE zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount NO-GAPS.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-documentheadertext            = ''.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-paymentterms                  = zbp_cds_c_recdte_cab=>gs_res_oc-paymentterms.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-supplierinvoicestatus         = 'D'.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-taxiscalculatedautomatically  = 'true'.
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-taxdeterminationdate          = |{ zbp_cds_c_recdte_cab=>gs_res_oc-purchaseorderdate }T00:00:00|.

                      lt_item = zbp_cds_c_recdte_cab=>gs_res_oc-_purchaseorderitem.

                      LOOP AT lt_item INTO ls_item.

                        CLEAR: lt_result1, lt_result2, lt_supplierinvoicei, lt_suplrinvcitempur, ls_res_supp, ls_to_supplierinvoiceitmacct.

                        lv_number = lv_number + 1.

                        lv_item_c = ls_item-purchaseorderitem.
                        lv_item_c = |{ lv_item_c ALPHA = IN }|.

                        APPEND VALUE #( SupplierInvoiceItem           = lv_number
                                        DocumentCurrency              = zbp_cds_c_recdte_cab=>gs_res_oc-documentcurrency
                                        Quantity                      = ls_item-orderquantity
                                        purchaseorderquantityunit     = ls_item-purchaseorderquantityunit
                                        SuplrInvcAcctAssignmentAmount = ls_item-netpriceamount
                                        TaxCode                       = ls_cont-indimp
                                        AccountAssignmentNumber       = '01'
                                        CostCenter                    = ls_item-purordaccountassignment-costcenter
                                        GLAccount                     = ls_item-purordaccountassignment-glaccount ) TO lt_supplierinvoicei.

                        " Corregir la referencia del array
                        ls_to_supplierinvoiceitmacct-results = lt_supplierinvoicei[].

                        APPEND VALUE #( supplierinvoiceitem            = lv_number
                                        purchaseorder                  = zbp_cds_c_recdte_cab=>gs_res_oc-purchaseorder
                                        purchaseorderitem              = lv_item_c
                                        taxcode                        = ls_cont-indimp
                                        documentcurrency               = zbp_cds_c_recdte_cab=>gs_res_oc-documentcurrency
                                        supplierinvoiceitemamount      = ls_item-netpriceamount
                                        isfinallyinvoiced              = 'true'
                                        to_supplierinvoiceitmacctassgm = ls_to_supplierinvoiceitmacct ) TO lt_suplrinvcitempur.

                      ENDLOOP.

                      " Mover la asignación fuera del LOOP
                      ls_to_SuplrInvcItemPurOrdRef-results = lt_suplrinvcitempur[].
                      zbp_cds_c_recdte_cab=>gs_req_contab_fact-to_suplrinvcitempurordref = ls_to_SuplrInvcItemPurOrdRef.

                      " Serializa el JSON de consulta
                      lv_json_req = /ui2/cl_json=>serialize( data        = zbp_cds_c_recdte_cab=>gs_req_contab_fact
                                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

                      " PascalCase JSON transformations
                      REPLACE ALL OCCURRENCES OF 'companycode'                    IN lv_json_req WITH 'CompanyCode'.
                      REPLACE ALL OCCURRENCES OF 'documentdate'                   IN lv_json_req WITH 'DocumentDate'.
                      REPLACE ALL OCCURRENCES OF 'postingdate'                    IN lv_json_req WITH 'PostingDate'.
                      REPLACE ALL OCCURRENCES OF 'invoicingparty'                 IN lv_json_req WITH 'InvoicingParty'.
                      REPLACE ALL OCCURRENCES OF 'supplierinvoiceidbyinvcgparty'  IN lv_json_req WITH 'SupplierInvoiceIDByInvcgParty'.
                      REPLACE ALL OCCURRENCES OF 'accountingdocumenttype'         IN lv_json_req WITH 'AccountingDocumentType'.
                      REPLACE ALL OCCURRENCES OF 'documentcurrency'               IN lv_json_req WITH 'DocumentCurrency'.
                      REPLACE ALL OCCURRENCES OF 'invoicegrossamount'             IN lv_json_req WITH 'InvoiceGrossAmount'.
                      REPLACE ALL OCCURRENCES OF 'documentheadertext'             IN lv_json_req WITH 'DocumentHeaderText'.
                      REPLACE ALL OCCURRENCES OF 'paymentterms'                   IN lv_json_req WITH 'PaymentTerms'.
                      REPLACE ALL OCCURRENCES OF 'supplierinvoicestatus'          IN lv_json_req WITH 'SupplierInvoiceStatus'.
                      REPLACE ALL OCCURRENCES OF 'taxiscalculatedautomatically'   IN lv_json_req WITH 'TaxIsCalculatedAutomatically'.
                      REPLACE ALL OCCURRENCES OF 'taxdeterminationdate'           IN lv_json_req WITH 'TaxDeterminationDate'.
                      REPLACE ALL OCCURRENCES OF 'supplierinvoiceitem'            IN lv_json_req WITH 'SupplierInvoiceItem'.
                      REPLACE ALL OCCURRENCES OF 'purchaseorder'                  IN lv_json_req WITH 'PurchaseOrder'.
                      REPLACE ALL OCCURRENCES OF 'PurchaseOrderitem'              IN lv_json_req WITH 'PurchaseOrderItem'.
                      REPLACE ALL OCCURRENCES OF 'taxcode'                        IN lv_json_req WITH 'TaxCode'.
                      REPLACE ALL OCCURRENCES OF 'SupplierInvoiceItemamount'      IN lv_json_req WITH 'SupplierInvoiceItemAmount'.
                      REPLACE ALL OCCURRENCES OF 'isfinallyinvoiced'              IN lv_json_req WITH 'IsFinallyInvoiced'.
                      REPLACE ALL OCCURRENCES OF 'quantity'                       IN lv_json_req WITH 'Quantity'.
                      REPLACE ALL OCCURRENCES OF 'PurchaseOrderQuantityunit'      IN lv_json_req WITH 'PurchaseOrderQuantityUnit'.
                      REPLACE ALL OCCURRENCES OF 'suplrinvcacctassignmentamount'  IN lv_json_req WITH 'SuplrInvcAcctAssignmentAmount'.
                      REPLACE ALL OCCURRENCES OF 'accountassignmentnumber'        IN lv_json_req WITH 'AccountAssignmentNumber'.
                      REPLACE ALL OCCURRENCES OF 'costcenter'                     IN lv_json_req WITH 'CostCenter'.
                      REPLACE ALL OCCURRENCES OF 'glaccount'                      IN lv_json_req WITH 'GLAccount'.
                      REPLACE ALL OCCURRENCES OF 'toSupplierinvoiceitmacctassgm'  IN lv_json_req WITH 'to_SupplierInvoiceItmAcctAssgmt'.
                      REPLACE ALL OCCURRENCES OF 'toSuplrinvcitempurordref'       IN lv_json_req WITH 'to_SuplrInvcItemPurOrdRef'.
                      REPLACE ALL OCCURRENCES OF '"true"' IN lv_json_req WITH 'true'.

                      " Contabilizar datos de la OC
                      lo_api->call_external_api( EXPORTING
                                                    iv_url            = lv_url
                                                    iv_user           = lv_user
                                                    iv_pass           = lv_pass
                                                    iv_method         = lv_method
                                                    iv_request_body   = lv_json_req
                                                    iv_token          = abap_true
                                                 IMPORTING
                                                    ev_response_text  = lv_resp
                                                    ev_code           = lv_status_code  ).

                      /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                                 CHANGING  data = zbp_cds_c_recdte_cab=>gs_res_contab_fact ).

                      IF lv_status_code EQ '200' OR lv_status_code EQ '201'.
                        IF zbp_cds_c_recdte_cab=>gs_res_contab_fact-d NE space. " Factura contabilizada

                          zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte   = keys[ 1 ]-IdDTE.
                          zbp_cds_c_recdte_cab=>gs_factura_fb60-factura = zbp_cds_c_recdte_cab=>gs_res_contab_fact-d-supplierinvoice.
                          zbp_cds_c_recdte_cab=>gs_factura_fb60-anio    = zbp_cds_c_recdte_cab=>gs_res_contab_fact-d-fiscalyear.
                          zbp_cds_c_recdte_cab=>gs_factura_fb60-status  = '03'.

                          CALL METHOD zbp_cds_c_recdte_cab=>set_log
                            EXPORTING
                              iddte_sap = keys[ 1 ]-IdDTE
                              mensaje   = |Exito: Se ha generado la contabilizacion { zbp_cds_c_recdte_cab=>gs_factura_fb60-factura } Año { zbp_cds_c_recdte_cab=>gs_factura_fb60-anio }|
                              tipo      = 'S'.

                        ELSE. " Factura NO contabilizada

                          zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte   = keys[ 1 ]-IdDTE.
                          zbp_cds_c_recdte_cab=>gs_factura_fb60-status  = '01'.

                          CALL METHOD zbp_cds_c_recdte_cab=>set_log
                            EXPORTING
                              iddte_sap = keys[ 1 ]-IdDTE
                              mensaje   = |Error: { lv_resp }|
                              tipo      = 'E'.

                        ENDIF.
                      ELSE.

                        /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                                   CHANGING  data = zbp_cds_c_recdte_cab=>gs_error ).

                        CALL METHOD zbp_cds_c_recdte_cab=>set_log
                          EXPORTING
                            iddte_sap = keys[ 1 ]-IdDTE
                            mensaje   = |Error: { zbp_cds_c_recdte_cab=>gs_error-error-message-value }|
                            tipo      = 'E'.

                      ENDIF.
                    ELSE.
                      " Agregar manejo cuando no se encuentra la parametrización
                      CALL METHOD zbp_cds_c_recdte_cab=>set_log
                        EXPORTING
                          iddte_sap = keys[ 1 ]-IdDTE
                          mensaje   = 'Error: No se encontró parametrización para el tipo de documento'
                          tipo      = 'E'.

                    ENDIF.

                  ELSE.

                    CALL METHOD zbp_cds_c_recdte_cab=>set_log
                      EXPORTING
                        iddte_sap = keys[ 1 ]-IdDTE
                        mensaje   = 'Error: Debe configurar mantenedor de Apis para realizar contabilización'
                        tipo      = 'E'.

                  ENDIF.

                ELSE.

                  CALL METHOD zbp_cds_c_recdte_cab=>set_log
                    EXPORTING
                      iddte_sap = keys[ 1 ]-IdDTE
                      mensaje   = 'Error: No se ha logrado obtener orden de compra'
                      tipo      = 'E'.

                ENDIF.

              CATCH cx_web_http_client_error cx_http_dest_provider_error.
                " Agregar manejo más específico del error
                CALL METHOD zbp_cds_c_recdte_cab=>set_log
                  EXPORTING
                    iddte_sap = keys[ 1 ]-IdDTE
                    mensaje   = 'Error: Excepción al llamar la API externa'
                    tipo      = 'E'.

            ENDTRY.

          ELSE.

            CALL METHOD zbp_cds_c_recdte_cab=>set_log
              EXPORTING
                iddte_sap = keys[ 1 ]-IdDTE
                mensaje   = 'Error: No se ha encontrado posición con referencia 801'
                tipo      = 'E'.

          ENDIF.
        ELSE.

          CALL METHOD zbp_cds_c_recdte_cab=>set_log
            EXPORTING
              iddte_sap = keys[ 1 ]-IdDTE
              mensaje   = 'Error: Debe configurar mantenedor de Apis para obtener orden de compras'
              tipo      = 'E'.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD rechazar.
  ENDMETHOD.

  METHOD contabilizar.
    DATA: lt_suplrinvcitempur TYPE TABLE OF zes_suplrinvcitempurordref,
          lt_supplierinvoicei TYPE TABLE OF zes_supplierinvoiceitmacctassg,
          lt_result1          TYPE TABLE OF zes_result_to_suplrinvcitempur,
          lt_result2          TYPE TABLE OF zes_result_to_supplierinvoicei,
          lt_item             TYPE ztt_purchaseorderitem.

    DATA: ls_to_SuplrInvcItemPurOrdRef TYPE zes_result_to_suplrinvcitempur,
          ls_to_supplierinvoiceitmacct TYPE zes_result_to_supplierinvoicei,
          ls_item                      LIKE LINE OF lt_item,
          ls_res_supp                  TYPE zes_result_to_suplrinvcitempur.

    DATA: lv_url         TYPE string,
          lv_json_req    TYPE string,
          lv_user        TYPE string,
          lv_pass        TYPE string,
          lv_method      TYPE string,
          lv_token       TYPE string,
          lv_resp        TYPE string,
          lv_status_code TYPE string,
          lv_cookie      TYPE string,
          lv_number      TYPE n LENGTH 6,
          lv_item_c      TYPE c LENGTH 5,
          lv_fecha       TYPE datum.

    CLEAR: zbp_cds_c_recdte_cab=>gs_res_oc,
           zbp_cds_c_recdte_cab=>gs_req_contab_fact,
           zbp_cds_c_recdte_cab=>gs_res_contab_fact,
           zbp_cds_c_recdte_cab=>gs_log,
           lv_json_req,
           lv_user,
           lv_pass,
           lv_method,
           lv_token,
           lv_cookie,
           lt_suplrinvcitempur,
           lt_supplierinvoicei,
           lt_item,
           lv_number,
           lv_status_code,
           ls_item,
           ls_to_SuplrInvcItemPurOrdRef.

    DATA(lo_api) = NEW zcl_api_consumption( ).
    " Comentar la siguiente línea porque NEW ya crea el objeto
    " CREATE OBJECT lo_api.

    zbp_cds_c_recdte_cab=>gv_accion = 'OC'.

    " Leer la entidad para obtener la OC asociada que se debe consultar
    READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
      ENTITY MonitorDte
        FIELDS ( IdDTE )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitorDTE).

    LOOP AT lt_monitordte INTO DATA(ls_monitor_dte).

      " Obtener los datos de la conexión de consulta
      SELECT SINGLE Idend,
                    Endpoint,
                    Zzuser     AS Usuario,
                    Zzpassword AS Password,
                    Zzmethod   AS Method
          FROM zcds_i_apis
          WHERE Idend EQ '1'
          INTO @DATA(ls_param).

      IF sy-subrc EQ 0.

        " Obtener OC asociada a las referencias
        READ TABLE zbp_cds_c_recdte_cab=>gt_referencias INTO DATA(ls_refdte) WITH KEY CodTipoDocRef = '801'
                                                                                      IdDTE         = ls_monitor_dte-IdDTE.
        IF sy-subrc EQ 0.

          " Obtener los datos de la OC
          lv_user   = ls_param-Usuario.
          lv_pass   = ls_param-Password.
          lv_method = ls_param-Method.
          lv_url    = |{ ls_param-Endpoint }('{ ls_refdte-Folio }')?$expand=_PurchaseOrderItem,_PurchaseOrderNote,_PurchaseOrderPartner,_SupplierAddress|.

          TRY.

              " Consultar datos de la OC
              lo_api->call_external_api( EXPORTING
                                          iv_url            = lv_url
                                          iv_user           = lv_user
                                          iv_pass           = lv_pass
                                          iv_method         = lv_method
                                         IMPORTING
                                          ev_response_text  = lv_resp
                                          ev_code           = lv_status_code  ).

              /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                         CHANGING  data = zbp_cds_c_recdte_cab=>gs_res_oc ).

              "Realizar contabilizacion
              IF zbp_cds_c_recdte_cab=>gs_res_oc IS NOT INITIAL.

                CLEAR: ls_param, lv_url, lv_user, lv_pass, lv_method, lv_fecha.

                " Obtener los datos de la conexión de contabilizacion
                SELECT SINGLE Idend,
                              Endpoint,
                              Zzuser     AS Usuario,
                              Zzpassword AS Password,
                              Zzmethod   AS Method
                  FROM zcds_i_apis
                 WHERE Idend EQ '2'"Contabilizar OC
                    INTO @ls_param.
                IF sy-subrc EQ 0.

                  lv_url    = ls_param-Endpoint.
                  lv_user   = ls_param-Usuario.
                  lv_pass   = ls_param-Password.
                  lv_method = ls_param-Method.

                  lv_fecha = cl_abap_context_info=>get_system_date( ).

                  "Obtener parametrizaciones
                  SELECT SINGLE blart, indimp FROM zcds_c__eqsii
                   WHERE docsii EQ @ls_monitor_dte-TipoDte
                  INTO @DATA(ls_cont).
                  IF sy-subrc NE 0.

                    " Mapeo de la estructura de contabilizacion
                    " Cabecera
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-companycode                   = zbp_cds_c_recdte_cab=>gs_res_oc-companycode.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-documentdate                  = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }T00:00:00|.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-postingdate                   = |{ lv_fecha+0(4) }-{ lv_fecha+4(2) }-{ lv_fecha+6(2) }T00:00:00|.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicingparty                = zbp_cds_c_recdte_cab=>gs_res_oc-supplier.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-supplierinvoiceidbyinvcgparty = zbp_cds_c_recdte_cab=>gs_res_oc-purchaseorder.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-accountingdocumenttype        = ls_cont-blart.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-documentcurrency              = zbp_cds_c_recdte_cab=>gs_res_oc-documentcurrency.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount            = zbp_cds_c_recdte_cab=>gt_cabecera[ 1 ]-MontoTotal.

                    SPLIT zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount AT '.' INTO DATA(lv_entero)
                                                                                                  DATA(lv_decimal).

                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount = |{ lv_entero }.000|.
                    CONDENSE zbp_cds_c_recdte_cab=>gs_req_contab_fact-invoicegrossamount NO-GAPS.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-documentheadertext            = ''.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-paymentterms                  = zbp_cds_c_recdte_cab=>gs_res_oc-paymentterms.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-supplierinvoicestatus         = 'D'.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-taxiscalculatedautomatically  = 'true'.
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-taxdeterminationdate          = |{ zbp_cds_c_recdte_cab=>gs_res_oc-purchaseorderdate }T00:00:00|.

                    lt_item = zbp_cds_c_recdte_cab=>gs_res_oc-_purchaseorderitem.

                    LOOP AT lt_item INTO ls_item.

                      CLEAR: lt_result1, lt_result2, lt_supplierinvoicei, lt_suplrinvcitempur, ls_res_supp, ls_to_supplierinvoiceitmacct.

                      lv_number = lv_number + 1.

                      lv_item_c = ls_item-purchaseorderitem.
                      lv_item_c = |{ lv_item_c ALPHA = IN }|.

                      APPEND VALUE #( SupplierInvoiceItem           = lv_number
                                      DocumentCurrency              = zbp_cds_c_recdte_cab=>gs_res_oc-documentcurrency
                                      Quantity                      = ls_item-orderquantity
                                      purchaseorderquantityunit     = ls_item-purchaseorderquantityunit
                                      SuplrInvcAcctAssignmentAmount = ls_item-netpriceamount
                                      TaxCode                       = ls_cont-indimp
                                      AccountAssignmentNumber       = '01'
                                      CostCenter                    = ls_item-purordaccountassignment-costcenter
                                      GLAccount                     = ls_item-purordaccountassignment-glaccount ) TO lt_supplierinvoicei.

                      " Corregir la referencia del array
                      ls_to_supplierinvoiceitmacct-results = lt_supplierinvoicei[].

                      APPEND VALUE #( supplierinvoiceitem            = lv_number
                                      purchaseorder                  = zbp_cds_c_recdte_cab=>gs_res_oc-purchaseorder
                                      purchaseorderitem              = lv_item_c
                                      taxcode                        = ls_cont-indimp
                                      documentcurrency               = zbp_cds_c_recdte_cab=>gs_res_oc-documentcurrency
                                      supplierinvoiceitemamount      = ls_item-netpriceamount
                                      isfinallyinvoiced              = 'true'
                                      to_supplierinvoiceitmacctassgm = ls_to_supplierinvoiceitmacct ) TO lt_suplrinvcitempur.

                    ENDLOOP.

                    " Mover la asignación fuera del LOOP
                    ls_to_SuplrInvcItemPurOrdRef-results = lt_suplrinvcitempur[].
                    zbp_cds_c_recdte_cab=>gs_req_contab_fact-to_suplrinvcitempurordref = ls_to_SuplrInvcItemPurOrdRef.

                    " Serializa el JSON de consulta
                    lv_json_req = /ui2/cl_json=>serialize( data        = zbp_cds_c_recdte_cab=>gs_req_contab_fact
                                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

                    " PascalCase JSON transformations
                    REPLACE ALL OCCURRENCES OF 'companycode'                    IN lv_json_req WITH 'CompanyCode'.
                    REPLACE ALL OCCURRENCES OF 'documentdate'                   IN lv_json_req WITH 'DocumentDate'.
                    REPLACE ALL OCCURRENCES OF 'postingdate'                    IN lv_json_req WITH 'PostingDate'.
                    REPLACE ALL OCCURRENCES OF 'invoicingparty'                 IN lv_json_req WITH 'InvoicingParty'.
                    REPLACE ALL OCCURRENCES OF 'supplierinvoiceidbyinvcgparty'  IN lv_json_req WITH 'SupplierInvoiceIDByInvcgParty'.
                    REPLACE ALL OCCURRENCES OF 'accountingdocumenttype'         IN lv_json_req WITH 'AccountingDocumentType'.
                    REPLACE ALL OCCURRENCES OF 'documentcurrency'               IN lv_json_req WITH 'DocumentCurrency'.
                    REPLACE ALL OCCURRENCES OF 'invoicegrossamount'             IN lv_json_req WITH 'InvoiceGrossAmount'.
                    REPLACE ALL OCCURRENCES OF 'documentheadertext'             IN lv_json_req WITH 'DocumentHeaderText'.
                    REPLACE ALL OCCURRENCES OF 'paymentterms'                   IN lv_json_req WITH 'PaymentTerms'.
                    REPLACE ALL OCCURRENCES OF 'supplierinvoicestatus'          IN lv_json_req WITH 'SupplierInvoiceStatus'.
                    REPLACE ALL OCCURRENCES OF 'taxiscalculatedautomatically'   IN lv_json_req WITH 'TaxIsCalculatedAutomatically'.
                    REPLACE ALL OCCURRENCES OF 'taxdeterminationdate'           IN lv_json_req WITH 'TaxDeterminationDate'.
                    REPLACE ALL OCCURRENCES OF 'supplierinvoiceitem'            IN lv_json_req WITH 'SupplierInvoiceItem'.
                    REPLACE ALL OCCURRENCES OF 'purchaseorder'                  IN lv_json_req WITH 'PurchaseOrder'.
                    REPLACE ALL OCCURRENCES OF 'PurchaseOrderitem'              IN lv_json_req WITH 'PurchaseOrderItem'.
                    REPLACE ALL OCCURRENCES OF 'taxcode'                        IN lv_json_req WITH 'TaxCode'.
                    REPLACE ALL OCCURRENCES OF 'SupplierInvoiceItemamount'      IN lv_json_req WITH 'SupplierInvoiceItemAmount'.
                    REPLACE ALL OCCURRENCES OF 'isfinallyinvoiced'              IN lv_json_req WITH 'IsFinallyInvoiced'.
                    REPLACE ALL OCCURRENCES OF 'quantity'                       IN lv_json_req WITH 'Quantity'.
                    REPLACE ALL OCCURRENCES OF 'PurchaseOrderQuantityunit'      IN lv_json_req WITH 'PurchaseOrderQuantityUnit'.
                    REPLACE ALL OCCURRENCES OF 'suplrinvcacctassignmentamount'  IN lv_json_req WITH 'SuplrInvcAcctAssignmentAmount'.
                    REPLACE ALL OCCURRENCES OF 'accountassignmentnumber'        IN lv_json_req WITH 'AccountAssignmentNumber'.
                    REPLACE ALL OCCURRENCES OF 'costcenter'                     IN lv_json_req WITH 'CostCenter'.
                    REPLACE ALL OCCURRENCES OF 'glaccount'                      IN lv_json_req WITH 'GLAccount'.
                    REPLACE ALL OCCURRENCES OF 'toSupplierinvoiceitmacctassgm'  IN lv_json_req WITH 'to_SupplierInvoiceItmAcctAssgmt'.
                    REPLACE ALL OCCURRENCES OF 'toSuplrinvcitempurordref'       IN lv_json_req WITH 'to_SuplrInvcItemPurOrdRef'.
                    REPLACE ALL OCCURRENCES OF '"true"' IN lv_json_req WITH 'true'.

                    " Contabilizar datos de la OC
                    lo_api->call_external_api( EXPORTING
                                                  iv_url            = lv_url
                                                  iv_user           = lv_user
                                                  iv_pass           = lv_pass
                                                  iv_method         = lv_method
                                                  iv_request_body   = lv_json_req
                                                  iv_token          = abap_true
                                               IMPORTING
                                                  ev_response_text  = lv_resp
                                                  ev_code           = lv_status_code  ).

                    /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                               CHANGING  data = zbp_cds_c_recdte_cab=>gs_res_contab_fact ).

                    IF lv_status_code EQ '200' OR lv_status_code EQ '201'.
                      IF zbp_cds_c_recdte_cab=>gs_res_contab_fact-d NE space. " Factura contabilizada

                        zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte   = keys[ 1 ]-IdDTE.
                        zbp_cds_c_recdte_cab=>gs_factura_fb60-factura = zbp_cds_c_recdte_cab=>gs_res_contab_fact-d-supplierinvoice.
                        zbp_cds_c_recdte_cab=>gs_factura_fb60-anio    = zbp_cds_c_recdte_cab=>gs_res_contab_fact-d-fiscalyear.
                        zbp_cds_c_recdte_cab=>gs_factura_fb60-status  = '03'.

                        CALL METHOD zbp_cds_c_recdte_cab=>set_log
                          EXPORTING
                            iddte_sap = keys[ 1 ]-IdDTE
                            mensaje   = |Exito: Se ha generado la contabilizacion { zbp_cds_c_recdte_cab=>gs_factura_fb60-factura } Año { zbp_cds_c_recdte_cab=>gs_factura_fb60-anio }|
                            tipo      = 'S'.

                        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                                text     = |Exito: Se ha generado la contabilizacion { zbp_cds_c_recdte_cab=>gs_factura_fb60-factura } Año { zbp_cds_c_recdte_cab=>gs_factura_fb60-anio }| ) ) TO reported-monitordte.

                      ELSE. " Factura NO contabilizada

                        zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte   = keys[ 1 ]-IdDTE.
                        zbp_cds_c_recdte_cab=>gs_factura_fb60-status  = '01'.

                        CALL METHOD zbp_cds_c_recdte_cab=>set_log
                          EXPORTING
                            iddte_sap = keys[ 1 ]-IdDTE
                            mensaje   = |Error: { lv_resp }|
                            tipo      = 'E'.

                        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                                text     = |Error: { lv_resp }| ) ) TO reported-monitordte.

                      ENDIF.
                    ELSE.

                      /ui2/cl_json=>deserialize( EXPORTING json = lv_resp
                                                 CHANGING  data = zbp_cds_c_recdte_cab=>gs_error ).

                      CALL METHOD zbp_cds_c_recdte_cab=>set_log
                        EXPORTING
                          iddte_sap = keys[ 1 ]-IdDTE
                          mensaje   = |Error: { zbp_cds_c_recdte_cab=>gs_error-error-message-value }|
                          tipo      = 'E'.

                      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                              text     = |Error: { zbp_cds_c_recdte_cab=>gs_error-error-message-value }| ) ) TO reported-monitordte.

                    ENDIF.
                  ELSE.
                    " Agregar manejo cuando no se encuentra la parametrización
                    CALL METHOD zbp_cds_c_recdte_cab=>set_log
                      EXPORTING
                        iddte_sap = keys[ 1 ]-IdDTE
                        mensaje   = 'Error: No se encontró parametrización para el tipo de documento'
                        tipo      = 'E'.

                    APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                            text     = 'Error: No se encontró parametrización para el tipo de documento' ) ) TO reported-monitordte.

                  ENDIF.

                ELSE.

                  CALL METHOD zbp_cds_c_recdte_cab=>set_log
                    EXPORTING
                      iddte_sap = keys[ 1 ]-IdDTE
                      mensaje   = 'Error: Debe configurar mantenedor de Apis para realizar contabilización'
                      tipo      = 'E'.

                  APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                          text     = 'Error: Debe configurar mantenedor de Apis para realizar contabilización' ) ) TO reported-monitordte.
                ENDIF.

              ELSE.

                CALL METHOD zbp_cds_c_recdte_cab=>set_log
                  EXPORTING
                    iddte_sap = keys[ 1 ]-IdDTE
                    mensaje   = 'Error: No se ha logrado obtener orden de compra'
                    tipo      = 'E'.

                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                              text     = 'Error: No se ha logrado obtener orden de compra' ) ) TO reported-monitordte.

              ENDIF.

            CATCH cx_web_http_client_error cx_http_dest_provider_error.
              " Agregar manejo más específico del error
              CALL METHOD zbp_cds_c_recdte_cab=>set_log
                EXPORTING
                  iddte_sap = keys[ 1 ]-IdDTE
                  mensaje   = 'Error: Excepción al llamar la API externa'
                  tipo      = 'E'.

              APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                      text     = 'Error: Excepción al llamar la API externa' ) ) TO reported-monitordte.

          ENDTRY.

        ELSE.

          CALL METHOD zbp_cds_c_recdte_cab=>set_log
            EXPORTING
              iddte_sap = keys[ 1 ]-IdDTE
              mensaje   = 'Error: No se ha encontrado posición con referencia 801'
              tipo      = 'E'.

          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                        text     = 'Error: No se ha encontrado posición con referencia 801' ) ) TO reported-monitordte.

        ENDIF.
      ELSE.

        CALL METHOD zbp_cds_c_recdte_cab=>set_log
          EXPORTING
            iddte_sap = keys[ 1 ]-IdDTE
            mensaje   = 'Error: Debe configurar mantenedor de Apis para obtener orden de compras'
            tipo      = 'E'.

        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                      text     = 'Error: Debe configurar mantenedor de Apis para obtener orden de compras' ) ) TO reported-monitordte.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD contabilizar_oc.

    DATA: lv_idddte     TYPE zclmm_tb_refdte-iddte_sap.

    CLEAR: zbp_cds_c_recdte_cab=>gs_referencia, lv_idddte.

    zbp_cds_c_recdte_cab=>gv_accion = 'REF'.

    lv_idddte = keys[ 1 ]-IdDTE.

    SELECT MAX( nrolinref )
     FROM zclmm_tb_refdte
      WHERE iddte_sap EQ @lv_idddte
        INTO @DATA(lv_linea).

    lv_linea = lv_linea + 1.

    zbp_cds_c_recdte_cab=>gs_referencia-iddte_sap = lv_idddte.
    zbp_cds_c_recdte_cab=>gs_referencia-nrolinref = lv_linea.
    zbp_cds_c_recdte_cab=>gs_referencia-tpodocref = '801'.
    zbp_cds_c_recdte_cab=>gs_referencia-folioref  = keys[ 1 ]-%param-folioref.
    zbp_cds_c_recdte_cab=>gs_referencia-fchref    = keys[ 1 ]-%param-fchref.

    CALL METHOD zbp_cds_c_recdte_cab=>set_log
      EXPORTING
        iddte_sap = lv_idddte
        mensaje   = |Éxito: Se ha ingresado referencia: { keys[ 1 ]-%param-fchref }|
        tipo      = 'S'.

  ENDMETHOD.

  METHOD rba_Detalle.
  ENDMETHOD.

  METHOD rba_Log.
  ENDMETHOD.

  METHOD rba_Referencias.
  ENDMETHOD.

  METHOD cba_Detalle.
  ENDMETHOD.

  METHOD cba_Log.
  ENDMETHOD.

  METHOD cba_Referencias.
  ENDMETHOD.

  METHOD GetDefaultsForReferencia.

    READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
      ENTITY MonitorDte
        FIELDS ( IdDTE )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitorDTE).

    LOOP AT zbp_cds_c_recdte_cab=>gt_cabecera INTO DATA(ls_cabecera).
      INSERT VALUE #( %tky = keys[ 1 ]-%tky ) INTO TABLE result REFERENCE INTO DATA(ls_new_line).

      ls_new_line->%param-proveedor = ls_cabecera-CodProveedor.
      ls_new_line->%param-fchref    = cl_abap_context_info=>get_system_date( ).

    ENDLOOP.

  ENDMETHOD.

  METHOD GetDefaultsForItem.

*    READ ENTITIES OF zcds_c_recdte_cab IN LOCAL MODE
*      ENTITY MonitorDte
*        FIELDS ( IdDTE )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_monitorDTE).
*
*    LOOP AT zbp_cds_c_recdte_cab=>gt_cabecera INTO DATA(ls_cabecera).
*     loop at zbp_cds_c_recdte_cab=>gt_detalle into data(ls_details) where IdDTE = ls_cabecera-IdDTE.
*      INSERT VALUE #( %tky = keys[ 1 ]-%tky ) INTO TABLE result REFERENCE INTO DATA(ls_new_line).
*
*      ls_new_line->%param-TaxCode = ls_cabecera-CodProveedor.
*      ls_new_line->%param-fchref    = cl_abap_context_info=>get_system_date( ).
*     ENDLOOP.
*   ENDLOOP.

  ENDMETHOD.

  METHOD GetDefaultsForMasiva.

    LOOP AT keys INTO DATA(key).
      INSERT VALUE #( %tky = key-%tky ) INTO TABLE result REFERENCE INTO DATA(new_line).

      new_line->%param-fchcontab = cl_abap_context_info=>get_system_date( ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCDS_C_RECDTE_CAB DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCDS_C_RECDTE_CAB IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    CASE zbp_cds_c_recdte_cab=>gv_accion.

      WHEN 'PDF'.  "Obtener PDF
        IF zbp_cds_c_recdte_cab=>gs_pdf IS NOT INITIAL.
          UPDATE zclmm_tb_cabdte SET urlpdf    = @zbp_cds_c_recdte_cab=>gs_pdf-pdf
                               WHERE iddte_sap = @zbp_cds_c_recdte_cab=>gs_pdf-iddte.
        ENDIF.

      WHEN 'OC'. "Contabilizar OC

        " Insertar Log
        IF zbp_cds_c_recdte_cab=>gt_log_proc IS NOT INITIAL.

          MODIFY zclmm_tb_logdte FROM TABLE @zbp_cds_c_recdte_cab=>gt_log_proc.

        ENDIF.

        " Modificar tablas en base a la contablizacion
        IF zbp_cds_c_recdte_cab=>gs_factura_fb60 IS NOT INITIAL.


          UPDATE zclmm_tb_procdte SET belnr       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-factura,
                                      belnc       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-belnc,
                                      gjahr       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-anio,
                                      blart       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-blart,
                                      status_cont = @zbp_cds_c_recdte_cab=>gs_factura_fb60-status
          WHERE iddte_sap = @zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte.


        ENDIF.

      WHEN 'SOC'.

        " Insertar Log
        IF zbp_cds_c_recdte_cab=>gs_log IS NOT INITIAL.

          MODIFY zclmm_tb_logdte FROM @zbp_cds_c_recdte_cab=>gs_log.

        ENDIF.

        " Modificar tablas en base a la contablizacion
        IF zbp_cds_c_recdte_cab=>gs_factura_fb60 IS NOT INITIAL.


          UPDATE zclmm_tb_procdte SET belnr       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-factura,
                                      belnc       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-belnc,
                                      gjahr       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-anio,
                                      blart       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-blart,
                                      status_cont = @zbp_cds_c_recdte_cab=>gs_factura_fb60-status
          WHERE iddte_sap = @zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte.


        ENDIF.

      WHEN 'REF'.

        IF zbp_cds_c_recdte_cab=>gs_referencia IS NOT INITIAL.
          INSERT zclmm_tb_refdte FROM @zbp_cds_c_recdte_cab=>gs_referencia.
        ENDIF.

      WHEN 'FB60'.
        IF zbp_cds_c_recdte_cab=>gt_log_proc IS NOT INITIAL.
          MODIFY zclmm_tb_logdte FROM TABLE @zbp_cds_c_recdte_cab=>gt_log_proc.
        ENDIF.

        " Modificar tablas en base a la contablizacion
        IF zbp_cds_c_recdte_cab=>gs_factura_fb60 IS NOT INITIAL.

          UPDATE zclmm_tb_procdte SET belnr       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-factura,
                                      belnc       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-belnc,
                                      gjahr       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-anio,
                                      blart       = @zbp_cds_c_recdte_cab=>gs_factura_fb60-blart,
                                      status_cont = @zbp_cds_c_recdte_cab=>gs_factura_fb60-status
          WHERE iddte_sap = @zbp_cds_c_recdte_cab=>gs_factura_fb60-iddte.

        ENDIF.
      WHEN 'UDET'." Actualizar detalles
        IF zbp_cds_c_recdte_cab=>gs_detalle_upd NE space.
          UPDATE zclmm_tb_detdte SET centrocosto = @zbp_cds_c_recdte_cab=>gs_detalle_upd-CentroCosto,
                                     cuentamayor = @zbp_cds_c_recdte_cab=>gs_detalle_upd-CuentaMayor
          WHERE iddte_sap = @zbp_cds_c_recdte_cab=>gs_detalle_upd-IdDTE
            AND nrolindet = @zbp_cds_c_recdte_cab=>gs_detalle_upd-NroLinea.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD cleanup.

    CLEAR: zbp_cds_c_recdte_cab=>gt_cabecera,
           zbp_cds_c_recdte_cab=>gt_detalle,
           zbp_cds_c_recdte_cab=>gt_referencias,
           zbp_cds_c_recdte_cab=>gt_impuestos,
           zbp_cds_c_recdte_cab=>gt_validacion,
           zbp_cds_c_recdte_cab=>gt_parametrizaciones,
           zbp_cds_c_recdte_cab=>gt_log,
           zbp_cds_c_recdte_cab=>gt_entradamercancia,
           zbp_cds_c_recdte_cab=>gt_factoring,
           zbp_cds_c_recdte_cab=>gt_log_proc.

    CLEAR: zbp_cds_c_recdte_cab=>gs_req_oc,
           zbp_cds_c_recdte_cab=>gs_res_oc,
           zbp_cds_c_recdte_cab=>gs_error_oc,
           zbp_cds_c_recdte_cab=>gs_req_contab_fact,
           zbp_cds_c_recdte_cab=>gs_res_contab_fact,
           zbp_cds_c_recdte_cab=>gs_factura_fb60,
           zbp_cds_c_recdte_cab=>gs_log.

    CLEAR: zbp_cds_c_recdte_cab=>gv_accion,
           zbp_cds_c_recdte_cab=>gv_iddte,
           zbp_cds_c_recdte_cab=>gv_msg,
           zbp_cds_c_recdte_cab=>gv_url,
           zbp_cds_c_recdte_cab=>gv_user,
           zbp_cds_c_recdte_cab=>gv_pass,
           zbp_cds_c_recdte_cab=>gv_update_url.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
