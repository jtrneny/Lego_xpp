#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
//
#include "..\A_main\ace.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


Static aVykaz, lVykaz
Static grpVyber,obdPrum
Static cmainfile
Static fileIn
Static konec

*
*
** CLASS FIN_finance_IN ********************************************************
CLASS  VYK_generuj_IN
EXPORTED:
  VAR  msg, dm, dc, df, ab
  VAR  state                                    // 0 - inBrowse  1 - inEdit  2 - inAppend
                                                // 'zav', 'poh', pok'

  METHOD init
  *
ENDCLASS


*
METHOD VYK_generuj_IN:init(parent,typ_lik,one_edt,que_del,has_foot)
  local drgDialog := parent:drgDialog, members, x, in_file

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  obdPrum := {{1,12},{2,1},{3,2},{4,3},{5,4},{6,5},{7,6},{8,7},{9,8},{10,9},{11,10},{12,11}}


RETURN self


** obecná funkce pro zobrazení øádkù výkazu DPH na SCR
function vyk_naplnvyk_in(vykaz,m_parent,ntypzpr)
  local ok := .T.
  local aFile := {}
  local key, cFiltr
  local sloupec
  local defvar
  local val, cx, nx, cc, cc1, aa, gg
//  local filein
  local tm, newit
  local vykaz_tm := {}, vykaz_sor := {}
  local vyber_tm := {}
  local i, j, k, l, n, nn, m
  local o, p
  local ni,nj, tmval := 0, tmarr, grpkey := {}
  local tm_nakl := {}
  local buffer, tmfile
//  local cmainfile, buffer, tmfile
  local nmax := 0
  local countrec
  local pa_mblock := {}, b_block, npos
  local field_name, odbd, odrgrf
  local alias, pa_sy
  local oldTag
  *
  local nsecBeg
//  local ntypZpr

  default ntypzpr to 0

  if ntypzpr = 0
    ntypzpr:= forms->ntypZpr
  endif

  if isobject( m_parent )
    if isMemberVar( m_parent:udcp, 'pa_grpkey')
      if isArray( m_parent:udcp:pa_grpkey)
        pa_sy := m_parent:udcp:pa_grpkey

        grpKey := {}
        aeval( pa_sy, { |x| if( ascan( grpKey, x) = 0, aadd( grpKey, x ), nil ) } )

