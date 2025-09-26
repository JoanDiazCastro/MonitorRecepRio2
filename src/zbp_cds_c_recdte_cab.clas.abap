CLASS zbp_cds_c_recdte_cab DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zcds_c_recdte_cab.

  PUBLIC SECTION.

    "Declaracion de types
    TYPES: BEGIN OF gty_contabilizar,
             tipodte     TYPE zcds_c_recdte_cab-tipodte,
             iddte       TYPE zclmm_ed_iddte_sap,
             psting_data TYPE budat,
             mwskz       TYPE mwskz,
             lifnr       TYPE lifnr,
           END OF gty_contabilizar,

           BEGIN OF gty_resp_contab,
             e_belnr TYPE belnr_d,
             e_gjahr TYPE gjahr,
             e_blart TYPE blart,
             e_belnc TYPE belnr_d,
           END OF gty_resp_contab,

           BEGIN OF gty_factura_ok,
             iddte   TYPE zclmm_tb_cabdte-iddte_sap,
             blart   TYPE blart,
             factura TYPE c LENGTH 10,
             belnc   TYPE c LENGTH 10,
             anio    TYPE c LENGTH 4,
             status  TYPE zclmm_tb_procdte-status_cont,
           END OF gty_factura_ok,

           BEGIN OF gty_pdf,
             iddte TYPE zclmm_tb_cabdte-iddte_sap,
             pdf   TYPE zclmm_tb_cabdte-urlpdf,
           END OF gty_pdf,

           BEGIN OF gty_log,
             iddte TYPE zclmm_ed_iddte_sap,
             tipo  TYPE msgty,
             error TYPE bapi_msg,
           END OF gty_log.

    "Tablas globales
    CLASS-DATA: gt_cabecera          TYPE TABLE OF zcds_c_recdte_cab,
                gt_detalle           TYPE TABLE OF zcds_c_recdte_det,
                gt_referencias       TYPE TABLE OF zcds_c_recdte_ref,
                gt_impuestos         TYPE TABLE OF zcds_c_recdte_impto,
                gt_validacion        TYPE TABLE OF zcds_c_checks_dte,
                gt_parametrizaciones TYPE TABLE OF zcds_c_parglob_dte,
                gt_log               TYPE TABLE OF zcds_c_recdte_log,
                gt_log_proc          TYPE TABLE OF zclmm_tb_logdte,
                gt_entradamercancia  TYPE TABLE OF zcds_c_recdte_ref_em,
                gt_factoring         TYPE TABLE OF zcds_c_recdte_factoring.

    " Estructuras globales
    CLASS-DATA: gs_req_oc          TYPE zes_get_purchaseorder,
                gs_res_oc          TYPE zes_resp_purchaseorder,
                gs_error_oc        TYPE zes_error_get_purchaseorder,
                gs_req_contab_fact TYPE zes_contabilizar_fact_prov,
                gs_res_contab_fact TYPE zes_contab_fact_prov_resp,
                gs_log             TYPE zclmm_tb_logdte,
                gs_factura_fb60    TYPE gty_factura_ok,
                gs_error           TYPE zes_api_error,
                gs_pdf             TYPE gty_pdf,
                gs_error_log       TYPE gty_log,
                gs_referencia      TYPE zclmm_tb_refdte,
                gs_req_contab_fb60 TYPE zes_journentrybulkcreatereque,
                gs_res_contab_fb60 TYPE zes_journalentrybulkresponse,
                gs_detalle_upd     TYPE zcds_c_recdte_det.

    "Variables globales
    CLASS-DATA: gv_accion     TYPE c LENGTH 4,
                gv_iddte      TYPE zclmm_tb_cabdte-iddte_sap,
                gv_msg        TYPE string,
                gv_url        TYPE string,
                gv_user       TYPE string,
                gv_pass       TYPE string,
                gv_update_url TYPE abap_bool.

    " Metodos globales
    CLASS-METHODS set_log
      IMPORTING
        iddte_sap TYPE zclmm_ed_iddte_sap
        tipo      TYPE msgty
        mensaje   TYPE bapi_msg.

    CLASS-METHODS change_json
      CHANGING cv_json TYPE string.

    CLASS-METHODS read_tvarv
      IMPORTING iv_campo        TYPE string
      RETURNING VALUE(ev_valor) TYPE string.

ENDCLASS.



