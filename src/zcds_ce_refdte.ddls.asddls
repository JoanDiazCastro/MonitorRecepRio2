@EndUserText.label: 'Custom entity tabla zclmm_tb_refdte'
define custom entity ZCDS_CE_REFDTE
{
  key iddte_sap : zclmm_ed_iddte_sap;
  key nrolinref : zclmm_ed_nrolinref;
      tpodocref : zclmm_ed_tpodocref;
      folioref  : zclmm_ed_folioref;
      @EndUserText.label : 'Fecha de la Referencia'
      fchref    : abap.char(10);
      @EndUserText.label : 'Razón referencia'
      razonref  : abap.char(90);

      // Asociacion
      _Cab      : association to parent ZCDS_CE_CABDTE on $projection.iddte_sap = _Cab.iddte_sap;

}