//        grpKey := m_parent:udcp:pa_grpkey
      endif
    endif

    // 6 - 7 výbìro odbobí  8 - 9 výbìr roku tj. nabízem posední období roku
    if ntypZpr = 6 .or. ntypZpr = 7 .or. ntypZpr = 8 .or. ntypZpr = 9

      if .not. empty(forms->mblockfrm)
        cblock := upper(allTrim(forms->mblockfrm))
        if(npos := at('(',cblock)) <> 0
          cblock := subStr(cblock, 1, npos-1)
        endif
        asystem->(dbSeek(upper(cblock),,'ASYSTEM01' ))
      endif

      if .not. m_parent:udcp:isReport
        odialog := drgDialog():new('sys_obdReport_sel', m_parent)
        odialog:create(,,.T.)

        if .not. odialog:udcp:lcan_continue
          return .f.
        endif
      endif

      obdARR := ListAsArray( obdReport)
    endif
  endif

  drgDBMS:open('defvykhd')
  drgDBMS:open('defvykit')
  drgDBMS:open('defvykit',,,,,'defvykita')
  drgDBMS:open('defvyksy')
  drgDBMS:open('defvyksy',,,,,'defvyksya')
  drgDBMS:open('ucetsys')

  if( Select( 'vykazw') > 0, vykazw->( dbCloseArea()), nil)
  drgDBMS:open('vykazw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  cx       := Space(60)
  grpVyber := ''
  konec    := .f.

  if Left(vykaz,4)<>'DIST' .and. Left(vykaz,4)<>'USER'
    drgMsgBox(drgNLS:msg('Pozor u sestavy je nastaveno pùvodní volání definice výkazu a sestava nebude správnì zpracována ...'))
    drgMsgBox(drgNLS:msg('Je potøeba v èásti Servis-Tiskové výstupy spustit tlaèítko UpravVyk   ...'))
  endif

  if defvykhd->( dbseek( Upper(vykaz),,'DEFVYKHD03'))

    if .not. Empty(defvykhd->cidsysvykb)
      if defvyksya ->(dbSeek( Upper(defvykhd->cidsysvykb),,'DEFVYKSY03'))
         DBGetVal(defvyksya->mblock)
      endif
    endif

    cFiltr := Format("Upper(cIDVykazu) == '%%' .and. Upper(cTypKumVyk) <> '00'", {Upper(defvykhd->cIDVykazu)})
    defvykit->(ads_setaof(cFiltr),dbGoTop())

    defvykit->( AdsSetOrder('DEFVYKIT12'), dbGoBotTom())
    i := defvykit->nRadekVyk
    defvykit->( AdsSetOrder('DEFVYKIT11'), dbGoBotTom())
    j := defvykit->nSloupVyk
    avykaz := Array(i,j)
    for k:=1 to Len(avykaz)
      for l:=1 to Len(avykaz[k])    ;      avykaz[k,l] := {0,{}}    //  1 - hodnota, 2 - pole
      next
    next
    lvykaz  := Array(i,j)
    for k:=1 to Len(lvykaz)
      for l:=1 to Len(lvykaz[k])    ;      lvykaz[k,l] := .f.
      next
    next

    defvykit->(ads_clearaof())

    cFiltr := Format("Upper(cIDvykazu) == '%%'", {Upper(defvykhd->cIDvykazu)})
    defvykit->(ads_setaof(cFiltr),dbGoTop())
    defvykit->( DbSetRelation( 'defvyksy',  { || Upper(defvykit->cidsysvykn)},'Upper(defvykit->cidsysvykn)','DEFVYKSY03'))
    defvykit->(dbSkip(0))

    defvykit->( AdsSetOrder('DEFVYKIT13'))
    countrec := defvykit->( mh_COUNTREC())
    defvykit->(dbGoTop())

    ** jedeme zpracování podladù pro tisk
    drgServiceThread:progressStart(drgNLS:msg('Zpracování podkladù ... ', 'DEFVYKIT'), ;
                                               countrec  )

//    defvyksy ->(dbSeek( Upper(defvykit->cidsysvykn),,'DEFVYKSY03'))
    if .not. Empty(defvyksy->mgrpvyber)

      cmainfile := AllTrim( defvyksy->cgrptable)
      if select(cmainfile) = 0
        if substr(upper(cmainfile), len(cmainfile), 1) = 'W'
          drgDBMS:open(cmainfile,.T.,.T.,drgINI:dir_USERfitm); ZAP
        else
          drgDBMS:open(cmainfile)
        endif
      endif

//  !!!!!!  je potøeba doøešit obecné zadání klíèe pro výbìr skupin
      buffer   := StrTran(MemoTran(defvyksy->mgrpvyber,chr(0)), ' ', '')
      grpVyber := buffer

      if at( ':', buffer) <> 0
        pa_sy    := listAsArray( buffer, ':' )
        grpVyber := strTran( strTran( pa_sy[2], ' ', ''), '%%->', '')
      endif


// výbìr klíèù do sestavy - výpisy sestav
      if len(grpkey) = 0
        obd   := Val(SubStr(obdReport,4,4) +SubStr(obdReport,1,2))
        filtr := Format("nRokObd = %%", {obd})
        (cmainfile)->( ads_setaof(filtr), dbGoTop())
        o := 0
        do while .not. (cmainfile)->( Eof())      /// .and. o <= 1
          if ( npos := ascan( grpkey, { |x| x = (cmainfile)->croobcpppv} )) = 0
            AAdd( grpkey, (cmainfile)->croobcpppv)
          endif
          (cmainfile)->(dbSkip())
          o++
        enddo
        (cmainfile)->( dbGoTop())
      endif
    else
      AAdd( grpkey, 0)
    endif

// nápoèet do vykazw
//   nsecBeg := seconds()


    do while .not.defvykit->(Eof())
      if konec
        return nil
      endif

      if len(grpKey) > 1
        for x := 1 to len(grpKey) step 1
          nR  := defvykit->nRadekVyk
          nS  := defvykit->nSloupVyk
          cky := grpKey[x]

          aadd( avykaz[ nR, nS, 2], { cky, 0 } )
         next
       endif


//      defvyksy ->(dbSeek( Upper(defvykit->cidsysvykn),,'DEFVYKSY03'))
//      for k := 1 to Len(grpkey)
        do case
        case Left(defvykit->ctypkumvyk,1) == 'K'
          lvykaz[defvykit->nRadekVyk,defvykit->nSloupVyk] := .t.

          if At(',', Alltrim(defvyksy->cmainfile)) > 0
            filein := AllTrim( Left( defvyksy->cmainfile, At( ',',Alltrim(defvyksy->cmainfile)) - 1))
            alias  := AllTrim( SubStr( defvyksy->cmainfile, At( ',',Alltrim(defvyksy->cmainfile)) + 1))
          else
            filein := Alltrim(defvyksy->cmainfile)
            alias  := Alltrim(defvyksy->cmainfile)
          endif

          if select(alias) = 0
            if substr(upper(filein), len(filein), 1) = 'W'
              drgDBMS:open(filein,.T.,.T.,drgINI:dir_USERfitm); ZAP
            else
              if filein <> alias
                drgDBMS:open(filein,,,,,alias)
              else
                drgDBMS:open(filein)
              endif
            endif
          endif

          filein := alias
  *---        drgDBMS:open(file)
          if vyk_okvyber( grpkey,defvyksy->cmainvyber)
            if .not. Empty(defvyksy->mblock)

              if ( npos := ascan( pa_mblock, { |x| x[1] = defvyksy->cidsysVyk } )) <> 0
                b_block := pa_mblock[npos,2]
              else
                b_block := COMPILE( defvyksy->mblock)
                aadd( pa_mblock, { defvyksy->cidsysVyk, b_block } )
              endif

              (filein)->(dbGoTop())

              do while .not. (filein)->(Eof())
                do case
                case defvykit->ctypkumvyk == 'K1'
                  cx := Space(60)
**                  avykaz[defvykit->nRadekVyk,defvykit->nSloupVyk,1] +=  DBGetVal(defvyksy->mblock)
                  avykaz[defvykit->nRadekVyk,defvykit->nSloupVyk,1] += Eval(b_block)

                case defvykit->ctypkumvyk == 'K2' .or. defvykit->ctypkumvyk == 'K3'         ;
                       .or. defvykit->ctypkumvyk == 'K4' .or. defvykit->ctypkumvyk == 'K5'  ;
                        .or. defvykit->ctypkumvyk == 'K6'
                  nx := (fileIn)->(FieldPos( defvyksy->cmainfield))
                  cc := ValType((fileIn)->(FieldGet(nx)))

                  do case
                  case defvykit->ctypkumvyk == 'K6'
                    odbd   := drgDBMS:dbd:getByKey(filein)
                    nx         := (filein)->(FieldPos( grpVyber))
                    field_name := (filein)->(FieldName(nx))
                    odrgrf := odbd:getFieldDesc(field_name)

                    do case
                    case odrgrf:type == 'N'
                      cx := StrZero((filein)->(FieldGet(nx)), odrgrf:len)
                    case odrgrf:type == 'C'
                      cx := Padr((filein)->(FieldGet(nx)), odrgrf:len)
                    endcase

                    nx         := (filein)->(FieldPos( defvyksy->cmainVyber))
                    field_name := (filein)->(FieldName(nx))
                    odrgrf     := odbd:getFieldDesc(field_name)

                    do case
                    case odrgrf:type == 'N'
                      cx := cx + StrZero((filein)->(FieldGet(nx)), odrgrf:len)
                    case odrgrf:type == 'C'
                      cx := cx +Padr((filein)->(FieldGet(nx)), odrgrf:len)
                    endcase

                    cx := Padr( cx, 60)


                  case defvykit->ctypkumvyk == 'K5'
                    if at( '(', grpVyber) <> 0
                      cx := (filein)->( DBGetVal(grpVyber))
                      cc := ValType(cx)
                      do case
                      case cc == 'N'
                        cx := StrZero( cx, 60)
                      case cc == 'C'
                        cx := Padr(    cx, 60)
                      endcase
                    else
                      nx := (filein)->(FieldPos( grpVyber))
                      cc := ValType((filein)->(FieldGet(nx)))
                      do case
                      case cc == 'N'
                        cx := StrZero((filein)->(FieldGet(nx)), 60)
                      case cc == 'C'
                        cx := Padr((filein)->(FieldGet(nx)), 60)
                      endcase
                    endif

                  case defvykit->ctypkumvyk == 'K3'
                    cx := NaklKeyUcKuw()
                  case defvykit->ctypkumvyk == 'K4'
                    cx := Left( NaklKeyUcKuw(), 48)
                  case cc == 'N'
                    cx := StrZero((fileIn)->(FieldGet(nx)), 60)
                  case cc == 'C'
                    cx := Padr((fileIn)->(FieldGet(nx)), 60)
                  otherwise
                    cx := Space(60)
                  endcase

                  ni := defvykit->nRadekVyk
                  nj := defvykit->nSloupVyk

**                  tmval := DBGetVal(defvyksy->mblock)
                  tmval := Eval(b_block)
                  m := aScan(avykaz[ni,nj,2], {|x| x[1] = cx})
                  if m = 0
                    AAdd(avykaz[ni,nj,2], {cx, tmval})
  *                 AAdd(avykaz, {cx})
                  else
                    avykaz[ni,nj,2, m, 2] += tmval
                  endif
                  avykaz[ni,nj,1] += tmval
                endcase

                (filein)->(dbSkip())
              enddo
            endif
          endif

        case Left(defvykit->ctypkumvyk,1) == 'F'
          b_block := COMPILE( defvyksy->mblock)
          lvykaz[defvykit->nRadekVyk,defvykit->nSloupVyk] := .t.

          do case
          case defvykit->ctypkumvyk == 'F1'
            avykaz[defvykit->nRadekVyk,defvykit->nSloupVyk,1] += Eval(b_block)
          endcase

        case Left(defvykit->ctypkumvyk,1) == 'V'
          do case
          case defvykit->ctypkumvyk == 'V0'
            lvykaz[defvykit->nRadekVyk,defvykit->nSloupVyk] := .t.
            avykaz[defvykit->nRadekVyk,defvykit->nSloupVyk,1] := 0

          case defvykit->ctypkumvyk == 'V1'
            if .not. Empty( defvykit->mvyraz)
              tm    := upravvyr( defvykit->mvyraz)
              tm[1] := AllTrim(str(defvykit->nRadekVyk)) + ','                ;
                         +AllTrim(str(defvykit->nSloupVyk))+ ':=' +tm[1]
              AAdd(vykaz_tm, tm)
            endif
          case defvykit->ctypkumvyk == 'V2'
            lvykaz[defvykit->nRadekVyk,defvykit->nSloupVyk] := .t.
            avykaz[defvykit->nRadekVyk,defvykit->nSloupVyk,1] := 0

          case defvykit->ctypkumvyk == 'V3'
            if .not. Empty( defvykit->mvyraz)
              tm    := upravvyr( defvykit->mvyraz)
              tm[1] := AllTrim(str(defvykit->nRadekVyk)) + ','                ;
                         +AllTrim(str(defvykit->nSloupVyk))+ ':=' +tm[1]
              AAdd(vykaz_tm, tm)
            endif
          endcase
        endcase
//      next
      drgServiceThread:progressInc()
      defvykit->(dbSkip())
    enddo

//    drgDump( seconds() -nsecBeg )

    drgServiceThread:progressEnd()

// vytvoøení prázdných bunìk pro neexistující klíèe
    countrec := defvykit->( mh_COUNTREC())
    defvykit->(dbGoTop())

    ** jedeme zpracování podladù pro tisk
    drgServiceThread:progressStart(drgNLS:msg('Vytvoøení prázdných polí ... ', 'DEFVYKIT'), ;
                                               countrec  )

    do while .not.defvykit->(Eof())
      ni := defvykit->nRadekVyk
      nj := defvykit->nSloupVyk

      do case
      case defvykit->ctypkumvyk == 'K5'

        for k := 1 to Len(grpkey)
          cx := grpkey[k]
          m := aScan(avykaz[ni,nj,2], {|x| x[1] = cx})
          if m = 0
            AAdd(avykaz[ni,nj,2], {cx, 0})
          endif
        next
      endcase

      if defvykit->ntypzaokr = 1
        if defvykit->nkodzaokr <> 1 .and. avykaz[ni,nj,1] <> 0
          avykaz[ni,nj,1] := mh_roundnumb( avykaz[ni,nj,1], defvykit->nkodzaokr)
        endif
      endif

      drgServiceThread:progressInc()
      defvykit->(dbSkip())
    enddo

    drgServiceThread:progressEnd()

/*
    if Len(grpkey) = 1
      if grpkey[1] = 0
        grpkey := {}
        for ni := 1 to Len(avykaz)
          for nj := 1 to Len(avykaz[ni])
            if .not. Empty( avykaz[ni,nj,2])
              for k := 1 to len( avykaz[ni,nj,2])
                cx := avykaz[ni,nj,2,k,1]
                m := aScan(grpkey, {|x| x = cx})
                if m = 0
                  AAdd(grpkey, cx)
                endif
              next
            end
          next
        next
      endif
    endif
*/


*     defvykhd->(dbrlock())
*     defvykhd->mpoznamka := ""
*     for n := 1 to Len(vykaz_tm)
*       defvykhd->mpoznamka += vykaz_tm[n,1] + ', '+vykaz_tm[n,2] +CRLF
*     next

// zpracování bloku pro výrazy
    if .not. Empty(vykaz_tm)
      n := 1

      do while len(vykaz_tm) > 0  // <> len(vykaz_sor)
        if n > len(vykaz_tm)
          EXIT
        endif
        newit := .t.
        tm := ListAsArray( vykaz_tm[n,2], ':')
        for nn := 1 to Len(tm)
          aa := tm[nn]
          if .not. Eval(COMPILE(aa))
            newit := .f.
            exit
          endif
        next
        if newit
          AAdd( vykaz_sor, vykaz_tm[n,1])
          tm := ListAsArray( vykaz_tm[n,1], ':=')
          tm := ListAsArray( tm[1], ',')
            o  := Val(tm[1])
          p  := Val(tm[2])
          lvykaz[o,p] := .t.

          ARemove( vykaz_tm, n)
          n := 1
        else
          n++
        end
      enddo

*      defvykhd->(dbrlock())
*      defvykhd->mpoznamka := ""
      for n := 1 to Len(vykaz_sor)
*        defvykhd->mpoznamka += vykaz_sor[n] + CRLF
        nx := At(':=', vykaz_sor[n])
        cc := SubStr(vykaz_sor[n], nx+2)
*        cc := StrTran(cc,Chr(13),'')
        aa := Left( vykaz_sor[n], nx-1)
        i :=  Val(Left( vykaz_sor[n], At(',', aa)-1))
        j :=  Val(SubStr(vykaz_sor[n], At(',', aa)+1))

        aVykaz[i,j,1] := Eval(COMPILE(cc))

        if Len(grpkey) > 1
          for k := 1 to Len(grpkey)
            cx := grpkey[k]
            aa := ',' +AllTrim(Str(k,,0)) +')'
            gg := StrTran(cc, 'afvykaz','afvykazg')
            gg := StrTran(gg, ')', aa)
            if( m := aScan(avykaz[i,j,2], {|x| x[1] = cx}) ) <> 0
              avykaz[i,j,2,m,2] := Eval(COMPILE(gg))
            endif

*           if m = 0
*             nx := Eval(COMPILE(gg))
*             AAdd(avykaz[i,j,2], {cx, nx})
*            endif
          next
        endif

      next
    endif

// zápis do vykazw
    defvykit->( OrdSetFocus('DEFVYKIT08'))
    defvykit->(dbGoTop())
    do while .not.defvykit->(Eof())

//      if .not. Empty(defvykit->cidsysvykb)
//        if defvyksya ->(dbSeek( Upper(defvykit->cidsysvykb),,'DEFVYKSY03'))
//           DBGetVal(defvyksya->mblock)
//        endif
//      endif

      do case
      case defvykit->ctypkumvyk == 'K2' .or. defvykit->ctypkumvyk == 'K3'         ;
            .or. defvykit->ctypkumvyk == 'K4' .or. defvykit->ctypkumvyk == 'K5'   ;
             .or. defvykit->ctypkumvyk == 'K6'
        if .not. Empty( avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2] )
          for n := 1 to Len( avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2])
            if .not. Empty(defvykit->cidsysvykb)
              if defvyksya ->(dbSeek( Upper(defvykit->cidsysvykb),,'DEFVYKSY03'))
                DBGetVal(defvyksya->mblock)
              endif
            endif

            cx  := avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,1]

            do case
            case defvykit->ctypkumvyk == 'K2'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Upper(Padr(cx, 60))+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                AktObdVykw()
              endif
              vykazw->ckey := cx

            case defvykit->ctypkumvyk == 'K3'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Upper(Padr(cx, 60))+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                AktObdVykw()
              endif
              vykazw->ckey := cx
              vykazw->ctmpkey := Left( cx, 48)

            case defvykit->ctypkumvyk == 'K4'
              cx := Left( cx, 48)
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Upper(Padr(cx, 60))+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                AktObdVykw()
              endif
              vykazw->ckey := cx
