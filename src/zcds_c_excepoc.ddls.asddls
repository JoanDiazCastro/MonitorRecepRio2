@Metadata.allowExtensions: true
define root view entity ZCDS_C_EXCEPOC
  as select from zclmm_tb_areadte
{
  key codarea    as Codarea,
      ''         as createdat,
      ''         as hkont,
      ''         as kostl,
      ''         as lastchangedat,
      ''         as lastchangedby,
      ''         as lifnr,
      ''         as locallastchangedat,
      descarea   as Descarea,
      createdby  as Createdby,
      changedby  as Changedby,
      lastmod    as Lastmod,
      lastmodloc as Lastmodloc
}
