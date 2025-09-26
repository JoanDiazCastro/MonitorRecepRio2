@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCLMM_TB_APIS'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZCDS_I_APIS
  as select from zclmm_tb_apis as zap
{
  key zap.idend      as Idend,
      zap.endpoint   as Endpoint,
      zap.zzuser     as Zzuser,
      zap.zzpassword as Zzpassword,
      zap.zzmethod   as Zzmethod,
      zap.createdby  as Createdby,
      zap.changedby  as Changedby,
      @Semantics.systemDateTime.lastChangedAt: true
      zap.lastmod    as Lastmod,
      @Semantics.systemDateTime.lastChangedAt: true
      zap.lastmodloc as Lastmodloc
}
