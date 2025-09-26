CLASS zcl_api_consumption DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS call_external_api
      IMPORTING
        iv_url           TYPE string
        iv_user          TYPE string
        iv_pass          TYPE string
        iv_method        TYPE string        DEFAULT 'POST'
        iv_request_body  TYPE string        OPTIONAL
        iv_token         TYPE abap_boolean  OPTIONAL
      EXPORTING
        ev_response_text TYPE string
        ev_code          TYPE string
      RAISING
        cx_web_http_client_error
        cx_http_dest_provider_error.

    METHODS get_token
      IMPORTING
        iv_url    TYPE string
        iv_user   TYPE string
        iv_pass   TYPE string
        iv_body   TYPE string
      EXPORTING
        ev_token  TYPE string
        ev_cookie TYPE string
      RAISING
        cx_web_http_client_error
        cx_http_dest_provider_error.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_API_CONSUMPTION IMPLEMENTATION.


  METHOD call_external_api.

    DATA: lv_token TYPE string.
    CLEAR: lv_token.

    DATA(lo_destination) = cl_http_destination_provider=>create_by_url( iv_url ).
    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

    IF iv_token EQ abap_true.

      " Set request headers (optional)
      lo_http_client->get_http_request( )->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
      lo_http_client->get_http_request( )->set_header_field( i_name = 'X-CSRF-Token' i_value = 'Fetch' ).

      lo_http_client->get_http_request( )->set_authorization_basic( i_username = iv_user
                                                                    i_password = iv_pass ).

      DATA(lo_resp_token) = lo_http_client->execute( if_web_http_client=>get ).

      " Get the response text
      lv_token  = lo_resp_token->get_header_field( 'X-CSRF-Token' ).
    ENDIF.

    " Set request headers (optional)
    lo_http_client->get_http_request( )->set_header_field( i_name = 'Content-Type'    i_value = 'application/json' ).
    lo_http_client->get_http_request( )->set_header_field( i_name = 'Accept'          i_value = 'application/json' ).
    lo_http_client->get_http_request( )->set_header_field( i_name = 'Accept-Language' i_value = 'ES' ).

    IF iv_token EQ abap_true.
      lo_http_client->get_http_request( )->set_header_field( i_name = 'X-CSRF-Token' i_value = lv_token ).
    ENDIF.

    lo_http_client->get_http_request( )->set_authorization_basic( i_username = iv_user
                                                                  i_password = iv_pass ).

    " Set the request body if provided
    IF iv_request_body IS NOT INITIAL.
      lo_http_client->get_http_request( )->set_text( iv_request_body ).
    ENDIF.

    " Execute the GET request
    CASE iv_method.
      WHEN 'GET'.
        DATA(lv_meth) = if_web_http_client=>get.
      WHEN 'POST'.
        lv_meth = if_web_http_client=>post.
      WHEN 'PUT'.
        lv_meth = if_web_http_client=>put.
      WHEN 'PATCH'.
        lv_meth = if_web_http_client=>patch.
      WHEN 'DELETE'.
        lv_meth = if_web_http_client=>delete.
    ENDCASE.

    DATA(lo_response) = lo_http_client->execute( i_method = lv_meth ).

    " Get the response text
    ev_response_text = lo_response->get_text( ).

    DATA(ls_status) = lo_response->get_status(  ).
    ev_code = ls_status-code.

    CONDENSE ev_code NO-GAPS.

    " Close the client (important for resource management)
    lo_http_client->close( ).

  ENDMETHOD.


  METHOD get_token.

    DATA(lo_destination) = cl_http_destination_provider=>create_by_url( iv_url ).
    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).



    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    DATA(lo_http2) = lo_http_client.
*    lo_http2->get_http_request( )->set_header_field( i_name = 'X-CSRF-Token' i_value = ev_token ).
*    lo_http2->get_http_request( )->set_text( iv_body ).
*
*    lo_http2->get_http_request( )->set_uri_path( 'https://my422275-api.s4hana.cloud.sap/sap/opu/odata/sap/API_SUPPLIERINVOICE_PROCESS_SRV/A_SupplierInvoice' ).
*    DATA(lo_resp2) = lo_http2->execute( if_web_http_client=>post ).
*    DATA(lv_rest) = lo_resp2->get_text( ).


    " Close the client (important for resource management)
*    lo_http_client->close( ).
  ENDMETHOD.
ENDCLASS.
