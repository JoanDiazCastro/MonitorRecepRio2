@EndUserText.label: 'Vista abstracta para contabilizar masivo'
@Metadata.allowExtensions: true
define root abstract entity ZCDS_AB_CONTAB_FB60
{
  @EndUserText.label : 'Indicador de impuesto'
  TaxCode     : abap.char( 2 );

  @EndUserText.label : 'Texto documento'
  Text        : abap.char( 100 );

  @EndUserText.label: 'Cuenta Mayor'
  @Consumption.valueHelpDefinition: [{
         entity     : {
             name   : 'zcds_c_hv_ctamayor',
             element: 'CuentaMayor'

         } } ]
  CuentaMayor : saknr;

  @EndUserText.label: 'Centro Costo'
  @Consumption.valueHelpDefinition: [{
         entity     : {
             name   : 'zcds_c_hv_ceco',
             element: 'CentroCosto'

         } } ]
  CentroCosto : kostl;

}
