CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS validdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validdate.

    METHODS saveprice FOR DETERMINE ON SAVE
      IMPORTING keys FOR header~saveprice.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS defaultdata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR header~defaultdata.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validdate.
    READ ENTITIES OF zi_price_header_m IN LOCAL MODE ENTITY
            header FIELDS ( pdate division plant price ) WITH CORRESPONDING #( keys )
                RESULT DATA(header).
*    LOOP AT header INTO DATA(ls_header).

    TRY.
        DATA(ls_header) = header[ 1 ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
    IF ls_header-pdate IS INITIAL.
      APPEND VALUE #(
           %tky = ls_header-%tky
           %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = |{ TEXT-006 }|
                  )

     ) TO reported-header.
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
    ENDIF.

    IF ls_header-plant IS INITIAL.
      APPEND VALUE #(
            %tky = ls_header-%tky
            %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = |{ TEXT-007 }|
                   )

      ) TO reported-header.
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
    ENDIF.

    IF ls_header-division IS INITIAL.
      APPEND VALUE #(
            %tky = ls_header-%tky
            %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = |{ TEXT-008 }|
                   )

      ) TO reported-header.
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.

    ENDIF.

    IF ls_header-price IS INITIAL.
      APPEND VALUE #(
            %tky = ls_header-%tky
            %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = |{ TEXT-009 }|
                   )

      ) TO reported-header.
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
    ENDIF.


    SELECT SINGLE pdate, division, plant
          FROM zi_price_app_cds
                WHERE headuuid = @ls_header-headuuid
                INTO @DATA(ls_data).
    IF sy-subrc = 0.
      IF ls_header-pdate IS NOT INITIAL.
        IF ls_data-pdate <> ls_header-pdate.
          APPEND VALUE #(
              %tky = ls_header-%tky
              %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |{ TEXT-001 }|
                     )

        ) TO reported-header.
          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        ENDIF.
      ENDIF.

      IF ls_header-division IS NOT INITIAL.
        IF ls_data-division <> ls_header-division.
          APPEND VALUE #(
              %tky = ls_header-%tky
              %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |{ TEXT-002 }|
                     )

       ) TO reported-header.
          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        ENDIF.
      ENDIF.

      IF ls_header-plant IS NOT INITIAL.
        IF ls_data-plant <> ls_header-plant.
          APPEND VALUE #(
              %tky = ls_header-%tky
              %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |{ TEXT-002 }|
                     )

       ) TO reported-header.
          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        ENDIF.
      ENDIF.

    ELSE.
*      SELECT SINGLE 'X'
*      FROM zi_price_app_cds
*            WHERE pdate = @ls_header-pdate
*            AND   plant = @ls_header-plant
*            AND   division = @ls_header-division
*                  INTO @DATA(lv_exist).
*      IF sy-subrc = 0.
*        APPEND VALUE #(
*                %tky = ls_header-%tky
*                %msg = new_message_with_text(
*                         severity = if_abap_behv_message=>severity-error
*                         text     = |{ TEXT-003 } { ls_header-division } { TEXT-004 } { ls_header-pdate+6(2) }/{ ls_header-pdate+4(2) }/{ ls_header-pdate+0(4) } { TEXT-005 }|
*                       )
*
*         ) TO reported-header.
*        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
*      ENDIF.
    ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD saveprice.
    DATA: lv_ftime TYPE cl_abap_context_info=>ty_system_time,
          lv_ttime TYPE cl_abap_context_info=>ty_system_time.

    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_tdate) TIME DATA(lv_time).

    READ ENTITIES OF zi_price_header_m IN LOCAL MODE
           ENTITY header
               ALL FIELDS WITH CORRESPONDING #( keys )
                       RESULT DATA(header)
                           ENTITY item
                               ALL FIELDS WITH
                                   CORRESPONDING #( keys )
                                       RESULT DATA(item).
    TRY.
        DATA(ls_header) = header[ 1 ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    SELECT MAX( cnt )
      FROM zdt_price_header
            WHERE pdate = @ls_header-pdate
            AND   plant = @ls_header-plant
            AND   division = @ls_header-division
               INTO @DATA(lv_cnt).
    IF lv_cnt = 0.
      lv_cnt = 1.
      lv_ftime = '000001'.
      lv_ttime = '235959'.
    ELSE.
      SELECT SINGLE head_uuid,
                    ttime,
                    ftime
            FROM zdt_price_header
                WHERE pdate = @ls_header-pdate
            AND   plant = @ls_header-plant
            AND   division = @ls_header-division
            AND   cnt = @lv_cnt
                INTO @DATA(ls_data).

      UPDATE zdt_price_header SET ttime = @lv_time
                              WHERE head_uuid = @ls_data-head_uuid.
      lv_cnt = lv_cnt + 1.
      lv_ftime = lv_time.
      lv_ttime = '235959'.
    ENDIF.

    MODIFY ENTITIES OF zi_price_header_m IN LOCAL MODE
        ENTITY header
            UPDATE SET FIELDS WITH VALUE #(
                          FOR head IN header (
                              %key = head-%key
                              %is_draft = head-%is_draft
                              cnt = lv_cnt
                              ttime = lv_ttime
                              ftime = lv_ftime
                          )
                  ) REPORTED DATA(modifyreported).
    reported = CORRESPONDING #( DEEP modifyreported ).


    SELECT material
