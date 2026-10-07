CLASS zcl_item_condition_amount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_prcg_doc_itm_cndn_amount .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ITEM_CONDITION_AMOUNT IMPLEMENTATION.


  METHOD if_prcg_doc_itm_cndn_amount~change_condition_amount.
    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.
    GET TIME STAMP FIELD DATA(lv_timestamp).
"    CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_date) TIME DATA(lv_time).

    MOVE-CORRESPONDING item_amounts TO item_result_amounts.
    MOVE-CORRESPONDING item_attributes TO item_result_attributes.
    MOVE-CORRESPONDING item_quantities TO item_result_quantities.
    MOVE-CORRESPONDING prcg_element_attributes TO prcg_element_result_amounts.

    CHECK item_attributes-salessddocumentcategory = 'C'.
    IF prcg_element_attributes-conditiontype = 'ZPR1'.
      SELECT SINGLE sprice
              FROM zi_price_app_data
                          WHERE pdate = @item_dates-pricingdate
                          AND   plant = @item_attributes-plant
                          AND   division = @item_attributes-division
                          AND   matnr    = @item_attributes-material
                          and   ftime <=  @item_attributes-yy1_ordercreatetime_pci  "@lv_time
                          and   ttime >=  @item_attributes-yy1_ordercreatetime_pci  "@lv_time
                              INTO @DATA(lv_sprice).
      IF sy-subrc = 0.
        prcg_element_result_amounts-conditionamount =  lv_sprice * item_quantities-orderquantity.
        prcg_element_result_amounts-conditionratevalue = lv_sprice.
        pricing_message = TEXT-001.
      ELSE.
        item_result_attributes-pricinghaserror = abap_true.
        pricing_message = | { TEXT-002 } { item_attributes-material } { TEXT-003 }  { item_dates-pricingdate } |.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
