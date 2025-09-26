 CLASS lhc_CabDTE DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
       IMPORTING keys REQUEST requested_authorizations FOR CabDTE RESULT result.

     METHODS read FOR READ
       IMPORTING keys FOR READ CabDTE RESULT result.

     METHODS lock FOR LOCK
       IMPORTING keys FOR LOCK CabDTE.

     METHODS update_cab FOR MODIFY
       IMPORTING cab FOR UPDATE CabDTE.

     METHODS delete FOR MODIFY
       IMPORTING keys FOR DELETE CabDTE.

     METHODS deep_create FOR MODIFY
       IMPORTING cab FOR CREATE CabDTE
                 pos FOR CREATE CabDTE\_Pos
                 ref FOR CREATE CabDTE\_ref.

     METHODS rba_Items FOR READ
       IMPORTING keys_rba FOR READ CabDTE\_Pos FULL result_requested RESULT result LINK association_links.

     METHODS rba_Ref FOR READ
       IMPORTING keys_rba FOR READ CabDTE\_ref FULL result_requested RESULT result LINK association_links.

*    METHODS cba_Ref FOR MODIFY
*      IMPORTING entities_cba FOR CREATE CabDTE\_Ref.

 ENDCLASS.

 CLASS lhc_CabDTE IMPLEMENTATION.

   METHOD get_instance_authorizations.
   ENDMETHOD.

   METHOD deep_create.
     DATA lv_num TYPE c LENGTH 8.
     DATA lv_dig TYPE zclmm_ed_char1.
     DATA: lv_iddte TYPE c LENGTH 35,
           lv_rut   TYPE c LENGTH 20.
     DATA ls_procdte TYPE zclmm_tb_procdte.

     DATA(it_cab) = cab.
     DATA(it_pos) = pos.
     DATA(it_ref) = ref.

     "Llenar tabla de cabecera
     LOOP AT it_cab INTO DATA(ls_cab).

       CLEAR: lv_iddte, lv_rut.

       lv_rut = ls_cab-rutemisor.
       REPLACE ALL OCCURRENCES OF '-' IN lv_rut WITH space. CONDENSE lv_rut NO-GAPS.

       zbp_cds_ce_cabdte=>gv_accion = 'C'.
       zbp_cds_ce_cabdte=>gv_iddte  = ls_cab-iddte_sap.

       lv_iddte = |{ ls_cab-tipodte }{ ls_cab-folio }{ ls_cab-fchemis }{ lv_rut }|.

       APPEND VALUE #( iddte_sap      = lv_iddte
                       tipodte        = ls_cab-tipodte
                       folio          = ls_cab-folio
                       fchemis        = ls_cab-fchemis
                       rutemisor      = ls_cab-rutemisor
                       rutrecep       = ls_cab-rutrecep
                       indnorebaja    = ls_cab-indnorebaja
                       tipodespacho   = ls_cab-tipodespacho
                       indtraslado    = ls_cab-indtraslado
                       fmapago        = ls_cab-fmapago
                       fchvenc        = ls_cab-fchvenc
                       rznsoc         = ls_cab-rznsoc
                       giroemis       = ls_cab-giroemis
                       acteco         = ls_cab-acteco
                       sucursal       = ls_cab-sucursal
                       cdgsiisucur    = ls_cab-cdgsiisucur
                       mntneto        = ls_cab-mntneto
                       mntexe         = ls_cab-mntexe
                       tasaiva        = ls_cab-tasaiva
                       iva            = ls_cab-iva
                       ivanoret       = ls_cab-ivanoret
                       mnttotal       = ls_cab-mnttotal
                       montonf        = ls_cab-montonf
                       urlpdf         = ls_cab-urlpdf
                       waers          = ls_cab-waers
                       febosid        = ls_cab-febosid
                       tmstfirma      = ls_cab-tmstfirma  ) TO zbp_cds_ce_cabdte=>gt_cabdte.

       IF it_pos IS NOT INITIAL.
         READ TABLE it_pos ASSIGNING FIELD-SYMBOL(<sr>) WITH KEY %cid_ref = ls_cab-%cid.

         LOOP AT <sr>-%target ASSIGNING FIELD-SYMBOL(<tr>).

           APPEND VALUE #(  iddte_sap      = lv_iddte
                            nrolindet      = <tr>-nrolindet
                            vlrcodigo      = <tr>-vlrcodigo
                            indexe         = <tr>-indexe
                            nmbitem        = <tr>-nmbitem
                            qtyitem        = <tr>-qtyitem
                            unmditem       = <tr>-unmditem
                            prcitem        = <tr>-prcitem
                            descuentopct   = <tr>-descuentopct
                            descuentomonto = <tr>-descuentomonto
                            montoitem      = <tr>-montoitem  ) TO zbp_cds_ce_cabdte=>gt_detdte.

         ENDLOOP.
       ENDIF.

       IF it_ref[] IS NOT INITIAL.
         READ TABLE it_ref ASSIGNING FIELD-SYMBOL(<sr_ref>) WITH KEY %cid_ref = ls_cab-%cid.

         LOOP AT <sr_ref>-%target ASSIGNING FIELD-SYMBOL(<tr_ref>).

           APPEND VALUE #(  iddte_sap      = lv_iddte
                            nrolinref      = <tr_ref>-nrolinref
                            tpodocref      = <tr_ref>-tpodocref
                            folioref       = <tr_ref>-folioref
                            fchref         = <tr_ref>-fchref
                            razonref       = <tr_ref>-razonref  ) TO zbp_cds_ce_cabdte=>gt_refdte.

         ENDLOOP.
       ENDIF.

       ls_procdte-iddte_sap   = lv_iddte.
       ls_procdte-fchrec      = cl_abap_context_info=>get_system_date( ).
       ls_procdte-status_cont = '02'.
       ls_procdte-stat_fact   = '00'.
       ls_procdte-lifnr       = zclmm_cs_check_dte=>get_proveedor( i_rut = ls_cab-rutemisor ).

       CLEAR: lv_num, lv_dig, lv_rut.

       SPLIT ls_cab-rutrecep AT '-' INTO lv_num lv_dig.
       SHIFT lv_num RIGHT DELETING TRAILING ' '.
       lv_rut = |{ lv_num(2) } { lv_num+2(3) } { lv_num+5(3) }-{ lv_dig }|.
       CONDENSE lv_rut NO-GAPS.

       SELECT SINGLE CompanyCode
        FROM I_AddlCompanyCodeInformation
         WHERE CompanyCodeParameterType EQ 'TAXNR'
           AND CompanyCodeParameterValue EQ @lv_rut
        INTO @ls_procdte-bukrs .

       IF sy-subrc NE 0.
         lv_rut = lv_num(2) && '.' &&  lv_num+2(3) && '.' && lv_num+5(3) && '-' && lv_dig.
         SELECT SINGLE CompanyCode
          FROM I_AddlCompanyCodeInformation
         WHERE CompanyCodeParameterType EQ 'TAXNR'
           AND CompanyCodeParameterValue EQ @lv_rut
          INTO @ls_procdte-bukrs.
       ENDIF.
       " Datos contabilización
       SELECT SINGLE hkont, kostl
        FROM zclmm_tb_excecoc
         WHERE lifnr EQ @ls_procdte-lifnr
        INTO ( @ls_procdte-hkont, @ls_procdte-kostl ).

       APPEND ls_procdte TO zbp_cds_ce_cabdte=>gt_procdte.
       DATA(lt_proc) = zbp_cds_ce_cabdte=>gt_procdte[].

       DATA(lo_check_recdte) = NEW zclmm_cs_check_dte( ).
       LOOP AT lt_proc INTO DATA(ls_proc).

         TRY.
             lo_check_recdte->set_data( EXPORTING it_cab = zbp_cds_ce_cabdte=>gt_cabdte[]
                                                  it_det = zbp_cds_ce_cabdte=>gt_detdte[]
                                                  it_ref = zbp_cds_ce_cabdte=>gt_refdte[]
                                                  it_pro = zbp_cds_ce_cabdte=>gt_procdte[] ).

             lo_check_recdte->check_dte( EXPORTING i_iddte_sap = ls_proc-iddte_sap
                                                   i_bukrs     = ls_proc-bukrs
                                                   i_tables    = abap_true
                                              IMPORTING
                                                   e_check     = ls_proc-checks
                                                   e_rechauto  = DATA(lv_rech)
                                                   e_motmail    = DATA(lv_motmail) ).

             lo_check_recdte->get_data( IMPORTING et_cab = zbp_cds_ce_cabdte=>gt_cabdte[]
                                                  et_det = zbp_cds_ce_cabdte=>gt_detdte[]
                                                  et_ref = zbp_cds_ce_cabdte=>gt_refdte[]
                                                  et_pro = zbp_cds_ce_cabdte=>gt_procdte[]
                                                  et_log = zbp_cds_ce_cabdte=>gt_logdte[] ).

             MODIFY zbp_cds_ce_cabdte=>gt_procdte[] FROM ls_proc TRANSPORTING checks WHERE iddte_sap = ls_proc-iddte_sap.

           CATCH cx_ai_system_fault INTO DATA(lo_exception).
             DATA(lv_text) = lo_exception->if_message~get_text( ).
         ENDTRY.
       ENDLOOP.
     ENDLOOP.

   ENDMETHOD.

   METHOD update_cab.
   ENDMETHOD.

   METHOD delete.
   ENDMETHOD.

   METHOD read.
   ENDMETHOD.

   METHOD lock.
   ENDMETHOD.

   METHOD rba_Items.
   ENDMETHOD.

   METHOD rba_Ref.
   ENDMETHOD.

