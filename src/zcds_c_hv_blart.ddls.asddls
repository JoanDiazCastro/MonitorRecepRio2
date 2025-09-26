@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda clase doc.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData:{
entitySet.name: 'ClaseDoc'
}
define view entity zcds_c_hv_blart
  as select from    I_AccountingDocumentType     as clas
    left outer join I_AccountingDocumentTypeText as Text on clas.AccountingDocumentType = Text.AccountingDocumentType
{
  key clas.AccountingDocumentType     as ClaseDoc,
      Text.AccountingDocumentTypeName as Descripcion
}
where
  Text.Language = $session.system_language
