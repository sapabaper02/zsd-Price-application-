@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Pricing Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SalesOrderPricingData
  as select from I_SalesOrderItemPricingElement as Pricing
    inner join   I_SalesOrderItem               as SalesItem on  Pricing.SalesOrder     = SalesItem.SalesOrder
                                                             and Pricing.SalesOrderItem = SalesItem.SalesOrderItem

{
  key Pricing.SalesOrder,
  key Pricing.SalesOrderItem,
      Pricing.ConditionType,
      Pricing.TransactionCurrency,
      cast( Pricing.ConditionAmount as abap.dec(15,2) ) as Amount,

      cast( SalesItem.OrderQuantity as abap.dec(13,3) ) as Quantity
}
where
  //     Pricing.ConditionType = 'PPR0' //Commented On 07.05.2025
     Pricing.ConditionType = 'ZPPR' //Added On 07.05.2025
  or Pricing.ConditionType = 'ZPR1'
  or Pricing.ConditionType = 'ZDIQ'
  or Pricing.ConditionType = 'ZFRT'