*              FROM zi_addtn_cost_cds
              FROM zi_additional_cost     "changed on 02OCT25
                      WHERE plant  = @ls_header-plant
                      AND  division = @ls_header-division
                      AND  fdate    <= @ls_header-pdate
                      AND  tdate    >= @ls_header-pdate
                          INTO TABLE @DATA(lt_product).


    LOOP AT lt_product INTO DATA(ls_product).
      TRY.
          MODIFY ENTITIES OF zi_price_header_m IN LOCAL MODE
                ENTITY header
                    CREATE BY \_item
                        "FIELDS ( HeadUuid ItemUuid Material )
                        FROM VALUE #( ( %key = ls_header-%key
                            %target = VALUE #( ( %cid = 'CID'
                                                headuuid = ls_header-headuuid
                                                %control-headuuid = if_abap_behv=>mk-on
                                                itemuuid = cl_system_uuid=>create_uuid_x16_static( )
                                                %control-itemuuid = if_abap_behv=>mk-on
                                                material = ls_product-material
                                                %control-material = if_abap_behv=>mk-on
                                            ) )
                                        )
                                    )
                    MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).
        CATCH cx_uuid_error.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_features.
  ENDMETHOD.

  METHOD defaultdata.

    CONSTANTS: lc_tzone TYPE cl_abap_context_info=>ty_time_zone VALUE 'INDIA'.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    CONVERT TIME STAMP lv_timestamp TIME ZONE lc_tzone INTO DATE DATA(lv_date) TIME DATA(lv_time).

    READ ENTITIES OF zi_price_header_m IN LOCAL MODE ENTITY
           header ALL FIELDS WITH CORRESPONDING #( keys )
               RESULT DATA(header).

    DATA(ls_header) = header[ 1 ].
    IF ls_header-pdate IS INITIAL.

      MODIFY ENTITIES OF zi_price_header_m IN LOCAL MODE
        ENTITY header
            UPDATE SET FIELDS WITH VALUE #(
                          FOR head IN header (
                              %key = head-%key
                              %is_draft = head-%is_draft
                              pdate = lv_date
                              time = lv_time
                              currency = 'INR'
                          )
                  ) REPORTED DATA(modifyreported).
      reported = CORRESPONDING #( DEEP modifyreported ).
    ELSE.
*      SELECT SINGLE 'X'
*   FROM zi_price_app_cds
*         WHERE pdate = @ls_header-pdate
*         AND   plant = @ls_header-plant
*         AND   division = @ls_header-division
*               INTO @DATA(lv_exist).
*      IF sy-subrc = 0.
*        "    select max( ttime )
*      ELSE.
*
*      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