*              cc := Left( cx, 48)
              cc := cx
              vykazw->ctmpkey := cx

              if Ascan( tm_nakl, cc) = 0
                AAdd( tm_nakl, cc)
              endif

            case defvykit->ctypkumvyk == 'K5'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Upper(Padr(cx, 60))+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                AktObdVykw()
              endif

              vykazw->ckey := cx

              sloupec := vykazw->(fieldpos('csloupec' +StrZero(defvykit->nsloupvyk,2)))
              vykazw->(fieldput(sloupec, Left( defvykit->cnazradvyk, 27) +Left( defvykit->cTextTm1, 3)))

            case defvykit->ctypkumvyk == 'K6'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Upper(Padr(cx, 60))+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                AktObdVykw()
              endif

              vykazw->ckey := cx

              sloupec := vykazw->(fieldpos('csloupec' +StrZero(defvykit->nsloupvyk,2)))
              vykazw->(fieldput(sloupec, Left( defvykit->cnazradvyk, 27) +Left( defvykit->cTextTm1, 3)))
            endcase

            sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))

            if defvykit->ntypzaokr = 0
              vykazw->(fieldput(sloupec, mh_roundnumb(avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,2],defvykit->nkodzaokr)))
            else
              vykazw->(fieldput(sloupec, avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,2]))
            endif

            if .not. Empty(defvykit->cidsysvyke)
              if defvyksya ->(dbSeek( Upper(defvykit->cidsysvyke),,'DEFVYKSY03'))
                DBGetVal(defvyksya->mblock)
              endif
            endif
          next
        endif
