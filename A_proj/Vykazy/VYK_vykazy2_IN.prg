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
Static grpVyber
Static grpVyber_K
Static primaryTAB
//Static obdKeyML

** obecná funkce pro zobrazení øádkù výkazu DPH na SCR
function vyk_naplnvyk2_in(vykaz,m_parent)
  local ok := .T.
  local aFile := {}
  local key, cFiltr
  local sloupec
  local defvar
  local val, cx, nx, cc, aa
  local filein
  local tm, newit
  local vykaz_tm := {}, vykaz_sor := {}
  local vyber_tm := {}
  local i, j, k, l, n, nn, m
  local o, p, r
  local ni,nj, tmval := 0, tmarr
  local grpkey   := {},grpkeyCP := {}
  local grpkeyV0 := {}
  local tm_nakl := {}
  local cmainfile, buffer, ckeyCP
  local nmax := 0
  local countrec
  local pa_mblock := {}, b_block, npos
  local adef := {}
  *
  local nsecBeg
  local cblock, odialog, nexit, cold_obdReport := obdReport
  local rokML, obdML, obdARR
  local ntypZpr := forms->ntypZpr, pa_sy


  obdKeyML := StrZero( uctOBDOBI:MZD:NROKOBD,6)

  if isobject( m_parent )
    if isMemberVar( m_parent:udcp, 'pa_grpkey')
      if isArray( m_parent:udcp:pa_grpkey)
        pa_sy := m_parent:udcp:pa_grpkey

        grpKey := {}
        aeval( pa_sy, { |x| if( ascan( grpKey, x) = 0, aadd( grpKey, x ), nil ) } )

        if( select('prsmldoh') > 0, prsmldoh->(ads_clearaof(), dbGoTop()), nil)
        if( select('msodppol') > 0, msodppol->(ads_clearaof(), dbGoTop()), nil)
        if( select('vazosoby') > 0, vazosoby->(ads_clearaof(), dbGoTop()), nil)
        if( select('osoby')    > 0, osoby->(ads_clearaof()   , dbGoTop()), nil)
        if( select('duchody')  > 0, duchody->(ads_clearaof() , dbGoTop()), nil)

