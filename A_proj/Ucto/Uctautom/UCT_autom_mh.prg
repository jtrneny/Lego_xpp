#include "Common.ch"
#include "gra.ch"
#include "ads.ch"
#include "adsdbe.ch"
#include "dbstruct.ch'
//
#include "..\Asystem++\Asystem++.ch"


static  cdirW, ltyp_NVv, s_brow,s_xbp_therm
static  p_polA
static  adenik := { { 'AN - výpoèet nedokonèené výroby' , 'AN', 100001, 1, 0 }, ;
                    { 'AV - výpoèet výrobní  režie    ' , 'AV', 100001, 1, 0 }, ;
                    { 'AS - výpoèet správní  režie    ' , 'AS', 100001, 1, 0 }, ;
                    { 'AZ - výpoèet zásobové režie    ' , 'AZ', 100001, 1, 0 }  }

static  astru  := { { 'cObdobi'   , 'c',  5,  0 }, ;
                    { 'nRok'      , 'I',  2,  0 }, ;
                    { 'nObdobi'   , 'I',  2,  0 }, ;
                    { 'cUcetMD'   , 'c',  6,  0 }, ;
                    { 'cNazPol1'  , 'c',  8,  0 }, ;
                    { 'cNazPol2'  , 'c',  8,  0 }, ;
                    { 'cNazPol3'  , 'c',  8,  0 }, ;
                    { 'cNazPol4'  , 'c',  8,  0 }, ;
                    { 'cNazPol5'  , 'c',  8,  0 }, ;
                    { 'cNazPol6'  , 'c',  8,  0 }, ;
                    { 'cTyp'      , 'c',  1,  0 }, ;
                    { 'nKCmdOBRO' , 'F',  8,  2 }, ;
                    { 'nKCdalOBRO', 'F',  8,  2 }, ;
                    { 'nKcMDksR'  , 'F',  8,  2 }, ;
                    { 'nKcDALksR' , 'F',  8,  2 }, ;
                    { 'nMnozNatR' , 'F',  8,  2 }  }

static  block_Ns, pa_Ns
static     it_Ns := "{...->cnazPol1,...->cnazPol2,...->cnazPol3," + ;
                    "...->cnazPol4,...->cnazPol5,...->cnazPol6}"


*
**___________ ROZBÌH všech NABÍDEK VÝPOÈTU AUTOMATIK ___________________________
function AUTUc_MAIv(cobd_Akt,brow,xbp_therm)
  local  lautNV_VSZr

  if isLogical(lautNV_VSZr :=  sysConfig('ucto:lautNV_VSZ'))
  else
    lautNV_VSZr := .f.
  endif

  cdirW       := drgINI:dir_USERfitm +userWorkDir() +'\'
  ltyp_NVv    := .f.
  s_brow      := brow
  s_xbp_therm := xbp_therm
  p_polA      := {}

  AUTUc_doklad(cobd_Akt)

  mycreateDir(cdirW)
  ucetpolA ->(ordSetFocus('UCETPO09')                        , ;
              dbsetScope(SCOPE_BOTH, cobd_Akt +'A')          , ;
              dbgotop()                                      , ;
              DbEval({|| AAdd(p_polA, ucetpolA->(RecNo())) }), ;
              dbclearscope()                                   )
  ASort(p_polA)

  *
  ucetkumW->(dbZap())

  if autom_hd->( dbSeek(cOBD_akt +'11',,'AUTOHD02'))
    ltyp_NVv := .not. autom_hd->ltyp_NV  // T - úèetní F - výrobní
  endif
  *
  ** VR
  if autom_hd->( dbSeek(cOBD_akt +'21',,'AUTOHD02'))
    AUTUc_scope()
    UCT_autom_vr(xbp_therm)
  endif
  AUTUc_clean()
  *
  ** SR
  if autom_hd->( dbSeek(cOBD_akt +'31',,'AUTOHD02'))
    AUTUc_scope()
    UCT_autom_sr(xbp_therm)
  endif
  AUTUc_clean()
  *
  ** ZR
  if autom_hd->( dbSeek(cOBD_akt +'41',,'AUTOHD02'))
    AUTUc_scope()
    UCT_autom_zr(xbp_therm)
  endif
  AUTUc_clean()

  **  do podkladù pro výpoèet NV se musí zahrnout i to co vygeneroval z vr/sr/zr
  *   dle cfg parametru
  if lautNV_VSZr
    UCT_aktucdat_OB_vszR(xbp_therm)
    ucetkumW->(dbZap())
  endif
  *
  ** NVu - NVv
  if autom_hd->( dbSeek(cOBD_akt +'11',,'AUTOHD02'))
    AUTUc_scope()
    ltyp_NVv := .not. autom_hd->ltyp_NV  // T - úèetní F - výrobní
    if(ltyp_NVv, UCT_autom_nvv(xbp_therm), UCT_autom_nvu(xbp_therm) )
  endif
  AUTUc_clean()

  *
  ** zrušíme nepoužité záznamy ucetpolA
  aeval(p_polA , {|x| ucetpolA ->(dbGoTo(x), if(sx_RLock(),dbdelete(),nil), dbUnlock())})

  *
  ** aktualizace obratù z automatik
  UCT_aktucdat_OBa(xbp_therm)
  s_xbp_therm:configure()
  s_brow:down():refreshAll()
