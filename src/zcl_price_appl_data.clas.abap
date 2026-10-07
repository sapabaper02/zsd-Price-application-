CLASS zcl_price_appl_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRICE_APPL_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "    DELETE from zdt_price_header.
    "    DELETE from zdt_price_item.


  ENDMETHOD.
ENDCLASS.
