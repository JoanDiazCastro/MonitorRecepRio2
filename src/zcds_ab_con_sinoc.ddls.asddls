@EndUserText.label: 'Vista abstracta para contabilizar Sin OC'
@Metadata.allowExtensions: true
define root abstract entity ZCDS_AB_CON_SINOC
{ 
  @UI.hidden: true
  proveedor : lifnr;
  
  @EndUserText.label : 'Folio Referencia DTE'  
  @Consumption.valueHelpDefinition: [{
         entity     : {
             name   : 'ZCDS_I_HV_AYUDA_SINOC', 
             element: 'PurchaseOrder'
             
         }, 
         additionalBinding  : [{ localElement: 'proveedor',
                                 element     : 'Supplier' 
                                }]
         }]
  folioref  : zclmm_ed_folioref;

  @EndUserText.label : 'Fecha de la Referencia'
  fchref    : abap.dats;

}
