@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Descripción estatus factoring'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.resultSet.sizeCategory: #XS //permite esplegar los datos en una select
define view entity zcds_i_status_fact
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCLMM_DM_STATFACT' ) as dom
{

      @ObjectModel.text.element: [ 'DescrStatusFact' ]
  key dom.value_low as CodStatusFactoring,

      @Semantics.text: true
      dom.text      as DescrStatusFact
}
where
  dom.language = $session.system_language
