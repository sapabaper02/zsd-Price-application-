@AbapCatalog.sqlViewName: 'ZPRICEDATA'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price Application Data'

@Analytics.dataCategory: #DIMENSION

define view ZI_PRICE_APP_DATA
  as select from    zdt_price_header as a
    left outer join zdt_price_item   as b on a.head_uuid = b.head_uuid
{
  key a.head_uuid  as HeadUuid,
  key b.item_uuid  as ItemUuid,
      a.pdate      as Pdate,
      a.plant      as Plant,
      a.division   as Division,
      a.time       as Time,
      a.price      as Price,
      a.currency   as Currency,
      a.ftime      as ftime,
      a.ttime      as ttime,
      a.created_by as CreatedBy,
      a.created_at as CreatedAt,
      b.matnr      as Matnr,
      b.maktx      as Maktx,
      b.qty        as Qty,
      b.uom        as Uom,
      b.bprice     as Bprice,
      b.pprice     as Pprice,
      b.bvalue     as Bvalue,
      b.scost      as Scost,
      b.acost      as Acost,
      b.sprice     as Sprice

}