//        grpkey := m_parent:udcp:pa_grpkey
      endif
    endif

    // 6 - 7 výbìr odbobí  8 - 9 výbìr roku tj. nabízíme poslední období roku
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

      obdARR   := ListAsArray( obdReport)
      obdKeyML := SubStr( obdReport,4,4) +SubStr( obdReport,1,2)
    endif

  endif

  drgDBMS:open('defvykhd')
  drgDBMS:open('defvykit')
  drgDBMS:open('defvykit',,,,,'defvykita')
  drgDBMS:open('defvyksy')
  drgDBMS:open('defvyksy',,,,,'defvyksya')
  drgDBMS:open('defvyksy',,,,,'defvyksyb')
  drgDBMS:open('defvyksy',,,,,'defvyksye')
  drgDBMS:open('ucetsys')
  drgDBMS:open('msprc_mo',,,,,'msprc_mom')
  drgDBMS:open('msprc_mo',,,,,'msprc_mok')
  drgDBMS:open('msprc_mo',,,,,'msprc_moc')
  drgDBMS:open('msvprum',,,,,'msvprumm')


  if( Select( 'vykazw') > 0, vykazw->( dbCloseArea()), nil)
  drgDBMS:open('vykazw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  cx := Space(60)

  if Left(vykaz,4)<>'DIST' .and. Left(vykaz,4)<>'USER'
    drgMsgBox(drgNLS:msg('Pozor u sestavy je nastaveno pùvodní volání definice výkazu a sestava nebude správnì zpracována ...'))
    drgMsgBox(drgNLS:msg('Je potøeba v èásti Servis-Tiskové výstupy spustit tlaèítko UpravVyk   ...'))
  endif

  if defvykhd->( dbseek( Upper(vykaz),,'DEFVYKHD03'))

//    primaryTAB :=
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
      for l:=1 to Len(avykaz[k])    ;      avykaz[k,l] := {0,{}}
      next
    next
    lvykaz  := Array(i,j)
    for k:=1 to Len(lvykaz)
      for l:=1 to Len(lvykaz[k])    ;      lvykaz[k,l] := .f.
      next
    next

    defvykit->(ads_clearaof())

    cFiltr := Format("Upper(cIDvykazu) == '%%' and nSloupVyk = 1", {Upper(defvykhd->cIDvykazu)})
    defvykit->(ads_setaof(cFiltr),dbGoTop())
    defvykit->( DbSetRelation( 'defvyksy',  { || Upper(defvykit->cidsysvykn)},'Upper(defvykit->cidsysvykn)','DEFVYKSY03'))
    defvykit->(dbSkip(0))
    defvykit->( DbSetRelation( 'defvyksyb',  { || Upper(defvykit->cidsysvykb)},'Upper(defvykit->cidsysvykb)','DEFVYKSY03'))
    defvykit->(dbSkip(0))
    defvykit->( DbSetRelation( 'defvyksye',  { || Upper(defvykit->cidsysvyke)},'Upper(defvykit->cidsysvyke)','DEFVYKSY03'))
    defvykit->(dbSkip(0))

    defvykit->( AdsSetOrder('DEFVYKIT10'))
//    countrec := defvykit->( mh_COUNTREC())
    defvykit->(dbGoTop())

//    defvyksy ->(dbSeek( Upper(defvykit->cidsysvykn),,'DEFVYKSY03'))
    if .not. Empty(defvyksy->mgrpvyber) .or.                  ;
         .not. Empty(defvyksyb->mgrpvyber) .or.                ;
           .not. Empty(defvyksye->mgrpvyber)
      do case
      case .not. Empty(defvyksy->mgrpvyber)
        cmainfile := AllTrim( defvyksy->cgrptable)
      case .not. Empty(defvyksyb->mgrpvyber)
        cmainfile := AllTrim( defvyksyb->cgrptable)
      case .not. Empty(defvyksye->mgrpvyber)
        cmainfile := AllTrim( defvyksye->cgrptable)
      endcase

      if select(cmainfile) = 0
        if substr(upper(cmainfile), len(cmainfile), 1) = 'W'
          drgDBMS:open(cmainfile,.T.,.T.,drgINI:dir_USERfitm); ZAP
        else
          drgDBMS:open(cmainfile)
        endif
      endif

//  !!!!!!  je potøeba doøešit obecné zadání klíèe pro výbìr skupin
      do case
      case .not. Empty(defvyksy->mgrpvyber)
        buffer := StrTran(MemoTran(defvyksy->mgrpvyber,chr(0)), ' ', '')
      case .not. Empty(defvyksyb->mgrpvyber)
        buffer := StrTran(MemoTran(defvyksyb->mgrpvyber,chr(0)), ' ', '')
      case .not. Empty(defvyksye->mgrpvyber)
        buffer := StrTran(MemoTran(defvyksye->mgrpvyber,chr(0)), ' ', '')
      endcase
      grpVyber := buffer

      if at( ':', buffer) <> 0
        pa_sy    := listAsArray( buffer, ':' )
        grpVyber := strTran( strTran( pa_sy[2], ' ', ''), '%%->', '')
      endif

*      key      := buffer

//  pro testy odstarnit !!!!
//      if Upper(cmainfile) = 'MZDYHD'
//        mzdyhd->(ads_setaof("nrokobd == 201210"),dbGoTop())
//     endif
//      (cmainfile)->(dbGoTop())
//      do while .not.(cmainfile)->(Eof()) .and.  nmax < 2
//        key := (cmainfile)->( DBGetVal(buffer))
*        key :=  DBGetVal(buffer)
//        if( ascan( grpkey, {|x| x = key} ) = 0, AAdd( grpkey, key), nil)
//        (cmainfile)->( dbSkip())
//        nmax++
//      enddo
    else
      AAdd( grpkey,0)
    endif

    if len( grpkey) = 0
      if Empty( (cmainfile)->(ads_getAOF()))
        cFiltr := Format("nRokObd = %%", {uctOBDOBI:MZD:NROKOBD})
        (cmainfile)->(ads_setaof(cFiltr),dbGoTop())
      endif

      if grpVyber = 'crocp'
        buffer   := 'crocpppv'
        grpVyber := buffer
        (cmainfile)->(dbGoTop())
        do while .not.(cmainfile)->(Eof())
          cFiltr := Format("Left(croobcpppv,11) = '%%' and lMzdaVroce", {Left((cmainfile)->croobcpppv,11)})
          msprc_moc->(ads_setaof(cFiltr),dbGoTop())
          do while .not.msprc_moc->(Eof())
            if Empty( msprc_moc->ddatvyst) .or. Year( msprc_moc->ddatvyst) >= 2012
              if ( Ascan( grpkey, {|x| x = msprc_moc->&buffer})) = 0
                AAdd( grpkey, msprc_moc->&buffer)
              endif
              if ( Ascan( grpkeyCP, {|x| x = Left(msprc_moc->&buffer,9)})) = 0
                AAdd( grpkeyCP, Left(msprc_moc->&buffer,9))
              endif
            endif
            msprc_moc->( dbSkip())
          enddo
          msprc_moc->( Ads_ClearAOF())
          (cmainfile)->( dbSkip())
        enddo
        (cmainfile)->( Ads_ClearAOF())
      else
        (cmainfile)->(dbGoTop())
        do while .not.(cmainfile)->(Eof())
          if Empty( (cmainfile)->ddatvyst) .or. Year( (cmainfile)->ddatvyst) >= 2012
            AAdd( grpkey, (cmainfile)->&buffer)
          endif
          (cmainfile)->( dbSkip())
        enddo
        (cmainfile)->( Ads_ClearAOF())
      endif
    endif

//    countrec := len( grpkey)
    countrec := defvykit->(Ads_GetRecordCount())

    ** jedeme zpracování podladù pro tisk
    drgServiceThread:progressStart(drgNLS:msg('Zpracování podkladù ... ', 'DEFVYKIT'), ;
                                               countrec  )

// nápoèet do vykazw
//   nsecBeg := seconds()                                                              ;

    do while .not.defvykit->(Eof())
      do case
*      case Left( defvykit->ctypkumvyk,1) = 'M'
*        if .not. Empty( grpkey)
*          nn := uctOBDOBI:MZD:NROK
*          nx := uctOBDOBI:MZD:NOBDOBI
*          for k := 1 to len(grpkey)
*            genradvy2mt( grpkey[k],nn,nx)
*          next
*        else
*          nn := Val(SubStr(obdReport,4,4))
*          nx := Val(SubStr(obdReport,1,2))
*          genradvy2mt( grpkey[k],nn,nx)     nutno opravit grpkey[k]
*        endif

      case defvykit->ctypkumvyk = 'V0'
        if .not. Empty( grpkey)
          nn := uctOBDOBI:MZD:NROK
          nx := uctOBDOBI:MZD:NOBDOBI
          for k := 1 to len(grpkey)
//            cFiltr := Format("cRoCpPPV = '%%'", {grpkey[k]})
//            (filein)->(ads_setaof( cFiltr),dbGoTop())

            grpVyber_K := grpkey[k]
            cX := Left( grpkey[k],9) + Left(defvykit->cSkupina1,3)

//            if ( Ascan( grpkeyV0, {|x| x = cX })) = 0
//              AAdd( grpkeyV0, cX)

              if .not. Empty(defvykit->ctypnapvyk)
                genradvy2f( grpkey[k],nn,nx)
              endif

              if .not. Empty(defvykit->ctypnapvyB)
                genradvy2f( grpkey[k],nn,-1)
              endif

              if .not. Empty(defvykit->ctypnapvyE)
                genradvy2f( grpkey[k],nn,-2)
              endif

              if Empty(defvykit->ctypnapvyk) .and.            ;
                    Empty(defvykit->ctypnapvyB) .and.         ;
                      Empty(defvykit->ctypnapvyE)
                genradvy2f( grpkey[k],nn,0)
              endif
//            endif
          next
        else
          nn := Val(SubStr(obdReport,4,4))
          nx := Val(SubStr(obdReport,1,2))
//          genradvy2f( grpkey[k],nn,nx)     nutno opravit grpkey[k]
        endif
      case defvykit->ctypkumvyk = 'K5'
        aa := Mh_token(defvykit->mvyber)
        for n := 1 to len(aa)
          if (i := aScan( adef,{|x| x[1] = aa[n]} )) = 0
            AAdd( adef, { aa[n], {}, {}, {}} )
            i := Len( adef)
          endif
          do case
          case Left(defvykit->ctypnapvyk,6) = 'MZ_DNY'
            AAdd( adef[i,2],defvykit->nRadekVyk)
          case Left(defvykit->ctypnapvyk,6) = 'MZ_HOD'
            AAdd( adef[i,3],defvykit->nRadekVyk)
          case Left(defvykit->ctypnapvyk,6) = 'MZ_MZD'
            AAdd( adef[i,4],defvykit->nRadekVyk)
          endcase
        next
      endcase
      defvykit->( dbSkip())
      drgServiceThread:progressInc()
    enddo

    defvykit->( dbGoTop())
//    filein := Alltrim(defvyksy->cmainfile)

//    if select(filein) = 0
//      if substr(upper(filein), len(filein), 1) = 'W'
//        drgDBMS:open(filein,.T.,.T.,drgINI:dir_USERfitm); ZAP
//      else
//        drgDBMS:open(filein)
//      endif
//    endif

    filein := 'mzdyitm'
    drgDBMS:open('mzdyit',,,,,filein)

    if .not. Empty( grpkey)
      for k := 1 to len(grpkey)
        if forms->ntypZpr <> 6
          cFiltr := Format("cRoCpPPV = '%%'", {grpkey[k]})
          (filein)->(ads_setaof( cFiltr),dbGoTop())

           do while .not.(filein)->( Eof())
             if (i := aScan( adef,{|x| x[1] = (filein)->cucetskup })) <> 0
               if( .not. Empty( adef[i,2]), genradvy2d( adef[i,2], grpkey[k], 'dn'), nil)
               if( .not. Empty( adef[i,3]), genradvy2d( adef[i,3], grpkey[k], 'ho'), nil)
               if( .not. Empty( adef[i,4]), genradvy2d( adef[i,4], grpkey[k], 'mz'), nil)
             endif
             (filein)->( dbSkip())
           enddo

          (filein)->( ads_clearaof())
        else
          for o := 1 to Len( obdARR)
            key := SubStr(grpkey[k],1,4) +SubStr(obdARR[o],1,2) +SubStr(grpkey[k],5)
            cFiltr := Format("cRoObCpPPV = '%%'", {key})
            (filein)->(ads_setaof( cFiltr),dbGoTop())

            do while .not.(filein)->( Eof())
              if (i := aScan( adef,{|x| x[1] = (filein)->cucetskup })) <> 0
                for  r := 2 to 4
                  if( .not. Empty( adef[i,r]), genradvy2d( adef[i,r], grpkey[k]), nil)
                next
              endif
              (filein)->( dbSkip())
            enddo

            (filein)->( ads_clearaof())
          next
        endif
//        drgServiceThread:progressInc()
      next
    else

    endif

    if .not. Empty( grpkeyCP)
      for k := 1 to len(grpkeyCP)
        if forms->ntypZpr <> 6
          cFiltr := Format("Left(cRoCpPPV,9) = '%%'", {grpkeyCP[k]})
          (filein)->(ads_setaof( cFiltr),dbGoTop())
          ckeyCP := grpkeyCP[k] + '999'

           do while .not.(filein)->( Eof())
             if (i := aScan( adef,{|x| x[1] = (filein)->cucetskup })) <> 0
               if( .not. Empty( adef[i,2]), genradvy2d( adef[i,2], ckeyCP, 'dn'), nil)
               if( .not. Empty( adef[i,3]), genradvy2d( adef[i,3], ckeyCP, 'ho'), nil)
               if( .not. Empty( adef[i,4]), genradvy2d( adef[i,4], ckeyCP, 'mz'), nil)
             endif
             (filein)->( dbSkip())
           enddo

          (filein)->( ads_clearaof())
        endif
//        drgServiceThread:progressInc()
      next
    endif

    drgServiceThread:progressEnd()
    vykazw ->( dbGoTop())

  else
    drgMsgBox(drgNLS:msg('Pozor nastavená definice výkazu u sestavy neexistuje ...'))
    ok := .F.
  endif

  * musíme vrátit do public pùvodní období pro sestavy
  obdReport := cold_obdReport
return(ok)


function genradvy2f( key, rok, obd)
  local n
  local ky, tmKey, kyM

  do case
  case obd > 0
//    if val(SubStr( key,5,5)) = 1000
//      xx := 111
//    endif
    for n := 1 to obd
      ky := SubStr( key,1,4) +StrZero( n,2) +SubStr( key,5)
      if msprc_mom->( dbSeek(ky,,'MSPRMO17'))
        msvprumm->( dbSeek(ky,,'PRUMV_06'))

        tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                  +Upper(defvykit->cskupina3)+ Padr(key, 60)+StrZero(defvykit->nradekvyk,4)
        if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
          mh_COPYFLD('defvykit', 'vykazw', .T.)
          vykazw->dposobd   := mh_LastODate( rok, obd)
          vykazw->ckey      := key
          vykazw->nrok      := rok
          vykazw->cSortKey1 := key

          kyM := obdKeyML + SubStr( key,5)
          if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
            vykazw->cSortKey2 := msprc_mok->cjmenorozl
            vykazw->cSortKey3 := msprc_mok->ckmenstrpr
          endif

        endif
        cx := 'nSloupec' + StrZero( n, 2)
        vykazw ->&cx := DBGetVal(defvyksy->mblock)
      endif
    next
  case obd =  0
    tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
              +Upper(defvykit->cskupina3)+ Padr(key, 60)+StrZero(defvykit->nradekvyk,4)
    if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
      mh_COPYFLD('defvykit', 'vykazw', .T.)
      vykazw->dposobd   := mh_LastODate( rok, obd)
      vykazw->ckey      := key
      vykazw->nrok      := rok
      vykazw->cSortKey1 := key

      kyM := obdKeyML + SubStr( key,5)
      if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
        vykazw->cSortKey2 := msprc_mok->cjmenorozl
        vykazw->cSortKey3 := msprc_mok->ckmenstrpr
      endif

    endif
  case obd = -1
    ky := SubStr( key,1,4) +StrZero( uctOBDOBI:MZD:NOBDOBI,2) +SubStr( key,5)
    msprc_mom->( dbSeek( ky,,'MSPRMO17'))
    kyM := obdKeyML + SubStr( key,5)
    msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
    DBGetVal(defvyksyb->mblock)
//    bBlock := COMPILE( defvyksyb->mblock )
//    eval( bBlock, key )

  case obd = -2
    ky := SubStr( key,1,4) +StrZero( uctOBDOBI:MZD:NOBDOBI,2) +SubStr( key,5)
    msprc_mom->( dbSeek( ky,,'MSPRMO17'))
    kyM := obdKeyML + SubStr( key,5)
    msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
    DBGetVal(defvyksye->mblock)

  endcase

return nil


static function genradvy2d( atmDef, key)
  local n
  local tmKey
  local block

  if Right( key,3) = '999'
    msprc_mom->( dbSeek( Left(key,9),,'MSPRMO22',.t.))
  else
    msprc_mom->( dbSeek( key,,'MSPRMO22'))
  endif

  for n := 1 to Len( atmDef)
//     tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
//                +Upper(defvykit->cskupina3)+ Padr(cx, 60)+StrZero(defvykit->nRadekVyk,4)

    defvykit->(dbSeek( Upper(defvykit->cidvykazu)+ StrZero(atmDef[n],4) +'01',,'DEFVYKIT08'))
//     key   := Right( key, 9) + StrZero(mzdyitm->nporpravzt,3)
    tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                +Upper(defvykit->cskupina3)+ Padr(key, 60)+StrZero(atmDef[n],4)
    if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
      mh_COPYFLD('defvykit', 'vykazw', .T.)
      vykazw->dposobd   := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
      vykazw->ckey      := key
      vykazw->nrok      := mzdyitm->nrok
      vykazw->cSortKey1 := key

      if Right( key,3) = '999'
        kyM := obdKeyML + SubStr( key,5,5)
      else
        kyM := obdKeyML + SubStr( key,5)
      endif

      if msprc_mok->( dbSeek(kyM,,'MSPRMO17', .t.))
        vykazw->cSortKey2 := msprc_mok->cjmenorozl
        vykazw->cSortKey3 := msprc_mok->ckmenstrpr
      endif
    endif

    cx     := 'nSloupec' + StrZero( mzdyitm->nobdobi,2)
    block  := StrTran( Lower( defvyksy->mblock),'mzdyit','mzdyitm')
    vykazw ->&cx += DBGetVal( block)

  next

return nil



/*

    if defvykhd->cIDvykazu <> 'DIST000063'

    do while .not.defvykit->(Eof())
      for k := 1 to Len(grpkey)
        do case
        case Left(defvykit->ctypkumvyk,1) == 'K'
          lvykaz[defvykit->nRadekVyk,defvykit->nSloupVyk] := .t.
          filein := Alltrim(defvyksy->cmainfile)

          if select(filein) = 0
            if substr(upper(filein), len(filein), 1) = 'W'
              drgDBMS:open(filein,.T.,.T.,drgINI:dir_USERfitm); ZAP
            else
              drgDBMS:open(filein)
            endif
          endif

          if vyk_okvyber( grpkey[k])
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
                  avykaz[defvykit->nRadekVyk,defvykit->nSloupVyk,1] += Eval(b_block)

                case defvykit->ctypkumvyk == 'K2' .or. defvykit->ctypkumvyk == 'K3' ;
                       .or. defvykit->ctypkumvyk == 'K4' .or. defvykit->ctypkumvyk == 'K5'
                  nx := (defvyksy->cmainfile)->(FieldPos( defvyksy->cmainfield))
                  cc := ValType((defvyksy->cmainfile)->(FieldGet(nx)))

                  do case
                  case defvykit->ctypkumvyk == 'K5'
                    cx := grpkey[k]
                  case defvykit->ctypkumvyk == 'K3'
                    cx := NaklKeyUcKuw()
                  case defvykit->ctypkumvyk == 'K4'
                    cx := Left( NaklKeyUcKuw(), 48)
                  case cc == 'N'
                    cx := StrZero((defvyksy->cmainfile)->(FieldGet(nx)), 60)
                  case cc == 'C'
                    cx := Padr((defvyksy->cmainfile)->(FieldGet(nx)), 60)
                  otherwise
                    cx := Space(60)
                  endcase

                  ni := defvykit->nRadekVyk
                  nj := defvykit->nSloupVyk

                  tmval := Eval(b_block)
                  m := aScan(avykaz[ni,nj,2], {|x| x[1] = cx})
                  if m = 0
                    AAdd(avykaz[ni,nj,2], {cx, tmval})
                  else
                    avykaz[ni,nj,2, m, 2] += tmval
                  endif
                  avykaz[ni,nj,1] += tmval
                endcase

                (filein)->(dbSkip())
              enddo
            endif
          endif

          do case
          case defvykit->ctypkumvyk == 'K5'
            ni := defvykit->nRadekVyk
            nj := defvykit->nSloupVyk
            cx := grpkey[k]
            m := aScan(avykaz[ni,nj,2], {|x| x[1] = cx})
            if m = 0
              AAdd(avykaz[ni,nj,2], {cx, 0})
            endif
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
      next
      drgServiceThread:progressInc()
      defvykit->(dbSkip())
    enddo

    drgServiceThread:progressEnd()

    else

      filein := Alltrim(defvyksy->CMAINFILE)

      cFiltr := Format("Upper(cIDvykazu) == '%%' .and. nSloupVyk = %%", {Upper(defvykhd->cIDvykazu),1})
      defvykit->(ads_setaof(cFiltr),dbGoTop())

      do while .not. defvykit->(Eof())
        if .not. Empty(defvykit->mVyber)
          tmarr := mh_Token(defvykit->mVyber,',')
          if( Empty(tmarr), AAdd(tmarr, AllTrim(defvykit->mVyber)), nil)

          if Len(tmarr) = 1 .and. tmarr[1] = '*'
          else
            for n:=1 to Len(tmarr)
              m := aScan(vyber_tm, {|x| x[1] = Val(tmarr[n])})
              if m = 0
                tm := { Val(AllTrim(tmarr[n])), {defvykit->nradekvyk,defvykit->nsloupvyk,AllTrim(defvyksy->mblock)} }
                AAdd(vyber_tm, tm)
              else
                tm := {defvykit->nradekvyk,defvykit->nsloupvyk,AllTrim(defvyksy->mblock)}
                AAdd(vyber_tm[m], tm)
              endif
            next
          endif

        endif
        drgServiceThread:progressInc()
        defvykit->( dbSkip())
      enddo

      drgServiceThread:progressEnd()



      if select(filein) = 0
        if substr(upper(filein), len(filein), 1) = 'W'
          drgDBMS:open(filein,.T.,.T.,drgINI:dir_USERfitm); ZAP
        else
          drgDBMS:open(filein)
        endif
      endif

      drgServiceThread:progressStart(drgNLS:msg('Zpracování podkladù ... ', 'DEFVYKIT'), ;
                                               Len(grpkey)  )

      for k := 1 to Len(grpkey)

        cFiltr := Format("nRok = %% .and. cCpPPV = '%%'", {2012,grpkey[k]})
        (filein)->(ads_setaof( cFiltr),dbGoTop())

        do while .not. (filein)->( Eof())
          m := aScan(vyber_tm, {|x| x[1] = (filein)->ndruhmzdy})
          if m > 0
            for n := 2 to Len(vyber_tm[m])
              i :=vyber_tm[m,n,1]
              j := vyber_tm[m,n,2]
              avykaz[i,j,1] += DBGetVal(vyber_tm[m,n,3])
            next
          endif

          (filein)->( dbSkip())
        enddo
        drgServiceThread:progressInc()

      next

      drgServiceThread:progressEnd()

    endif

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

      for n := 1 to Len(vykaz_sor)
        nx := At(':=', vykaz_sor[n])
        cc := SubStr(vykaz_sor[n], nx+2)
        aa := Left( vykaz_sor[n], nx-1)
        i :=  Val(Left( vykaz_sor[n], At(',', aa)-1))
        j :=  Val(SubStr(vykaz_sor[n], At(',', aa)+1))

        aVykaz[i,j,1] := Eval(COMPILE(cc))
      next
    endif

// zápis do vykazw
    defvykit->( OrdSetFocus('DEFVYKIT08'))
    defvykit->(dbGoTop())
    do while .not.defvykit->(Eof())

      if .not. Empty(defvykit->cidsysvykb)
        if defvyksya ->(dbSeek( Upper(defvykit->cidsysvykb),,'DEFVYKSY03'))
           DBGetVal(defvyksya->mblock)
        endif
      endif

      do case
      case defvykit->ctypkumvyk == 'K2' .or. defvykit->ctypkumvyk == 'K3'   ;
            .or. defvykit->ctypkumvyk == 'K4' .or. defvykit->ctypkumvyk == 'K5'
        if .not. Empty( avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2] )
          for n := 1 to Len( avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2])
            cx  := avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,1]

            do case
            case defvykit->ctypkumvyk == 'K2'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Padr(cx, 60)+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
              endif
              vykazw->ckey := cx

            case defvykit->ctypkumvyk == 'K3'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Padr(cx, 60)+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
              endif
              vykazw->ckey := cx
              vykazw->ctmpkey := Left( cx, 48)

            case defvykit->ctypkumvyk == 'K4'
              cx := Left( cx, 48)
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Padr(cx, 60)+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
              endif
              vykazw->ckey := cx
              cc := cx
              vykazw->ctmpkey := cx

              if Ascan( tm_nakl, cc) = 0
                AAdd( tm_nakl, cc)
              endif

            case defvykit->ctypkumvyk == 'K5'
              key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                      +Upper(defvykit->cskupina3)+ Padr(cx, 60)+StrZero(defvykit->nRadekVyk,4)
              if .not. vykazw->(dbSeek(key,,'VYKAZW01'))
                mh_COPYFLD('defvykit', 'vykazw', .T.)
                vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
              endif

              vykazw->ckey := cx

              sloupec := vykazw->(fieldpos('csloupec' +StrZero(defvykit->nsloupvyk,2)))
              vykazw->(fieldput(sloupec, Left( defvykit->cnazradvyk, 27) +Left( defvykit->cTextTm1, 3)))
            endcase

            sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))
            vykazw->(fieldput(sloupec, mh_roundnumb(avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,2,n,2],defvykit->nkodzaokr)))
          next
        endif
      otherwise
        key := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
              +Upper(defvykit->cskupina3)+ Padr(cx,60)+ StrZero(defvykit->nRadekVyk,4)
        if .not. vykazw->(dbSeek(key,,'VYKAZw01'))
          mh_COPYFLD('defvykit', 'vykazw', .T.)
          vykazw->ckey := cx
          vykazw->dposobd := mh_LastODate( Val(SubStr(obdReport,4,4)), Val(SubStr(obdReport,1,2)))
        endif

        if defvykit->ctypkumvyk == 'V2' .or. defvykit->ctypkumvyk == 'V3'
          if .not. Empty( cx)
            vykazw->ctmpkey := Left( cx, 48)
          endif
        endif

        if defvykit->ctypkumvyk <> '00'
          sloupec := vykazw->(fieldpos('nsloupec' +StrZero(defvykit->nsloupvyk,2)))
          vykazw->(fieldput(sloupec, mh_roundnumb(avykaz[defvykit->nRadekVyk,defvykit->nsloupvyk,1],defvykit->nkodzaokr)))
        endif
      endcase

      if .not. Empty(defvykit->cidsysvyke)
        if defvyksya ->(dbSeek( Upper(defvykit->cidsysvyke),,'DEFVYKSY03'))
           DBGetVal(defvyksya->mblock)
        endif
      endif

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

    if .not. Empty(defvykhd->cidsysvyke)
      if defvyksya ->(dbSeek( Upper(defvykhd->cidsysvyke),,'DEFVYKSY03'))
         DBGetVal(defvyksya->mblock)
      endif
    endif

*/