return nil


static function AUTUc_doklad(cobd_Akt)
  local  x, cKy, ctag := ucetpolA->(ordSetFocus('UCETPO09'))
  local  cobd_Min := LEFT( cobd_Akt, 4) +strZero( val( right( cobd_Akt, 2)) -1, 2)

  for x := 1 to len(adenik) step 1
    cKy := cobd_Min +upper( adenik[x,2])
    ucetpolA->(dbSetScope(SCOPE_BOTH, cky), dbGoBottom())
    if( .not. ucetpolA->(eof()), adenik[x,3] := ucetpolA->ndoklad, nil)
  next

  ucetpolA->(dbClearScope(), ordSetFocus(ctag), dbGoTop())
return .t.


static function AUTUc_scope()
  local  cKy := strZero(autom_hd->nrok,4)    + ;
                strZero(autom_hd->nobdobi,2) +strZero(autom_hd->ntyp_Aut,1)
  *
  ** bude se mìnit cnazPol3 z C8 -> C36
  local  pa_stru := ucetkum->( dbStruct()), npos, nin

  if ( npos := ascan( pa_stru, { |x| upper(x[DBS_NAME]) = 'CNAZPOL3' } )) <> 0
     nlen := pa_stru[npos,DBS_LEN]

     if( nin := ascan( astru, { |x| upper(x[DBS_NAME]) = 'CNAZPOL3' } )) <> 0
       astru[nin,DBS_LEN] := nlen
     endif
  endif

  autom_it->(dbSetScope(SCOPE_BOTH, cKy), dbGoTop())
  *
  if select('uckum_w') <> 0
    uckum_W->(dbCloseArea())
    FErase(cdirW +'uckum_w.adi')
    FErase(cdirW +'uckum_w.adt')
  endif
  DbCreate(cdirW +'uckum_w', aSTRu, oSession_free)
  DbUseArea(.t., oSession_free, cdirW +'uckum_w',,.f.,.f.)
return .t.

static function AUTUc_clean()
  autom_it->(dbClearScope())
  s_xbp_therm:configure()
  s_brow:down():refreshAll()
return .t.


*
** propojení na automty
*
** zmìna cnazPol3 z C8 -> C36 ovlivní automaty
function AUTUc_Ns(cnazPol)
  local  nstep, npos, nlen_cnazPol := 8

  static pa_Ns

  if isNull(pa_Ns)
    pa_Ns := {}
    for nstep := 1 to 6 step 1
      if ( npos := ascan( astru, { |x| upper(x[DBS_NAME]) = 'CNAZPOL' +str(nstep,1) } )) <> 0
        aadd( pa_Ns, astru[npos] )
      endif
    next
  endif

  if ( npos := ascan( pa_Ns, { |x| upper(x[DBS_NAME]) = upper(cnazPol) } )) <> 0
    nlen_cnazPol := pa_Ns[npos,DBS_LEN]
  endif
