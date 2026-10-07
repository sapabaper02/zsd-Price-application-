@EndUserText.label: 'Header Price Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_PRICE_HEADER
    provider contract transactional_query
  as projection on ZI_PRICE_HEADER
{
  key HeadUuid,
      @Search.defaultSearchElement: true
      Pdate,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH',
                     element: 'Plant'} }]
      Plant,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CnsldtnDivisionVH',
                     element: 'Division'} }]
      Division,
      Time,
      Price,
      Currency,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Item : redirected to composition child ZC_PRICE_ITEM
}
