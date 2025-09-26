CLASS lhc_zcds_c__eqsii DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZcdsC_eqsii
        RESULT result.
ENDCLASS.

CLASS lhc_zcds_c__eqsii IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.