*        cx  := replicate('ž',25)
*        key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
*                  +Upper(defvykit->cskupina3)+ Upper(cx)+StrZero(defvykit->nRadekVyk,4)
*        if( .not. vykazw->(dbSeek(key)), mh_COPYFLD('defvykit', 'vykazw', .T.), nil)
*        vykazw->ckey := replicate('ž',25)
*        sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))
*        vykazw->(fieldput(sloupec, mh_roundnumb(avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,1],defvykit->nkodzaokr)))
      otherwise
        for n := 1 to len( grpkey)
          if len( grpkey) > 1
            cx := grpkey[n]
          endif

          if .not. Empty(defvykit->cidsysvykb)
            if defvyksya ->(dbSeek( Upper(defvykit->cidsysvykb),,'DEFVYKSY03'))
              DBGetVal(defvyksya->mblock)
            endif
          endif

          key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                +Upper(defvykit->cskupina3)+ Upper(Padr(cx,60))+ StrZero(defvykit->nRadekVyk,4)
          if .not. vykazw->(dbSeek(key,,'VYKAZw01'))
            mh_COPYFLD('defvykit', 'vykazw', .T.)
            vykazw->ckey := cx
            AktObdVykw()
          endif

//          oldTAG := vykazw->( AdsSetOrder( 'VYKAZw01'))
//          vykazw ->( Ads_SetScope(SCOPE_TOP   , key), ;
//                     Ads_SetScope(SCOPE_BOTTOM, key), DbGoTop() )

