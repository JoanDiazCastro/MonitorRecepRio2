@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sociedad'
@ObjectModel.resultSet.sizeCategory: #XS //permite desplegar los datos en una select
define view entity ZCDS_I_bukrs
  as select from I_CompanyCode as t0
{
      @UI.textArrangement: #TEXT_FIRST
      @ObjectModel.text.element: [ 'butxt' ]
  key t0.CompanyCode     as bukrs,
      t0.CompanyCodeName as butxt

}
where
  t0.Language = $session.system_language
