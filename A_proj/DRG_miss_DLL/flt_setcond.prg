#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "class.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"

#include "GRA.CH"


static function gate(isL)
  local name := if(isL, 'cLGATE_', 'cRGATE_'), x, npos, cC := ''

  for x := 1 to 4 step 1
    if (npos := filtritw ->(FieldPos(name +str(x,1)))) <> 0
      cC += filtritw ->(FieldGet(npos))
    endif
  next
return strtran(cC, ' ', '')


*
**
CLASS flt_setcond
EXPORTED:
  var    ft_cond, ex_cond, file, indexName READONLY
  method init, destroy, relfiltrs
HIDDEN:
  var    isVariable, inDesign, isdesc
  method setCond, SortOrder, Relations, ResetKey
ENDCLASS


method flt_setcond:init(inDesign,isdesc)
  LOCAL  buffer := StrTran(MemoTran(filtrs->mdata,chr(0)), ' ', ''), n, cname
  local  extBlock

  cresetKey  := xresetKey := ''

  ::inDesign := inDesign
  ::isdesc   := isdesc

  while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    if Left(buffer,1) = '['
      cname := lower(substr(buffer,2,n -3))

      do case
      case cname         = 'definevariable'
        ::isVariable := .T.
      case cname         = 'definefield'
        ::isVariable := .F.
      case left(cname,5) ='table'
        ::file := substr(cname,at(':',cname) +1)
        drgDBMS:open(::file)

        (::file)->(dbGoTop())
      case IsMethod(self, cNAMe, CLASS_HIDDEN)
        self:&cname(substr(buffer, n +1))
      endcase
    endif
    buffer := substr(buffer, n +1)
  end

  ::setCond()
RETURN self


*
**
method flt_setcond:SortOrder(buffer)
  LOCAL  pa, isCompound, x, indexKey := '', n, cc
  *
  LOCAL  odesc, type, len, dec, indexDef, tagNo
  LOCAL  oldEXACT

  if( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    pa         := ListAsArray(substr(buffer,1,n -1))
    isCompound := (Len(pa) > 1)

    *
    for x := 1 to len(pa) step 1
      cc := pa[x]
      odesc := drgDBMS:getFieldDesc(::file, pa[x])
      type  := odesc:type
      len   := odesc:len
      dec   := odesc:dec

      indexKey += if(type = 'C', 'Upper(' +pa[x] +')', ;
                   if(type = 'D', 'DToS(' +pa[x] +')', ;
                    if(type = 'N' .and. isCompound, 'StrZero(' +pa[x] +',' +Str(len) +')', pa[x])))
      indexKey += if(isCompound .and. x < len(pa), '+', '')
    next

    *
    ::indexName := (::file) ->(Ads_GetIndexFilename())
    indexDef    := drgDBMS:dbd:getByKey(::file):indexDef

    oldEXACT    := Set(_SET_EXACT, .F.)
    tagNo       := AScan(indexDef, {|X| Upper(StrTran(X:cIndexKey, ' ', '')) = Upper(indexKey)})
    Set(_SET_EXACT, oldEXACT)

    do case
    case(tagNo <> 0)
      (::file) ->(AdsSetOrder(tagNo))
    case(tagNo =  0 .and. .not. empty(indexKey))
      DbSelectArea(::file)

**      INDEX ON &(indexKey) TO (drgINI:dir_USERfitm +'TISKY') ADDITIVE

      (::file) ->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'TISKY', 'TISKY',  indexKey ))
      (::file) ->(AdsSetOrder('TISKY'))
    endcase
  endif
RETURN self


method flt_setcond:Relations(buffer)
  LOCAL pa, n

  while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)
    if Left(buffer,1) <> '['
      pa := ListAsArray(lower(substr(buffer,1,n -1)),':')
      *
      drgDBMS:open(pa[5])

      (pa[5]) ->(AdsSetOrder(Val(pa[1])))
      (pa[4]) ->(DbSetRelation(pa[5], COMPILE(pa[3]), pa[3]), dbSkip(0))
    endif
    buffer := substr(buffer, n +1)
  enddo
RETURN self


method flt_setcond:relfiltrs(mfile, ex_cond)
  local  pa := {}, filter := ''

  (mfile)->(dbsetFilter( COMPILE(ex_cond) ), dbgotop() )

/*
  do while .not. (mfile)->(eof())
    if( DBGetVal(ex_cond), aadd(pa,(mfile)->(recno())), nil)

    (mfile)->(dbskip())
  enddo

  (mfile)->(ads_clearaof(), dbgotop())

  aeval(pa,{|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  if( empty(filter), filter := 'recno() = 0', nil)

  (mfile)->(ads_setaof(filter),dbgotop())
*/
return self


