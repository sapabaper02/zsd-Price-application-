@EndUserText.label: 'Item Price Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_PRICE_ITEM
  as projection on ZI_PRICE_ITEM
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
      CreatedBy,
      LastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _Header : redirected to parent ZC_PRICE_HEADER
}
