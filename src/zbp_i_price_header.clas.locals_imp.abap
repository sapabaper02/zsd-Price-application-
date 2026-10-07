CLASS lhc_price DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE header.

    METHODS read FOR READ
      IMPORTING keys FOR READ header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK header.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ header\_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE header\_item.

    METHODS defaultheadervalue FOR READ
      IMPORTING keys FOR FUNCTION header~defaultheadervalue RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

ENDCLASS.

CLASS lhc_price IMPLEMENTATION.

  METHOD create.
    DATA: ls_header TYPE zdt_price_header.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_header_entity>).
      ls_header = CORRESPONDING #( <lfs_header_entity> ).
      TRY.
          ls_header-head_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
      ENDTRY.
      ls_header-currency = 'INR'.
      MODIFY zdt_price_header FROM @ls_header.

      INSERT VALUE #(
                        %cid = <lfs_header_entity>-%cid
                        headuuid = ls_header-head_uuid
        )   INTO TABLE mapped-header.

    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_header TYPE zdt_price_header.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_header_entity>).
      ls_header = CORRESPONDING #( <lfs_header_entity> ).
      "      ls_header-head_uuid = <lfs_header_entity>-HeadUuid.
      MODIFY zdt_price_header FROM @ls_header.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_del_keys>).
      DELETE FROM zdt_price_header WHERE head_uuid = @<lfs_del_keys>-headuuid.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_item.
  ENDMETHOD.

  METHOD cba_item.
    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<lfs_head_item>).
      DATA(lv_headuuid) = <lfs_head_item>-headuuid.
      LOOP AT <lfs_head_item>-%target ASSIGNING FIELD-SYMBOL(<lfs_item>).
        DATA(ls_item) = CORRESPONDING zdt_price_item( <lfs_item> MAPPING FROM ENTITY USING CONTROL ).
        ls_item-head_uuid = lv_headuuid.
        TRY.
            ls_item-item_uuid = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
        ENDTRY.
        MODIFY zdt_price_item FROM @ls_item.

        INSERT VALUE #(
                        %cid = <lfs_item>-%cid
                        itemuuid = ls_item-item_uuid
        )   INTO TABLE mapped-item.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD defaultheadervalue.
    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_date) TIME DATA(lv_time).

    DATA : lt_header TYPE TABLE FOR READ RESULT zi_price_header.

    APPEND INITIAL LINE TO lt_header ASSIGNING FIELD-SYMBOL(<fs_header>).
    TRY.
        <fs_header>-headuuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
    ENDTRY.
    <fs_header>-pdate = lv_date.
    <fs_header>-time = lv_time.
    <fs_header>-currency = 'INR'.

    result = VALUE #( FOR <fs_header_m> IN lt_header
                 (
                     %cid = keys[ 1 ]-%cid
                   "  %key-HeadUuid = <fs_header>-HeadUuid
                     %param = CORRESPONDING #( <fs_header_m> )
                 )
    )  .
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_price_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_price_header IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