return nlen_cnazPol


function AUTUc_dirW()    ;   return cdirW
function AUTUc_typNVv()  ;   return ltyp_NVv
*
* typ vvýpoètu z obratu / koncových stavù roku
function AUTUC_typV()
  local  pa

  if sysConfig('ucto:lAUTO_OBR')
    pa := { '( uckum_w ->nKCmdOBRO  -uckum_w ->nKCdalOBRo )', ;
            '( uckum_w ->nKCdalOBRO -uckum_w ->nKCmdOBRo  )'  }
  else
    pa := { '( uckum_w ->nKCmdKSr  -uckum_w ->nKCdalKSr )', ;
            '( uckum_w ->nKCdalKSr -uckum_w ->nKCmdKSr  )'  }
  endif
return pa


*
** opaèná kopie TO -> IN
function AUTUc_cpy(cDBIn,cDBTo,lDBAp)
  Local  nPOs
  Local  xVAL
  Local  aX, aC, aDBTo := ( cDBTo) ->( dbSTRUCT())

  If( IsNIL( lDBAp), NIL, If( lDBAp, ( cDBTo) ->( dbAPPEND()), NIL ))

  aEVAL( aDBTo, { |X,M| ;
       ( nPOs := ( cDBIn) ->( FIELDPOS( X[DBS_NAME]))   , ;
         If( nPOs <> 0, ( xVAL := ( cDBIn) ->( FIELDGET( nPOs)   ) , ;
                                  ( cDBTo) ->( FIELDPUT( M, xVAL))   ), NIL ) ) })
return nil

