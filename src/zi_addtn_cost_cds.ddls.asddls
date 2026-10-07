@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Data CDS'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.dataCategory: #DIMENSION
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_ADDTN_COST_CDS
  as select from zdt_addtn_cost
{
  key costuuid           as Costuuid,
      material           as Material,
      plant              as Plant,
      fdate              as Fdate,
      tdate              as Tdate,
      division           as Division,
      pprice             as Pprice,
      bvalue             as Bvalue,
      scost              as Scost,
      acost              as Acost,
      currency           as Currency,
      createdby          as Createdby,
      createdat          as Createdat,
      lastchangedby      as Lastchangedby,
      lastchangedat      as Lastchangedat,
      locallastchangedat as Locallastchangedat
}
