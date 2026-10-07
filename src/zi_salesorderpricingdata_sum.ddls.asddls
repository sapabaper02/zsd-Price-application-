@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Pricing Data Summation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SalesOrderPricingData_Sum as select from ZI_SalesOrderPricingData
{
    key SalesOrder,
    key SalesOrderItem,
    TransactionCurrency,
    sum( Amount / Quantity  ) as Amount
}
group by SalesOrder, SalesOrderItem, TransactionCurrency
