CLASS zcl_sd_sls_modify_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_sd_sls_modify_item .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SD_SLS_MODIFY_ITEM IMPLEMENTATION.


  METHOD if_sd_sls_modify_item~modify_fields.
    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.

    salesdocumentitem_extension_o = salesdocumentitem_extension_i.
    if salesdocumentitem_extension_o-yy1_ordercreatetime_sdi is INITIAL.
        GET TIME STAMP FIELD DATA(lv_timestamp).
        CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_tdate) TIME DATA(lv_time).

        salesdocumentitem_extension_o-yy1_ordercreatetime_sdi = lv_time.
    endif.
  ENDMETHOD.
ENDCLASS.