*
** testA -> ucetpolA , nápoèet do ucetpolS pro aktualizaci (kum, kumk, kumu)
function AUTUc_dok(nkcMd,nposM)
  local  ntyP    := autom_hd->ntyp_AUT, nstepS, npoS
  local  nnazPol := val( right(autom_hd->cnazPolx, 1))
  local  atyP    := adenik[ntyp]
  *
  local  ckeyS, cordNo, cnazPol, ctag, ntag

  block_Ns := COMPILE( strTran( it_Ns, '...', 'ucetpola' ) )

  if atyP[5] = 0
    atyP[5] := nposM
  else
    if(atyP[5] <> nposM, (atyP[3] += 1, atyP[4] := 1), atyP[4] += 1)
  endIf

  for nstepS := 1 to 2 step 1
    if len(p_polA) <> 0
      ucetpola->(dbGoTo(p_polA[1]))
      (adel(p_polA,1), asize(p_polA, len(p_polA)-1))
    else
      ucetpola->(dbAppend())
    endif
    ucetpola->(sx_RLock())

    ucetpolA->cobdobi    := testA  ->cobdobi
    ucetpolA->nrok       := testA  ->nrok
    ucetpolA->nobdobi    := testA  ->nobdobi
    ucetpolA->cobdobiDan := ucetsys->cobdobiDan
    ucetpolA->cdenik     := atyp[2]
    ucetpolA->ndoklad    := atyp[3]
    ucetpolA->nordItem   := atyp[4]
    ucetpolA->nordUcto   := nstepS
    ucetpolA->ctypUct    := '3'

    ucetpolA->cnazPol1   := ucetpolA->cnazPol2 := ;
    ucetpolA->cnazPol3   := ucetpolA->cnazPol4 := ;
    ucetpolA->cnazPol5   := ucetpolA->cnazPol6 := ''

    if ntyP = 1
      if nstepS = 1  ;  ucetpolA->cucetMd  := autom_it->cucet_Dal
                        ucetpolA->cucetDal := autom_it->cucet_Md
                        ucetpolA->nkcMd    := 0
                        ucetpolA->nkcDal   := nkcMd
                        ucetpolA->ctyp_R   := 'DAL'
      else           ;  ucetpolA->cucetMd  := autom_it->cucet_Md
                        ucetpolA->cucetDal := autom_it->cucet_Dal
                        ucetpolA->nkcMd    := nkcMd
                        ucetpolA->nkcDal   := 0
                        ucetpolA->ctyp_R   := 'MD'
      endif
    Else
      if nstepS = 1  ;  ucetpolA->cucetMd  := autom_it->cucet_Md
                        ucetpolA->cucetDal := autom_it->cucet_Dal
                        ucetpolA->nkcMd    := nkcMd
                        ucetpolA->nkcDal   := 0
                        ucetpolA->ctyp_R   := 'MD'
      else           ;  ucetpolA->cucetMd  := autom_it->cucet_Dal
                        ucetpolA->cucetDal := autom_it->cucet_Md
                        ucetpolA->nkcMd    := 0
                        ucetpolA->nkcDal   := nkcMd
                        ucetpolA->ctyp_R   := 'DAL'
      endif
    endif

    ucetpolA->ddatPoriz  := date()
    ucetpolA->ctext      := atyp[1]

    if nstepS = 1
      for npoS := 1 to nnazPol step 1
        cnazPol  := testA->(fieldGet( fieldPos('cnazpol' +str(npoS,1) ) ))
        ucetpolA->( fieldPut( fieldPos( 'cnazpol' +str(npoS,1)), cnazPol))
      next
    elseif ntyP > 1
      if nnazPol > 2
        ctag := 'UCETK_' +if(nnazPol = 3, '09', ;
                          if(nnazPol = 4, '10', ;
                          if(nnazPol = 5, '11', '12')))
        cky  := upper(autom_it->crozp___CO)
        ucetkum->(dbSeek(cky,,ctag))

        for npoS := 1 to nnazPol step 1
          cnazPol  := ucetkum->(fieldGet( fieldPos('cnazpol' +str(npoS,1) ) ))
          ucetpolA->( fieldPut( fieldPos( 'cnazpol' +str(npoS,1)), cnazPol))
        next
      else
        npoS := ucetpolA->( fieldPos( autom_hd->cnazPolX))
                ucetpolA->( fieldPut( npoS, autom_it->crozp___CO))
        if( ntyP = 3, ucetpolA->cnazPol1 := autom_it->crozp__STR, ;
                      ucetpolA->cnazPol1 := testA   ->cnazPol1    )
      endif
    endif

    ucetpolA->culoha     := 'U'
    ucetpolA->ndokladOrg := ucetpolA->ndoklad
    ucetpolA->cuserAbb   := sysConfig('SYSTEM:cUSERABB')
    ucetpolA->ddatZmeny  := date()
    ucetpolA->ccasZmeny  := time()

    *
    ** pomocný soubor pro aktualizaci z automatù
    ckeyS := ucetpolA->( sx_keyData( 'UCETPO07' ))
    pa_Ns := EVAL(block_Ns)

    if .not. ucetkumW->(dbSeek(ckeyS))
      AUTUc_cpy('ucetpola','ucetkumW',.t.)
      ucetkumW->ckey       := ckeyS

      ucetkumW->nkcMDobrO  := ucetpolA->nKcMD
      ucetkumW->nkcDALobrO := ucetpolA->nKcDAL
      ucetkumW->nmnozNAT   := ucetpolA->nMNOZNAT
      ucetkumW->nmnozNAT2  := ucetpolA->nMNOZNAT2

      UCETKUMw ->pa_Ns     := var2Bin( pa_Ns )
    else
      ucetkumW->nkcMDobrO  += ucetpolA->nKcMD
      ucetkumW->nkcDALobrO += ucetpolA->nKcDAL
      ucetkumW->nmnozNAT   += ucetpolA->nMNOZNAT
      ucetkumW->nmnozNAT2  += ucetpolA->nMNOZNAT2
    endif
  next
return nil