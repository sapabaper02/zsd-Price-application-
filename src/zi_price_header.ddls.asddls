@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Price Interface View'
define root view entity ZI_PRICE_HEADER as select from zdt_price_header
composition [0..*] of ZI_PRICE_ITEM as _Item
{
    key head_uuid as HeadUuid,
    pdate as Pdate,
    plant as Plant,
    division as Division,
    time as Time,
    price as Price,
    currency as Currency,
    @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
    _Item // Make association public
}