CLASS zbp_cds_c_recdte_cab IMPLEMENTATION.


  METHOD read_tvarv.

    SELECT SINGLE value
     FROM zclmm_tb_tvarvc
      WHERE name EQ @iv_campo
    INTO @ev_valor.

  ENDMETHOD.


  METHOD set_log.

    SELECT MAX( correlativo )
        FROM zclmm_tb_logdte
        WHERE iddte_sap EQ @iddte_sap
        INTO @DATA(lv_correlativo).

    lv_correlativo = lv_correlativo + 1.

    gs_log-iddte_sap   = iddte_sap.
    gs_log-correlativo = lv_correlativo.
    gs_log-fecha       = cl_abap_context_info=>get_system_date( ).
    gs_log-hora        = cl_abap_context_info=>get_system_time( ).
    gs_log-uname       = sy-uname.
    gs_log-tipo        = tipo.
    gs_log-mensaje     = mensaje.

    APPEND gs_log TO zbp_cds_c_recdte_cab=>gt_log_proc.

  ENDMETHOD.


  METHOD change_json.

    CASE zbp_cds_c_recdte_cab=>gv_accion.
      WHEN 'OC'.

      WHEN 'FB60'.
        REPLACE ALL OCCURRENCES OF 'journalentrybulkcreaterequest'  IN cv_json WITH 'JournalEntryBulkCreateRequest'.
        REPLACE ALL OCCURRENCES OF 'messageheader'                  IN cv_json WITH 'MessageHeader'.
        REPLACE ALL OCCURRENCES OF 'creationdatetime'               IN cv_json WITH 'CreationDateTime'.
        REPLACE ALL OCCURRENCES OF 'journalentrycreaterequest'      IN cv_json WITH 'JournalEntryCreateRequest'.
        REPLACE ALL OCCURRENCES OF 'journalentry'                   IN cv_json WITH 'JournalEntry'.
        REPLACE ALL OCCURRENCES OF 'originalreferencedocumenttype'  IN cv_json WITH 'OriginalReferenceDocumentType'.
        REPLACE ALL OCCURRENCES OF 'businesstransactiontype'        IN cv_json WITH 'BusinessTransactionType'.
        REPLACE ALL OCCURRENCES OF 'accountingdocumenttype'         IN cv_json WITH 'AccountingDocumentType'.
        REPLACE ALL OCCURRENCES OF 'documentreferenceid'            IN cv_json WITH 'DocumentReferenceID'.
        REPLACE ALL OCCURRENCES OF 'documentheadertext'             IN cv_json WITH 'DocumentHeaderText'.
        REPLACE ALL OCCURRENCES OF 'createdbyuser'                  IN cv_json WITH 'CreatedByUser'.
        REPLACE ALL OCCURRENCES OF 'companycode'                    IN cv_json WITH 'CompanyCode'.
        REPLACE ALL OCCURRENCES OF 'documentdate'                   IN cv_json WITH 'DocumentDate'.
        REPLACE ALL OCCURRENCES OF 'postingdate'                    IN cv_json WITH 'PostingDate'.
        REPLACE ALL OCCURRENCES OF 'taxdeterminationdate'           IN cv_json WITH 'TaxDeterminationDate'.
        REPLACE ALL OCCURRENCES OF 'item'                           IN cv_json WITH 'Item'.
        REPLACE ALL OCCURRENCES OF 'referencedocumentitem'          IN cv_json WITH 'ReferenceDocumentItem'.
        REPLACE ALL OCCURRENCES OF 'glaccount'                      IN cv_json WITH 'GLAccount'.
        REPLACE ALL OCCURRENCES OF 'amountintransactioncurrency'    IN cv_json WITH 'AmountInTransactionCurrency'.
        REPLACE ALL OCCURRENCES OF 'currencycode'                   IN cv_json WITH 'currencyCode'.
        REPLACE ALL OCCURRENCES OF 'debitcreditcode'                IN cv_json WITH 'DebitCreditCode'.
        REPLACE ALL OCCURRENCES OF 'documentitemtext'               IN cv_json WITH 'DocumentItemText'.
        REPLACE ALL OCCURRENCES OF 'accountassignment'              IN cv_json WITH 'AccountAssignment'.
        REPLACE ALL OCCURRENCES OF 'costcenter'                     IN cv_json WITH 'CostCenter'.
        REPLACE ALL OCCURRENCES OF 'tax'                            IN cv_json WITH 'Tax'.
        REPLACE ALL OCCURRENCES OF 'taxcode'                        IN cv_json WITH 'TaxCode'.
        REPLACE ALL OCCURRENCES OF 'Taxcode'                        IN cv_json WITH 'TaxCode'.
        REPLACE ALL OCCURRENCES OF 'taxexpenseamountintransaccrcy'  IN cv_json WITH 'TaxExpenseAmountInTransacCrcy'.
        REPLACE ALL OCCURRENCES OF 'currencycode'                   IN cv_json WITH 'currencyCode'.
        REPLACE ALL OCCURRENCES OF 'creditoritem'                   IN cv_json WITH 'CreditorItem'.
        REPLACE ALL OCCURRENCES OF 'referencedocumentitem'          IN cv_json WITH 'ReferenceDocumentItem'.
        REPLACE ALL OCCURRENCES OF 'creditor'                       IN cv_json WITH 'Creditor'.
        REPLACE ALL OCCURRENCES OF 'amountintransactioncurrency'    IN cv_json WITH 'AmountInTransactionCurrency'.
        REPLACE ALL OCCURRENCES OF 'debitcreditcode'                IN cv_json WITH 'DebitCreditCode'.
        REPLACE ALL OCCURRENCES OF 'documentitemtext'               IN cv_json WITH 'DocumentItemText'.
        REPLACE ALL OCCURRENCES OF 'referencedocumentItem'          IN cv_json WITH 'ReferenceDocumentItem'.
        REPLACE ALL OCCURRENCES OF 'documentItemtext'               IN cv_json WITH 'DocumentItemText'.
        REPLACE ALL OCCURRENCES OF 'Taxexpenseamountintransaccrcy'  IN cv_json WITH 'TaxExpenseAmountInTransacCrcy'.
        REPLACE ALL OCCURRENCES OF 'productTaxItem'                 IN cv_json WITH 'ProductTaxItem'.
        REPLACE ALL OCCURRENCES OF 'Taxbaseamountintranscrcy'       IN cv_json WITH 'TaxBaseAmountInTransCrcy'.
        REPLACE ALL OCCURRENCES OF 'conditiontype'                  IN cv_json WITH 'ConditionType'.

      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
