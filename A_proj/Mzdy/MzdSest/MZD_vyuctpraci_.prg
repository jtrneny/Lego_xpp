// Program:... _TmVyuPr.Prg
// Funkce:.... Vytvoýen¡ a TMP souboru pro VP pýe£Ÿtov n¡ mezd


//
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
* Pro TISK
*
********************** MZD_vyuctpraci *****************************************


function mzd_vyuctpraci_()
  local  nOldREC
  local  cX, n
  local  tmObd, tmRok, ctmObd
  local  cUcet1, cUcet2
//  local  xKEYo := StrZero( ACT_OBDyn(), 4) +"0001"  // + StrZero( ACT_OBDon(), 2)
//  local  xKEYd := StrZero( ACT_OBDyn(), 4) +"9999"   // + StrZero( ACT_OBDon(), 2)

  drgDBMS:open('mzddavit',,,,,'mzddavits')
  drgDBMS:open('c_vnmzuc')
  drgDBMS:open('c_vnsast')

  drgDBMS:open('tmpvyuprw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

//  mzddavits->( dbSetRelation( 'c_vnmzucs'  , ;
//                             { || mzddavits->nUcetMzdy } , ;
//                                 'mzddavits->nUcetMzdy' ) )

  tmObd  := Val(Left(obdReport,2))
  tmRok  := Val(SubStr(obdReport,4,4))
  ctmObd :=  Left(obdReport,2)+'/'+ SubStr(obdReport,6,2)
  filtr := Format("cObdobi = '%%' .and. cdenik = 'MH' .and. nucetmzdy <> 0", {ctmObd})
  mzddavits ->( ads_setaof(filtr), OrdSetFocus('MZDDAVIT01'), dbGoTop())

  drgServiceThread:progressStart(drgNLS:msg('Hrubé mzdy  ... '), ;
                                             mzddavits->(Ads_GetRecordCount()) )

  mzddavits->( OrdSetFocus('MZDDAVIT11'))
  mzddavits->( dbGoTop())

//  MZDiniVNU( aX)
//  mzddavits->( Set_rSCOPE( 13, xKEYo, xKEYd))

  do while .not. mzddavits->( Eof())
    if mzddavits->nUcetMzdy <> 0
      c_vnmzuc->( dbSeek( mzddavits->nucetmzdy,, 'C_VNMZUC01'))
      for n := 1 to 2
        cX := Str( n, 1)

        mh_CopyFld( 'mzddavits', 'tmpvyuprw', .t.)
        VNU_mzddavitw( 'tmpvyuprw')

        if tmpvyuprw->&( "nSazbaVNU" +cX) <> 0
          tmpvyuprw->cKmenStr := if( n = 1, tmpvyuprw->cKmenStrPr, tmpvyuprw->cKmenStrSt)
          if n = 1 .or. c_vnmzuc->cTypVnUcto = "VNU2_PST"
            cUcet1 := c_vnmzuc->&( "cUcetNak" +cX)
            cUcet2 := c_vnmzuc->&( "cUcetVyn" +cX)
          else
            if c_vnsast->( dbSeek( Upper( tmpvyuprw->cNazPol5),, 'CNAZPOL1'))
              cX     := "2"
              cUcet1 := c_vnsast->cUcetNak1
              cUcet2 := c_vnsast->cUcetVyn1
            endif
          endif
          tmpvyuprw->cUcetNak   := fGenVNucZM( cUcet1, "tmpvyuprw")
          tmpvyuprw->cUcetVyn   := fGenVNucZM( cUcet2, "tmpvyuprw")

          tmpvyuprw->nSazbaVNU  := tmpvyuprw->&( "nSazbaVNU" +cX)
          tmpvyuprw->nCelkemVNU := tmpvyuprw->&( "nSazbaVNU" +cX) * tmpvyuprw->&( "nMnozsVNU" +cX)
          tmpvyuprw->nMnozsVNU  := tmpvyuprw->&( "nMnozsVNU" +cX)
          if n = 1 .and. ( c_vnmzuc->cTypVnUcto = "VNU2_PST" .or. c_vnmzuc->cTypVnUcto = "VNU3_PCS")
            tmpvyuprw->cNazPol5 := ""
          endif
        endif
      next
    endif
    drgServiceThread:progressInc()
    mzddavits->( dbSkip())
  enddo

  mzddavits->( Ads_ClearAof())
  tmpvyuprw->( dbGoTop())

  drgServiceThread:progressEnd()

return( nil)



/*
static function fNAPLtmp()

  TmpVyuPr ->( dbAppend())

        TmpVyuPr ->cObdobi    := M_Dav ->cObdobi
        TmpVyuPr ->nRok       := M_Dav ->nRok
        TmpVyuPr ->nObdobi    := M_Dav ->nObdobi
        TmpVyuPr ->cKmenStrPr := M_Dav ->cKmenStrPr
        TmpVyuPr ->nOsCisPrac := M_Dav ->nOsCisPrac
        TmpVyuPr ->cPracovnik := M_Dav ->cPracovnik
        TmpVyuPr ->nDoklad    := M_Dav ->nDoklad
        TmpVyuPr ->nOrdItem   := M_Dav ->nOrdItem
        TmpVyuPr ->dDatPoriz  := M_Dav ->dDatPoriz
        TmpVyuPr ->cKmenStrSt := M_Dav ->cKmenStrSt
        TmpVyuPr ->nCisPrace  := M_Dav ->nCisPrace
        TmpVyuPr ->nUcetMzdy  := M_Dav ->nUcetMzdy
        TmpVyuPr ->cNazPol1   := M_Dav ->cNazPol1
        TmpVyuPr ->cNazPol2   := M_Dav ->cNazPol2
        TmpVyuPr ->cNazPol3   := M_Dav ->cNazPol3
        TmpVyuPr ->cNazPol4   := M_Dav ->cNazPol4
        TmpVyuPr ->cNazPol5   := M_Dav ->cNazPol5
        TmpVyuPr ->cNazPol6   := M_Dav ->cNazPol6
        TmpVyuPr ->nDruhMzdy  := M_Dav ->nDruhMzdy
        TmpVyuPr ->cZkratJEDN := M_Dav ->cZkratJEDN

RETURN( NIL)
*/