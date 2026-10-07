@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cost BO View'
define root view entity ZI_ADDTN_COST
  as select from zdt_addtn_cost as Cost
{
  key costuuid           as Costuuid,
      material           as Material,
      plant              as Plant,
      fdate              as FDate,
      tdate              as TDate,  
      division           as Division,
      pprice             as Pprice,
      bvalue             as Bvalue,
      scost              as Scost,
      acost              as Acost,
      currency           as Currency,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby      as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat
}
