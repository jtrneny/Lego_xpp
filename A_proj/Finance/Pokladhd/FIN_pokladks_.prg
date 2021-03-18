#include "class.ch"
#include "common.ch"
#include "dbstruct.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


# xTranslate  .FSTKEYs  => ::astav_ks\[ 1\]
# xTranslate  .NEWKs    => ::astav_ks\[ 2\]
# xTranslate  .FSTLOCKs => ::astav_ks\[ 3\]
# xTranslate  .MODIKs   => ::astav_ks\[ 4\]
# xTranslate  .prijem   => ::astav_ks\[ 5\]
# xTranslate  .vydej    => ::astav_ks\[ 6\]
# xTranslate  .pri_tuz  => ::astav_ks\[ 7\]
# xTranslate  .vyd_tuz  => ::astav_ks\[ 8\]


*
********* OBECNÁ TØÍDA KUMULACE POKLADNÍCH DOKALDÚ ****************************
CLASS FIN_pokladks
exported:
  var     pokladks_rlo
  method  init, destroy, ps, rlo, pokladks_wrt

hidden:
  var     ckeya, ckeyb, newDok, newKs ,modiKs, fstLocks, fstKeys
  var     astav_ks, pocstav_s, pocstav_tuz_s
ENDCLASS


method FIN_pokladks:init(insave)
  default insave to .f.

  ::pokladks_rlo  := {}
  ::pocstav_s     := 0
  ::pocstav_tuz_s := 0
  ::modiKs        := 0

  ::ckeya   := strzero(pokladhdw->npokladna,3)
  ::ckeyb   := ::ckeya +dtos(pokladhdw->dporizdok)

  drgDBMS:open('pokladks')
  if(pokladks->(dbscope()), pokladks->(dbclearscope(),dbgotop()), nil)
     pokladks->(AdsSetOrder(1)                          , ;
                dbsetscope(SCOPE_BOTH,::ckeya),dbgotop()  )

  if pokladhdw->listuz_uc
    ::astav_ks := { ::ckeyb, .t., 0, 0, pokladhdw->nprijem , pokladhdw->nvydej, ;
                                        pokladhdw->nprijem , pokladhdw->nvydej  }
  else
    ::astav_ks := { ::ckeyb, .t., 0, 0, pokladhdw->nprijemz, pokladhdw->nvydejz, ;
                                        pokladhdw->nprijem , pokladhdw->nvydej  }
  endIf

  if(insave, ::ps(), nil)
return self


method FIN_pokladks:ps()
  if pokladks->(dbseek(::ckeya,,'POKLADK1'))
    pokladks->(dbseek(::ckeyb,.t.,'POKLADK1'))

    if empty(pokladks->dporizdok)
      pokladks->(dbgobottom())                 // nový záznam není pøepoèet
    else                                       // pøepoèet pøi zmìnì èástky
      if(pokladks->(sx_keydata()) = ::ckeyb)   // starý záznam
      else                                     // nový záznam
        pokladks->(dbskip(-1))
      endif
    endif
    ::pocstav_s     := if(pokladks->(bof()), pokladks->npocstav  , pokladks->naktstav  )
    ::pocstav_tuz_s := if(pokladks->(bof()), pokladks->npocst_tuz, pokladks->naktst_tuz)

  else                                         // nový záznam není pøepoèet
    pokladms->(dbseek(pokladhdw->npokladna,,'POKLADM1'))

    ::pocstav_s     := pokladms->npocstav
    ::pocstav_tuz_s := pokladms->npocst_tuz
  endif

  pokladhdw->npocstav := ::pocstav_s
return


method FIN_pokladks:rlo(newRec)
  local ok

  ::newDok := newRec
  ::newKs  := .not. pokladks->(dbseek(::ckeyb,,'POKLADK1'))

  if ::newDok
    ::fstKeys := ::ckeyb
    if ::newKs  ;  pokladks->(dbseek(::ckeyb,.t.,'POKLADK1'))
                   ::fstlocks := pokladks->(recno())
    else        ;  ::modiKs   := pokladks->(recno())
                   ::fstlocks := pokladks->(recno())
    endif
  else
    ::fstKeys := strzero(pokladhdw->npokladna,3) +dtos(pokladhdw->dporiz_or)
    pokladks->(dbseek(::fstKeys,,'POKLADK1'))
    ::modiKs   := pokladks->(recno())
    ::fstlocks := pokladks->(recno())

    if ::fstKeys <> ::ckeyb                      // zmìna dporizdok pøi opravì
      do case
      case(::fstKeys > ::ckeyb)                  // posun dporizdok DOLÚ
        pokladks->(dbseek(::ckeyb,.t.,'POKLADK1'))
      case(::fstKeys < ::ckeyb)                  // posun dporizdok NAHORU
        pokladks->(dbseek(::fstKeys,.t.,'POKLADK1'))
      endcase
    endif
  endif

  pokladks->(dbeval({|| aadd(::pokladks_rlo,pokladks->(recno())) },,,,,.t.))
  ok := pokladks->(sx_rlock(::pokladks_rlo))
