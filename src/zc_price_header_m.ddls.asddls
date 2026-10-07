@EndUserText.label: 'Header Price Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_PRICE_HEADER_M
    provider contract transactional_query
        as projection on ZI_PRICE_HEADER_M as Header
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
      ftime                 as ftime,
      ttime                 as ttime,
      cnt                   as cnt,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      /* Associations */
      _Item : redirected to composition child ZC_PRICE_ITEM_M
}
