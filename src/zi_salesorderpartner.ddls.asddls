@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Partner Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SALESORDERPARTNER as select from I_SalesOrderPartner
{
    key SalesOrder,
    key PartnerFunction,
    Customer,
    Supplier,
    Personnel,
    ContactPerson,
    Partner,
    FullName,
    ReferenceBusinessPartner,
    AddressID,
    AddressPersonID,
    AddressObjectType,
    SDDocPartnerAddressRefType,
    BPAddrDeterminationTransaction,
    BPRefAddressIDForDocSpcfcAddr,
    SDDocPartnerAddrIsDocSpecific,
    VATRegistration,
    UnloadingPointName,
    CorrespondenceLanguage,
    FormOfAddress,
    InternationalPhoneNumber,
    InternationalMobilePhoneNumber,
    InternationalFaxNumber,
    EmailAddress,
    /* Associations */
    _Address,
    _BPRefAddressForDocSpcfcAddr,
    _BusinessPartnerAddress,
    _ContactPerson,
    _DfltAddrRprstn,
    _OrganizationAddress,
    _OrgNamePostalAddress,
    _PartnerFunction,
    _PersonAddress,
    _PersonName,
    _SalesOrder
}
