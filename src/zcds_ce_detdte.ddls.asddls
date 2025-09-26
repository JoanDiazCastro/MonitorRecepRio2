@EndUserText.label: 'Custom entity tabla zclmm_tb_detdte'
define custom entity ZCDS_CE_DETDTE
{

  key iddte_sap      : zclmm_ed_iddte_sap;
  key nrolindet      : abap.char(4);
      vlrcodigo      : abap.char(35);
      indexe         : abap.char(1);
      nmbitem        : abap.char(80);
      qtyitem        : abap.char(18);
      unmditem       : abap.char(4);
      prcitem        : abap.char(18);
      descuentopct   : abap.char(5);
      descuentomonto : abap.char(18);
      montoitem      : abap.char(18);

      // Asociacion
      _Cab           : association to parent ZCDS_CE_CABDTE on $projection.iddte_sap = _Cab.iddte_sap; 

}
