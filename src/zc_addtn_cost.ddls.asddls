@EndUserText.label: 'Cost Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_ADDTN_COST
  provider contract transactional_query
  as projection on ZI_ADDTN_COST as Cost
{
  key Costuuid,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH',
                     element: 'Product'} }]
      Material,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH',
                     element: 'Plant'} }]
      Plant,
      FDate,
      TDate,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CnsldtnDivisionVH',
                     element: 'Division'} }]
      Division,
      Pprice,
      Bvalue,
      Scost,
      Acost,
      Currency,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat
}
