@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price Application Data'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.dataCategory: #DIMENSION
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_PRICE_APP_CDS
  as select from zdt_price_header as a
    left outer join   zdt_price_item   as b on a.head_uuid = b.head_uuid
{
  key a.head_uuid  as HeadUuid,
  key b.item_uuid  as ItemUuid,
      a.pdate      as Pdate,
      a.plant      as Plant,
      a.division   as Division,
      a.time       as Time,
      a.price      as Price,
      a.currency   as Currency,
      a.ttime      as ttime,
      a.ftime      as ftime,
      a.cnt        as cnt,
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
