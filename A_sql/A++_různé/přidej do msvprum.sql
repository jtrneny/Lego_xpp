//delete from mssazzam where cTypSazby ='SAZOSOOHOD'  ; 
INSERT INTO msvprumv
       (  ctask,cUloha,nRok,nObdobi,cObdobi,nRokObd,nCtvrtleti,cCtvrtlRim,lrucVypPru,cKmenStrPr,nOsCisPrac,cPracovnik,cJmenoRozl,
          nPorPraVzt,lStavem,cVybObd_P,cVybObd_N,cDelkPrDob,nDelkPDoby,nAlgCelOdm,nPocMesPr,nKcsNEMOC,nKcsDAN_NP,nDOdpra_NP,nHOdpra_NP,
          nKcsPRACP,nDOdpra_PP,nHOdpra_PP,nDnyNap_PP,nHodNap_PP,nMzdNap_PP,nDFondu_PP,nHFondu_PP,nKcsODMEN,nDOdpra_OO,nHOdpra_OO,nDFondu_OO,
          nHFondu_OO,nV_NEMOC,nS_NEMOC,nRezIm,dDatNast,dDatVyst,nKDSkut,nDNY_PP01,nHOD_PP01,nKC_PP01,nDNY_PP02,nDOdpra_PP,nHOD_PP02,nKC_PP02,
          nDNY_PP03,nHOD_PP03,nKC_PP03,nDNY_PPSUM,nHOD_PPSUM,nKC_PPSUM,nHOD_PRESC,nKC_ODMcel,nKC_ODMroz,nKC_ODMcis,nHodPrumPP,nDenPrumPP,
          nDnyNap_NA,nHodNap_NA,nMzdNap_NA,nDFondu_NA,nHFondu_NA,nDny_Na01,nHod_Na01,nMzd_Na01,nDny_Na02,nHod_Na02,nMzd_Na02,nDny_Na03,
          nHod_Na03,nMzd_Na03,nDny_NaSum,nHod_NaSum,nMzd_NaSum,nHodPrumNa,nKD_NM01,nKDO_NM01,nKC_NM01,nKD_NM02,nKDO_NM02,nKC_NM02,nKD_NM03,nKDO_NM03,
          nKC_NM03,nKD_NMSUM,nKDO_NMSUM,nKC_NMSUM,nDenVZhruN,nDenVZcisN,nDenVZciKN,nSazDenNiN,nSazDenVyN,nSazDenVKN,nSazDenMaN,nSazDenN_1,nSazDenN_2,
          nSazDenN_3,nSazDenN_4,nSazDenN_5,nSazDenM_1,nSazDenM_2,nSazDenO_1,nSazDenO_2,nDenVZhruH,nDenVZcisH,nDenVZciKH,nSazDenH_1,nSazDenH_2,
          nPruMesMzH,nPruMesMzC,nDanUleva,cTmKmStrPr,cRoObCpPPv)
       SELECT ctask,cUloha,nRok,2,'02/14',201402,nCtvrtleti,cCtvrtlRim,lrucVypPru,cKmenStrPr,nOsCisPrac,cPracovnik,cJmenoRozl,
          nPorPraVzt,lStavem,cVybObd_P,cVybObd_N,cDelkPrDob,nDelkPDoby,nAlgCelOdm,nPocMesPr,nKcsNEMOC,nKcsDAN_NP,nDOdpra_NP,nHOdpra_NP,
          nKcsPRACP,nDOdpra_PP,nHOdpra_PP,nDnyNap_PP,nHodNap_PP,nMzdNap_PP,nDFondu_PP,nHFondu_PP,nKcsODMEN,nDOdpra_OO,nHOdpra_OO,nDFondu_OO,
          nHFondu_OO,nV_NEMOC,nS_NEMOC,nRezIm,dDatNast,dDatVyst,nKDSkut,nDNY_PP01,nHOD_PP01,nKC_PP01,nDNY_PP02,nDOdpra_PP,nHOD_PP02,nKC_PP02,
          nDNY_PP03,nHOD_PP03,nKC_PP03,nDNY_PPSUM,nHOD_PPSUM,nKC_PPSUM,nHOD_PRESC,nKC_ODMcel,nKC_ODMroz,nKC_ODMcis,nHodPrumPP,nDenPrumPP,
          nDnyNap_NA,nHodNap_NA,nMzdNap_NA,nDFondu_NA,nHFondu_NA,nDny_Na01,nHod_Na01,nMzd_Na01,nDny_Na02,nHod_Na02,nMzd_Na02,nDny_Na03,
          nHod_Na03,nMzd_Na03,nDny_NaSum,nHod_NaSum,nMzd_NaSum,nHodPrumNa,nKD_NM01,nKDO_NM01,nKC_NM01,nKD_NM02,nKDO_NM02,nKC_NM02,nKD_NM03,nKDO_NM03,
          nKC_NM03,nKD_NMSUM,nKDO_NMSUM,nKC_NMSUM,nDenVZhruN,nDenVZcisN,nDenVZciKN,nSazDenNiN,nSazDenVyN,nSazDenVKN,nSazDenMaN,nSazDenN_1,nSazDenN_2,
          nSazDenN_3,nSazDenN_4,nSazDenN_5,nSazDenM_1,nSazDenM_2,nSazDenO_1,nSazDenO_2,nDenVZhruH,nDenVZcisH,nDenVZciKH,nSazDenH_1,nSazDenH_2,
          nPruMesMzH,nPruMesMzC,nDanUleva,cTmKmStrPr,cRoObCpPPv
FROM   msvprumv_