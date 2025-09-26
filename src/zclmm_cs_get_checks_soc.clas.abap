CLASS zclmm_cs_get_checks_soc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS: get_checks FOR TABLE FUNCTION zclmm_tf_stringval_soc.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_CS_GET_CHECKS_SOC IMPLEMENTATION.


  METHOD get_checks  BY DATABASE FUNCTION
                     FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING zcds_i_checks.

    RETURN select mandt as client,
                  bukrs,
                  ltrim(STRING_AGG(ValorString , '' ORDER BY code)) as StringVal
           FROM zcds_i_checks
           GROUP BY mandt, bukrs;
  ENDMETHOD.
ENDCLASS.