//          do while .not. vykazw->( eof())
            if defvykit->ctypkumvyk == 'V2' .or. defvykit->ctypkumvyk == 'V3'
              if .not. Empty( cx)
                vykazw->ctmpkey := Left( cx, 48)
              endif
            endif

            do case
            case defvykit->ctypkumvyk = 'B1'
              if defvyksya ->(dbSeek( Upper(defvykit->cidsysvykn),,'DEFVYKSY03'))
                sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))
                aa := DBGetVal(defvyksya->mblock)
                if defvykit->ntypzaokr = 0
                  vykazw->(fieldput(sloupec, mh_roundnumb( aa,defvykit->nkodzaokr)))
                else
                  vykazw->(fieldput(sloupec, aa))
                endif
              endif
            case defvykit->ctypkumvyk = 'B2'
              if defvyksya ->(dbSeek( Upper(defvykit->cidsysvykn),,'DEFVYKSY03'))
                sloupec := vykazw->(fieldpos('csloupec' +StrZero(defvykit->nsloupvyk,2)))
                aa := DBGetVal(defvyksya->mblock)
                vykazw->(fieldput(sloupec, aa ))
              endif
            otherwise
              if defvykit->ctypkumvyk <> '00'
                if len( grpkey) > 1 .and. Len( avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2])> 0
                  sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))
                  if defvykit->ntypzaokr = 0
                    vykazw->(fieldput(sloupec, mh_roundnumb(avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,2],defvykit->nkodzaokr)))
                  else
                    vykazw->(fieldput(sloupec, avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,2]))
                  endif
                else
                  sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))
                  if defvykit->ntypzaokr = 0
                    vykazw->(fieldput(sloupec, mh_roundnumb(avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,1],defvykit->nkodzaokr)))
                  else
                    vykazw->(fieldput(sloupec, avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,1]))
                  endif
                endif
              endif
            endcase
            if .not. Empty(defvykit->cidsysvyke)
              if defvyksya ->(dbSeek( Upper(defvykit->cidsysvyke),,'DEFVYKSY03'))
                DBGetVal(defvyksya->mblock)
              endif
            endif

