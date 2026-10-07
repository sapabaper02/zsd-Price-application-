CLASS lhc_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Item.

    METHODS read FOR READ
      IMPORTING keys FOR READ Item RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ Item\_Header FULL result_requested RESULT result LINK association_links.

*    METHODS defaultitemvalue FOR READ
*      IMPORTING keys FOR FUNCTION Item~defaultitemvalue RESULT result.

ENDCLASS.

CLASS lhc_Item IMPLEMENTATION.

  METHOD update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_item>).
      DATA(ls_item) = CORRESPONDING zdt_price_item( <lfs_item> MAPPING FROM ENTITY ).
      MODIFY zdt_price_item FROM @ls_item.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_item>).
      DELETE FROM zdt_price_item WHERE item_uuid = @<lfs_item>-ItemUuid.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

*  METHOD defaultitemvalue.
*    DATA : lt_item TYPE TABLE FOR READ RESULT zi_price_item,
*           ls_item LIKE LINE OF lt_item.
*
*
*
*    LOOP AT keys INTO DATA(ls_key).
*      DATA(ls_header) = ls_key-%param.
*
*
**      READ ENTITIES OF zmp_i_store_u IN LOCAL MODE
**        ENTITY store
**        FIELDS ( store_id currency )
**        WITH CORRESPONDING #( keys )
**        RESULT DATA(lt_store_read_results)
**        FAILED failed.
*
*      SELECT product
*                  FROM I_Product
*                          WHERE division = @ls_header-Division
*                                   INTO TABLE @DATA(lt_product).
**      LOOP AT lt_product INTO DATA(ls_product).
**        TRY.
**            ls_item-itemuuid = cl_system_uuid=>create_uuid_x16_static( ).
**          CATCH cx_uuid_error.
**        ENDTRY.
**        ls_item-Material = ls_product-product.
**        APPEND ls_item TO lt_item.
**      ENDLOOP.
*
*        append INITIAL LINE TO lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
*
*        <fs_item>-HeadUuid = ls_header-HeadUuid.
*        <fs_item>-Material = '1001'.
*        TRY.
*            <fs_item>-itemuuid = cl_system_uuid=>create_uuid_x16_static( ).
*          CATCH cx_uuid_error.
*        ENDTRY.
*
*      result = VALUE #( FOR <fs_rec_m> IN lt_item
*                        (
*                        " %cid = keys[ 1 ]-%cid
*                          ItemUuid = ls_item-ItemUuid
*
*                         %param = <fs_rec_m> )
*                        ) .
*
*
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.