return ok



method FIN_pokladks:pokladks_wrt()
  local  recNo  := pokladks->(recno()), pa
  local  cc     := '(pokladks->npocstav +pokladks->nprijem -pokladks->nvydej)'
  local  cc_tuz := '(pokladks->npocst_tuz +pokladks->npri_tuz -pokladks->nvyd_tuz)'
*
  local  listuz_uc := pokladhdw->listuz_uc
  local  pocstav_s, pocstav_tuz_s

  if ::modiKs <> 0
    pokladks->(dbgoto(::modiKs))

    if .not. ::newDok
      pokladks->nprijem    -= .prijem
      pokladks->nvydej     -= .vydej
      pokladks->npri_tuz   -= .pri_tuz
      pokladks->nvyd_tuz   -= .vyd_tuz
    endif

    if pokladhdw->_delrec <> '9' .and. ::fstKeys = ::ckeyb
      pokladks->nprijem  += if(listuz_uc, pokladhdw->nprijem, pokladhdw->nprijemz)
      pokladks->nvydej   += if(listuz_uc, pokladhdw->nvydej , pokladhdw->nvydejz )
      pokladks->npri_tuz += pokladhdw->nprijem
      pokladks->nvyd_tuz += pokladhdw->nvydej
    endif

    pokladks->naktstav   := DBGetVal(cc)
    pokladks->naktst_tuz := DBGetVal(cc_tuz)
  endif

  if ::newKs  ;  pokladks->(dbgoto(::fstLocks))
                 ::fstKeys := pokladks->(sx_keydata())
                 ::ps()
                 mh_copyfld('pokladhd','pokladks',.t., .f.)
                 if .not. listuz_uc
                   pokladks->nprijem := pokladhd->nprijemz
                   pokladks->nvydej  := pokladhd->nvydejz
                 endif

                 pokladks->npocstav   := ::pocstav_s
                 pokladks->npocst_tuz := ::pocstav_tuz_s
                 pokladks->npri_tuz   := pokladhd->nprijem //  .pri_tuz
                 pokladks->nvyd_tuz   := pokladhd->nvydej  //  .vyd_tuz
                 pokladks->naktstav   := DBGetVal(cc)
                 pokladks->naktst_tuz := DBGetVal(cc_tuz)

                 if( ::fstKeys > ::ckeyb, recNo := pokladks->(recNo()), nil)

  else        ;  if ::fstKeys <> ::ckeyb
                   pokladks->(dbseek(::ckeyb,,'POKLADK1'))

                   pokladks->nprijem += if(listuz_uc, pokladhdw->nprijem, pokladhdw->nprijemz)
                   pokladks->nvydej  += if(listuz_uc, pokladhdw->nvydej , pokladhdw->nvydejz )
                   pokladks->naktstav   := DBGetVal(cc)
                   pokladks->naktst_tuz := DBGetVal(cc_tuz)
                 endif
  endif

  pokladks->(dbcommit())

  pokladks->(dbgoTo(recNo))
  pocstav_s     := pokladks->npocStav
  pocstav_tuz_s := pokladks->npocSt_tuz

  pokladks->(dbeval( { || ( pokladks->npocStav   := pocstav_s          , ;
                            pokladks->naktStav   := DBGetVal(cc)       , ;
                              pocstav_s          := pokladks->naktStav , ;
                            pokladks->npocSt_tuz := pocstav_tuz_s      , ;
                            pokladks->naktSt_tuz := DBGetVal(cc_tuz)   , ;
                              pocstav_tuz_s      := naktSt_tuz           ) },,,,,.t.))

  pokladks->(dbunlock(), dbcommit(), dbclearscope())
return


method FIN_pokladks:destroy()
  ::astav_ks    := NIL
return