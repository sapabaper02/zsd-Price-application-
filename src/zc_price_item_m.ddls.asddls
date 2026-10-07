@EndUserText.label: 'Item Price Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_PRICE_ITEM_M
  as projection on ZI_PRICE_ITEM_M as Item
{
  key ItemUuid,
      HeadUuid,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH',
                     element: 'Product'} }]
      Material,
      MaterialDesc,
      Qty,
      Uom,
      Bprice,
      Pprice,
      Bvalue,
      Scost,
      Acost,
      Sprice,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      /* Associations */
      _Header : redirected to parent ZC_PRICE_HEADER_M
}
