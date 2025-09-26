@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_i_parglob_dte
  as select from    zclmm_tb_parglob                                  as par
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'' ) as dd on  par.parametro = dd.value_low
                                                                            and dd.language   = $session.system_language
  //    left outer join dd07t            as dd on  par.parametro = dd.domvalue_l
  //                                           and dd.ddlanguage = $session.system_language
{
  key par.bukrs     as Sociedad,
  key par.parametro as Parametro,
      dd.text       as Descripcion,
      par.activo

}
