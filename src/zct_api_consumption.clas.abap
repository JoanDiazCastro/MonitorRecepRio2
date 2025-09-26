class ZCT_API_CONSUMPTION definition
  public
  inheriting from CL_COMM_TARGET_HTTP_LV5
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(APPLICATION_DESTINATION) type SAPPDESTNAME optional
    raising
      CX_APPDESTINATION
      CX_COMMUNICATION_TARGET_ERROR .
protected section.
private section.

  constants CID type CL_COMMUNICATION_TARGET_ROOT=>NAME_TYPE value 'ZCT_API_CONSUMPTION' ##NO_TEXT.
  constants CMULTIPLE_APPDESTS type ABAP_BOOL value 'X' ##NO_TEXT.
  constants CTEMPLATE_PATHPREFIX type STRING value '/A_SUPPLIERINVOICE' ##NO_TEXT.
  constants Ccreated_by_cota type CL_COMMUNICATION_TARGET_ROOT=>NAME_TYPE value 'ZCT_API_CONSUMPTION' ##NO_TEXT.
ENDCLASS.



CLASS ZCT_API_CONSUMPTION IMPLEMENTATION.


  method CONSTRUCTOR.
  SUPER->constructor(
    EXPORTING
      id = cid
      template_pathprefix = CTEMPLATE_PATHPREFIX
      SECKEY = CONV int8( '2240880662625982223-' )
      created_by_cota = Ccreated_by_cota
      multiple_appdests = CMULTIPLE_APPDESTS
      application_destination = application_destination
     ).
  endmethod.
ENDCLASS.