*  METHOD cba_Ref.
*  ENDMETHOD.

 ENDCLASS.


 CLASS lsc_ZCDS_CE_CABDTE DEFINITION INHERITING FROM cl_abap_behavior_saver.
   PROTECTED SECTION.

     METHODS finalize REDEFINITION.

     METHODS check_before_save REDEFINITION.

     METHODS save REDEFINITION.

     METHODS cleanup REDEFINITION.

     METHODS cleanup_finalize REDEFINITION.

 ENDCLASS.

 CLASS lsc_ZCDS_CE_CABDTE IMPLEMENTATION.

   METHOD finalize.
   ENDMETHOD.

   METHOD check_before_save.
   ENDMETHOD.

   METHOD save.

     CASE zbp_cds_ce_cabdte=>gv_accion.

       WHEN 'C'.

         IF zbp_cds_ce_cabdte=>gt_cabdte[] IS NOT INITIAL AND zbp_cds_ce_cabdte=>gt_detdte[] IS NOT INITIAL.

           MODIFY zclmm_tb_cabdte FROM TABLE @zbp_cds_ce_cabdte=>gt_cabdte.

           IF zbp_cds_ce_cabdte=>gt_procdte[] IS NOT INITIAL.

             MODIFY zclmm_tb_procdte FROM TABLE @zbp_cds_ce_cabdte=>gt_procdte.

           ENDIF.

           IF sy-subrc EQ 0.

             MODIFY zclmm_tb_detdte FROM TABLE @zbp_cds_ce_cabdte=>gt_detdte.

             IF sy-subrc EQ 0.

               reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
                ( %msg     = new_message_with_text( text     = 'Registros creados'
                                                    severity = if_abap_behv_message=>severity-success ) )
                  ).
             ELSE.

               reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
              ( %msg     = new_message_with_text( text     = 'Error al crear registros de posicion'
                                                  severity = if_abap_behv_message=>severity-error ) )
                ).

             ENDIF.

             IF zbp_cds_ce_cabdte=>gt_refdte[] IS NOT INITIAL.
               MODIFY zclmm_tb_refdte FROM TABLE @zbp_cds_ce_cabdte=>gt_refdte.
               IF sy-subrc EQ 0.

                 reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
                  ( %msg     = new_message_with_text( text     = 'Registros creados'
                                                      severity = if_abap_behv_message=>severity-success ) )
                    ).
               ELSE.

                 reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
                ( %msg     = new_message_with_text( text     = 'Error al crear registros de Referencia'
                                                    severity = if_abap_behv_message=>severity-error ) )
                  ).
               ENDIF.
             ENDIF.
             IF zbp_cds_ce_cabdte=>gt_logdte[] IS NOT INITIAL.
               MODIFY zclmm_tb_logdte FROM TABLE @zbp_cds_ce_cabdte=>gt_logdte.
               IF sy-subrc EQ 0.

                 reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
                  ( %msg     = new_message_with_text( text     = 'Registros creados'
                                                      severity = if_abap_behv_message=>severity-success ) )
                    ).
               ELSE.

                 reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
                ( %msg     = new_message_with_text( text     = 'Error al crear registros de Log'
                                                    severity = if_abap_behv_message=>severity-error ) )
                  ).
               ENDIF.
             ENDIF.
           ENDIF.
         ELSE.
           reported-cabdte = VALUE #( BASE reported-cabdte iddte_sap = zbp_cds_ce_cabdte=>gv_iddte
                ( %msg     = new_message_with_text( text     = 'Error al crear registros de cabecera'
                                                    severity = if_abap_behv_message=>severity-error ) )
                  ).
         ENDIF.

     ENDCASE.

   ENDMETHOD.

   METHOD cleanup.

     CLEAR: zbp_cds_ce_cabdte=>gt_cabdte,
            zbp_cds_ce_cabdte=>gt_detdte,
            zbp_cds_ce_cabdte=>gt_refdte,
            zbp_cds_ce_cabdte=>gt_procdte,
            zbp_cds_ce_cabdte=>gv_accion,
            zbp_cds_ce_cabdte=>gv_iddte.

   ENDMETHOD.

   METHOD cleanup_finalize.
   ENDMETHOD.

 ENDCLASS.

 CLASS lhc_DetDTE DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS update_pos FOR MODIFY
       IMPORTING entities FOR UPDATE DetDTE.

     METHODS delete FOR MODIFY
       IMPORTING keys FOR DELETE DetDTE.

     METHODS read FOR READ
       IMPORTING keys FOR READ DetDTE RESULT result.

     METHODS rba_Cab FOR READ
       IMPORTING keys_rba FOR READ DetDTE\_Cab FULL result_requested RESULT result LINK association_links.

 ENDCLASS.

 CLASS lhc_DetDTE IMPLEMENTATION.

   METHOD update_pos.
   ENDMETHOD.

   METHOD delete.
   ENDMETHOD.

   METHOD read.
   ENDMETHOD.

   METHOD rba_Cab.
   ENDMETHOD.

 ENDCLASS.
 CLASS lhc_refdte DEFINITION INHERITING FROM cl_abap_behavior_handler.

   PRIVATE SECTION.

     METHODS update FOR MODIFY
       IMPORTING entities FOR UPDATE RefDTE.

     METHODS delete FOR MODIFY
       IMPORTING keys FOR DELETE RefDTE.

     METHODS read FOR READ
       IMPORTING keys FOR READ RefDTE RESULT result.

     METHODS rba_Cab FOR READ
       IMPORTING keys_rba FOR READ RefDTE\_Cab FULL result_requested RESULT result LINK association_links.

 ENDCLASS.

 CLASS lhc_refdte IMPLEMENTATION.

   METHOD update.
   ENDMETHOD.

   METHOD delete.
   ENDMETHOD.

   METHOD read.
   ENDMETHOD.

   METHOD rba_Cab.
   ENDMETHOD.

 ENDCLASS.