//            vykazw->( dbSkip())
//          enddo
//          vykazw->( Ads_ClearScope(SCOPE_TOP)   , ;
//                    Ads_ClearScope(SCOPE_BOTTOM) )
//          vykazw->( AdsSetOrder( oldTAG))
        next
      endcase

//      if .not. Empty(defvykit->cidsysvyke)
//        if defvyksya ->(dbSeek( Upper(defvykit->cidsysvyke),,'DEFVYKSY03'))
//           DBGetVal(defvyksya->mblock)
//        endif
//      endif

      defvykit->(dbSkip())
    enddo

    if .not. Empty( tm_nakl)
      defvykit->(dbGoTop())
      do while .not.defvykit->(Eof())
          for n := 1 to Len( tm_nakl)
            cx  := tm_nakl[n]
            key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                    +Upper(defvykit->cskupina3)+ Padr(cx,60)+StrZero(defvykit->nRadekVyk,4)
            if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
              mh_COPYFLD('defvykit', 'vykazw', .T.)
              vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
              vykazw->ckey    := cx
              vykazw->ctmpkey := cx
            endif
          next
        defvykit->(dbSkip())
      enddo
    endif

    vykazw->(dbGoTop())
    defvykit->(ads_clearaof())

    if At( 'MZD_VyplPas', defvykhd->ctypvykazu) > 0

      drgDBMS:open('msprc_mo',,,,,'msprc_mox')
      do while .not. vykazw->( Eof())
        if msprc_mox->( dbSeek( Left(vykazw->ckey,15),,'MSPRMO17'))
          vykazw->csortkey1 := msprc_mox->cjmenorozl
          vykazw->csortkey2 := msprc_mox->cvyplmist
          vykazw->csortkey3 := msprc_mox->ckmenstrpr
        endif
        vykazw->( dbSkip())
      enddo

      msprc_mox->( dbCloseArea())
    endif

    vykazw->(dbGoTop())
    if .not. Empty(defvykhd->cidsysvyke)
      if defvyksya ->(dbSeek( Upper(defvykhd->cidsysvyke),,'DEFVYKSY03'))
         DBGetVal(defvyksya->mblock)
      endif
    endif

  else
    drgMsgBox(drgNLS:msg('Pozor nastavená definice výkazu u sestavy neexistuje ...'))
    ok := .F.
  endif

return(ok)

function vyk_okvyber(grpkey,vardef)
  local lok := .f.
  local n
  local filtr := ''
  local arr, atmp, ctmp, cx
  local oldset
*  local vardef := AllTrim(defvyksy->cmainvyber)
*  local cfile  := Alltrim(defvyksy->cmainfile)
  local nrok, nobdobi
  local buffer, con, cnt := 1, filtrtm, arg := {}, cc
  local podminka := .f.
  *
  nROK    := Val(SubStr(obdReport,4,4))      //uctOBDOBI:UCT:NROK
  nOBDOBI := Val(SubStr(obdReport,1,2))      //uctOBDOBI:UCT:NOBDOBI

*  ucetsys->( dbSeek( Upper('U')+StrZero(nrok,4)+StrZero(nobdobi,2)), 'UCETSYS3')

  if .not. Empty(defvykit->mVyber)
    arr := mh_Token(defvykit->mVyber,',')
    if( Empty(arr), AAdd(arr, AllTrim(defvykit->mVyber)), nil)

    if Len(arr) = 1 .and. arr[1] = '*'
    else
    for n:=1 to Len(arr)
      if at('..',arr[n])> 0
        atmp := mh_Token(arr[n],'..')

//  !!!!!!!   je potøeba doøešit volání podle typovosti promìnných
        if At("DRUHMZDY", vardef) > 0
          ctmp := '(' + formstr(vardef,atmp[1]) +'>=' +atmp[1]+ '.and.'+ formstr(vardef,atmp[2]) +'<=' +atmp[2]+ ')'
        else
          ctmp := '(' + formstr(vardef,atmp[1]) +'>=' +"'" +atmp[1]+ "'"+'.and.'+ formstr(vardef,atmp[2]) +'<=' +"'" +atmp[2]+ "'"+')'
        endif
      else
        if At("DRUHMZDY", vardef) > 0
          ctmp := formstr(vardef,arr[n]) +'='+ arr[n]
        else
          ctmp := formstr(vardef,arr[n]) +'='+ "'" +arr[n]+ "'"
        endif
      endif

      filtr += if( .not. Empty(filtr), '.or.', '') + ctmp
    next
    endif
    buffer := StrTran(MemoTran(defvyksy->mpodminka,chr(0)), ' ', '')

    while( asc(buffer) <> 0 .and. (i := at(chr(0), buffer)) > 0 )
      * nrok = %% .and. nobdobi = %%
      * Val(SubStr(obdReport,4,4))-1
      * Val(SubStr(obdReport,1,2))
      *
      ** na prvním øádku je výraz pro fitr
      ** na dalších øádcích jsou honoty pro nastavené
      if cnt = 1   ;   filtrtm := substr( buffer,1,i -1)
      else
        cc := substr(buffer,1,i -1)
        cx := '{|| ' +cc  +' }'
        val := eval(&(cx))
        aadd(arg, val)
      endif

      cnt++
      buffer := substr(buffer, i +1)
    end
    cx := format(filtrtm,arg)

