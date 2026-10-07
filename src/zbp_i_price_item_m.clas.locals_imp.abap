CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setitemdata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~setitemdata.
    METHODS changematerial FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~changematerial.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD setitemdata.
    DATA: lv_qty        TYPE p LENGTH 11 DECIMALS 3,
          lv_bprice     TYPE p LENGTH 11 DECIMALS 2,   "Base Price
          lv_pprice     TYPE p LENGTH 11 DECIMALS 2,   "Packing Price
          lv_bvalue     TYPE p LENGTH 11 DECIMALS 2,   "Brand Value
          lv_scost      TYPE p LENGTH 11 DECIMALS 2,   "Scheme Cost
          lv_acost      TYPE p LENGTH 11 DECIMALS 2,   "Admin Cost
          lv_sprice     TYPE p LENGTH 11 DECIMALS 2,   "Selling Price
          lv_cprice(10) TYPE c.


    READ ENTITIES OF zi_price_header_m IN LOCAL MODE
            ENTITY item
                ALL FIELDS WITH CORRESPONDING #( keys )
                       RESULT DATA(item).

    READ ENTITIES OF zi_price_header_m IN LOCAL MODE
        ENTITY item BY \_header
            ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(header)
        LINK DATA(link)
        FAILED DATA(failed)
        REPORTED DATA(reported1).

    TRY.
        DATA(ls_head) = header[ 1 ].
      CATCH cx_sy_itab_line_not_found ##NO_HANDLER.
    ENDTRY.

    TRY.
        DATA(ls_item) = item[ 1 ].
      CATCH cx_sy_itab_line_not_found ##NO_HANDLER.
    ENDTRY.

    IF ls_item-material IS NOT INITIAL.
      SELECT SINGLE product,
             \_text-productname
                  FROM i_product
                      WHERE product = @ls_item-material
                       AND    \_text-language = @sy-langu
                          INTO @DATA(ls_product).
      SELECT SINGLE product,
                    alternativeunit,
                    quantitynumerator,
                    quantitydenominator
              FROM i_productunitsofmeasure
              WHERE product = @ls_item-material
              AND   alternativeunit = 'KG'
                      INTO @DATA(ls_uom).

*      SELECT SINGLE price
*              FROM zi_price_app_cds
*                     WHERE headuuid = @ls_item-headuuid
*                          INTO @DATA(lv_price).
*      IF sy-subrc <> 0.
*        SELECT SINGLE price
*                FROM zdt_header_d
*                    WHERE headuuid = @ls_item-headuuid
*                            INTO @lv_price.
*      ENDIF.

      DATA(lv_price) = ls_head-price.

      "Qty
      lv_qty = ls_uom-quantitydenominator / ls_uom-quantitynumerator.
      "Base Price
      lv_bprice = ls_uom-quantitydenominator / ls_uom-quantitynumerator * lv_price.

      SELECT SINGLE material,
             pprice,
             bvalue             ,
             scost         ,
             acost
*                FROM zi_addtn_cost_cds
                FROM zi_additional_cost     " changed on 19sep2025
                        WHERE material = @ls_item-material
                        AND   plant = @ls_head-plant
                        AND   fdate   <= @ls_head-pdate
                        AND   tdate   >= @ls_head-pdate
                            INTO @DATA(ls_cost).
      IF ls_cost IS NOT INITIAL.
        "Packing Price
        lv_pprice = ls_cost-pprice.

        "Brand Value
        lv_bvalue = ls_cost-bvalue.

        "Scheme Cost
        lv_scost = ls_cost-scost.

        "Admin Cost
        lv_acost = ls_cost-acost.
      ENDIF.
      "Selling Price
      lv_sprice = lv_bprice + lv_pprice + lv_bvalue + lv_scost + lv_acost.

      lv_cprice = lv_sprice.
      SPLIT lv_cprice AT '.' INTO DATA(lv_val) DATA(lv_dec).

      IF lv_dec(2) = '00'.
        DATA(lv_fprice) = lv_sprice.
      ELSEIF lv_dec(1) < 5.
        lv_fprice = floor( lv_sprice ).
      ELSE.
        lv_fprice = ceil( lv_sprice ).
      ENDIF.

      MODIFY ENTITIES OF zi_price_header_m IN LOCAL MODE
              ENTITY item
                  UPDATE SET FIELDS WITH VALUE #(
                          FOR it IN item (
                              %key = it-%key
                              %is_draft = it-%is_draft
                              materialdesc = ls_product-productname
                              qty = lv_qty
                              uom = ls_uom-alternativeunit
                              bprice = lv_bprice
                              pprice = lv_pprice
                              bvalue = lv_bvalue
                              scost = lv_scost
                              acost = lv_acost
                              sprice = lv_fprice
                         "     %control = value (  )
                          )
                  ) REPORTED DATA(modifyreported).
      reported = CORRESPONDING #( DEEP modifyreported ).
    ENDIF.
  ENDMETHOD.
  METHOD changematerial.
    READ ENTITIES OF zi_price_header_m IN LOCAL MODE
            ENTITY header
                ALL FIELDS WITH CORRESPONDING #( keys )
                        RESULT DATA(header)
                            ENTITY item
                                ALL FIELDS WITH
                                    CORRESPONDING #( keys )
                                        RESULT DATA(item).

  ENDMETHOD.
ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
