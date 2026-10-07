@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Item Price Interface View'
define view entity ZI_PRICE_ITEM_M
  as select from zdt_price_item
  association to parent ZI_PRICE_HEADER_M as _Header on $projection.HeadUuid = _Header.HeadUuid
{
  key item_uuid             as ItemUuid,
      head_uuid             as HeadUuid,
      matnr                 as Material,
      maktx                 as MaterialDesc,
      qty                   as Qty,
      uom                   as Uom,
      bprice                as Bprice,
      pprice                as Pprice,
      bvalue                as Bvalue,
      scost                 as Scost,
      acost                 as Acost,
      sprice                as Sprice,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Header
}
