#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



function pro_cenzboz_vyd(nkey)
  local  cKey := upper(pvpitemw->ccisSklad) +upper(pvpitemw->csklPol)
  local  y, z, lcenaPru, nOldMnozS
  *
  local  mnozPRdod := pvpitemw->nmnozPRdod
  local  mnozREodb := pvpitemw->nmnozREodb
  local  cenNAPdod := pvpitemw->ncenNAPdod
  local  cenaCELK  := pvpitemw->ncenaCELK
  *
  local  mnozPR_or := pvpitemw->nmnozPR_or
  local  mnozRE_or := pvpitemw->nmnozRE_or
  local  mnozZO_or := pvpitemw->nmnozZO_or
  local  cenaCE_or := pvpitemw->ncenaCE_or

  * je zapnutý trigger na pvpitem - modifikace cenZboz je øešena na serveru
  if istriggers_pvpitem
    return 0
  endif

  if cenzboz->(dbseek(cKey,,'CENIK03')) .and. ReplRec( 'cenZboz')   // cenzboz->(sx_Rlock())
    do case
    case( nkey = xbeK_INS)                       // nový výdej

      if upper( cenzboz->cpolCen) = 'C'
        if upper( cenzboz->ctypSKLcen) = 'PRU' .and. cenzboz->nmnozSZBO <= mnozPRdod
          pvpitemw->ncenaCelk  := cenzboz ->ncenaCZBO
          pvpitemw->nrozdilPoh := cenzboz ->ncenaCZBO - (mnozPRdod * cenNAPdod)
          cenzboz ->nmnozSZBO  := cenzboz ->ncenaCZBO := 0
          pvpitemw->nmnozSZBO  := pvpitemw->ncenaCZBO := 0
        else
          pvpitemw->ncenaCELK := Round( mnozPRdod * cenNAPdod, 2)
          cenzboz ->nmnozSZBO -= mnozPRdod
          pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
          cenzboz ->ncenaCZBO -= cenaCELK
          pvpitemw->ncenaCZBO := cenzboz->ncenaCZBO
          if pvpitemw->ncenaCELK < 0
            cenzboz->ncenaSZBO := PRO_skladCena(cenzboz->ctypSKLcen)
          endif
        endif

        if mnozPRdod > 0
          if mnozREodb > 0
            cenzboz->nmnozRZBO  -= if( mnozPRdod > mnozREodb, mnozREodb,  mnozPRdod)
            cenzboz->nmnozRZBO  := MAX( 0, cenzboz->nmnozRZBO )
            y :=  mnozPRdod - mnozREodb

            if y > 0
              cenzboz->nmnozDZBO -= y
            endif

            y := cenzboz->nmnozDZBO - cenzboz->nmnozSZBO

            if y > 0
              cenzboz->nmnozDZBO   -= y
              pvpitemw->nmnozZOBJE := y
            endif
          else
            cenzboz->nmnozDZBO -= mnozPRdod
          endif
        else
          cenzboz->nmnozDZBO -= mnozPRdod
        endif

        cenzboz->nmnozDZBO := MAX( 0, cenzboz->nmnozDZBO )

        if pvpitemw->nmnozKOBJE > 0
          cenzboz->nmnozKZBO  -= If( mnozPRdod - mnozREodb > 0, mnozPRdod - mnozREodb, 0 )
          cenzboz->nmnozKZBO  := MAX( 0, cenzboz->nmnozKZBO)
        endif
        cenzboz->ncenaSVZM := cenzboz->ncenaSZBO    // * KURZ

      else
        cenzboz ->nmnozSZBO -= mnozPRdod
        pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
        cenzboz ->nmnozDZBO -= mnozPRdod
      endif

    case( nkey = xbeK_ENTER)                     // oprava výdeje

      if upper( cenzboz->cpolCen) = 'C'
        cenzboz->nmnozSZBO += mnozPR_or
        cenzboz->ncenaCZBO += cenaCE_or

        if upper( cenzboz->ctypSKLcen) = 'PRU' .and. cenzboz->nmnozSZBO <= mnozPRdod
          pvpitemw->ncenaCelk  := cenzboz ->ncenaCZBO
          pvpitemw->nrozdilPoh := cenzboz ->ncenaCZBO - (mnozPRdod * cenNAPdod)
          cenzboz ->nmnozSZBO  := cenzboz ->ncenaCZBO := 0
          pvpitemw->nmnozSZBO  := pvpitemw->ncenaCZBO := 0
        else
          cenzboz ->nmnozSZBO -= mnozPRdod
          pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
          cenzboz ->ncenaCZBO -= cenaCELK
          pvpitemw->ncenaCZBO := cenzboz->ncenaCZBO
        endif

        if mnozPRdod > 0
          if mnozREodb > 0
            cenzboz->nmnozRZBO  += if( mnozPR_or > mnozRE_or, mnozRE_or, mnozPR_or )
            cenzboz->nmnozRZBO  -= if( mnozPRdod > mnozREodb, mnozREodb, mnozPRdod )
            cenzboz->nmnozRZBO := MAX( 0, cenzboz->nmnozRZBO )
            y := mnozPRdod - mnozREodb
            z := mnozPR_or - mnozRE_or
            cenzboz->nmnozDZBO  += if( z > 0, z, 0 ) - if( y > 0, y, 0)

            y := cenzboz->nmnozDZBO + mnozZO_or - cenzboz->nmnozSZBO

            if y > 0  ;  if cenzboz->nmnozDZBO = 0
                           cenzboz->nmnozDZBO := mnozZO_or
                         endif
                         cenzboz ->nmnozDZBO  -= y
                         pvpitemw->nmnozZObje := y
            else      ;  cenzboz ->nmnozDZBO  += mnozZO_or
                         pvpitemw->nmnozZObje := 0
            endif
          else
            cenzboz->nmnozDZBO += mnozPR_or - mnozPRdod
          endif
        else
          cenzboz->nmnozDZBO += mnozPR_or - mnozPRdod
        endif

        cenzboz->nmnozDZBO := MAX( 0, cenzboz->nmnozDZBO )

        if pvpitemw->nmnozKOBJE > 0
          cenzboz->nmnozKZBO += pvpitemw->nmnozKOBJE - mnozPRdod
          cenzboz->nmnozKZBO := MAX( 0, cenzboz->nmnozKZBO )
        endif

        if pvpitemw->ncenaCelk < 0
          cenzboz->ncenaSZBO := PRO_skladCena(cenzboz->ctypSKLcen)
        endif
        CenZboz->nCenasVZM := CenZboz->nCenasZBO  // * KURZ     !!!!!!!!!

      else
        cenzboz ->nmnozSZBO += mnozPR_or - mnozPRdod
        pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
        cenzboz ->nmnozDZBO += mnozPR_or - mnozPRdod
      endif


    case( nkey = xbeK_DEL)                       // zrušení výdeje

        lcenaPru  := upper(cenzboz->ctypSKLcen) = 'PRU'
        nOldMnozS := CenZboz->nMnozsZBO

        if upper( cenzboz->cpolCen) = 'C'
          cenzboz->nmnozSZBO += mnozPRdod
          cenzboz->nmnozSZBO := if( lcenaPru, cenzboz->nmnozsZbo, MAX( 0, cenzboz->nmnozSZbo))
          cenzboz->ncenaCZBO += cenaCELK

          if mnozPRdod > 0
            if mnozREodb > 0
              cenzboz->nmnozRZBO += if( mnozPRdod > mnozREodb, mnozREodb, mnozPRdod )
              cenzboz->nmnozRZBO := MAX( 0, cenzboz->nmnozRZBO )

              y :=  mnozPRdod - mnozREodb
              cenzboz->nmnozDZBO += if( y > 0, y, 0 )
              cenzboz->nmnozDZBO += if( lcenaPRU, pvpitemw->nmnozZOBJE, if( nOldMnozS < 0, 0, pvpitemw->nmnozZOBJE))
            else
              cenzboz->nmnozDZBO += if( lCenaPRU, mnozPRdod,            if( nOldMnozS < 0, 0, mnozPRdod ))
            endif
          else
            cenzboz->nmnozDZBO += if( lcenaPRU, mnozPRdod, if( nOldMnozS < 0, 0, mnozPRdod))
          endif

          cenzboz->nmnozDZBO := if( lCenaPRU, MAX( 0, cenzboz->nmnozDZBO), ;
                                              if( nOldMnozS < 0, cenzboz->nmnozDZBO, cenzboz->nmnozDZBO ))
          if pvpitemw->nmnozKOBJE > 0
            cenzboz->nmnozKZBO +=  pvpitemw->nmnozKOBJE
            cenzboz->nmnozKZBO := MAX( 0, cenzboz->nmnozKZBO )
          endif

          if cenaCELK < 0
            cenzboz->ncenaSZBO := PRO_skladCena(cenzboz->ctypSKLcen)
          endif
          cenzboz->ncenaSVZM := cenzboz->ncenaSZBO  // * KURZ     !!!!!!!!!
        else
          cenzboz->nmnozSZBO += mnozPRdod
          cenzboz->nmnozDZBO += mnozPRdod
        endif
      endcase

     cenzboz->dDatPZBO  := pvpitemw->dDatPVP
   endif

   cenzboz->(dbUnlock())
