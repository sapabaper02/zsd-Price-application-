CLASS lhc_cost DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*   METHODS get_instance_features FOR INSTANCE FEATURES
*     IMPORTING keys REQUEST requested_features FOR cost RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR cost RESULT result.
    METHODS defaultdata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR cost~defaultdata.
    METHODS validmaterial FOR VALIDATE ON SAVE
      IMPORTING keys FOR cost~validmaterial.

ENDCLASS.

CLASS lhc_cost IMPLEMENTATION.

*  METHOD get_instance_features.
*  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD defaultdata.
    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_tdate) TIME DATA(lv_time).

    DATA(lv_date) = '99991231'.

    READ ENTITIES OF zi_addtn_cost IN LOCAL MODE
        ENTITY cost
         ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(cost).
    TRY.
        DATA(ls_cost) = cost[ 1 ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
    IF ls_cost-material IS INITIAL.
      MODIFY ENTITIES OF zi_addtn_cost IN LOCAL MODE
        ENTITY cost
            UPDATE SET FIELDS WITH VALUE #(
                          FOR ct IN cost (
                              %key = ct-%key
                              %is_draft = ct-%is_draft
                              currency = 'INR'
                              fdate = lv_tdate
                              tdate = lv_date
                          )
                  ) REPORTED DATA(modifyreported).
      reported = CORRESPONDING #( DEEP modifyreported ).
    ELSEIF ls_cost-division IS INITIAL.
      SELECT SINGLE division
              FROM i_product
                    WHERE product = @ls_cost-material
                          INTO @DATA(lv_division).
      IF lv_division IS NOT INITIAL.
        MODIFY ENTITIES OF zi_addtn_cost IN LOCAL MODE
              ENTITY cost
                  UPDATE SET FIELDS WITH VALUE #(
                                FOR ct IN cost (
                                    %key = ct-%key
                                    %is_draft = ct-%is_draft
                                    division  = lv_division
                        )
                        ) REPORTED modifyreported.
        reported = CORRESPONDING #( DEEP modifyreported ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD validmaterial.

    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_tdate) TIME DATA(lv_time).

    READ ENTITIES OF zi_addtn_cost IN LOCAL MODE
        ENTITY cost
         ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(cost).

    TRY.
        DATA(ls_cost) = cost[ 1 ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    IF ls_cost-material IS INITIAL.
      APPEND VALUE #(
         %tky = ls_cost-%tky
         %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |{ TEXT-003 }|
                )

   ) TO reported-cost.
      APPEND VALUE #( %tky = ls_cost-%tky ) TO failed-cost.
    ENDIF.

    IF ls_cost-plant IS INITIAL.
      APPEND VALUE #(
         %tky = ls_cost-%tky
         %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |{ TEXT-004 }|
                )

   ) TO reported-cost.
      APPEND VALUE #( %tky = ls_cost-%tky ) TO failed-cost.
    ENDIF.

    CHECK ls_cost IS NOT INITIAL.

    SELECT SINGLE material
          FROM zi_addtn_cost_cds
                WHERE costuuid = @ls_cost-costuuid
                INTO @DATA(ls_data).

    IF sy-subrc <> 0.
      SELECT SINGLE material
            FROM zi_addtn_cost_cds
                  WHERE material = @ls_cost-material
                  AND plant = @ls_cost-plant
                  AND fdate = @ls_cost-fdate
                  INTO @ls_data.
      IF sy-subrc = 0.
        APPEND VALUE #(
              %tky = ls_cost-%tky
              %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |{ TEXT-001 } { TEXT-002 }|
                     )

        ) TO reported-cost.
        APPEND VALUE #( %tky = ls_cost-%tky ) TO failed-cost.
      ELSE.
        SELECT costuuid,
                      material
                FROM  zdt_addtn_cost
                    WHERE material = @ls_cost-material
                    AND   plant   = @ls_cost-plant
                    AND   fdate   <= @lv_tdate
                    AND   tdate   >= @lv_tdate
                      INTO TABLE @DATA(lt_ocost).
        IF sy-subrc = 0.
          TRY.
              DATA(ls_ocost) = lt_ocost[ 1 ].
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
          DATA(lv_ydate) = ls_cost-fdate - 1.
          UPDATE zdt_addtn_cost
                  SET tdate = @lv_ydate
                       WHERE costuuid = @ls_ocost-costuuid.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
