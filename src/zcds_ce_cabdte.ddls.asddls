@EndUserText.label: 'Custom entity tabla zclmm_tb_cabdte'
define root custom entity ZCDS_CE_CABDTE
{

  key iddte_sap    : zclmm_ed_iddte_sap;
      tipodte      : zclmm_ed_tipodte;
      folio        : zclmm_ed_foliodte;
      fchemis      : zclmm_ed_fechaemis_dte;
      rutemisor    : zclmm_ed_rutemis_dte;
      rutrecep     : zclmm_ed_rutrecp_dte;
      indnorebaja  : abap.char(1);
      tipodespacho : abap.char(1);
      indtraslado  : abap.char(1);
      fmapago      : abap.char(1);
      fchvenc      : zclmm_ed_fechavcto_dte;
      rznsoc       : zclmm_ed_rznsoc_emisor_dte;
      giroemis     : zclmm_ed_giro_emisor_dte;
      acteco       : abap.char(6);
      sucursal     : abap.char(20);
      cdgsiisucur  : abap.char(9);
      @Semantics.amount.currencyCode: 'WAERS'
      mntneto      : zclmm_ed_neto_dte;
      @Semantics.amount.currencyCode: 'WAERS'
      mntexe       : zclmm_ed_exento_dte;
      tasaiva      : abap.char(5);
      @Semantics.amount.currencyCode: 'WAERS'
      iva          : zclmm_ed_iva_dte;
      @Semantics.amount.currencyCode: 'WAERS'
      ivanoret     : zclmm_ed_ivanoret_dte;
      @Semantics.amount.currencyCode: 'WAERS'
      mnttotal     : zclmm_ed_total_dte;
      @Semantics.amount.currencyCode: 'WAERS'
      montonf      : zclmm_ed_montonf_dte;
      urlpdf       : abap.char(200);
      waers        : waers;
      febosid      : zclmm_ed_febosid;
      tmstfirma    : abap.char(20);

      // Asociacion a las posiciones
      _Pos         : composition [0..*] of ZCDS_CE_DETDTE;
      _ref         : composition [0..*] of ZCDS_CE_REFDTE;

}
