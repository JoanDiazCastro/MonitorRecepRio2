@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recepción FEL: Referencias DTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@OData.entitySet.name: 'Referencias'
//@OData.publish: true
@Metadata.allowExtensions: true

define view entity zcds_c_recdte_ref
  as select from zclmm_tb_refdte as ref
  association to parent zcds_c_recdte_cab as _Header on $projection.IdDTE = _Header.IdDTE
  //    left outer join edocldtetypet   as edo on  (
  //        edo.dte_type                                     = concat(
  //          '0', ref.tpodocref
  //        )
  //        or edo.dte_type                                  = ref.tpodocref
  //      )
  //                                           and edo.spras = $session.system_language

{
  key ref.iddte_sap              as IdDTE,
  key ref.nrolinref              as NroLinea,
      ref.tpodocref              as CodTipoDocRef,
      case
      when ref.tpodocref = '801' then 'Orden de Compra'
      else 'TestDescripcion' end as DescTipoDocRef,
      //      else edo.description end as DescTipoDocRef,
      ref.folioref               as Folio,
      case
      when ref.fchref is not initial
      then
      cast(
      (concat(
      (concat(left(ref.fchref,4), substring(ref.fchref, 6, 2))), substring(ref.fchref, 9, 2))
      ) as abap.dats)
      else '' end                as FechaDocRef,
      @EndUserText.label: 'Razón Referencia'
      ref.razonref               as RazonReferencia,

      _Header
}
where
  ref.tpodocref != 'EM'
