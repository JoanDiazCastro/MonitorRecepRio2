@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ayuda búsqueda vía pago'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData:{
//entitySet.name: 'ViaPago',
//publish: true
//}
define view entity zcds_c_hv_viapago
  as select from I_PaymentMethodText
{
  key PaymentMethod            as ViaPago,
      PaymentMethodDescription as Descripcion

}
where
      Country  = 'CL'
  and Language = $session.system_language