*    cx := 'ucetkumu->nrok=' + Str(nrok,4) +' .and. ucetkumu->nobdobi=' + Str(nobdobi,2)
*    cx := Format("nROK = %% .and. nOBDOBI = %%", {nROK, nOBDOBI})
*    filtr := filtr + if( .not. Empty(AllTrim(cX)), '.and.' +AllTrim(cX),'')
    oldset := Set(_SET_EXACT, .f. )

    if .not. Empty(cX)
      if .not. Empty( filtr)
        filtr := '(' + filtr+ ').and.' +AllTrim(cX)
      else
        filtr := AllTrim(cX)
      endif
      podminka := .t.
    endif

    if .not. Empty( grpVyber)
      filtrtm := '('
      for n := 1 to len( grpKey)
        filtrtm += grpVyber +' ='+ "'" +grpKey[n]+ "'" + if( n < len( grpKey),'.or.',')')
      next

      filtr := filtrtm + '.and.(' + filtr+ ')'


*      cX := grpVyber
*      ctmp := formstr( grpVyber, grpKey) +'='+ "'" +grpKey+ "'"
*      cX   := ctmp

*      if .not. Empty(cX)

///////   !!!!!!!  nutno doøešit obecné zadání klíèe a jeho volání
//        filtr := 'Upper('+ grpVyber +') ='+ "'" +grpKey+ "'" + '.and.(' + filtr+ ')'
*//   filtr := grpVyber +' ='+ "'" +grpKey+ "'" + '.and.(' + filtr+ ')'
*        filtr := AllTrim(cX) + '.and.(' + filtr+ ')'

*        filtr := if( podminka, filtr + '.and.' ,'(' + filtr+ ').and.')
*        filtr := filtr + AllTrim(cX)
*      endif
    endif

    if At( '.', AllTrim(filtr)) = 1 .or. At( '(.', AllTrim(filtr)) = 1
      drgMsgBox(drgNLS:msg('Pozor chybnì nastavený filtr pro výbìr v rámci výkazù ...'))
      konec := .t.
      lok   := .f.
    else
//      drgDump(str(defvykit->nRadekVyk,4,0)+','+str(defvykit->nsloupvyk,4,0))
//      drgDump(filtr)
      (fileIn)->( ads_setaof(filtr), dbGoTop())
      Set(_SET_EXACT,oldset)
      lok := .not. (fileIn)->(eof())
    endif
  endif

return(lok)

function formstr(val,lenval)
  local ret, num

  if Type( val) == 'C'
    num := Len(lenval)
    ret := 'SubStr(' + val + ',1,'+ AllTrim(Str(num))+')'
  else
    ret := val
  endif

return(ret)