return 0


function nak_cenzboz_pri(nkey)
  local  cKey := upper(pvpitemw->ccisSklad) +upper(pvpitemw->csklPol)
  *
  local  mnozPRdod := pvpitemw->nmnozPRdod
  local  mnozREodb := pvpitemw->nmnozREodb
  local  cenNAPdod := pvpitemw->ncenNAPdod
  local  cenaCELK  := pvpitemw->ncenaCELK
  local  mnozVYobj := pvpitemw->nmnozVyObj
  *
  local  mnozPR_or := pvpitemw->nmnozPR_or
  local  mnozRE_or := pvpitemw->nmnozRE_or
  local  mnozZO_or := pvpitemw->nmnozZO_or
  local  cenaCE_or := pvpitemw->ncenaCE_or
  local  mnozVY_or := pvpitemw->nmnozVy_or

  if cenzboz->(dbseek(cKey,,'CENIK03')) .and. cenzboz->(sx_Rlock())
    do case
    case( nkey = xbeK_INS)                                            // nový pøíjem

      if upper( cenzboz->cpolCen) = 'C'
        cenzboz->nmnozSZbo += mnozPRdod
        cenzboz->ncenaCZBO += cenaCELK

        if upper( cenzboz->ctypSKLcen) = 'PRU'
          if( mnozPRdod < 0, cenzboz->nmnozSZbo := max( 0, cenzboz->nmnozSZbo), nil )
                             cenzboz->nCenasZBO := PRO_skladCena(cenzboz->ctypSKLcen)
        endif

        if .not. empty( pvpitemw->ccisObj)
          cenzboz->nmnozDZbo += ( mnozPRdod - mnozVYobj )
          cenzboz->nmnozRZBO += mnozVYobj
        else
          cenzboz->nmnozDzbo += mnozPRdod
        endif

        cenzboz->nmnozDzbo := max( 0, cenzboz->nmnozDzbo )
        cenzboz->ncenaSvzm := cenzboz ->ncenaSZBO    // * KURZ     !!!!!!!!!
        cenzboz->ncenaNZBO := pvpitemw->ncenNapDOD
        cenzboz->ncenaKurz := cenzboz ->ncenaNZBO    // * KURZ     !!!!!!!!!


        pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
        pvpitemw->ncenaCZBO := cenzboz->ncenaCZBO
      else
        cenzboz ->nmnozSZBO += mnozPRdod
        cenzboz ->nmnozDZBO += mnozPRdod

        pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
        pvpitemw->ncenaCZBO := cenzboz->ncenaCZBO
      endif

    case( nkey = xbeK_ENTER)                                         // oprava pøíjmu

      if upper( cenzboz->cpolCen) = 'C'
        cenzboz->nmnozSZBO -= mnozPR_or
        cenzboz->ncenaCZBO -= cenaCE_or

        cenzboz->nmnozSZbo += mnozPRdod
        cenzboz->ncenaCZBO += cenaCELK

        if upper( cenzboz->ctypSKLcen) = 'PRU' .and. mnozPRdod < 0   // pøíjem nínusem
          cenzboz->nmnozSZbo := max( 0, cenzboz->nmnozSZbo)
        endif

        cenzboz ->nCenasZBO := PRO_skladCena(cenzboz->ctypSKLcen)

        if .not. empty( pvpitemw->ccisObj)
          cenzboz->nmnozDZbo += ( mnozPRdod - mnozVYobj )
          cenzboz->nmnozRZBO += mnozVYobj
        else
          cenzboz->nmnozDzbo += mnozPRdod
        endif

        cenzboz->nmnozDzbo := max( 0, cenzboz->nmnozDzbo )
        cenzboz->ncenaSvzm := cenzboz ->ncenaSZBO    // * KURZ     !!!!!!!!!
        cenzboz->ncenaNZBO := pvpitemw->ncenNapDOD
        cenzboz->ncenaKurz := cenzboz ->ncenaNZBO    // * KURZ     !!!!!!!!!

        pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
        pvpitemw->ncenaCZBO := cenzboz->ncenaCZBO
      else
        cenzboz ->nmnozSZBO += mnozPRdod
        cenzboz ->nmnozDZBO += mnozPRdod

        pvpitemw->nmnozSZBO := cenzboz->nmnozSZBO
        pvpitemw->ncenaCZBO := cenzboz->ncenaCZBO
      endif

    case( nkey = xbeK_DEL)                                           // zrušení pøíjmu

      if upper( cenzboz->cpolCen) = 'C'
        cenzboz->nmnozSZBO -= mnozPR_or
        cenzboz->ncenaCZBO -= cenaCE_or

        if upper( cenzboz->ctypSKLcen) = 'PRU' .and. mnozPRdod < 0   // pøíjem nínusem
          cenzboz->nmnozSZbo := max( 0, cenzboz->nmnozSZbo)
        endif

        cenzboz ->nCenasZBO := PRO_skladCena(cenzboz->ctypSKLcen)

        if .not. empty( pvpitemw->ccisObj)
          cenzboz->nmnozDZbo += ( mnozPRdod - mnozVYobj )
          cenzboz->nmnozRZBO += mnozVYobj
        else
          cenzboz->nmnozDzbo += mnozPRdod
        endif

        cenzboz->nmnozDzbo := max( 0, cenzboz->nmnozDzbo )
        cenzboz->ncenaSvzm := cenzboz->ncenaSZBO    // * KURZ     !!!!!!!!!
        cenzboz->ncenaKurz := cenzboz->ncenaNZBO    // * KURZ     !!!!!!!!!
      else
        cenzboz ->nmnozSZBO -= mnozPRdod
        cenzboz ->nmnozDZBO -= mnozPRdod
      endif
    endcase

    cenzboz->dDatPZBO  := pvpitemw->dDatPVP
  endif

  cenzboz->(dbUnlock())
return 0


*
** pøepoèet skladové ceny
static function PRO_skladCENA(cTyp, file)
  local  cenaSZBO := 0

  do case
  case upper(ctyp) = 'PEV'
    cenaSZBO := pvpitemw->ncenNAPdod

  case upper(ctyp) = 'PRU'
    cenaSZBO := if( cenzboz->ncenaCZBO <> 0 .and. cenzboz->nmnozSZBO <> 0, ;
                    Round( cenzboz->ncenaCZBO / cenzboz->nmnozSZBO, 2 )  , cenzboz->ncenaSZBO)
  otherwise
    cenaSZBO := cenzboz->ncenaSZBO
  endcase
return cenaSZBO