method flt_setcond:ResetKey(buffer)
  cresetKey := buffer
  xresetKey := ''  //DBGETVAL(cresetKey)
return self


method flt_setcond:destroy()

  if (::file) ->(AdsSetOrder()) = 'TISKY'
    (::file) ->(OrdListClear(), OrdListAdd(::indexName), AdsSetOrder(1))

//    FErase(drgINI:dir_USERfitm +'TISKY.adi')
    FErase(drgINI:dir_USERfitm +'TISKY.cdx')
  endif
RETURN


method flt_setcond:setCond()
  local clga, cnam, ctyp, nlen, crel, cval, cvyr, crga, cond := ''
  local odesc, recCount, recs := filtritw ->(recNo())
  local ok
  *
  ::ft_cond := ''
  ::ex_cond := ''
  *
  filtritw ->(DbGoTop())


  do while .not. filtritw ->(Eof())
    clga  := gate(.T.)
    cnam  := alltrim(filtritw ->cVYRAZ_1)
    if isObject(odesc := drgDBMS:getFieldDesc(cnam))
      ctyp := odesc:type
      nlen := odesc:len
    endif
    crel  := alltrim(filtritw ->cRELACE )
    cval  := alltrim(filtritw ->cVYRAZ_2)
    cvyr  := alltrim(filtritw ->cOPERAND)
    crga  := gate(.F.)

    cond += clga

    do case
    case ctyp = 'N'
      if !isObject(odesc := drgDBMS:getFieldDesc(cval))
        cVal:= Str(Val(cval))
      endif
      cond += cnam +' ' +crel +' ' +cval +' '

    case ctyp = 'C'

      * tohle je pìkná blbost == je binární shoda, nemìla by se používat pro *,? kovenci
      if at('?', cval) <> 0 .or. at( '*', cval) <> 0
        crel := if( crel = '==', '=', crel)
      endif

      do case
      case( crel = '=' .or. crel = '!=' )
        if at('?', cval) <> 0 .or. at( '*', cval) <> 0
          crel := if(crel = '=', '', '!' )
          cval := upper(cval)
          cnam := 'upper(' +cnam + ')'
          if lower(alltrim(filtrs->cmainfile)) $ lower(alltrim(filtritw ->cVYRAZ_1))
            cond += crel +'contains(' +cnam + ',"' +cval + '")' +' '
          else
            cond += crel +'like("' +cval +'", ' +cNam +' )' +' '
          endif

        else
          cvAL := upper(cvAL)
          cond += 'upper(' +cnam +')' +' ' +crel +'"' +cval +'" '
        endif
      case at( '->', cval ) <> 0
        cond += cnam + ' ' +crel +' ' +cval +' '
      otherWise
        cval := padr(cval,nlen)
        cond += cNAM + ' ' +cREL +' ' +'"' +cVAL +'" '
      endcase

    case ctyp = 'D'
      cnam := 'dtos(' +cnam +')'
      if at('->', cval) <> 0
        cond += cnam +' ' +crel +' ' +'dtos(' +cval +')' +' '
      else
        cond += cnam +' ' +crel +' ' +'dtos(ctod(' +'"' +cval +'"))' +' '
      endif

    case ctyp = 'L'
      crel := if( crel = '==', '', '!' )
      cond += crel +if( Equal(cvAL, 'Ne'), '!' +cnam, cnam) +' '
    endcase

    cond += crga +' ' +cvyr +' '

    ok := if( at('->',filtritw ->cVYRAZ_2) <> 0                                      , ;
              lower(alltrim(filtrs->cmainfile)) $ lower(alltrim(filtritw ->cVYRAZ_2)), ;
              .t.                                                                      )

    if lower(alltrim(filtrs->cmainfile)) $ lower(alltrim(filtritw ->cVYRAZ_1)) .and. ok
      ::ft_cond += cond
    else
      ::ft_cond += '(1 = 1)' +' ' +cvyr +' '
      ::ex_cond += cond
    endif
    cond := ''
    filtritw ->(DbSkip())
  enddo

  * upravíme vzor filtru
  do case
  case lower(right(::ft_cond,6)) = '.and. '                // .and.
    ::ft_cond := substr(::ft_cond, 1, len(::ft_cond) -7)

  case lower(right(::ft_cond,5)) = '.or. '                 // .or.
     ::ft_cond := substr(::ft_cond, 1, len(::ft_cond) -6)

 * ex_cond nelze realizovat pøes AOF
  case lower(right(::ex_cond,6)) = '.and. '                // .and.
    ::ex_cond := substr(::ex_cond, 1, len(::ex_cond) -7)

  case lower(right(::ex_cond,5)) = '.or. '                 // .or.
     ::ex_cond := substr(::ex_cond, 1, len(::ex_cond) -6)

  endcase

  filtritw ->(dbGoTo(recs))
return .t.