function upravvyr( vyraz)
  local znak := {'A','B','C','D','E','F','G','H','I','J'}
  local cis  := {'1','2','3','4','5','6','7','8','9','0'}
  local znakvyr := {'(',')','/','+','-',':','*',':','='}
  local aa, cc, vv, vvz, vvc, cx
  local cctm, aatm
  local n, nn, m, mm
  local bunky := {}
  local ret := {'',''}

  cc   := AllTrim(vyraz)
  cc   := StrTran(cc,Chr(13),'')
  cc   := StrTran(cc,Chr(10),'')
  cctm := cc

  aEval(znakvyr, {|x| cctm := StrTran( cctm, x, '\') } )
  aatm := listAsArray(cctm, '\')

  for n := 1 to Len(aatm)
    if .not. Empty( aatm[n])
      vvc := ''
      mm  := 0
      for nn := 1 to Len(aatm[n])
        m := aScan( znak, SubStr( aatm[n],nn,1))
        if m > 0
          vvc := vvc +cis[m]
          mm++
        else
          exit
        endif
      next
      if mm > 0
        AAdd( bunky, {aatm[n],'afvykaz(' +AllTrim(SubStr(aatm[n], nn)) +',' + vvc +')'})
        ret[2] := ret[2] + 'lfvykaz('+ AllTrim(SubStr(aatm[n], nn)) +',' + vvc +'):'
      endif
    endif
  next

  ASort( bunky,,, {|aX,aY| Len(aX[1]) > Len(aY[1]) } )
  aEval(bunky, {|x| cc := StrTran( cc, x[1],x[2])})

  ret[1] := cc
  ret[2] := Left(ret[2], Len(ret[2])-1)
return(ret)

/*
function upravvyr( vyraz)
  local znak := {'A','B','C','D','E','F','G','H','I','J'}
  local cis  := {'1','2','3','4','5','6','7','8','9','0'}
  local nod, ndo
  local aa, cc, vv, vvz, vvc
  local n, nn, m, j
  local znod, ciod
  local ok := .t.
  local okzn, okci
  local ret := {'',''}

  cc   := AllTrim(vyraz)
  cc   := StrTran(cc,Chr(13),'')
  cc   := StrTran(cc,Chr(10),'')
  znod := 1
  nod  := 1

  do while nod > 0
    n    := 1
    ndo  := 0
    okzn := okci := .t.
    vvz  := vvc  := ''

    for nn := 1 to 10
      n := At( znak[nn], cc, znod)
      if n > 0
        if( ndo == 0, ndo := n-1, nil)
        vvz := vvz + znak[nn]
        do while okzn
          (n++, aa := SubStr( cc, n, 1), j := aScan( znak, aa))
          if j > 0
            vvz := vvz + znak[j]
          else
            ( okzn := .f., j := aScan( cis, aa))
            if j > 0
              vvc := vvc + cis[j]
              do while okci
                (n++, aa := SubStr( cc, n, 1), j := aScan( cis, aa))
                if( j > 0, vvc := vvc + cis[j], okci := .f.)
              enddo
            endif
          endif
        enddo
        znod := n
      endif

      do case
      case .not. okzn .and. .not. okci
        EXIT
      case (okzn .and. .not. okci) .or. (.not. okzn .and. okci)
        ( vvz := '', vvc := '')
        EXIT
      endcase
    next

    vv := ''
    for nn := 1 to len(vvz)
      m := aScan( znak, SubStr( vvz, nn, 1))
      vv := vv + Str(m,1)
    next

    if n > 0
      ret[1] := ret[1] + if(ndo>=nod,SubStr(cc,nod,ndo-nod+1),'') +'afvykaz(' +vvc +',' +vv +')'
      ret[2] := ret[2] + 'lfvykaz(' +vvc +',' +vv +')'+':'
    else
      if nod <= Len( cc)
        ret[1] := ret[1] + SubStr(cc,nod,nod-Len(cc)+1)
      endif
      ret[2] := Left(ret[2], Len(ret[2])-1)
    endif
    nod := n
  enddo

return(ret)

*/


Function afVykaz(n,m)
Return( aVykaz[n,m,1])

Function afVykazg(n,m,g)
Return( aVykaz[n,m,2,g,2])


Function lfVykaz(n,m)
Return( lVykaz[n,m])


Function NaklKeyUcKuw()
  local cret := ''
  local n, nx, cc
  local ans[6]

  c_naklstw->(dbGoTop())
  do while .not. c_naklstw->( Eof())
    if c_naklstw->nporadi > 0
      ans[c_naklstw->nporadi] := alltrim(c_naklstw->citems_ns)
    endif
    c_naklstw->(dbskip())
  enddo

  for n := 1 to 6
    if .not. Empty( ans[n])
      nx   := (fileIn)->(FieldPos( ans[n]))
      cret += (fileIn)->(FieldGet(nx))
    endif
  next

  n    := (fileIn)->(FieldPos( defvyksy->cmainfield))
  cret := Padr( Padr(cret,48) +(fileIn)->(FieldGet(n)), 60)

Return(cret)


Function EndSumNakVys(typ)
  local  colum
  local  val
  local  n
  local  cfindkey
  local  ctmkey := ''
  local  atmkey := {}

  default typ to 0

  drgDBMS:open('vykazww',.T.,.T.,drgINI:dir_USERfitm); ZAP


  do while .not. vykazw->( Eof())

    cfindkey := Upper(Padr(Space(48)+SubStr( vykazw->ckey,49,6),60))
//                 + StrZero(vykazw->nRadekVyk,4)

    if vykazww->( dbSeek(cfindkey,,'VYKAZww01'))
      for n := 1 to 49
        colum := vykazw->(fieldpos( 'nsloupec' + StrZero(n,2)))
        val   := vykazw->(fieldget(colum))+ vykazww->(fieldget(colum))
        vykazww->(fieldput(colum, val))
      next
    else
      val := 0
      mh_COPYFLD('vykazw', 'vykazww', .T.)
      vykazww->ckey := Space(48)+SubStr( vykazw->ckey,49,6)
    endif

    if aScan( atmkey, vykazw->ctmpkey) = 0
      AAdd( atmkey,vykazw->ctmpkey)
    endif

    vykazw->(dbskip())
  enddo

  if( typ = 1, vykazw->(dbZap()), nil)

  aEval( atmkey,{|x| ctmkey += AllTrim(x)+','})
  ctmkey := Left( ctmkey,Len(ctmkey)-1)
  vykazww->(dbGoTop())
  do while .not. vykazww->( Eof())
    mh_COPYFLD('vykazww', 'vykazw', .T.)
    vykazw->ctmpkey := Chr(254)+Chr(254)+Chr(254)
    vykazw->ntmpkey := 1
    vykazw->mtmpkey := ctmkey
    vykazww->(dbskip())
  enddo
  vykazww->( dbCloseArea())

  vykazw->(dbGoTop())

Return( nil)

static function AktObdVykw()

  vykazw->cobdobi := SubStr(obdReport,1,3)+ SubStr(obdReport,6,2)
  vykazw->nrok    := Val(SubStr(obdReport,4,4))
  vykazw->nobdobi := Val(SubStr(obdReport,1,2))
  vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))

return( nil)