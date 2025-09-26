@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datos cabecera DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_cabdte
  as select from zclmm_tb_cabdte
{
  key iddte_sap,
  key tipodte,
  key folio,
  key fchemis,
  key rutemisor,
  key rutrecep,
      indnorebaja,
      tipodespacho,
      indtraslado,
      fmapago,
      fchvenc,
      rznsoc,
      giroemis,
      acteco,
      sucursal,
      cdgsiisucur,
      @Semantics.amount.currencyCode: 'WAERS'
      mntneto,
      @Semantics.amount.currencyCode: 'WAERS'
      mntexe,
      tasaiva,
      @Semantics.amount.currencyCode: 'WAERS'
      iva,
      @Semantics.amount.currencyCode: 'WAERS'
      ivanoret,
      @Semantics.amount.currencyCode: 'WAERS'
      mnttotal,
      @Semantics.amount.currencyCode: 'WAERS'
      montonf,
      urlpdf,
      waers,
      febosid,
      cast( (
      concat( (
      concat( ( substring( tmstfirma,1,4 ) ),
               ( substring( tmstfirma,6,2 ) )

               ) ),
               ( substring( tmstfirma,9,2 ) )
                )) as abap.dats ) as fecharecsii

}
