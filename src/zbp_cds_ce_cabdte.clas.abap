CLASS zbp_cds_ce_cabdte DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zcds_ce_cabdte.


  CLASS-DATA: gt_cabdte  TYPE TABLE OF zclmm_tb_cabdte,
              gt_detdte  TYPE TABLE OF zclmm_tb_detdte,
              gt_refdte  TYPE TABLE OF zclmm_tb_refdte,
              gt_procdte TYPE TABLE OF zclmm_tb_procdte,
              gt_logdte  TYPE TABLE OF zclmm_tb_logdte.

  CLASS-DATA: gv_accion TYPE c LENGTH 1,
              gv_iddte  TYPE zclmm_tb_cabdte-iddte_sap.

ENDCLASS.



CLASS ZBP_CDS_CE_CABDTE IMPLEMENTATION.
ENDCLASS.
