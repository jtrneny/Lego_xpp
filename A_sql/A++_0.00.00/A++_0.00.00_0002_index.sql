EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT01',
   'UPPER(CIDOBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT02',
   'UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT03',
   'UPPER(CGROUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT04',
   'UPPER(CIDOBJECT)+UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT05',
   'UPPER(CIDOBJECT)+UPPER(CGROUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT06',
   'UPPER(CUSER)+UPPER(CIDOBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'ASYSACT07',
   'UPPER(CGROUP)+UPPER(CIDOBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysact',
   'asysact.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysini',
   'asysini.adi',
   'ASYSINI01',
   'UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysini',
   'asysini.adi',
   'ASYSINI02',
   'UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT) +UPPER(CFILE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysini',
   'asysini.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD01',
   'UPPER(CIDPRIPOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD02',
   'NIDPRIPOM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD03',
   'UPPER(CTASK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprhd',
   'asysprhd.adi',
   'ASYSPRHD04',
   'NRECFILTRS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprhd',
   'asysprhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprit',
   'asysprit.adi',
   'ASYSPRIT01',
   'UPPER(CIDPRIPOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprit',
   'asysprit.adi',
   'ASYSPRIT02',
   'NIDPRIPOM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprit',
   'asysprit.adi',
   'ASYSPRIT03',
   'UPPER(CTASK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysprit',
   'asysprit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM01',
   'UPPER(CZKROBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM02',
   'UPPER(CUSER)+UPPER(CZKROBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM03',
   'UPPER(CTYPOBJECT)+UPPER(CZKROBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM04',
   'UPPER(CIDOBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM05',
   'UPPER(CNAMEOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM06',
   'UPPER(CTASK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM07',
   'UPPER(CPRGOBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'ASYSTEM08',
   'NSYSACT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asystem',
   'asystem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );

EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysver',
   'asysver.adi',
   'ASYSVER01',
   'UPPER(CVERZE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysver',
   'asysver.adi',
   'ASYSVER02',
   'NVERZE',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysver',
   'asysver.adi',
   'ASYSVER03',
   'NTYPVER',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysver',
   'asysver.adi',
   'ASYSVER04',
   'DTOS(DPLANVER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysver',
   'asysver.adi',
   'ASYSVER05',
   'DTOS(DVZNIKVER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'asysver',
   'asysver.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'atribop',
   'atribop.adi',
   'ATRIBOP1',
   'UPPER(CTYPOPER) +UPPER(CATRIBOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'atribop',
   'atribop.adi',
   'ATRIBOP2',
   'UPPER(CATRIBOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'atribop',
   'atribop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'autom_hd',
   'autom_hd.adi',
   'AUTOHD01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTYP_AUT,1) +STRZERO(NSUB_AUT,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'autom_hd',
   'autom_hd.adi',
   'AUTOHD02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTYP_AUT,1) +IF (LSET_AUT, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'autom_hd',
   'autom_hd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'autom_it',
   'autom_it.adi',
   'AUTOIT01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTYP_AUT,1) +STRZERO(NSUB_AUT,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'autom_it',
   'autom_it.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banky_abo',
   'banky_abo.adi',
   'BANABO01',
   'UPPER(CKODBAN_CR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banky_abo',
   'banky_abo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banky_cr',
   'banky_cr.adi',
   'BANNYCR1',
   'UPPER(CKODBAN_CR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banky_cr',
   'banky_cr.adi',
   'BANKYCR2',
   'UPPER(CNAZBAN_CR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banky_cr',
   'banky_cr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_1',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_2',
   'UPPER(CBANK_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_3',
   'NCISPOVYP',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_4',
   'STRZERO(NDOKLAD,10) +UPPER(CBANK_UCT) +STRZERO(NCISPOVYP,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_5',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_6',
   'UPPER(CBANK_UCT) +STRZERO(NCISPOVYP,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_7',
   'UPPER(CBANK_UCT) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_8',
   'STRZERO(NROK,4)  +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP_9',
   'UPPER(CBANK_UCT) +STRZERO(NROK,4) +STRZERO(NCISPOVYP,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP10',
   'UPPER(CDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP11',
   'STRZERO(NICO,8)  +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP12',
   'UPPER(CDENIK)    +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'BANVYP13',
   'STRZERO(NROK,4)  +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvyphd',
   'banvyphd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_1',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5) +UPPER(CDENIK_PAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_2',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_3',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_4',
   'UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_5',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10) +DTOS (DDATUHRADY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_6',
   'UPPER(CDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'BANKVY_7',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'banvypit',
   'banvypit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'bilance',
   'bilance.adi',
   'BILNAN01',
   'STRZERO(NICO,8) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'bilance',
   'bilance.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_aktiv',
   'c_aktiv.adi',
   'C_AKTIV1',
   'NZNAKAKT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_aktiv',
   'c_aktiv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_algrez',
   'c_algrez.adi',
   'C_ALGREZ1',
   'NALGREZIE',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_algrez',
   'c_algrez.adi',
   'C_ALGREZ2',
   'UPPER(CPOPISALG)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_algrez',
   'c_algrez.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_atrib',
   'c_atrib.adi',
   'C_ATRIB1',
   'UPPER(CATRIBOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_atrib',
   'c_atrib.adi',
   'C_ATRIB2',
   'UPPER(CPOPISATR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_atrib',
   'c_atrib.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bankuc',
   'c_bankuc.adi',
   'BANKUC1',
   'UPPER(CBANK_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bankuc',
   'c_bankuc.adi',
   'BANKUC2',
   'LISMAIN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bankuc',
   'c_bankuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_banky',
   'c_banky.adi',
   'C_BANKY01',
   'UPPER(CKODBANKY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_banky',
   'c_banky.adi',
   'C_BANKY02',
   'UPPER(CNAZBANKY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_banky',
   'c_banky.adi',
   'C_BANKY03',
   'NKODBANKY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_banky',
   'c_banky.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bankyc',
   'c_bankyc.adi',
   'C_BANK01',
   'UPPER(CKODBANKY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bankyc',
   'c_bankyc.adi',
   'C_BANK02',
   'UPPER(CNAZBANKY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bankyc',
   'c_bankyc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bcd',
   'c_bcd.adi',
   'C_BCD1',
   'NCARKKOD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_bcd',
   'c_bcd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_carkod',
   'c_carkod.adi',
   'C_CARK1',
   'UPPER (CZKRCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_carkod',
   'c_carkod.adi',
   'C_CARK2',
   'UPPER (CNAZCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_carkod',
   'c_carkod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_celsaz',
   'c_celsaz.adi',
   'C_JCD1',
   'UPPER(CDANPZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_celsaz',
   'c_celsaz.adi',
   'C_JCD2',
   'UPPER(CNAZDANP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_celsaz',
   'c_celsaz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dalpro',
   'c_dalpro.adi',
   'C_DALPR1',
   'NDALMERMES',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dalpro',
   'c_dalpro.adi',
   'C_DALPR2',
   'UPPER(CDALSIPROH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_danskp',
   'c_danskp.adi',
   'C_DANSKP1',
   'UPPER( CODPISK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_danskp',
   'c_danskp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dodavk',
   'c_dodavk.adi',
   'C_DODAVK01',
   'UPPER(CTYPDODAVK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dodavk',
   'c_dodavk.adi',
   'C_DODAVK02',
   'UPPER(CNAZDODAVK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dodavk',
   'c_dodavk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dodpod',
   'c_dodpod.adi',
   'C_DODPOD01',
   'UPPER(CTYPDODPOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dodpod',
   'c_dodpod.adi',
   'C_DODPOD02',
   'UPPER(CNAZDODPOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dodpod',
   'c_dodpod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dokume',
   'c_dokume.adi',
   'C_DOKUME01',
   'UPPER(CZKRDOKUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dokume',
   'c_dokume.adi',
   'C_DOKUME02',
   'UPPER(CTYPDOKUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dokume',
   'c_dokume.adi',
   'C_DOKUME03',
   'UPPER(CNAZDOKUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dokume',
   'c_dokume.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dph',
   'c_dph.adi',
   'C_DPH1',
   'NKLICDPH',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dph',
   'c_dph.adi',
   'C_DPH2',
   'NPROCDPH',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dph',
   'c_dph.adi',
   'C_DPH3',
   'STRZERO(NNAPOCET,2) +DTOS (DDATPLAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_dph',
   'c_dph.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohi',
   'c_drpohi.adi',
   'C_DRPOH1',
   'NDRPOHYB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohi',
   'c_drpohi.adi',
   'C_DRPOH2',
   'UPPER(CNAZEVPOH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohi',
   'c_drpohi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohp',
   'c_drpohp.adi',
   'DRPOHP1',
   'NDRPOHYBP',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohp',
   'c_drpohp.adi',
   'DRPOHP2',
   'UPPER(CNAZEVPOH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohp',
   'c_drpohp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohy',
   'c_drpohy.adi',
   'C_DRPOH1',
   'NCISLPOH',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohy',
   'c_drpohy.adi',
   'C_DRPOH2',
   'UPPER( CNAZEVPOH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohy',
   'c_drpohy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohz',
   'c_drpohz.adi',
   'DRPOHZ1',
   'NDRPOHYB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohz',
   'c_drpohz.adi',
   'DRPOHZ2',
   'UPPER(CNAZEVPOH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drpohz',
   'c_drpohz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drvlst',
   'c_drvlst.adi',
   'C_DRVLS1',
   'NKODDRVLAS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drvlst',
   'c_drvlst.adi',
   'C_DRVLS2',
   'UPPER(CPOPISVLAS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_drvlst',
   'c_drvlst.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_duchod',
   'c_duchod.adi',
   'DUCHOD01',
   'NTYPDUCHOD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_duchod',
   'c_duchod.adi',
   'DUCHOD02',
   'UPPER(CNAZDUCHOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_duchod',
   'c_duchod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_expml',
   'c_expml.adi',
   'EXPML1',
   'STRZERO(NROK,4) +STRZERO(NPRUCHOD,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_farmy',
   'c_farmy.adi',
   'FARMY_1',
   'NFARMA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_farmy',
   'c_farmy.adi',
   'FARMY_2',
   'UPPER(CNAZEVFAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_farmy',
   'c_farmy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_farmyv',
   'c_farmyv.adi',
   'FARMYV_1',
   'UPPER(CNAZPOL4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_farmyv',
   'c_farmyv.adi',
   'FARMYV_2',
   'NFARMA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_farmyv',
   'c_farmyv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_firmysk',
   'c_firmysk.adi',
   'C_FIRMSK01',
   'UPPER(CZKR_SKUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_firmysk',
   'c_firmysk.adi',
   'C_FIRMSK02',
   'UPPER(CNAZ_SKUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_firmysk',
   'c_firmysk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_funcpr',
   'c_funcpr.adi',
   'C_FUNC01',
   'UPPER(CFUNPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_funcpr',
   'c_funcpr.adi',
   'C_FUNC02',
   'UPPER(CNAZFUNCPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_funcpr',
   'c_funcpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC1',
   'UPPER(CUCETSK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC3',
   'UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_grupuc',
   'c_grupuc.adi',
   'CGRUPUC4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_grupuc',
   'c_grupuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_jednot',
   'c_jednot.adi',
   'C_JEDNOT1',
   'UPPER(CZKRATJEDN)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_jednot',
   'c_jednot.adi',
   'C_JEDNOT2',
   'UPPER(CNAZJEDNOT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_jednot',
   'c_jednot.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_katzbo',
   'c_katzbo.adi',
   'C_KATZB1',
   'NZBOZIKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_katzbo',
   'c_katzbo.adi',
   'C_KATZB2',
   'UPPER( CNAZEVKAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_katzbo',
   'c_katzbo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_klassd',
   'c_klassd.adi',
   'C_KLASSD1',
   'UPPER(CKODKLAS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_klassd',
   'c_klassd.adi',
   'C_KLASSD2',
   'UPPER(CNAZEVKLAS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_klassd',
   'c_klassd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_klazam',
   'c_klazam.adi',
   'KLASZA01',
   'NKLASZAM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_klazam',
   'c_klazam.adi',
   'KLASZA02',
   'UPPER(CNAZKLASZA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_klazam',
   'c_klazam.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koddop',
   'c_koddop.adi',
   'C_KDOP_1',
   'NKOD_DOP',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koddop',
   'c_koddop.adi',
   'C_KDOP_2',
   'UPPER(CNAZEV_DOP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koddop',
   'c_koddop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koef',
   'c_koef.adi',
   'KOEF1',
   'UPPER(CPOPISKOEF)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koef',
   'c_koef.adi',
   'KOEF2',
   'NKOEFPREP',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koef',
   'c_koef.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koefmn',
   'c_koefmn.adi',
   'C_KOEMN01',
   'NKOEFMN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koefmn',
   'c_koefmn.adi',
   'C_KOEMN02',
   'UPPER( CPOPISKOEF)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_koefmn',
   'c_koefmn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_konsym',
   'c_konsym.adi',
   'KONSYM1',
   'NKONSTSYMB',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_konsym',
   'c_konsym.adi',
   'KONSYM2',
   'UPPER(CPOPISKS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_konsym',
   'c_konsym.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_kraje',
   'c_kraje.adi',
   'C_KRAJ_1',
   'UPPER(CKRAJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_kraje',
   'c_kraje.adi',
   'C_KRAJ_2',
   'UPPER(CNAZ_KRAJE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_kraje',
   'c_kraje.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_lekari',
   'c_lekari.adi',
   'CLEKAR01',
   'UPPER(CZKRATLEKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_lekari',
   'c_lekari.adi',
   'CLEKAR02',
   'UPPER(CNAZEVLEKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_lekari',
   'c_lekari.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_lekpro',
   'c_lekpro.adi',
   'CLEKPR01',
   'UPPER(CZKRATKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_lekpro',
   'c_lekpro.adi',
   'CLEKPR02',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_lekpro',
   'c_lekpro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ1',
   'UPPER(CDRUHMAJ) +STRZERO(NINVCIS,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ2',
   'UPPER(CDRUHMAJ) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ3',
   'UPPER(CDRUHMAJ) +UPPER(CNAZEVMAJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ4',
   'NINVCIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ5',
   'NINVCISDIM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'C_MAJ6',
   'UPPER(CNAZEVMAJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_maj',
   'c_maj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_meny',
   'c_meny.adi',
   'C_MENY1',
   'UPPER (CZKRATMENY)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_meny',
   'c_meny.adi',
   'C_MENY2',
   'UPPER (CNAZMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_meny',
   'c_meny.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_mimprv',
   'c_mimprv.adi',
   'MIPRVZ01',
   'NMIMOPRVZT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_mimprv',
   'c_mimprv.adi',
   'MIPRVZ02',
   'UPPER(CNAZMIMPRV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_mimprv',
   'c_mimprv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_mince',
   'c_mince.adi',
   'C_MINC1',
   'UPPER(CZKRATMENY) +STRZERO(NVALMINCE,11)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_mince',
   'c_mince.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_mzdpol',
   'c_mzdpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_naklst',
   'c_naklst.adi',
   'C_NAKLST1',
   'UPPER(CNAZPOL1)+UPPER(CNAZPOL2)+UPPER(CNAZPOL3)+UPPER(CNAZPOL4)+UPPER(CNAZPOL5)+UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_naklst',
   'c_naklst.adi',
   'C_NAKLST2',
   'NKLICNS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_naklst',
   'c_naklst.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nakstr',
   'c_nakstr.adi',
   'NAKSTR01',
   'UPPER(CNAZPOL1) +IF (LREZVYROB, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nakstr',
   'c_nakstr.adi',
   'NAKSTR02',
   'LREZSPRAV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nakstr',
   'c_nakstr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_napdmz',
   'c_napdmz.adi',
   'C_NAPDMZ01',
   'NDRUHMZDY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_napdmz',
   'c_napdmz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_narod',
   'c_narod.adi',
   'NARODN01',
   'UPPER(CZKRATNAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_narod',
   'c_narod.adi',
   'NARODN02',
   'UPPER(CNAZNAROD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_narod',
   'c_narod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML01',
   'UPPER(ML_RAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML02',
   'UPPER(NAME_RAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML03',
   'NRADMZDLIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrml',
   'c_nazrml.adi',
   'C_NAZRML04',
   'NTYPRADMZL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrml',
   'c_nazrml.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrvp',
   'c_nazrvp.adi',
   'C_NAZRVP01',
   'NPORADI',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazrvp',
   'c_nazrvp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'C_NAZZB1',
   'UPPER(CNAZEVNAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'C_NAZZB2',
   'NKLICNAZ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'C_NAZZB3',
   'NZBOZIKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nazzbo',
   'c_nazzbo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nemgen',
   'c_nemgen.adi',
   'C_NEMGEN01',
   'STRZERO(DM,4) +STRZERO(KOD,2) +STRZERO(VETA,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nemgen',
   'c_nemgen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nzmatr',
   'c_nzmatr.adi',
   'C_NZMATR01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NKEYMATR,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nzmatr',
   'c_nzmatr.adi',
   'C_NZMATR02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CNAZMATR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_nzmatr',
   'c_nzmatr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_object',
   'c_object.adi',
   'C_OBJECT01',
   'UPPER(CTYPOBJECT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_object',
   'c_object.adi',
   'C_OBJECT02',
   'UPPER(CNAZTYPOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_object',
   'c_object.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_oblast',
   'c_oblast.adi',
   'C_OBL1',
   'NKLICOBL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_oblast',
   'c_oblast.adi',
   'C_OBL2',
   'UPPER(CNAZEVOBL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_oblast',
   'c_oblast.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_obvzth',
   'c_obvzth.adi',
   'C_OBVZT1',
   'UPPER(CZKRATOBVZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_obvzth',
   'c_obvzth.adi',
   'C_OBVZT2',
   'UPPER(CNAZOBVZTH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpmis',
   'c_odpmis.adi',
   'C_1',
   'UPPER(CKLICODMIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpmis',
   'c_odpmis.adi',
   'C_2',
   'UPPER(CNAZODPMIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpmis',
   'c_odpmis.adi',
   'C_3',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpmis',
   'c_odpmis.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC01',
   'NPORODPPOL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC02',
   'UPPER(CTYPODPPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC03',
   'STRZERO(NROK,4) +STRZERO(NPORODPPOL,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpoc',
   'c_odpoc.adi',
   'C_ODPOC04',
   'STRZERO(NROK,4) +UPPER(CTYPODPPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_odpoc',
   'c_odpoc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ogamo',
   'c_ogamo.adi',
   'C_OGAMO1',
   'NCISLPOH',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ogamo',
   'c_ogamo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_okresy',
   'c_okresy.adi',
   'C_OKRES1',
   'UPPER(COKRES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_okresy',
   'c_okresy.adi',
   'C_OKRES2',
   'UPPER(CNAZ_OKRES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_okresy',
   'c_okresy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_opacim',
   'c_opacim.adi',
   'C_OPACI1',
   'DTOS ( DDATZKOPAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_oprakt',
   'c_oprakt.adi',
   'INFSUM01',
   'NKODOPRAKT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_oprakt',
   'c_oprakt.adi',
   'INFSUM02',
   'UPPER(CNAZOPRAKT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_oprakt',
   'c_oprakt.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_opravn',
   'c_opravn.adi',
   'C_OPRAVN01',
   'UPPER(COPRAVNENI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_opravn',
   'c_opravn.adi',
   'C_OPRAVN02',
   'UPPER(CNAZOPRAVN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_opravn',
   'c_opravn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_opravy',
   'c_opravy.adi',
   'C_DRUHO1',
   'NDRUHOPRAV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_opravy',
   'c_opravy.adi',
   'C_DRUHO2',
   'UPPER(CNAZEVDRUH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parame',
   'c_parame.adi',
   'C_PARAME01',
   'UPPER(CPARAMETR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parame',
   'c_parame.adi',
   'C_PARAME02',
   'UPPER(CNAZPARAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parame',
   'c_parame.adi',
   'C_PARAME03',
   'UPPER(CSKUPPAR) +UPPER(CPARAMETR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parame',
   'c_parame.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parsku',
   'c_parsku.adi',
   'C_PARSKU01',
   'CSKUPPAR',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parsku',
   'c_parsku.adi',
   'C_PARSKU02',
   'UPPER(CNAZSKUPPA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_parsku',
   'c_parsku.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_plemen',
   'c_plemen.adi',
   'C_PLEMEN1',
   'UPPER(CPLEMENO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_plemen',
   'c_plemen.adi',
   'C_PLEMEN2',
   'UPPER(CNAZPLEMEN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_plemen',
   'c_plemen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_podruc',
   'c_podruc.adi',
   'C_PODR1',
   'UPPER(CZKRATMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_podruc',
   'c_podruc.adi',
   'C_PODR2',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRATMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_podruc',
   'c_podruc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pojust',
   'c_pojust.adi',
   'C_POJUST01',
   'UPPER(CZKRPOJIST)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pojust',
   'c_pojust.adi',
   'C_POJUST02',
   'UPPER(CNAZPOJIST)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pojust',
   'c_pojust.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_polrvp',
   'c_polrvp.adi',
   'C_POLRVP01',
   'UPPER(CRZ_VP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_polrvp',
   'c_polrvp.adi',
   'C_POLRVP02',
   'STRZERO(NTYPNAP,1) +STRZERO(NFIELD_VP,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_polrvp',
   'c_polrvp.adi',
   'C_POLRVP03',
   'NDRUHMZDY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_polrvp',
   'c_polrvp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracdo',
   'c_pracdo.adi',
   'DELPRD01',
   'UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracdo',
   'c_pracdo.adi',
   'DELPRD02',
   'UPPER(CNAZDELPRD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracdo',
   'c_pracdo.adi',
   'DELPRD03',
   'NHODTYDEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracdo',
   'c_pracdo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC1',
   'UPPER(COZNPRAC) +UPPER(CNAZEVPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC2',
   'UPPER(CNAZEVPRAC) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC3',
   'UPPER(COZNPRAC) +UPPER(CSTRED) +UPPER(CNAZEVPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracov',
   'c_pracov.adi',
   'C_PRAC4',
   'UPPER(COZNPRACN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracov',
   'c_pracov.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracsm',
   'c_pracsm.adi',
   'PRACSM_1',
   'UPPER(CTYPSMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracsm',
   'c_pracsm.adi',
   'PRACSM_2',
   'UPPER(CNAZSMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracsm',
   'c_pracsm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracvz',
   'c_pracvz.adi',
   'PRACVZ01',
   'NTYPPRAVZT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracvz',
   'c_pracvz.adi',
   'PRACVZ02',
   'UPPER(CNAZPRAVZT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracvz',
   'c_pracvz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracza',
   'c_pracza.adi',
   'PRAZAR01',
   'UPPER(CPRACZAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracza',
   'c_pracza.adi',
   'PRAZAR02',
   'UPPER(CNAZPRACZA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pracza',
   'c_pracza.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pravfo',
   'c_pravfo.adi',
   'C_PRFOR1',
   'NKODPRFORM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pravfo',
   'c_pravfo.adi',
   'C_PRFOR2',
   'UPPER(CPOPISPRFO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pravfo',
   'c_pravfo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prepmj',
   'c_prepmj.adi',
   'C_PREPMJ01',
   'UPPER(CVYCHOZIMJ)+ UPPER(CCILOVAMJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prepmj',
   'c_prepmj.adi',
   'C_PREPMJ02',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + UPPER(CVYCHOZIMJ)+ UPPER(CCILOVAMJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prepmj',
   'c_prepmj.adi',
   'C_PREPMJ03',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + UPPER(CCILOVAMJ)+ UPPER(CVYCHOZIMJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prerus',
   'c_prerus.adi',
   'PRER1',
   'UPPER(CKODPRER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prerus',
   'c_prerus.adi',
   'PRER2',
   'UPPER(CNAZPRER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prerus',
   'c_prerus.adi',
   'PRER3',
   'NKODPRER',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prerus',
   'c_prerus.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pripl',
   'c_pripl.adi',
   'C_PRIPL1',
   'UPPER(CKODPRIPL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pripl',
   'c_pripl.adi',
   'C_PRIPL2',
   'STRZERO(NDRUHMZDY,4) +UPPER(CKODPRIPL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pripom',
   'c_pripom.adi',
   'C_PRIPOM01',
   'UPPER(CTYPPRIPOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pripom',
   'c_pripom.adi',
   'C_PRIPOM02',
   'UPPER(CNAZPRIPOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_pripom',
   'c_pripom.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prodej',
   'c_prodej.adi',
   'PRODEJ1',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prodej',
   'c_prodej.adi',
   'PRODEJ2',
   'UPPER(CNAZPRODEJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_prodej',
   'c_prodej.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_psc',
   'c_psc.adi',
   'C_PSC1',
   'UPPER(CPSC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_psc',
   'c_psc.adi',
   'C_PSC2',
   'UPPER(CMISTO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_psc',
   'c_psc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_rodsta',
   'c_rodsta.adi',
   'ZKRRODST',
   'UPPER(CZKRRODSTV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_rodsta',
   'c_rodsta.adi',
   'NAZRODST',
   'UPPER(CNAZRODSTV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_rodsta',
   'c_rodsta.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_sklady',
   'c_sklady.adi',
   'C_SKLAD1',
   'UPPER( CCISSKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_sklady',
   'c_sklady.adi',
   'C_SKLAD2',
   'UPPER( CNAZSKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_sklady',
   'c_sklady.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skolen',
   'c_skolen.adi',
   'CSKOLE01',
   'UPPER(CZKRATKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skolen',
   'c_skolen.adi',
   'CSKOLE02',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skolen',
   'c_skolen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skolit',
   'c_skolit.adi',
   'CSKOLI01',
   'UPPER(CZKRATSKOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skolit',
   'c_skolit.adi',
   'CSKOLI02',
   'UPPER(CNAZEVSKOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skolit',
   'c_skolit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skoluk',
   'c_skoluk.adi',
   'CUKOSK01',
   'UPPER(CZKRATKAUK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skoluk',
   'c_skoluk.adi',
   'CUKOSK02',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skoluk',
   'c_skoluk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skumis',
   'c_skumis.adi',
   'C_1',
   'UPPER(CKLICSKMIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skumis',
   'c_skumis.adi',
   'C_2',
   'UPPER(CNAZSKMIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skumis',
   'c_skumis.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skupol',
   'c_skupol.adi',
   'SKUPOL1',
   'UPPER(CSKUPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skupol',
   'c_skupol.adi',
   'SKUPOL2',
   'UPPER(CNAZSKUPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skupol',
   'c_skupol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skupuc',
   'c_skupuc.adi',
   'SKUPUC_1',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skupuc',
   'c_skupuc.adi',
   'SKUPUC_2',
   'UPPER(CNAZSKUPUC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_skupuc',
   'c_skupuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_spojen',
   'c_spojen.adi',
   'C_SPOJEN01',
   'UPPER(CZKRSPOJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_spojen',
   'c_spojen.adi',
   'C_SPOJEN02',
   'UPPER(CTYPSPOJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_spojen',
   'c_spojen.adi',
   'C_SPOJEN03',
   'UPPER(CNAZSPOJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_spojen',
   'c_spojen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_srazky',
   'c_srazky.adi',
   'C_SRAZKY01',
   'UPPER(CZKRSRAZKY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_srazky',
   'c_srazky.adi',
   'C_SRAZKY02',
   'UPPER(CNAZSRAZKY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_srazky',
   'c_srazky.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stapri',
   'c_stapri.adi',
   'C_STAPRI01',
   'NSTAPRIPOM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stapri',
   'c_stapri.adi',
   'C_STAPRI02',
   'UPPER(CNAZSTAPRI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stapri',
   'c_stapri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stares',
   'c_stares.adi',
   'C_STARES01',
   'UPPER(CZKRSTARES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stares',
   'c_stares.adi',
   'C_STARES02',
   'UPPER(CTYPSTARES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stares',
   'c_stares.adi',
   'C_STARES03',
   'UPPER(CNAZSTARES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stares',
   'c_stares.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_statpr',
   'c_statpr.adi',
   'STAPRI01',
   'UPPER(CZKRSTAPRI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_statpr',
   'c_statpr.adi',
   'STAPRI02',
   'UPPER(CNAZSTAPRI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_statpr',
   'c_statpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_staty',
   'c_staty.adi',
   'C_STATY1',
   'UPPER(CZKRATSTAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_staty',
   'c_staty.adi',
   'C_STATY2',
   'UPPER(CNAZEVSTAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_staty',
   'c_staty.adi',
   'C_STATY3',
   'UPPER(CZKRATMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_staty',
   'c_staty.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stred',
   'c_stred.adi',
   'STRED1',
   'UPPER(CSTRED)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stred',
   'c_stred.adi',
   'STRED2',
   'UPPER(CNAZSTR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stred',
   'c_stred.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_streod',
   'c_streod.adi',
   'C_STRE1',
   'STRZERO(NCISFIRMY,5) +UPPER(CSTRED_ODB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_streod',
   'c_streod.adi',
   'C_STRE2',
   'STRZERO(NCISFIRMY,5) +UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_streod',
   'c_streod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_strjod',
   'c_strjod.adi',
   'C_STRE1',
   'STRZERO(NCISFIRMY,5) +UPPER(CSTROJ_ODB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_strjod',
   'c_strjod.adi',
   'C_STRE2',
   'STRZERO(NCISFIRMY,5) +UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_strjod',
   'c_strjod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stroje',
   'c_stroje.adi',
   'C_STROJ1',
   'NTYPSTROJE',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_stroje',
   'c_stroje.adi',
   'C_STROJ2',
   'UPPER(CNAZEVTYPU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_svatky',
   'c_svatky.adi',
   'C_SVATKY01',
   'DTOS ( DDATUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_svatky',
   'c_svatky.adi',
   'C_SVATKY02',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_svatky',
   'c_svatky.adi',
   'C_SVATKY03',
   'STRZERO(NROK,4) +STRZERO(NMESIC,2) +STRZERO(NDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_svatky',
   'c_svatky.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC1',
   'UPPER(CUCETSY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC3',
   'UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_syntuc',
   'c_syntuc.adi',
   'CSYNTUC4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_syntuc',
   'c_syntuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarif',
   'c_tarif.adi',
   'C_TARIF1',
   'UPPER(CTARIFSTUP) +UPPER(CTARIFTRID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarif',
   'c_tarif.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarify',
   'c_tarify.adi',
   'C_TARIFY01',
   'UPPER(CTARIFSTUP) +UPPER(CTARIFTRID) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarify',
   'c_tarify.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarstu',
   'c_tarstu.adi',
   'C_TARSTU01',
   'UPPER(CTARIFSTUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarstu',
   'c_tarstu.adi',
   'C_TARSTU02',
   'UPPER(CNAZTARSTU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tarstu',
   'c_tarstu.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tartri',
   'c_tartri.adi',
   'C_TARTRI01',
   'UPPER(CTARIFTRID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tartri',
   'c_tartri.adi',
   'C_TARTRI02',
   'UPPER(CNAZTARTRI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tartri',
   'c_tartri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_task',
   'c_task.adi',
   'C_TASK01',
   'UPPER(CTASK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_task',
   'c_task.adi',
   'C_TASK02',
   'UPPER(CNAZULOHY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_task',
   'c_task.adi',
   'C_TASK03',
   'UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_task',
   'c_task.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_termin',
   'c_termin.adi',
   'TERMIN01',
   'NPORTERMIN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_termin',
   'c_termin.adi',
   'TERMIN02',
   'UPPER(CNAZTERMIN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_termin',
   'c_termin.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_titpr',
   'c_titpr.adi',
   'C_TITPR01',
   'UPPER(CTITULPRED)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_titpr',
   'c_titpr.adi',
   'C_TITPR02',
   'UPPER(CNAZTITPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_titpr',
   'c_titpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_titza',
   'c_titza.adi',
   'C_TITZA01',
   'UPPER(CTITULZA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_titza',
   'c_titza.adi',
   'C_TITZA02',
   'UPPER(CNAZTITZA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_titza',
   'c_titza.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_trasy',
   'c_trasy.adi',
   'TRASY1',
   'UPPER(CCISTRASY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_trasy',
   'c_trasy.adi',
   'TRASY2',
   'UPPER(CNAZTRASY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_trasy',
   'c_trasy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC1',
   'UPPER(CUCETTR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC3',
   'UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_triduc',
   'c_triduc.adi',
   'CTRIDUC4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_triduc',
   'c_triduc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typabo',
   'c_typabo.adi',
   'TYPABO01',
   'UPPER(CTYPABO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typabo',
   'c_typabo.adi',
   'TYPABO02',
   'UPPER(CPOPISABO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typabo',
   'c_typabo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typblo',
   'c_typblo.adi',
   'C_TYPBL0',
   'UPPER(CTYPBLOKAC) +UPPER(CPOPISTYPU) +UPPER(CKODBLOKAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typcen',
   'c_typcen.adi',
   'C_TYPCE1',
   'UPPER(CTYPSKLCEN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typcen',
   'c_typcen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdan',
   'c_typdan.adi',
   'C_TYPDAN01',
   'NTYPDANE',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdan',
   'c_typdan.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdim',
   'c_typdim.adi',
   'C_1',
   'NTYPDIM',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdim',
   'c_typdim.adi',
   'C_2',
   'UPPER(CNAZTYPDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdim',
   'c_typdim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdkm',
   'c_typdkm.adi',
   'C_TYPDKM01',
   'UPPER(CTYPDOKUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdkm',
   'c_typdkm.adi',
   'C_TYPDKM02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdkm',
   'c_typdkm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdmz',
   'c_typdmz.adi',
   'C_TYPDMZ01',
   'UPPER(CTYPDMZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdmz',
   'c_typdmz.adi',
   'C_TYPDMZ02',
   'UPPER(CNAZTYPDMZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdmz',
   'c_typdmz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdok',
   'c_typdok.adi',
   'C_TYPDOK01',
   'UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typdok',
   'c_typdok.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfak',
   'c_typfak.adi',
   'TYPFAK1',
   'UPPER(CZKRTYPFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfak',
   'c_typfak.adi',
   'TYPFAK2',
   'UPPER(CPOPISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfak',
   'c_typfak.adi',
   'TYPFAK3',
   'STRZERO(NFINTYP,1) +UPPER(CPOPISFAK) +IF (LISPARFAK, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfak',
   'c_typfak.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfo',
   'c_typfo.adi',
   'C_FYZOS1',
   'UPPER(NKODFYZOSB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfo',
   'c_typfo.adi',
   'C_FYZOS2',
   'UPPER(CPOPISFYOS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typfo',
   'c_typfo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typhod',
   'c_typhod.adi',
   'C_1',
   'UPPER(CTYPHODNOC)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typhod',
   'c_typhod.adi',
   'C_2',
   'UPPER(CNAZTYPHOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typhod',
   'c_typhod.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkai',
   'c_typkai.adi',
   'C_TYPKAI1',
   'NKARTA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkai',
   'c_typkai.adi',
   'C_TYPKAI2',
   'UPPER(CPOPISKAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkai',
   'c_typkai.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkar',
   'c_typkar.adi',
   'TYPKAR1',
   'NKARTA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkar',
   'c_typkar.adi',
   'TYPKAR2',
   'UPPER( CPOPISKAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkar',
   'c_typkar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkaz',
   'c_typkaz.adi',
   'C_TYPKAZ1',
   'NKARTA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkaz',
   'c_typkaz.adi',
   'C_TYPKAZ2',
   'UPPER(CPOPISKAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typkaz',
   'c_typkaz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typlis',
   'c_typlis.adi',
   'C_TYPLI1',
   'UPPER(CTYPLISTKU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmaj',
   'c_typmaj.adi',
   'C_TYPMAJ1',
   'NTYPMAJ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmaj',
   'c_typmaj.adi',
   'C_TYPMAJ2',
   'UPPER(CNAZTYPU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmaj',
   'c_typmaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmat',
   'c_typmat.adi',
   'TYPMAT1',
   'UPPER(CTYPMAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmat',
   'c_typmat.adi',
   'TYPMAT2',
   'UPPER(CNAZTYPMAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmat',
   'c_typmat.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmer',
   'c_typmer.adi',
   'C_1',
   'UPPER(CTYPMERENI)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmer',
   'c_typmer.adi',
   'C_2',
   'UPPER(CNAZTYPMER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typmer',
   'c_typmer.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typop',
   'c_typop.adi',
   'TYPOPER1',
   'UPPER(CTYPOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typop',
   'c_typop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH01',
   'UPPER(CULOHA)+UPPER(CPODULOHA)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH02',
   'UPPER(CULOHA)+UPPER(CPODULOHA) +UPPER(CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH03',
   'UPPER(CTYPPOHYBU)+UPPER(CULOHA)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH04',
   'UPPER(CTASK)+UPPER(CPODULOHA)+UPPER(CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH05',
   'UPPER(CULOHA)+UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'C_TYPPOH06',
   'UPPER(CULOHA)+UPPER(CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpoh',
   'c_typpoh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpol',
   'c_typpol.adi',
   'TYPPOL1',
   'UPPER(CTYPPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpol',
   'c_typpol.adi',
   'TYPPOL2',
   'UPPER(CNAZTYPPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typpol',
   'c_typpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typses',
   'c_typses.adi',
   'C_1',
   'UPPER(CTYPSESTAV)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typses',
   'c_typses.adi',
   'C_2',
   'UPPER(CNAZTYPSES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typses',
   'c_typses.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typskp',
   'c_typskp.adi',
   'C_SKP1',
   'UPPER(CTYPSKP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typskp',
   'c_typskp.adi',
   'C_SKP2',
   'UPPER(CNAZTYPSKP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typskp',
   'c_typskp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typspo',
   'c_typspo.adi',
   'C_TYPSPO01',
   'UPPER(CTYPSPOJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typspo',
   'c_typspo.adi',
   'C_TYPSPO02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typspo',
   'c_typspo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typsrz',
   'c_typsrz.adi',
   'C_TYPSRZ01',
   'UPPER(CTYPSRZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typsrz',
   'c_typsrz.adi',
   'C_TYPSRZ02',
   'UPPER(CNAZTYPSRZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typsrz',
   'c_typsrz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typtrp',
   'c_typtrp.adi',
   'C_TYPTRP01',
   'UPPER(CZKRTRVPLA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typtrp',
   'c_typtrp.adi',
   'C_TYPTRP02',
   'UPPER(CNAZTYPTRP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typtrp',
   'c_typtrp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typuct',
   'c_typuct.adi',
   'TYPUCT1',
   'UPPER(CULOHA) +UPPER(CTYPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typuct',
   'c_typuct.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typuhr',
   'c_typuhr.adi',
   'TYPUHR1',
   'UPPER(CZKRTYPUHR)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typuhr',
   'c_typuhr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typukl',
   'c_typukl.adi',
   'C_TYPUKL01',
   'UPPER(CTYPUKOLU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typukl',
   'c_typukl.adi',
   'C_TYPUKL02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typukl',
   'c_typukl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typvys',
   'c_typvys.adi',
   'C_TYPVYS01',
   'UPPER(CTYPVYS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typvys',
   'c_typvys.adi',
   'C_TYPVYS02',
   'UPPER(CNAZTYPVYS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typvys',
   'c_typvys.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_typzak',
   'c_typzak.adi',
   'C_TYPZAK1',
   'UPPER(CTYPZAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tystre',
   'c_tystre.adi',
   'C_TYSTRE01',
   'UPPER(CTYPSTARES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tystre',
   'c_tystre.adi',
   'C_TYSTRE02',
   'UPPER(CNAZTYP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_tystre',
   'c_tystre.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctden',
   'c_uctden.adi',
   'C_UCTDEN01',
   'UPPER(CDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctden',
   'c_uctden.adi',
   'C_UCTDEN02',
   'UPPER(CNAZDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctden',
   'c_uctden.adi',
   'C_UCTDEN03',
   'UPPER(CTASK)+UPPER(CDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctden',
   'c_uctden.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN1',
   'UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN2',
   'UPPER(CNAZ_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN3',
   'UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctosn',
   'c_uctosn.adi',
   'UCTOSN4',
   'UPPER(CSKUPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctosn',
   'c_uctosn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskl',
   'c_uctskl.adi',
   'UCTSKL1',
   'STRZERO(NCISLPOH,5) +STRZERO(NUCETSK_OD,3) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskl',
   'c_uctskl.adi',
   'UCTSKL2',
   'NCISLPOH',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskl',
   'c_uctskl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskp',
   'c_uctskp.adi',
   'C_USKUP1',
   'NUCETSKUP',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskp',
   'c_uctskp.adi',
   'C_USKUP2',
   'UPPER (CNAZUCTSK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskp',
   'c_uctskp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskz',
   'c_uctskz.adi',
   'C_UCTSKZ1',
   'NUCETSKUP',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskz',
   'c_uctskz.adi',
   'C_UCTSKZ2',
   'UPPER(CNAZUCTSK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uctskz',
   'c_uctskz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukoly',
   'c_ukoly.adi',
   'C_UKOLY01',
   'UPPER(CZKRUKOLU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukoly',
   'c_ukoly.adi',
   'C_UKOLY02',
   'UPPER(CTYPUKOLU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukoly',
   'c_ukoly.adi',
   'C_UKOLY03',
   'UPPER(CNAZUKOLU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukoly',
   'c_ukoly.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukonpv',
   'c_ukonpv.adi',
   'UKPRVZ01',
   'NTYPUKOPRV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukonpv',
   'c_ukonpv.adi',
   'UKPRVZ02',
   'UPPER(CNAZUKOPRV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ukonpv',
   'c_ukonpv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'C_ULOZM1',
   'UPPER(CCISSKLAD)+ UPPER (CULOZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'C_ULOZM2',
   'UPPER(CULOZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'C_ULOZM3',
   'UPPER (CNAZEVMIST)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_ulozmi',
   'c_ulozmi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uzvzth',
   'c_uzvzth.adi',
   'C_UZVZT1',
   'UPPER(CZKRATUZVZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uzvzth',
   'c_uzvzth.adi',
   'C_UZVZT2',
   'UPPER(CNAZUZVZTH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_uzvzth',
   'c_uzvzth.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vbanuc',
   'c_vbanuc.adi',
   'BANKUC1',
   'UPPER(CVNBAN_UCT)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vbanuc',
   'c_vbanuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vniuct',
   'c_vniuct.adi',
   'VNIUCT1',
   'UPPER(CNAZPOL2) +UPPER(CTYPZAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vniuct',
   'c_vniuct.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vnmzuc',
   'c_vnmzuc.adi',
   'C_VNMZUC01',
   'NUCETMZDY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vnmzuc',
   'c_vnmzuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vnsast',
   'c_vnsast.adi',
   'C_VNSAST01',
   'UPPER(CCISSTROJE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vnsast',
   'c_vnsast.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vozdr',
   'c_vozdr.adi',
   'C_VOZDR1',
   'UPPER(CVOZDRUH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vozkat',
   'c_vozkat.adi',
   'C_VOZKA1',
   'UPPER(CVOZKATEG)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_voztyp',
   'c_voztyp.adi',
   'C_VOZT1',
   'UPPER(CVOZTYP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vycnsh',
   'c_vycnsh.adi',
   'VYCNSH01',
   'STRZERO(NTYP_VYCNS,1) +UPPER(CNAZPOLVYC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vycnsh',
   'c_vycnsh.adi',
   'VYCNSH02',
   'STRZERO(NTYP_VYCNS,1) +UPPER(CNAZPOLNAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vycnsh',
   'c_vycnsh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vycnsi',
   'c_vycnsi.adi',
   'VYCNSI01',
   'STRZERO(NTYP_VYCNS,1) +UPPER(CNAZPOLVYC) +UPPER(CNAZPOLX)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vycnsi',
   'c_vycnsi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykazm',
   'c_vykazm.adi',
   'C_VYKAZM01',
   'NDRUHMZDY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykazm',
   'c_vykazm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykazy',
   'c_vykazy.adi',
   'C_VYKAZY1',
   'STRZERO( NVYKAZ, 3) + UPPER( CPROMRADEK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykazy',
   'c_vykazy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH1',
   'STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH2',
   'LSETS__DPH',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH3',
   'STRZERO(NRADEK_VAZ,3) +STRZERO(NRADEK_DPH,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykdph',
   'c_vykdph.adi',
   'VYKDPH4',
   'STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3) +STRZERO(NDAT_OD,8)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykdph',
   'c_vykdph.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykrad',
   'c_vykrad.adi',
   'C_VYKRAD01',
   'NRADEKVYK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vykrad',
   'c_vykrad.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vyplmi',
   'c_vyplmi.adi',
   'C_VYPLMI01',
   'UPPER(CVYPLMIST)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vyplmi',
   'c_vyplmi.adi',
   'C_VYPLMI02',
   'UPPER(CNAZVYPLMI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vyplmi',
   'c_vyplmi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vzdel',
   'c_vzdel.adi',
   'VZDELA01',
   'UPPER(CZKRVZDEL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vzdel',
   'c_vzdel.adi',
   'VZDELA02',
   'UPPER(CNAZVZDELA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vzdel',
   'c_vzdel.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vzdeuk',
   'c_vzdeuk.adi',
   'UKOVZD01',
   'UPPER(CZKRUKOVZD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vzdeuk',
   'c_vzdeuk.adi',
   'UKOVZD02',
   'UPPER(CNAZUKOVZD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_vzdeuk',
   'c_vzdeuk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamest',
   'c_zamest.adi',
   'ZAMEST1',
   'NOSCISPRAC',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamest',
   'c_zamest.adi',
   'ZAMEST2',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamest',
   'c_zamest.adi',
   'ZAMEST3',
   'IF (LPRI_ZAL, ''1'', ''0'') +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamest',
   'c_zamest.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamevz',
   'c_zamevz.adi',
   'ZAMVZT01',
   'NTYPZAMVZT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamevz',
   'c_zamevz.adi',
   'ZAMVZT02',
   'UPPER(CNAZZAMVZT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zamevz',
   'c_zamevz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zaokr',
   'c_zaokr.adi',
   'C_ZAOKR1',
   'NKODZAOKR',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zaokr',
   'c_zaokr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'ZDRPOJ01',
   'NZDRPOJIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'ZDRPOJ02',
   'UPPER(CZKRZDRPOJ) +UPPER(CNAZZDRPOJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'ZDRPOJ03',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zdrpoj',
   'c_zdrpoj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zpudop',
   'c_zpudop.adi',
   'TYPUHR1',
   'UPPER(CZKRZPUDOP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zpudop',
   'c_zpudop.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zpusrz',
   'c_zpusrz.adi',
   'ZPUSRZ01',
   'UPPER(CZPUSSRAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zpusrz',
   'c_zpusrz.adi',
   'ZPUSRZ02',
   'UPPER(CPOPISZPSR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'c_zpusrz',
   'c_zpusrz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenprodc',
   'cenprodc.adi',
   'CENPROD1',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenprodc',
   'cenprodc.adi',
   'CENPROD2',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenprodc',
   'cenprodc.adi',
   'CENPROD3',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenprodc',
   'cenprodc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_in',
   'cenzb_in.adi',
   'CENINV01',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATINVEN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_in',
   'cenzb_in.adi',
   'CENINV02',
   'DTOS (DDATINVEN) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_in',
   'cenzb_in.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_ns',
   'cenzb_ns.adi',
   'CENZBNS1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_ns',
   'cenzb_ns.adi',
   'CENZBNS2',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_ns',
   'cenzb_ns.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_ps',
   'cenzb_ps.adi',
   'CENPS01',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_ps',
   'cenzb_ps.adi',
   'CENPS02',
   'STRZERO(NROK,4) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzb_ps',
   'cenzb_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK01',
   'UPPER( CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK02',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK03',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) +STRZERO(NKLICNAZ,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK04',
   'UPPER(CCISSKLAD) + UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK05',
   'STRZERO(NZBOZIKAT,4) + UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK06',
   'STRZERO(NKLICNAZ,5) + UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK07',
   'UPPER(CCISSKLAD) +STRZERO(NZBOZIKAT,4) + UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK08',
   'NCARKKOD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK09',
   'NMNOZKZBO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK10',
   'STRZERO(NUCETSKUP,3) + UPPER(CCISSKLAD) + UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK11',
   'UPPER(CKATCZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK12',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK13',
   'UPPER(CSKLPOL) + UPPER(CCISSKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'CENIK14',
   'UPPER(CZKRCARKOD) + UPPER(CCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cenzboz',
   'cenzboz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cinfsum',
   'cinfsum.adi',
   'INFSUM01',
   'UPPER(CKODSUMRAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cinfsum',
   'cinfsum.adi',
   'INFSUM02',
   'UPPER(CNAZSUMRAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cinfsum',
   'cinfsum.adi',
   'INFSUM03',
   'NPORADI',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cinfsum',
   'cinfsum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol1',
   'cnazpol1.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol1',
   'cnazpol1.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol1',
   'cnazpol1.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol2',
   'cnazpol2.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL2 )',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol2',
   'cnazpol2.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol2',
   'cnazpol2.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol3',
   'cnazpol3.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL3)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol3',
   'cnazpol3.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol3',
   'cnazpol3.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol4',
   'cnazpol4.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL4)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol4',
   'cnazpol4.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol4',
   'cnazpol4.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol5',
   'cnazpol5.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL5)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol5',
   'cnazpol5.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol5',
   'cnazpol5.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol6',
   'cnazpol6.adi',
   'CNAZPOL1',
   'UPPER(CNAZPOL6)',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol6',
   'cnazpol6.adi',
   'CNAZPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'cnazpol6',
   'cnazpol6.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_01',
   'UPPER( CTASK + ":" + CITEM )',
   '',
   3,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_02',
   'UPPER( CTASK )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_03',
   'STR( NFORGS, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_04',
   'STR( NSKLADY, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_05',
   'STR( NODBYT, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_06',
   'STR( NFINANCE, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_07',
   'STR( NPOKLADNA, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_08',
   'STR( NDIM, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_09',
   'STR( NIM, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_10',
   'STR( NZVIRATA, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_11',
   'STR( NUCTO, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_12',
   'STR( NZAKAZKY, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_13',
   'STR( NMZDY, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_14',
   'STR( NBCD, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_15',
   'STR( NEVIDSW, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_16',
   'STR( NPRODEJCI, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_17',
   'STR( NTPV, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_18',
   'STR( NRV, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_19',
   'STR( NPRODEJ, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_20',
   'STR( NPERSONAL, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_21',
   'STR( NDOCHAZKA, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'CONFIG_22',
   'STR( NEVIDAS, 1 )',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'config',
   'config.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'confighd',
   'confighd.adi',
   'CONFIGHD01',
   'UPPER(CTASK)+UPPER(CITEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'confighd',
   'confighd.adi',
   'CONFIGHD02',
   'UPPER(CITEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'confighd',
   'confighd.adi',
   'CONFIGHD03',
   'NPRINT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'confighd',
   'confighd.adi',
   'CONFIGHD04',
   'UPPER(CTASKTM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'confighd',
   'confighd.adi',
   'CONFIGHD05',
   'UPPER(CNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'confighd',
   'confighd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configit',
   'configit.adi',
   'CONFIGIT01',
   'UPPER(CTASK)+UPPER(CITEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configit',
   'configit.adi',
   'CONFIGIT02',
   'UPPER(CITEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configit',
   'configit.adi',
   'CONFIGIT03',
   'UPPER(CNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configit',
   'configit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configus',
   'configus.adi',
   'CONFIGUS01',
   'UPPER(CTASK)+UPPER(CITEM)+UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configus',
   'configus.adi',
   'CONFIGUS02',
   'UPPER(CITEM)+UPPER(CTASK)+UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configus',
   'configus.adi',
   'CONFIGUS03',
   'UPPER(CITEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configus',
   'configus.adi',
   'CONFIGUS04',
   'UPPER(CUSER)+UPPER(CTASK)+UPPER(CITEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configus',
   'configus.adi',
   'CONFIGUS05',
   'UPPER(CNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'configus',
   'configus.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH01',
   'UPPER(CIDDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH02',
   'UPPER(CZKRDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH03',
   'UPPER(CNAZDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH04',
   'UPPER(CMAINFILE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH05',
   'UPPER(CTYPDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH06',
   'NID',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH07',
   'UPPER(CNAZDATKOM)+UPPER(CIDDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'DATKOMH08',
   'NBLOK_DEF',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomhd',
   'datkomhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomit',
   'datkomit.adi',
   'DATKOMI01',
   'UPPER(CIDDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomit',
   'datkomit.adi',
   'DATKOMI02',
   'UPPER(CZKRDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomit',
   'datkomit.adi',
   'DATKOMI03',
   'UPPER(CNAZDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'datkomit',
   'datkomit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykhd',
   'defvykhd.adi',
   'DEFVYKHD01',
   'UPPER(CTYPVYKAZU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykhd',
   'defvykhd.adi',
   'DEFVYKHD02',
   'UPPER(CNAZVYKAZU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykhd',
   'defvykhd.adi',
   'DEFVYKHD03',
   'UPPER(CIDVYKAZU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykhd',
   'defvykhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT01',
   'UPPER(CTYPVYKAZU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT02',
   'UPPER(CTASK)+UPPER(CTYPVYKAZU)+UPPER(CSKUPINA1)+UPPER(CSKUPINA2)+UPPER(CSKUPINA3)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT03',
   'UPPER(CTYPVYKAZU)+UPPER(CNAZRADVYK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT04',
   'UPPER(CTYPVYKAZU)+UPPER(CTYPKUMVYK)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT05',
   'UPPER(CTYPVYKAZU)+STRZERO(NSLOUPVYK,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT06',
   'UPPER(CTYPVYKAZU)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'DEFVYKIT07',
   'UPPER(CTASK)+UPPER(CTYPVYKAZU)+UPPER(CSKUPINA1)+UPPER(CSKUPINA2)+UPPER(CSKUPINA3)+STRZERO(NRADEKVYK,4)+STRZERO(NSLOUPVYK,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvykit',
   'defvykit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvyksy',
   'defvyksy.adi',
   'DEFVYKSY01',
   'UPPER(CTYPNAPVYK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvyksy',
   'defvyksy.adi',
   'DEFVYKSY02',
   'UPPER(CNAZNAPVYK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'defvyksy',
   'defvyksy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmaj',
   'dmaj.adi',
   'DMAJ_1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmaj',
   'dmaj.adi',
   'DMAJ_2',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmaj',
   'dmaj.adi',
   'DMAJ_3',
   'STRZERO(NROKODPISU,4) + STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmaj',
   'dmaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmajz',
   'dmajz.adi',
   'DMAJZ_1',
   'STRZERO(NUCETSKUP,3)+ STRZERO(NINVCIS,10) + STRZERO(NROKODPISU,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmajz',
   'dmajz.adi',
   'DMAJZ_2',
   'STRZERO(NUCETSKUP,3)+ STRZERO(NINVCIS,10) + STRZERO(NROKODPISU,4)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmajz',
   'dmajz.adi',
   'DMAJZ_3',
   'STRZERO(NROKODPISU,4) + STRZERO(NUCETSKUP,3)+ STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dmajz',
   'dmajz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'docipodm',
   'docipodm.adi',
   'DOCIPODM01',
   'NCISDODAVK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'docipodm',
   'docipodm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD1',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD2',
   'UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD3',
   'UPPER(CCISLOBINT) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD4',
   'STRZERO(NCISFIRMY,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD5',
   'UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD6',
   'UPPER(CZKRTYPFAK) +UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFIRMY,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD8',
   'STRZERO(NCISFIRMY) +UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD9',
   'STRZERO(NKASA,3) +DTOS (DVYSTFAK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD10',
   'UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD11',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'DODLHD12',
   'UPPER(CNAZEV) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlsthd',
   'dodlsthd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT1',
   'STRZERO(NDOKLAD,10) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT3',
   'UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT4',
   'UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT5',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT6',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISVYSFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT7',
   'STRZERO(NCISLOEL,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT8',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT9',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'DODLIT10',
   'NSTAV_FAKT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodlstit',
   'dodlstit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodterm',
   'dodterm.adi',
   'DODTERM01',
   'UPPER(CZKRCARKOD) + UPPER(CCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodterm',
   'dodterm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV1',
   'NKLICNAZ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV2',
   'STRZERO(NCISFIRMY,5) +STRZERO(NKLICNAZ,5) +STRZERO(NCENAOZBO,13)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV3',
   'UPPER(CSKLPOL) +IF (LHLAVNIDOD, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV4',
   'STRZERO(NCISFIRMY,5) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV5',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV6',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CZKRATMENY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV7',
   'LHLAVNIDOD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'DODAV8',
   'UPPER(CZKRCARKOD) + UPPER(CCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dodzboz',
   'dodzboz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'doklisoz',
   'doklisoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dokonc',
   'dokonc.adi',
   'DOKONC1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dokonc',
   'dokonc.adi',
   'DOKONC2',
   'UPPER(CCISZAKAZ) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZAOBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dokument',
   'dokument.adi',
   'DOKUMEN01',
   'NCISDOKUM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dokument',
   'dokument.adi',
   'DOKUMEN02',
   'NIDDOKUM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dokument',
   'dokument.adi',
   'DOKUMEN03',
   'UPPER(CIDDOKUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dokument',
   'dokument.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2001',
   'dph_2001.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2001',
   'dph_2001.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2001',
   'dph_2001.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2004',
   'dph_2004.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2004',
   'dph_2004.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2004',
   'dph_2004.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2009',
   'dph_2009.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2009',
   'dph_2009.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dph_2009',
   'dph_2009.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dphdata',
   'dphdata.adi',
   'DPHDATA',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dphdata',
   'dphdata.adi',
   'DPHDATA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dphdata',
   'dphdata.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'druhymzd',
   'druhymzd.adi',
   'DRMZDY1',
   'NDRUHMZDY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'druhymzd',
   'druhymzd.adi',
   'DRMZDY2',
   'UPPER(CNAZEVDMZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'druhymzd',
   'druhymzd.adi',
   'DRMZDY3',
   'NTYPDOVOL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'druhymzd',
   'druhymzd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +UPPER(CKODPRER)       +STRZERO(NCASBEG,5,2) +STRZERO(NCASEND,5,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +UPPER(CKODPRERE)      +STRZERO(NCASEND,5,2) +STRZERO(NCASBEG,5,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY03',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUM)     +UPPER(CCASEND)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY04',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUMPL)   +UPPER(CCASEND)        +UPPER(CKODPRER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY05',
   'STRZERO(NROK,4)       +STRZERO(NMESIC,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY06',
   'UPPER(CIDOSKARTY)     +UPPER(CKODPRER)   +STRZERO(NCASEND,5,2)  +STRZERO(NROK,4)    +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY07',
   'UPPER(CIDOSKARTY)     +UPPER(CKODPRERE)  +STRZERO(NCASBEG,5,2)  +STRZERO(NROK,4)    +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY08',
   'UPPER(CIDOSKARTY)     +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +STRZERO(NCASTMP,5,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NSAYSCR,2) +STRZERO(NDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY10',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)   +STRZERO(NMESIC,2)     +STRZERO(NDEN,2)    +STRZERO(NSAYCRD,2)    +UPPER(CKODPRER)      +STRZERO(NCASBEG,5,2) +STRZERO(NCASEND,5,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY11',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUM)     +UPPER(CKODPRER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY12',
   'STRZERO(NOSCISPRAC,5) +DTOS (DDATUM)     +STRZERO(NPRITPRAC,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'DSPOHY13',
   'STRZERO(NOSCISPRAC,5) +UPPER(CKODPRER)   +DTOS (DDATUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'dspohyby',
   'dspohyby.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'duchody',
   'duchody.adi',
   'DUCHD_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'duchody',
   'duchody.adi',
   'DUCHD_02',
   'UPPER(CRODCISPRA) +IF (LAKTIV, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'duchody',
   'duchody.adi',
   'DUCHO_03',
   'UPPER(CRODCISPRA) +STRZERO(NTYPDUCHOD,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'duchody',
   'duchody.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'elnardim',
   'elnardim.adi',
   'DIM1',
   'NINVCISDIM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'elnardim',
   'elnardim.adi',
   'DIM2',
   'UPPER(CVYROBCE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'elnardim',
   'elnardim.adi',
   'DIM3',
   'UPPER(CIDCISLO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'elnardim',
   'elnardim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errkar',
   'errkar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errkarob',
   'errkarob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errkumul',
   'errkumul.adi',
   'ERRKUM1',
   'DTOS (DDATKONTR) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errkumul',
   'errkumul.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errmnoz',
   'errmnoz.adi',
   'ERRMNOZ1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errmnoz',
   'errmnoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errstav',
   'errstav.adi',
   'ERRSTAV1',
   'DTOS (DDATKONTR) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errstav',
   'errstav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'errzmobd',
   'errzmobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_02',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_03',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_04',
   'STRZERO(NROK,4) +UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_05',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ELDPI_06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidp04',
   'evlidp04.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_01',
   'UPPER(CRODCISPRA) +STRZERO(NDOKLAD,10) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_02',
   'UPPER(CRODCISPRA) +STRZERO(NPOREVIDLI,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_03',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_04',
   'UPPER(CRODCISPRA) +STRZERO(NDOKLAD,10) +STRZERO(NITPOPRVZT,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'ELDPI_05',
   'UPPER(CRODCISPRA) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'evlidupi',
   'evlidupi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explsthd',
   'explsthd.adi',
   'EXPLSTHD01',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explsthd',
   'explsthd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT01',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT02',
   'STRZERO(NDOKLAD,10) +UPPER(CCISZAKAZI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT03',
   'UPPER(CCISZAKAZI)   +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explstit',
   'explstit.adi',
   'EXPLSTIT04',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'explstit',
   'explstit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD3',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD4',
   'UPPER(CSIDLO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD5',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD6',
   'DTOS ( DSPLATFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NDOKLAD,10) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD8',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD9',
   'NCENZAKCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD10',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRTYPFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD11',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD12',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD13',
   'UPPER(CTEXTFAKT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD14',
   'STRZERO(NCISFIRMY,5) +STRZERO(NFINTYP,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD15',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD16',
   'NCENZAHCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD17',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD18',
   'STRZERO(NICO,8) +STRZERO(NROK,4) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD19',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD20',
   'UPPER(CISZAL_FAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD21',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'FPRIHD22',
   'UPPER(CNAZEV) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakprihd',
   'fakprihd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD2',
   'UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD3',
   'DTOS (DVYSTFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHH4',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD5',
   'NCENZAKCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD6',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD8',
   'UPPER(CNAZPOL1) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'FODBHD9',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnphd',
   'fakvnphd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT1',
   'STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT2',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT3',
   'STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5) +STRZERO(NSUBCOUNT,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT4',
   'UPPER(CNAZPOL3) +STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT5',
   'UPPER(CNAZPOL1) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'FVYSIT6',
   'UPPER(CCISZAKAZ) +STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvnpit',
   'fakvnpit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD3',
   'UPPER(CCISLOBINT) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD4',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD5',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD6',
   'UPPER(CZKRTYPFAK) +UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFIRMY,5) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD8',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRTYPFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD9',
   'STRZERO(NKASA,3) +DTOS (DVYSTFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD10',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD11',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD12',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD13',
   'DTOS ( DSPLATFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD14',
   'NCENZAKCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD15',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD16',
   'STRZERO(NCISFIRMY,5) +STRZERO(NFINTYP,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD17',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD18',
   'NCENZAHCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD19',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD20',
   'UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD21',
   'STRZERO(NICO,8) +STRZERO(NROK,4) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD22',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD23',
   'UPPER(CISZAL_FAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD24',
   'DTOS ( DVYSTFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD25',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD26',
   'NCISFIRDOA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD27',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'FODBHD28',
   'UPPER(CNAZEV) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvyshd',
   'fakvyshd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT1',
   'STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT3',
   'UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT4',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT5',
   'UPPER(CNAZPOL3) +STRZERO(NCISFAK,10) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT6',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT7',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT8',
   'STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT9',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT10',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT11',
   'STRZERO(NCISLODL,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT12',
   'UPPER(CCISZAKAZI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'FVYSIT13',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fakvysit',
   'fakvysit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS01',
   'UPPER(CIDFILTERS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS02',
   'UPPER(CFLTNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS03',
   'UPPER(CTASK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS04',
   'UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS05',
   'UPPER(CMAINFILE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS06',
   'UPPER(CTYPFILTRS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS07',
   'NCISFILTRS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'FILTRS08',
   'UPPER(CFLTNAME)+UPPER(CIDFILTERS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'filtrs',
   'filtrs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'finpren',
   'finpren.adi',
   'FINPREN1',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'finpren',
   'finpren.adi',
   'FINPREN2',
   'STRZERO(NWKSTATION,3) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'finpren',
   'finpren.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY1',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY3',
   'UPPER(CSIDLO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY4',
   'UPPER(CPSC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY5',
   'NMNOZNEODB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY6',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY7',
   'STRZERO(NKLICOBL,8) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY8',
   'UPPER(CDIC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'FIRMY9',
   'UPPER(CZKRATSTAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmy',
   'firmy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD01',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD02',
   'UPPER(CZKRCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD03',
   'UPPER(CCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmybcd',
   'firmybcd.adi',
   'FIRMYBCD04',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKRCARKOD) +UPPER(CCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmybcd',
   'firmybcd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyda',
   'firmyda.adi',
   'FIRMYDA1',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyda',
   'firmyda.adi',
   'FIRMYDA2',
   'STRZERO(NCISFIRMY,5) +UPPER(CNAZEVDOA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyda',
   'firmyda.adi',
   'FIRMYDA3',
   'NCISFIRDOA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyda',
   'firmyda.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyfi',
   'firmyfi.adi',
   'FIRMYFI1',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyfi',
   'firmyfi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmysk',
   'firmysk.adi',
   'FIRMYSK01',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmysk',
   'firmysk.adi',
   'FIRMYSK02',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKR_SKUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmysk',
   'firmysk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC1',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC2',
   'UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC3',
   'UPPER(CBANK_NAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC4',
   'STRZERO(NCISFIRMY,5) +UPPER(CBANK_NAZ) +UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC5',
   'STRZERO(NCISFIRMY,5) +UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC6',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC7',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'FIRMYUC8',
   'UPPER(CDIC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyuc',
   'firmyuc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyva',
   'firmyva.adi',
   'FIRMYVA01',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyva',
   'firmyva.adi',
   'FIRMYVA02',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKR_SK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyva',
   'firmyva.adi',
   'FIRMYVA03',
   'STRZERO(NCISFIRMY,5) +UPPER(CZKR_SK) +UPPER(CZKR_SKVA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'firmyva',
   'firmyva.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fixnakl',
   'fixnakl.adi',
   'FIXNAK1',
   'STRZERO(NROKVYP,4) +UPPER(CNAZPOL1) +STRZERO(NOBDMES,2) +UPPER(CNAZPOL2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fixnakl',
   'fixnakl.adi',
   'FIXNAK2',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fixnakl',
   'fixnakl.adi',
   'FIXNAK3',
   'UPPER(CNAZPOL1) +STRZERO(NROKVYP,4) +STRZERO(NOBDMES,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fixnakl',
   'fixnakl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS01',
   'UPPER(CUSER)+UPPER(CCALLFORM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS02',
   'UPPER(CFLTNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS03',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDFILTERS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS04',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDFORMS)+UPPER(CIDFILTERS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fltusers',
   'fltusers.adi',
   'FLTUSERS05',
   'UPPER(CIDFILTERS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'fltusers',
   'fltusers.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS01',
   'UPPER(CIDFORMS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS02',
   'UPPER(CFORMNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS03',
   'UPPER(CTASK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS04',
   'UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS05',
   'UPPER(CMAINFILE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS06',
   'UPPER(CTYPFORMS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS07',
   'NCISFORMS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS08',
   'UPPER(CFORMNAME)+UPPER(CIDFORMS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'FORMS09',
   'NFORMS_LL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'forms',
   'forms.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS01',
   'UPPER(CUSER)+UPPER(CCALLFORM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS02',
   'UPPER(CFORMNAME)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS03',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDFORMS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'frmusers',
   'frmusers.adi',
   'FRMUSERS04',
   'UPPER(CIDFORMS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'frmusers',
   'frmusers.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'hodatrib',
   'hodatrib.adi',
   'HODATR1',
   'UPPER(COZNOPER) +UPPER(CATRIBOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'hodatrib',
   'hodatrib.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV1',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NPOZICE,3) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV2',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusov',
   'ikusov.adi',
   'IKUSOV4',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusov',
   'ikusov.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS1',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NPOZICE,3) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS2',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusovs',
   'ikusovs.adi',
   'IKUSOVS4',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ikusovs',
   'ikusovs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'infnap',
   'infnap.adi',
   'INFNAP01',
   'UPPER(SOUBOR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'infnap',
   'infnap.adi',
   'INFNAP02',
   'STRZERO(NROK,4) +UPPER(SOUBOR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'infnap',
   'infnap.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalendar',
   'kalendar.adi',
   'KALENDAR01',
   'DTOS(DDATUM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalendar',
   'kalendar.adi',
   'KALENDAR02',
   'STRZERO(NROK,4) +STRZERO(NTYDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalendar',
   'kalendar.adi',
   'KALENDAR03',
   'STRZERO(NROK,4) +STRZERO(NMESIC,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalendar',
   'kalendar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkmzd',
   'kalkmzd.adi',
   'KALKMZD1',
   'UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkmzd',
   'kalkmzd.adi',
   'KALKMZD2',
   'UPPER(CVYRPOL) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkmzd',
   'kalkmzd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkul',
   'kalkul.adi',
   'KALKUL1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +STRZERO(NROKVYP,4) +STRZERO(NOBDMES,2) +DTOS(DDATAKTUAL) +STRZERO(NPORKALDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkul',
   'kalkul.adi',
   'KALKUL2',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +UPPER(CTYPKALK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkul',
   'kalkul.adi',
   'KALKUL3',
   'UPPER(CCISZAKAZ) +UPPER(CTYPKALK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkul',
   'kalkul.adi',
   'KALKUL4',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)+STRZERO(NSTAVKALK,2) +STRZERO(NROKVYP,4) +STRZERO(NOBDMES,2) +DTOS(DDATAKTUAL) +STRZERO(NPORKALDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkul',
   'kalkul.adi',
   'KALKUL5',
   'UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +UPPER(CTYPKALK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkul',
   'kalkul.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkzak',
   'kalkzak.adi',
   'KALKZAK1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkzak',
   'kalkzak.adi',
   'KALKZAK2',
   'UPPER(CCISZAKAZ) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZAOBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kalkzem',
   'kalkzem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_1',
   'DTOS (DVYHOTPLAN) + UPPER(CPRACZAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_2',
   'DTOS (DVYHOTPLAN) + UPPER(CSTRED) + UPPER(CPRACZAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_3',
   'UPPER(CPRACZAR) + DTOS(DVYHOTPLAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_4',
   'STRZERO(NTYDKAPBLO,2) + UPPER(CPRACZAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_5',
   'UPPER(CPRACZAR) + STRZERO(NTYDKAPBLO,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapl_den',
   'kapl_den.adi',
   'KAPL_6',
   'UPPER(CPRACZAR) + UPPER(CCISPLAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_1',
   'DTOS (DVYHOTPLAN) + UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_2',
   'DTOS (DVYHOTPLAN) + UPPER(CSTRED) + UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_3',
   'UPPER(COZNPRAC) + DTOS(DVYHOTPLAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_4',
   'STRZERO(NTYDKAPBLO,2) + UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_5',
   'UPPER(COZNPRAC) + STRZERO(NTYDKAPBLO,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_den',
   'kapp_den.adi',
   'KAPP_6',
   'UPPER(COZNPRAC) + UPPER(CCISPLAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_tyd',
   'kapp_tyd.adi',
   'KAPPTY_1',
   'UPPER(CVYROBSTRE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_tyd',
   'kapp_tyd.adi',
   'KAPPTY_2',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kapp_tyd',
   'kapp_tyd.adi',
   'KAPPTY_3',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC) +STRZERO(NROKKAPBLO,4) +STRZERO(NTYDKAPBLO,2) +STRZERO(NVOLSTRKAP,9)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kaps_tyd',
   'kaps_tyd.adi',
   'KAPSTY_1',
   'UPPER(CVYROBSTRE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kaps_tyd',
   'kaps_tyd.adi',
   'KAPSTY_2',
   'UPPER(CVYROBSTRE) +STRZERO(NTYDKAPBLO,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kaps_tyd',
   'kaps_tyd.adi',
   'KAPSTY_3',
   'UPPER(CVYROBSTRE) +STRZERO(NTYDKAPBLO,2) +STRZERO(NVOLLIDKAP,9)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kategzvi',
   'kategzvi.adi',
   'KATEGZVI_1',
   'NZVIRKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kategzvi',
   'kategzvi.adi',
   'KATEGZVI_2',
   'UPPER(CNAZEVKAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kategzvi',
   'kategzvi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'komusers',
   'komusers.adi',
   'KOMUSERS01',
   'UPPER(CUSER)+UPPER(CCALLFORM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'komusers',
   'komusers.adi',
   'KOMUSERS02',
   'UPPER(CNAZDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'komusers',
   'komusers.adi',
   'KOMUSERS03',
   'UPPER(CUSER)+UPPER(CCALLFORM)+UPPER(CIDDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'komusers',
   'komusers.adi',
   'KOMUSERS04',
   'UPPER(CIDDATKOM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'komusers',
   'komusers.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzhd',
   'kurzhd.adi',
   'KURZHD1',
   'DTOS ( DDATPLATN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzhd',
   'kurzhd.adi',
   'KURZHD2',
   'STRZERO(NDENKURZ,2) +UPPER(CMESKURZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzhd',
   'kurzhd.adi',
   'KURZHD3',
   'UPPER(CMESKURZ) +STRZERO(NDENKURZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzhd',
   'kurzhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT1',
   'DTOS (DDATPLATN) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT2',
   'UPPER(CZKRATMENY) +DTOS (DDATPLATN) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT3',
   'UPPER(CZKRATMENY) +STRZERO(NDENKURZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT4',
   'UPPER(CZKRATMENY) +STRZERO(NTYDKURZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT5',
   'UPPER(CZKRATMENY) +STRZERO(NMESKURZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT6',
   'UPPER(CZKRATMENY) +STRZERO(NKVAKURZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT7',
   'UPPER(CZKRATMENY) +STRZERO(NPOLKURZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'KURZIT8',
   'UPPER(CZKRATMENY) +STRZERO(NROKKURZ,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kurzit',
   'kurzit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV1',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NPOZICE,3) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV2',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV4',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV5',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV6',
   'UPPER(CNIZPOL) +UPPER(CVYSPOL) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV7',
   'UPPER(CSKLPOL) +UPPER(CVYSPOL) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV8',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVARPOZ,3) +STRZERO(NCISOPER,4) +STRZERO(NPOZICE,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'KUSOV9',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kusov',
   'kusov.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE1',
   'CTREEKEY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE2',
   'IF (LNAKPOL, ''1'', ''0'') +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE3',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVYSVAR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE4',
   'CTREEKEY +UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE5',
   'CTREEKEY +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE6',
   'UPPER(CVYRPOL) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'TREE7',
   'UPPER(CSKLPOL) + CTREEKEY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustree',
   'kustree.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustreem',
   'kustreem.adi',
   'TREEM1',
   'CTREEKEY +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'kustreem',
   'kustreem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_02',
   'UPPER(CRODCISPRA) +STRZERO(NPORADI,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_03',
   'UPPER(CRODCISPRA) +UPPER(CZKRATKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'lekprohl',
   'lekprohl.adi',
   'LEKPR_05',
   'UPPER(CRODCISPRA) +DTOS (DDALSLEKPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'lekprohl',
   'lekprohl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'licence',
   'licence.adi',
   'LICENCE01',
   'NIDUZIVSW',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'licence',
   'licence.adi',
   'LICENCE02',
   'NUSRIDDB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'licence',
   'licence.adi',
   'LICENCE03',
   'UPPER(CNAZFIRMY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'licence',
   'licence.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'list_dav',
   'list_dav.adi',
   'LISTDAV_01',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'list_dav',
   'list_dav.adi',
   'LISTDAV_02',
   'STRZERO( NOSCISPRAC, 5) + STRZERO( NDOKLAD, 10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'list_dav',
   'list_dav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD8',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd',
   'listhd.adi',
   'LISTHD9',
   'UPPER(CCISZAKAZI) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd2',
   'listhd2.adi',
   'LISTHD8',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhd_1',
   'listhd_1.adi',
   'LISTHD8',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listhdnv',
   'listhdnv.adi',
   'LISTHD1',
   'DTOS (DDATUMNV) +UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT2',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT3',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTPLAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT4',
   'UPPER(CPRIJPRAC) +UPPER(CJMENOPRAC) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT5',
   'DTOS (DVYHOTPLAN) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT6',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT7',
   'UPPER(COBDOBI) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT8',
   'UPPER(CCISZAKAZ) +UPPER(CNAZPOL1) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTIT9',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTSKUT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTI10',
   'STRZERO(NOSCISPRAC,5) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTI11',
   'UPPER(COBDOBI) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTI12',
   'DTOS ( DVYHOTSKUT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTI13',
   'UPPER(CVYRPOL) +STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'LISTI14',
   'NDAVKA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit',
   'listit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT2',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT3',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTPLAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT4',
   'UPPER(CPRIJPRAC) +UPPER(CJMENOPRAC) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT5',
   'DTOS (DVYHOTPLAN) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT6',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT7',
   'UPPER(COBDOBI) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT8',
   'UPPER(CCISZAKAZ) +UPPER(CNAZPOL1) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTIT9',
   'STRZERO(NOSCISPRAC,5) +DTOS (DVYHOTSKUT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTI10',
   'STRZERO(NOSCISPRAC,5) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTI11',
   'UPPER(COBDOBI) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit2',
   'listit2.adi',
   'LISTI12',
   'DTOS ( DVYHOTSKUT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listit_1',
   'listit_1.adi',
   'LISTIT1',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD2',
   'NPORCISLIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'listkap',
   'listkap.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV9',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV11',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +IF (LRUCPORIZ, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'M_DAV13',
   'STRZERO(NROK,4) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav',
   'm_dav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_dav10',
   'm_dav10.adi',
   'M_DAV8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'M_DAVHD08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +IF (LRUCPORIZ, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davhd',
   'm_davhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,6) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_daviso',
   'm_daviso.adi',
   'M_DAV8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT11',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10) +IF (LRUCPORIZ, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'M_DAVIT13',
   'STRZERO(NROK,4) +STRZERO(NUCETMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_davit',
   'm_davit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM2',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM3',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM5',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM6',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM7',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM8',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NTMOBDSORT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'M_NEM9',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)+STRZERO(NPORADI,6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nem',
   'm_nem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD02',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemhd',
   'm_nemhd.adi',
   'M_NEMHD04',
   'STRZERO(NTMROKZPRA,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemhd',
   'm_nemhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT03',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT05',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT07',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT08',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6) +STRZERO(NTMOBDSORT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'M_NEMIT09',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)+STRZERO(NPORADI,6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemit',
   'm_nemit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC2',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC3',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemoc',
   'm_nemoc.adi',
   'M_NEMOC4',
   'STRZERO(NTMROKZPRA,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTMPORSORT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_nemoc',
   'm_nemoc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'M_SRZ_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_srz',
   'm_srz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_tmp',
   'm_tmp.adi',
   'M_TMP1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_tmp',
   'm_tmp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_zmdav',
   'm_zmdav.adi',
   'ZMTMP_01',
   'STRZERO(NRECZM,6) +STRZERO(NFILZM,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'm_zmdav',
   'm_zmdav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ01',
   'STRZERO( NTYPMAJ,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ02',
   'NINVCIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ03',
   'UPPER( CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ04',
   'UPPER( CTYPSKP) + STRZERO( NTYPMAJ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ05',
   'STRZERO( NODPISK,1) + STRZERO( NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ06',
   'STRZERO( NODPISK,1) + STRZERO( NTYPMAJ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ07',
   'STRZERO( NODPISK,1) + UPPER( CTYPSKP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ08',
   'UPPER( CTYPSKP) + STRZERO( NODPISK,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ09',
   'NTYPUODPI',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ10',
   'NROKYODPIU',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ11',
   'UPPER( CNAZPOL5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'MAJ12',
   'UPPER( CCELEK) +UPPER( CVYKRES)+ UPPER( CUMISTENI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj',
   'maj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj_ps',
   'maj_ps.adi',
   'MAJ_PS_01',
   'STRZERO(NTYPMAJ,3) + STRZERO(NINVCIS,10) + STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj_ps',
   'maj_ps.adi',
   'MAJ_PS_02',
   'STRZERO(NROK,4) + STRZERO(NTYPMAJ,3) + STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'maj_ps',
   'maj_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majobd',
   'majobd.adi',
   'MAJOBD_1',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majobd',
   'majobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majoper',
   'majoper.adi',
   'MAJOPER1',
   'UPPER(COZNOPER) +STRZERO(NINVCIS,6) +UPPER(CDRUHMAJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majoper',
   'majoper.adi',
   'MAJOPER2',
   'UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3) +STRZERO(NINVCIS,6) +UPPER(CDRUHMAJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majoper',
   'majoper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_01',
   'STRZERO(NUCETSKUP,3) + STRZERO( NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_02',
   'NINVCIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_03',
   'UPPER( CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_04',
   'UPPER( CTYPSKP) + STRZERO(NUCETSKUP,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_05',
   'STRZERO(NODPISK,1) + STRZERO( NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_06',
   'STRZERO(NODPISK,1) + STRZERO( NUCETSKUP,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_07',
   'STRZERO(NODPISK,1) + UPPER( CTYPSKP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_08',
   'UPPER( CTYPSKP) + STRZERO(NODPISK,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_09',
   'NTYPUODPI',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_10',
   'NROKYODPIU',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'MAJZ_11',
   'NDOKLPREV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz',
   'majz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_ps',
   'majz_ps.adi',
   'MAJZ_PS_01',
   'STRZERO(NUCETSKUP,3) + STRZERO(NINVCIS,10) + STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_ps',
   'majz_ps.adi',
   'MAJZ_PS_02',
   'STRZERO(NROK,4) + STRZERO(NUCETSKUP,3) + STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majz_ps',
   'majz_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majzobd',
   'majzobd.adi',
   'MAJZOBD_1',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'majzobd',
   'majzobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'manblopr',
   'manblopr.adi',
   'MANBLO_0',
   'UPPER(CVYROBSTRE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'manblopr',
   'manblopr.adi',
   'MANBLO_1',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'manblopr',
   'manblopr.adi',
   'MANBLO_2',
   'UPPER(CVYROBSTRE) +UPPER(COZNPRAC) +DTOS(NDENMANBLO) +STRZERO(NBLOKHODIN,9)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'matrtmp',
   'matrtmp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_02',
   'UPPER(CRODCISPRA) +IF (LAKTIV, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_03',
   'UPPER(CRODCISPRA) +STRZERO(NMIMOPRVZT,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mimprvz',
   'mimprvz.adi',
   'MIPRV_04',
   'UPPER(CRODCISPRA) +STRZERO(NMIMOPRVZT,2) +DTOS (DMIMPRVZOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mimprvz',
   'mimprvz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM1',
   'NINVCISDIM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM2',
   'UPPER(CNAZEVDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM3',
   'STRZERO(NTYPDIM,3) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM4',
   'STRZERO(NTYPDIM,3) +UPPER(CNAZEVDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM5',
   'UPPER(CKLICODMIS) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM6',
   'UPPER(CKLICODMIS) +UPPER(CNAZEVDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM7',
   'UPPER(CKLICODMIS) +STRZERO(NTYPDIM,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM8',
   'STRZERO(NTYPDIM,3) +UPPER(CKLICODMIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM9',
   'DTOS ( DDATZARDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM10',
   'DTOS ( DDATPOHDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM11',
   'UPPER(CKLICSKMIS) +UPPER(CKLICODMIS) +STRZERO(NINVCISDIM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'DIM12',
   'STRZERO(NINVCISDIM,6) +STRZERO(NPOCKUSDIM,11,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msdim',
   'msdim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msmatr',
   'msmatr.adi',
   'MSMATR1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NKEYMATR,2) +STRZERO(NRADMATR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msmatr',
   'msmatr.adi',
   'MSMATR2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NKEYMATR,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msmatr',
   'msmatr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORODPPOL,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +UPPER(CTYPODPPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +UPPER(CRODCISRP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP04',
   'UPPER(CRODCISRP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP05',
   'UPPER(CRODCISRP) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORODPPOL,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP07',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'MSODPP08',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +UPPER(CTYPODPPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msodppol',
   'msodppol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO01',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO04',
   'UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO05',
   'UPPER(CIDOSKARTY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO06',
   'UPPER(CPASSWORD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO07',
   'STRZERO(NTMDATVYST,8) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO08',
   'UPPER(CKMENSTRPR) +STRZERO(NTMDATVYST,8)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'MSPRDO09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_md',
   'msprc_md.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO05',
   'UPPER(CKMENSTRPR) +UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO06',
   'DTOS( DDATVZNPRV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO07',
   'DTOS( DDATVYST)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NTMDATVYST,8)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO09',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'MSPRMO10',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mo',
   'msprc_mo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ01',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ04',
   'UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ05',
   'UPPER(CKMENSTRPR) +UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ07',
   'UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ08',
   'UPPER(CVYPLMIST) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ09',
   'UPPER(CRODCISPRA) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ10',
   'IF (LSTAVEM, ''1'', ''0'') +UPPER(CTYPTARPOU) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ11',
   'DTOS ( DDATVZNPRV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ12',
   'DTOS ( DDATVYST)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ13',
   'NTMDATVYST',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'MSPRMZ14',
   'NWKSTATION',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msprc_mz',
   'msprc_mz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDELKPRDOB) +DTOS (DPLATSAZOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDELKPRDOB) +IF (LAKTSAZBA, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +DTOS (DPLATSAZOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssazzam',
   'mssazzam.adi',
   'MSSAZZAM05',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +IF (LAKTSAZBA, ''1'', ''0'') +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssazzam',
   'mssazzam.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_02',
   'UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_03',
   'UPPER(CRODCISPRA) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPSRZ,2) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_07',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'MSSRZ_08',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mo',
   'mssrz_mo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_02',
   'UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_05',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPSRZ,2) +STRZERO(NPORUPLSRZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_06',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NPORADI,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_07',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_08',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'MSSRZ_09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CZKRSRAZKY) +IF (LAKTIVSRZ, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mssrz_mz',
   'mssrz_mz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR1',
   'UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR2',
   'UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +DTOS (DPLATTAROD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR3',
   'UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +IF (LAKTTARIF, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarhro',
   'mstarhro.adi',
   'C_TARHR4',
   'IF (LAKTTARIF, ''1'', ''0'') +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarhro',
   'mstarhro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +DTOS (DPLATTAROD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN3',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +IF (LAKTTARIF, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN4',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +DTOS (DPLATTAROD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN5',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +IF (LAKTTARIF, ''1'', ''0'') +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'C_TARIN6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CTYPTARPOU) +UPPER(CTARIFTRID) +UPPER(CTARIFSTUP) +UPPER(CDELKPRDOB) +DTOS (DPLATTAROD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mstarind',
   'mstarind.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_01',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msvprum',
   'msvprum.adi',
   'PRUMV_04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msvprum',
   'msvprum.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'msvprum',
   'msvprum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH02',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH03',
   'STRZERO(NROK,4) +UPPER(CPRACTMSOR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH04',
   'STRZERO(NROK,4) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH05',
   'STRZERO(NROK,4) +UPPER(CKMENSTRPR) +UPPER(CPRACTMSOR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH07',
   'STRZERO(NROK,4) +UPPER(CPRACTMSOR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH08',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'TMMZLH09',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisth',
   'mzdlisth.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI3',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NFOOT,1) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI4',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI5',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI6',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NFOOT,1) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'TMPMZLI7',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NFOOT,1) +STRZERO(NPORPRAVZT,3) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdlisti',
   'mzdlisti.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'MZMZO_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'MZMZO_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdmz_ob',
   'mzdmz_ob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdpren',
   'mzdpren.adi',
   'MZDPREN1',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdpren',
   'mzdpren.adi',
   'MZDPREN2',
   'STRZERO(NWKSTATION,3) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdpren',
   'mzdpren.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_05',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_06',
   'UPPER(CDENIK) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +STRZERO(NTYPZAMVZT,2) +STRZERO(NZDRPOJIS,3) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_10',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_11',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_13',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_14',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +UPPER(CDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_15',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NDRUHMZDY,4) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_16',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_17',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'MZDY_18',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy',
   'mzdy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_03',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_04',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NZDRPOJIS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'MZDOB_06',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_obd',
   'mzdy_obd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'MZDYS_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'MZDYS_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'MZDYS_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzdy_srz',
   'mzdy_srz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'KUMRO_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'KUMRO_02',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'KUMRO_03',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzkum_ro',
   'mzkum_ro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'MZPOO_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'MZPOO_02',
   'STRZERO(NROK,4) +STRZERO(NCTVRTLETI,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzpod_ob',
   'mzpod_ob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'MZDY_01',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'MZDY_02',
   'STRZERO(NROK,4)+STRZERO(NCTVRTLETI,1) +UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'MZDY_03',
   'UPPER(CKMENSTRPR) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzstr_ob',
   'mzstr_ob.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzvykpot',
   'mzvykpot.adi',
   'MZDLIST1',
   'UPPER(CISPRAC) +UPPER(RADML)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'mzvykpot',
   'mzvykpot.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'nakpol',
   'nakpol.adi',
   'NAKPOL1',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'nakpol',
   'nakpol.adi',
   'NAKPOL2',
   'UPPER(CNAZTPV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'nakpol',
   'nakpol.adi',
   'NAKPOL3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'nakpol',
   'nakpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'namzvyit',
   'namzvyit.adi',
   'NAMZVYI_01',
   'UPPER(CTYPVYKAZU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'namzvyit',
   'namzvyit.adi',
   'NAMZVYI_02',
   'UPPER(CTYPVYKAZU)+STRZERO(NRADEKVYK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'namzvyit',
   'namzvyit.adi',
   'NAMZVYI_03',
   'UPPER(CTYPVYKAZU)+UPPER(CNAZRADVYK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'namzvyit',
   'namzvyit.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'namzvyit',
   'namzvyit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'o_uctosn',
   'o_uctosn.adi',
   'OUCOS_01',
   'UPPER(CUCET)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'o_uctosn',
   'o_uctosn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'obdobiw',
   'obdobiw.adi',
   'OBDOBIW_1',
   'STRZERO(NROK, 4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'obdobiw',
   'obdobiw.adi',
   'OBDOBIW_2',
   'NOBDOBI',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD0',
   'UPPER(CCISLOBINT) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD1',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD2',
   'DTOS ( DDATOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD3',
   'DTOS ( DDATDOODB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD4',
   'STRZERO(NROK_OBJ,4) +STRZERO(NPOR_OBJ,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD5',
   'STRZERO(NPOR_OBJ,5) +STRZERO(NROK_OBJ,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD6',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD7',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD8',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD9',
   'UPPER(CSIDLO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD10',
   'UPPER(CSIDLODOA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD11',
   'UPPER(CNAZPRACOV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD12',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD13',
   'NEXTOBJ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'OBJHEAD14',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objhead',
   'objhead.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objit_02',
   'objit_02.adi',
   'OBJ02_1',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objit_03',
   'objit_03.adi',
   'OBJIT1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATDOODB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objit_at',
   'objit_at.adi',
   'OBJITAT0',
   'DTOS(DDATREODB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objit_at',
   'objit_at.adi',
   'OBJITAT1',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objit_at',
   'objit_at.adi',
   'OBJITAT2',
   'UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objit_at',
   'objit_at.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM0',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM1',
   'UPPER(CSKLPOL) +UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATREODB) +UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM4',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +DTOS (DDATOBDOD) +UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM5',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM6',
   'NMNOZVPINT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM7',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CVYRPOL) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM8',
   'UPPER(CCISZAKAZ) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITEM9',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE10',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE11',
   'STRZERO(NROKRV,4) +STRZERO(NPOLOBJRV,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE12',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE13',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE14',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +STRZERO(NUCETSKUP,3) +UPPER(CVYRPOL) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE15',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CCISSKLAD) +UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE16',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISLOBINT) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE17',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISZAKAZI) +STRZERO(NCISLPOLZA,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE18',
   'UPPER(CCISZAKAZI) +STRZERO(NCISLPOLZA,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE19',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE20',
   'STRZERO(NZBOZIKAT,4) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE21',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE22',
   'UPPER(CCISLOBINT) +STRZERO(NZBOZIKAT,4) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE23',
   'NSTAV_FAKT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'OBJITE24',
   'STRZERO(NDOKLAD,10) +STRZERO(NSTAV_FAKT,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objitem',
   'objitem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH1',
   'UPPER(CCISOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH2',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH3',
   'DTOS ( DDATOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH4',
   'STRZERO(NROK_OBJ,4) +STRZERO(NPOR_OBJ,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH5',
   'UPPER(CZAKOBJINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH6',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvyshd',
   'objvyshd.adi',
   'OBJDODH7',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI1',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISOBJ) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI2',
   'UPPER(CCISOBJ) +STRZERO(NCISFIRMY,5) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI3',
   'STRZERO(NCISFIRMY,5) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI4',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI5',
   'UPPER(CCISOBJ) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI6',
   'UPPER(CCISZAKAZI) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI7',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objvysit',
   'objvysit.adi',
   'OBJVYSI8',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objzak',
   'objzak.adi',
   'OBJZAK1',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5) +DTOS (DTERMPOVYR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objzak',
   'objzak.adi',
   'OBJZAK2',
   'UPPER(CCISZAKAZ) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objzak',
   'objzak.adi',
   'OBJZAK3',
   'DTOS (DTERMPOVYR) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objzak',
   'objzak.adi',
   'OBJZAK4',
   'DTOS(DTERMPOVYR) +UPPER(CCISZAKAZ) +STRZERO(NMNPOTVYRZ,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objzakr',
   'objzakr.adi',
   'OBJZAR1',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'objzakr',
   'objzakr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnhe',
   'odesnhe.adi',
   'ODESNHE0',
   'UPPER(CNAZODES) +STRZERO(NCISFIRMY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnhe',
   'odesnhe.adi',
   'ODESNHE1',
   'STRZERO(NCISFIRMY) +UPPER(CNAZODES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnhe',
   'odesnhe.adi',
   'ODESNHE2',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnhe',
   'odesnhe.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT0',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +STRZERO(NPORODES) +STRZERO(NITMODES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT1',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT2',
   'NCISODES',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT3',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT4',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +STRZERO(NZBOZIKAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT5',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'ODESNIT6',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnit',
   'odesnit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnro',
   'odesnro.adi',
   'ODESNRO0',
   'STRZERO(NCISFIRMY) +STRZERO(NCISODES) +STRZERO(NPORODES)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnro',
   'odesnro.adi',
   'ODESNRO1',
   'NPORODES',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odesnro',
   'odesnro.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvsoz',
   'odvsoz.adi',
   'ODVSZ_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvsoz',
   'odvsoz.adi',
   'ODVSZ_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvsoz',
   'odvsoz.adi',
   'ODVSZ_03',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvsoz',
   'odvsoz.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvsoz',
   'odvsoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvzak',
   'odvzak.adi',
   'ODVZAK1',
   'UPPER(CCISZAKAZ) +STRZERO(NCISLOKUSU,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'odvzak',
   'odvzak.adi',
   'ODVZAK2',
   'UPPER(CCISZAKAZ) +DTOS (DDATUMODV) +UPPER(CCASODV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'operace',
   'operace.adi',
   'OPER1',
   'UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'operace',
   'operace.adi',
   'OPER2',
   'UPPER(CTARIFSTUP) +UPPER(CTARIFTRID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'operace',
   'operace.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opertree',
   'opertree.adi',
   'OPTREE1',
   'CTREEKEY +UPPER(CVYRPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opertree',
   'opertree.adi',
   'OPTREE2',
   'UPPER(CNAZZBO) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opertree',
   'opertree.adi',
   'OPTREE3',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL) +STRZERO(NVYSVAR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opertree',
   'opertree.adi',
   'OPTREE4',
   'CTREEKEY +UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opertree',
   'opertree.adi',
   'OPTREE5',
   'UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opertree',
   'opertree.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opistxt',
   'opistxt.adi',
   'OPISTXT_01',
   'NRADEK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'opistxt',
   'opistxt.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'osoby',
   'osoby.adi',
   'OSOBY01',
   'NCISOSOBY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'osoby',
   'osoby.adi',
   'OSOBY02',
   'UPPER(COSOBA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'osoby',
   'osoby.adi',
   'OSOBY03',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'osoby',
   'osoby.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parprzal',
   'parprzal.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parprzal',
   'parprzal.adi',
   'FODBHD2',
   'NCISZALFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parprzal',
   'parprzal.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parvyzal',
   'parvyzal.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parvyzal',
   'parvyzal.adi',
   'FODBHD2',
   'NCISZALFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parvyzal',
   'parvyzal.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parzak',
   'parzak.adi',
   'PARZAK_1',
   'UPPER(CATRIB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'parzak',
   'parzak.adi',
   'PARZAK_2',
   'UPPER(CATRIBNAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_02',
   'UPPER(CRODCISPRA) +STRZERO(NORDITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_03',
   'UPPER(CRODCISPRA) +STRZERO(NORDITEMTM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_05',
   'UPPER(CRODCISPRA) +UPPER(COBLASTTYP) +STRZERO(NPORADI,3) +DTOS (DDATPREDKO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_06',
   'NORDITEM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_07',
   'NORDITEMTM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_08',
   'UPPER(CRODCISPRA) +STRZERO(NORDITEMTM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_09',
   'DTOS ( DDATPREDKO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_10',
   'IF (LUSKUTECN, ''1'', ''0'') +UPPER(CRODCISPRA) +STRZERO(NORDITEMTM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'PERSI_11',
   'IF (LUSKUTECN, ''1'', ''0'') +DTOS (DDATPREDKO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'persitem',
   'persitem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'personal',
   'personal.adi',
   'PERSO_01',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'personal',
   'personal.adi',
   'PERSO_02',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'personal',
   'personal.adi',
   'PERSO_03',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'personal',
   'personal.adi',
   'PERSO_04',
   'UPPER(CIDOSKARTY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'personal',
   'personal.adi',
   'PERSO_05',
   'UPPER(CKMENSTRPR) +UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'personal',
   'personal.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pln_objs',
   'pln_objs.adi',
   'PLNOBJ1',
   'STRZERO(NCISFIRMY) +UPPER(CCISOBJ) +STRZERO(NINTCOUNT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pln_objv',
   'pln_objv.adi',
   'PLNOBJ1',
   'STRZERO(NCISFIRMY) +UPPER(CCISOBJ) +STRZERO(NINTCOUNT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD3',
   'UPPER(CCISLOBINT) +STRZERO(NCISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD4',
   'STRZERO(NCISFIRMY) +STRZERO(NCISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD5',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD6',
   'UPPER(CZKRTYPFAK) +UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD7',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFIRMY) +STRZERO(NCISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD8',
   'STRZERO(NCISFIRMY) +UPPER(CZKRTYPFAK) +STRZERO(NCISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD9',
   'STRZERO(NKASA) +DTOS (DVYSTFAK) +STRZERO(NCISFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD10',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD11',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD12',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD13',
   'DTOS ( DSPLATFAK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD14',
   'NCENZAKCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD15',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD16',
   'STRZERO(NCISFIRMY) +STRZERO(NFINTYP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakhd',
   'podfakhd.adi',
   'FODBHD17',
   'UPPER(CDENIK) +STRZERO(NDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT1',
   'STRZERO(NCISFAK) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT3',
   'UPPER(CCISLOBINT) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT4',
   'UPPER(CZKRTYPFAK) +STRZERO(NCISFAK) +STRZERO(NINTCOUNT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT5',
   'UPPER(CNAZPOL3) +STRZERO(NCISFAK) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'podfakit',
   'podfakit.adi',
   'FVYSIT6',
   'UPPER(CZKRPRODEJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokin_hd',
   'pokin_hd.adi',
   'POKIN_01',
   'STRZERO(NPOKLADNA,3) +DTOS (DDAT_INV) +STRZERO(NCNT_INV,2) +UPPER(CCAS_INV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokin_hd',
   'pokin_hd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokin_it',
   'pokin_it.adi',
   'POKIN_01',
   'STRZERO(NPOKLADNA,3) +DTOS(DDAT_INV) +STRZERO(NCNT_INV,2) +STRZERO(NVALMINCE,11,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokin_it',
   'pokin_it.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL1',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL4',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,2) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL5',
   'UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokl_lik',
   'pokl_lik.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH1',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH2',
   'STRZERO(NPOKLADNA,3) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH3',
   'STRZERO(NCISFIRMY,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH4',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH5',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH6',
   'UPPER(CTEXTDOK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH7',
   'NCENZAKCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH8',
   'STRZERO(NPOKLADNA,3) +DTOS (DPORIZDOK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLADH9',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD10',
   'STRZERO(NPOKLADNA,3) +STRZERO(NOSCISPRAC,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD11',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD12',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'POKLAD13',
   'UPPER(CJMENOPRIJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladhd',
   'pokladhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_1',
   'STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5) +UPPER(CDENIK_PAR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_2',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_3',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladit',
   'pokladit.adi',
   'BANKVY_4',
   'UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladit',
   'pokladit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladks',
   'pokladks.adi',
   'POKLADK1',
   'STRZERO(NPOKLADNA,3) +DTOS(DPORIZDOK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladks',
   'pokladks.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladms',
   'pokladms.adi',
   'POKLADM1',
   'NPOKLADNA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladms',
   'pokladms.adi',
   'POKLADM2',
   'UPPER(CNAZPOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokladms',
   'pokladms.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklhd',
   'poklhd.adi',
   'POKLHD1',
   'STRZERO(NKASA,3) +DTOS(DVYSTFAK) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklhd',
   'poklhd.adi',
   'POKLHD2',
   'STRZERO(NKASA,3) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklhd',
   'poklhd.adi',
   'POKLHD3',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklhd',
   'poklhd.adi',
   'POKLHD4',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklhd',
   'poklhd.adi',
   'POKLHD5',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklhd',
   'poklhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklit',
   'poklit.adi',
   'POKLIT1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklit',
   'poklit.adi',
   'POKLIT2',
   'STRZERO(NKASA,3) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklit',
   'poklit.adi',
   'POKLIT3',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poklit',
   'poklit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokza_za',
   'pokza_za.adi',
   'POKIN_01',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPOKLADNA,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokza_za',
   'pokza_za.adi',
   'POKIN_02',
   'STRZERO(NCISOSOBY,6) +STRZERO(NPOKLADNA,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pokza_za',
   'pokza_za.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polnabp',
   'polnabp.adi',
   'POLNABP1',
   'NZBOZIKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polnabp',
   'polnabp.adi',
   'POLNABP2',
   'UPPER(CNAZEVNAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polnabp',
   'polnabp.adi',
   'POLNABP3',
   'UPPER(CNAZEVNAZ) +STRZERO(NCISFIRMY,5) +STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polnabp',
   'polnabp.adi',
   'POLNABP4',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polnabp',
   'polnabp.adi',
   'POLNABP5',
   'NCISNAB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polnabp',
   'polnabp.adi',
   'POLNABP6',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISNAB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polop_02',
   'polop_02.adi',
   'POL02_1',
   'UPPER(CSTRED) +UPPER(COZNPRAC) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polop_02',
   'polop_02.adi',
   'POL02_2',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polop_02',
   'polop_02.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER2',
   'UPPER(COZNOPER) +UPPER(CVYRPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER3',
   'NPORCISLIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER4',
   'NZAPUSTENO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER5',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER6',
   'UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER7',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVAROPER,3) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'POLOPER8',
   'UPPER(CCISZAKAZI) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloper',
   'poloper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_2',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_3',
   'UPPER(CCISZAKAZ) +STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12) +STRZERO(NPOZICE,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_4',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2) +UPPER(CVYRPOL) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_5',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2) +UPPER(CVYRPOL) +STRZERO(NPOZICE,3) +STRZERO(NCISOPER,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_6',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2) +STRZERO(NPORCISLIS,12)+UPPER(COZNPRACN)+UPPER(CVYRPOL) +STRZERO(NPOZICE,3) +STRZERO(NCISOPER,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'POLOPZ_7',
   'UPPER(CCISZAKAZ) +STRZERO(NPOCCEZAPZ,2)+STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)+UPPER(COZNPRAC)+UPPER(COZNPRACN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'poloperz',
   'poloperz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polsestc',
   'polsestc.adi',
   'POLSESTC',
   'NRECCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polsestc',
   'polsestc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polsestn',
   'polsestn.adi',
   'POLSESTN',
   'NRECNAB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'polsestn',
   'polsestn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'popisdim',
   'popisdim.adi',
   'DIM_P1',
   'NINVCISDIM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'popisdim',
   'popisdim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ppoper',
   'ppoper.adi',
   'PPOPER1',
   'UPPER(COZNOPER) +UPPER(COZNPRPO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ppoper',
   'ppoper.adi',
   'PPOPER2',
   'UPPER(COZNPRPO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ppoper',
   'ppoper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracpost',
   'pracpost.adi',
   'PRACPO1',
   'UPPER(COZNPRPO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracpost',
   'pracpost.adi',
   'PRACPO2',
   'UPPER(CNAZPRPO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracpost',
   'pracpost.adi',
   'PRACPO3',
   'UPPER(CSTRED) +UPPER(COZNPRPO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracpost',
   'pracpost.adi',
   'PRACPO4',
   'UPPER(COZNPRAC) +UPPER(COZNPRPO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracpost',
   'pracpost.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracvaz',
   'pracvaz.adi',
   'PRVAZ_1',
   'UPPER(COZNPRAC) + DTOS(DDATPLAN) + STRZERO( NPORADI, 3)',
   'EMPTY(CPLANOVANO)',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracvaz',
   'pracvaz.adi',
   'PRVAZ_2',
   'UPPER(CIDVAZBY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pracvaz',
   'pracvaz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prenterm',
   'prenterm.adi',
   'PRENOS1',
   'STRZERO(NROK,4) +STRZERO(NMESIC,2) +STRZERO(NDEN,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prenterm',
   'prenterm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prepprc',
   'prepprc.adi',
   'PREPP_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NPROF1,1) +STRZERO(NPROF23,2) +UPPER(CFONDPD) +UPPER(CVEDCIN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prepprc',
   'prepprc.adi',
   'PREPP_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NPROF23,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prepprc',
   'prepprc.adi',
   'PREPP_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +UPPER(CPRACZAR) +UPPER(CDELKPRDOB) +STRZERO(NSOUBPRAPO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prepprc',
   'prepprc.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prepprc',
   'prepprc.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_1',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_2',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_3',
   'UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prijatpl',
   'prijatpl.adi',
   'PRIJPL_4',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prijatpl',
   'prijatpl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD1',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD2',
   'UPPER(CKODBAN_CR) +DTOS (DDATE_EXP) +STRZERO(NFILE_EXP,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD3',
   'DTOS (DPRIKUHR) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD4',
   'UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhhd',
   'prikuhhd.adi',
   'FDODHD5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhhd',
   'prikuhhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD1',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD2',
   'UPPER(CVARSYM) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD3',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'FDODHD4',
   'UPPER(CSIDLO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD5',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD6',
   'UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZKRTYPZAV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'PRIKHD8',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prikuhit',
   'prikuhit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prmat',
   'prmat.adi',
   'PRMAT_1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +DTOS (DDATAKTUAL) +STRZERO(NPORKALDEN,2) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prmat',
   'prmat.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prmzdy',
   'prmzdy.adi',
   'PRMZDY1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +DTOS (DDATAKTUAL) +STRZERO(NPORKALDEN,2) +UPPER(CVYRPOLKAL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prmzdy',
   'prmzdy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenfi',
   'procenfi.adi',
   'PROCENHFI1',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenfi',
   'procenfi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD01',
   'NCISPROCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD02',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD03',
   'UPPER(COZNPROCEN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenhd',
   'procenhd.adi',
   'PROCENHD04',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenhd',
   'procenhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO01',
   'NTYPPROCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO02',
   'NCISPROCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO03',
   'NPOLPROCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO04',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISFIRMY,5)+UPPER(CCISSKLAD)+UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO05',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISFIRMY,5)+STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO06',
   'STRZERO(NTYPPROCEN,5)+UPPER(CCISSKLAD)+UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO07',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO08',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NPOLPROCEN,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO09',
   'UPPER(CCISSKLAD)+UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'PROCENHO10',
   'NZBOZIKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenho',
   'procenho.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'PROCENIT01',
   'NTYPPROCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'PROCENIT02',
   'NCISPROCEN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'PROCENIT03',
   'STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NPOLPROCEN,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'PROCENIT04',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'PROCENIT05',
   'NZBOZIKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'PROCENIT06',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'procenit',
   'procenit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML01',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML02',
   'UPPER(CRODCISPRA) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML03',
   'UPPER(CRODCISPRA) +DTOS (DDATVZNPRV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML04',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML05',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'PRCSML06',
   'STRZERO(NROK,4) +UPPER(CRODCISPRA) +DTOS (DDATVZNPRV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'prsmldoh',
   'prsmldoh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD01',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD02',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD03',
   'UPPER (CCISSKLAD) + STRZERO(NCISLPOH,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD04',
   'STRZERO(NCISLPOH,5) + UPPER (CCISSKLAD) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD05',
   'UPPER (COBDPOH)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD06',
   'DTOS( DDATPVP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD07',
   'STRZERO(NTYPPOH,1) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD09',
   'NPRENIFT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD10',
   'NCISLODL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD11',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD12',
   'UPPER (CNAZFIRMY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD13',
   'STRZERO(NTYPPOH,1) + STRZERO(NCISFIRMY,5) + STRZERO(NCISLODL,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD14',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD15',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD16',
   'UPPER (CCISSKLAD)+ STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD17',
   'UPPER (CCISSKLAD)+ STRZERO(NTYPPOH,1) + STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'PVPHEAD18',
   'STRZERO(NROK,4) +UPPER(CTYPPOHYBU) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvphead',
   'pvphead.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM01',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM02',
   'UPPER (CCISSKLAD) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM03',
   'UPPER (CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM04',
   'NDOKLADV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM05',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM06',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM07',
   'UPPER (CCISLOBINT) +STRZERO(NTYPPOH,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM08',
   'UPPER (CNAZPOL3) +STRZERO(NTYPPOH,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM09',
   'UPPER (CCISZAKAZ) +STRZERO(NTYPPOH,2) + UPPER (CCISSKLAD) + UPPER (CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM10',
   'UPPER (CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM11',
   'STRZERO(NTYPPOH,2) + UPPER (CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NCISFAK,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM13',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NCISLPOH,5) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM14',
   'UPPER (CCISOBJ) + UPPER (CCISSKLAD) + UPPER (CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM15',
   'STRZERO(NDOKLAD,10) + UPPER(CUCTOVANO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM16',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM17',
   'NCISLODL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM18',
   'STRZERO(NCISFAK,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM19',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM20',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM21',
   'UPPER (CCISSKLAD) + UPPER (CSKLPOL) + STRZERO(NTYPPOH,2) + STRZERO( RECNO(),10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM22',
   'UPPER (CCISZAKAZI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM23',
   'STRZERO(NCISFIRMY,5) + UPPER(CCISSKLAD) + UPPER(CSKLPOL) + STRZERO(NTYPPOH,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM24',
   'STRZERO(NCISLODL,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM25',
   'UPPER(CVYRPOL) + STRZERO(NVARCIS, 3) + STRZERO(NTYPPOH, 2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM26',
   'UPPER (CCISSKLAD) +STRZERO(NDOKLAD,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM27',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + DTOS(DDATPVP) + UPPER(CCASPVP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM28',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + DTOS(DDATPVP) + UPPER(CCASPVP)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'PVPITEM29',
   'STRZERO(NROK,4) +UPPER(CTYPPOHYBU) +STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpitem',
   'pvpitem.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpkumul',
   'pvpkumul.adi',
   'PVPKUM1',
   'UPPER(COBDPOH) +UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpkumul',
   'pvpkumul.adi',
   'PVPKUM2',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpkumul',
   'pvpkumul.adi',
   'PVPKUM3',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpkumul',
   'pvpkumul.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM01',
   'UPPER(CCISSKLAD) + STRZERO( NTYPPVP, 1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM02',
   'UPPER(CNAZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM03',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpterm',
   'pvpterm.adi',
   'PVPTERM04',
   'UPPER(CCARKOD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpterm',
   'pvpterm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpuloz',
   'pvpuloz.adi',
   'PVPULOZ1',
   'STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5) +UPPER(CULOZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpuloz',
   'pvpuloz.adi',
   'PVPULOZ2',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CULOZZBO) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpuloz',
   'pvpuloz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpzak',
   'pvpzak.adi',
   'PVPZAK1',
   'STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'pvpzak',
   'pvpzak.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'range_hd',
   'range_hd.adi',
   'RANGE_1',
   'UPPER(CRANGE_ITM) +STRZERO(NSTART_DOK,10) +STRZERO(NKONEC_DOK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'range_hd',
   'range_hd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'range_it',
   'range_it.adi',
   'RANGE_1',
   'UPPER(CRANGE_ITM) +STRZERO(NSTART_DOK,10) +STRZERO(NKONEC_DOK,10) +UPPER(CUSER_ABB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'range_it',
   'range_it.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'reghlzme',
   'reghlzme.adi',
   'REGHL_01',
   'UPPER( CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'reghlzme',
   'reghlzme.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_01',
   'UPPER(CFARMA) + STRZERO(NPORCISLIS, 10) + STRZERO(NPORCISRAD,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_02',
   'STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_03',
   'UPPER(CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2) + STRZERO( NTYPPOHYB, 2) + STRZERO( NDRPOHYBP, 5) + UPPER(CFARMAZMN) + UPPER(CZVIREZEM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'regzvipr',
   'regzvipr.adi',
   'REGPR_04',
   'UPPER(CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2) + STRZERO(NPORCISLIS, 10) + STRZERO(NPORCISRAD,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'regzvipr',
   'regzvipr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_01',
   'UPPER(CRODCISPRA) +STRZERO(NRODPRISL,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_02',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_03',
   'STRZERO(NOSCISPRAC,5) +UPPER(CTYPRODPRI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_04',
   'UPPER(CRODCISPRA) +UPPER(CTYPRODPRI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rodprisl',
   'rodprisl.adi',
   'RODPR_05',
   'UPPER(CRODCISRP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rodprisl',
   'rodprisl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rok2005',
   'rok2005.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rokuzv',
   'rokuzv.adi',
   'ROKUZV_1',
   'NROKUZV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rokuzv',
   'rokuzv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rokuzvz',
   'rokuzvz.adi',
   'ROKUZVZ_1',
   'NROKUZV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rokuzvz',
   'rokuzvz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozbpz_h',
   'rozbpz_h.adi',
   'C_ROZB01',
   'NTYP_ROZ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozbpz_h',
   'rozbpz_h.adi',
   'C_ROZB02',
   'LSET_ROZ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozbpz_h',
   'rozbpz_h.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozbpz_i',
   'rozbpz_i.adi',
   'C_ROZB01',
   'STRZERO(NTYP_ROZ,3) +STRZERO(NVAL_1,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozbpz_i',
   'rozbpz_i.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozprac',
   'rozprac.adi',
   'ROZPRA1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'rozprac',
   'rozprac.adi',
   'ROZPRA2',
   'UPPER(CCISZAKAZ) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CZAOBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'seznabp',
   'seznabp.adi',
   'SEZNABP1',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISNAB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'seznabp',
   'seznabp.adi',
   'SEZNABP2',
   'NCISNAB',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'sklpren',
   'sklpren.adi',
   'SKLPREN1',
   'UPPER(CTYPPRENOS) +STRZERO(NCISSTANIC,3) +STRZERO(NCISPRENOS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'sklpren',
   'sklpren.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_02',
   'UPPER(CRODCISPRA) +STRZERO(NPORADI,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_03',
   'UPPER(CRODCISPRA) +UPPER(CZKRATKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'skoleni',
   'skoleni.adi',
   'SKOLE_05',
   'UPPER(CRODCISPRA) +DTOS (DDALSSKOLE)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'skoleni',
   'skoleni.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC01',
   'STRZERO(NCISFIRMY,5) +STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC02',
   'UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC03',
   'STRZERO(NZBOZIKAT,4) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC04',
   'UPPER(CTYPSLEVY) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC05',
   'UPPER(CTYPSLEVY) +STRZERO(NCISFIRMY,5) +STRZERO(NZBOZIKAT,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC06',
   'UPPER(CTYPSLEVY) +STRZERO(NCISFIRMY,5) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC07',
   'UPPER(CTYPSLEVY) +STRZERO(NZBOZIKAT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'SLEVYC08',
   'UPPER(CTYPSLEVY) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slevycen',
   'slevycen.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slzmzdy',
   'slzmzdy.adi',
   'SLMZD_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CSESTAVA) +STRZERO(NPROFESE,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slzmzdy',
   'slzmzdy.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'slzmzdy',
   'slzmzdy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'spojeni',
   'spojeni.adi',
   'SPOJENI01',
   'NCISSPOJ',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'spojeni',
   'spojeni.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'summaj',
   'summaj.adi',
   'SUMMAJ_1',
   'UPPER(COBDOBI)+STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'summaj',
   'summaj.adi',
   'SUMMAJ_2',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROK,4)+STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'summaj',
   'summaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'summajz',
   'summajz.adi',
   'SUMMAJZ_1',
   'UPPER(COBDOBI)+STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'summajz',
   'summajz.adi',
   'SUMMAJZ_2',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NROK,4)+STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'summajz',
   'summajz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'sumpvpit',
   'sumpvpit.adi',
   'SUM1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NCISLPOH,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'sumpvpit',
   'sumpvpit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_lstzak',
   't_lstzak.adi',
   'LSTZAK1',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_ustevi',
   't_ustevi.adi',
   'T_USTEV_01',
   'UPPER( CDRUHZV) + UPPER(CFARMAODK) + DTOS( DDATZMZV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_ustevi',
   't_ustevi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_vpobj',
   't_vpobj.adi',
   'R06_01',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_vpobj',
   't_vpobj.adi',
   'R07_02',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD1',
   'STRZERO(NROKVYTVOR,4) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD2',
   'STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD3',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NCISOPER,4) +STRZERO(NUKONOPER,2) +STRZERO(NVAROPER,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD4',
   'UPPER(CCISZAKAZ) +UPPER(COZNPRAC) +UPPER(COZNOPER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD5',
   'UPPER(CSTRED) +UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD6',
   'UPPER(COZNPRAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   't_zaspra',
   't_zaspra.adi',
   'LISTHD7',
   'UPPER(CCISZAKAZ) +STRZERO(NPORCISLIS,12)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tm_vekka',
   'tm_vekka.adi',
   'TMPMZLH1',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tm_vekka',
   'tm_vekka.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_cmzd',
   'tmp_cmzd.adi',
   'TMPCMZ01',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_cmzd',
   'tmp_cmzd.adi',
   'TMPCMZ02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_cmzd',
   'tmp_cmzd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzlh',
   'tmp_mzlh.adi',
   'TMPMZLH1',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzlh',
   'tmp_mzlh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'TMPMZLI1',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'TMPMZLI2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'TMPMZLI3',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5) +STRZERO(NFOOT,1) +STRZERO(NTYPRADMZL,3) +STRZERO(NRADMZDLIS,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_mzli',
   'tmp_mzli.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_nemr',
   'tmp_nemr.adi',
   'TMPNEMR1',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_nemr',
   'tmp_nemr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_ppri',
   'tmp_ppri.adi',
   'TMPPRICE',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_ppri',
   'tmp_ppri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_prpr',
   'tmp_prpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_term',
   'tmp_term.adi',
   'TMPTER01',
   'UPPER(CIDOSKARTY) +DTOS (DDATUM) +UPPER(CCAS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_term',
   'tmp_term.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO11',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UCETPO12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_uctp',
   'tmp_uctp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmp_vykz',
   'tmp_vykz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV1',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV2',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV3',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CKMENSTRPR) +STRZERO(NOSCISPRAC,5) +STRZERO(NDRUHMZDY,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV4',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV6',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDRUHMZDY,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV7',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'M_DAV8',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpdav',
   'tmpdav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpprecs',
   'tmpprecs.adi',
   'TMPCS_01',
   'STRZERO(NPODNIK, 5) +STRZERO(NTYPUCTU,2) +STRZERO(NOP_CS,3) +STRZERO(NOU_CS,3) +STRZERO(NTYPTRANS,2) +STRZERO(NTYPAGENDY,2) +STRZERO(NCISLOUCSK,2) +UPPER(CSPECSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpprecs',
   'tmpprecs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpprefo',
   'tmpprefo.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpprekb',
   'tmpprekb.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpsumko',
   'tmpsumko.adi',
   'TSUMKO01',
   'NOSCISPRAC',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpsumko',
   'tmpsumko.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpvyupr',
   'tmpvyupr.adi',
   'TMVYU_01',
   'STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tmpvyupr',
   'tmpvyupr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tpv_r02',
   'tpv_r02.adi',
   'TPV2_1',
   'STRZERO(NKEY,1) +UPPER(CCISSKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'tpv_r02',
   'tpv_r02.adi',
   'TPV2_2',
   'STRZERO(NKEY,1) +STRZERO(NUCETSKUP,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'trvalzav',
   'trvalzav.adi',
   'TRVZAV01',
   'UPPER(CZKRTYPZAV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'trvalzav',
   'trvalzav.adi',
   'TRVZAV02',
   'UPPER(CNAZEVZAV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'trvalzav',
   'trvalzav.adi',
   'TRVZAV03',
   'UPPER(CBANK_UCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'trvalzav',
   'trvalzav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL01',
   'UPPER(CULOHA)+UPPER(CPODULOHA) +UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL02',
   'UPPER(CULOHA)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL03',
   'UPPER(CTYPDOKLAD)+UPPER(CULOHA)+UPPER(CPODULOHA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL04',
   'UPPER(CTASK)+UPPER(CPODULOHA) +UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL05',
   'UPPER(CTASK)+UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'TYPDOKL06',
   'UPPER(CTYPDOKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'typdokl',
   'typdokl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_1',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_2',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_3',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_6',
   'STRZERO(NROK,4) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UCETDH_7',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdohd',
   'ucetdohd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,2) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetdoit',
   'ucetdoit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterr',
   'uceterr.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterr',
   'uceterr.adi',
   'UZAVER_2',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterr',
   'uceterr.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterr',
   'uceterr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,2) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uceterri',
   'uceterri.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_02',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_03',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_04',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_07',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_08',
   'UPPER(CNAZPOL2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_09',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_10',
   'UPPER(CNAZPOL4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_11',
   'UPPER(CNAZPOL5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UCETK_12',
   'UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkum',
   'ucetkum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_02',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_03',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_04',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL2) +UPPER(CNAZPOL1) +UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UCETK_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumk',
   'ucetkumk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumu',
   'ucetkumu.adi',
   'UCETK_01',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumu',
   'ucetkumu.adi',
   'UCETK_02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetkumu',
   'ucetkumu.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetplah',
   'ucetplah.adi',
   'UCETPL01',
   'STRZERO(NROK,4) +UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetplah',
   'ucetplah.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetplan',
   'ucetplan.adi',
   'UCETPL01',
   'STRZERO(NROK,4) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetplan',
   'ucetplan.adi',
   'UCETPL02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetplan',
   'ucetplan.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpocs',
   'ucetpocs.adi',
   'POCSTU01',
   'STRZERO(NROK,4) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpocs',
   'ucetpocs.adi',
   'POCSTU02',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpocs',
   'ucetpocs.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPOL6',
   'UPPER(CULOHA +COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO11',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO12',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO13',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO14',
   'UPPER(CDENIK) +UPPER(CTYPPOHYBU) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UCETPO15',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpol',
   'ucetpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO10',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NMAINITEM,6) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UCETPO11',
   'UPPER(CNAZPOL3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpola',
   'ucetpola.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpre',
   'ucetpre.adi',
   'UCTSKL1',
   'UPPER(CULOHA) +STRZERO(NDRPOHYB,5) +STRZERO(NOD,5) +UPPER(CUCTO1) +UPPER(CUCTO2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpre',
   'ucetpre.adi',
   'UCTSKL2',
   'UPPER(CULOHA) +IF (LHEAD, ''1'', ''0'') +STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpreh',
   'ucetpreh.adi',
   'UCETPR1',
   'UPPER(CKEYUCT) +UPPER(CTYPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpreh',
   'ucetpreh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpres',
   'ucetpres.adi',
   'TYPUCT1',
   'UPPER(CTYPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpres',
   'ucetpres.adi',
   'TYPUCT2',
   'STRZERO(NFINTYP) +UPPER(CTYPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetpres',
   'ucetpres.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprhd',
   'ucetprhd.adi',
   'UCETPRHD01',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprhd',
   'ucetprhd.adi',
   'UCETPRHD02',
   'UPPER(CULOHA +CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprhd',
   'ucetprhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT01',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU) +UPPER(CUCETSKUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT02',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU) +UPPER(CUCETSKUP) +STRZERO(NPOLUCTPR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT03',
   'UPPER(CULOHA) +UPPER(CTYPDOKLAD) +UPPER(CTYPPOHYBU) +STRZERO(NPOLUCTPR,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprit',
   'ucetprit.adi',
   'UCETPRIT04',
   'UPPER(CULOHA +CTYPPOHYBU+CUCETSKUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprit',
   'ucetprit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprsy',
   'ucetprsy.adi',
   'UCETPRSY01',
   'UPPER(CTYPUCT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetprsy',
   'ucetprsy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD02',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSLAD03',
   'UPPER(CUCETMD) +UPPER(CSYMBOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD04',
   'UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD05',
   'UPPER(CTEXT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD06',
   'UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD08',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UCSALD09',
   'UPPER(CUCETMD) +UPPER(CSYMBOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsald',
   'ucetsald.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD01',
   'UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD02',
   'LISCLOSE',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD03',
   'UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD04',
   'UPPER(CTEXT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD05',
   'UPPER(CUCETMD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +IF (LISCLOSE, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UCSALD08',
   'UPPER(CUCETMD) +UPPER(CSYMBOL) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsalk',
   'ucetsalk.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS1',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS2',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS3',
   'UPPER(CULOHA) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NAKTUC_KS,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsys',
   'ucetsys.adi',
   'UCETSYS4',
   'UPPER(CULOHA) +IF (LAKTOBD, ''1'', ''0'')',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetsys',
   'ucetsys.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetuzv',
   'ucetuzv.adi',
   'UZAVER1',
   'UPPER(CULOHA) +UPPER(COBDOBI) +STRZERO(NCISUZV,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ucetuzv',
   'ucetuzv.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_1',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_2',
   'UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_3',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_5',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UCETDH_6',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokhd',
   'uctdokhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL2',
   'STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL3',
   'UPPER(CULOHA) +STRZERO(NDOKLADORG,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL5',
   'UPPER(CDENIK) +UPPER(COBDOBI) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPOL6',
   'UPPER(CULOHA) +UPPER(COBDOBI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPO07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CUCETMD) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPO08',
   'UPPER(CUCETMD) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UCETPO09',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CDENIK) +STRZERO(NDOKLAD,10) +UPPER(CUCETMD) +UPPER(CSYMBOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uctdokit',
   'uctdokit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ukoly',
   'ukoly.adi',
   'UKOLY01',
   'NCISUKOLU',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ukoly',
   'ukoly.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ulozeni',
   'ulozeni.adi',
   'ULOZE1',
   'UPPER(CCISSKLAD) + UPPER(CSKLPOL) + UPPER(CULOZZBO)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ulozeni',
   'ulozeni.adi',
   'ULOZE2',
   'UPPER(CULOZZBO) + UPPER(CSKLPOL) + UPPER(CCISSKLAD)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ulozeni',
   'ulozeni.adi',
   'ULOZE3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CULOZZBO) +STRZERO(NULOZCELK,11)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'ulozeni',
   'ulozeni.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'umaj',
   'umaj.adi',
   'UMAJ_1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'umaj',
   'umaj.adi',
   'UMAJ_2',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'umaj',
   'umaj.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'umajz',
   'umajz.adi',
   'UMAJZ_1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'umajz',
   'umajz.adi',
   'UMAJZ_2',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NROKODPISU,4)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'umajz',
   'umajz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD1',
   'NCISUPOMIN',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD2',
   'STRZERO(NCISFIRMY,5) +STRZERO(NCISUPOMIN,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD3',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD4',
   'NICO',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominhd',
   'upominhd.adi',
   'UPOMHD5',
   'NCENZAKCEL',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominhd',
   'upominhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominit',
   'upominit.adi',
   'UPOMIT1',
   'STRZERO(NCISUPOMIN,10) +STRZERO(NINTCOUNT,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'upominit',
   'upominit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'users',
   'users.adi',
   'USERS01',
   'UPPER(CUSER)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'users',
   'users.adi',
   'USERS02',
   'NCISOSOBY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'users',
   'users.adi',
   'USERS03',
   'UPPER(CPRIHLJMEN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'users',
   'users.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'usersgrp',
   'usersgrp.adi',
   'USERSGRP01',
   'UPPER(CGROUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'usersgrp',
   'usersgrp.adi',
   'USERSGRP02',
   'UPPER(CNAMEGROUP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'usersgrp',
   'usersgrp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_1',
   'UPPER(COBDOBIDAN)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_2',
   'NCISFAK',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_3',
   'UPPER(CVARSYM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uskutpl',
   'uskutpl.adi',
   'USKPL_4',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uskutpl',
   'uskutpl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'usrtypoh',
   'usrtypoh.adi',
   'USRTYPOH01',
   'UPPER(CUSER)+UPPER(CTASK)+UPPER(CTYPPOHYBU)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'usrtypoh',
   'usrtypoh.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrd',
   'uzaverrd.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrd',
   'uzaverrd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrm',
   'uzaverrm.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrm',
   'uzaverrm.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrsf',
   'uzaverrsf.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrsf',
   'uzaverrsf.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrss',
   'uzaverrss.adi',
   'UZVERR_1',
   'UPPER(COBDOBI) +UPPER(CDENIK) +STRZERO(NDOKLAD,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzaverrss',
   'uzaverrss.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzavisoz',
   'uzavisoz.adi',
   'UZAVER1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzavisoz',
   'uzavisoz.adi',
   'UZAVER2',
   'UPPER(COBDOBI) +STRZERO(NCISUZAV,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzavisoz',
   'uzavisoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvdofa',
   'uzvdofa.adi',
   'UZAVER1',
   'NCISUZV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvdofa',
   'uzvdofa.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzverrsi',
   'uzverrsi.adi',
   'UZVERRSI_1',
   'UPPER(COBDOBI)+UPPER(CDENIK)+STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzverrsi',
   'uzverrsi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzverrsz',
   'uzverrsz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisoz',
   'uzvisoz.adi',
   'UZAVER1',
   'UPPER(COBDOBI) +STRZERO(NCISUZV,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisoz',
   'uzvisoz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisozf',
   'uzvisozf.adi',
   'UZAVER1',
   'UPPER(COBDOBI) +STRZERO(NCISUZV,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisozf',
   'uzvisozf.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisozi',
   'uzvisozi.adi',
   'UZVHIM_1',
   'UPPER(COBDOBI)+STRZERO(NCISUZV,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisozi',
   'uzvisozi.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'uzvisozz',
   'uzvisozz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazdokum',
   'vazdokum.adi',
   'INUNIQID',
   'UPPER(CINUNIQID) + UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazdokum',
   'vazdokum.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazdokum',
   'vazdokum.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) + STRZERO(NITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazdokum',
   'vazdokum.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazdokum',
   'vazdokum.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazfirmy',
   'vazfirmy.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazfirmy',
   'vazfirmy.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazfirmy',
   'vazfirmy.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazfirmy',
   'vazfirmy.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazfirmy',
   'vazfirmy.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazoprav',
   'vazoprav.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazoprav',
   'vazoprav.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazoprav',
   'vazoprav.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazoprav',
   'vazoprav.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazoprav',
   'vazoprav.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazosoby',
   'vazosoby.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazosoby',
   'vazosoby.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazosoby',
   'vazosoby.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazosoby',
   'vazosoby.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazosoby',
   'vazosoby.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazspoje',
   'vazspoje.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazspoje',
   'vazspoje.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazspoje',
   'vazspoje.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazspoje',
   'vazspoje.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazspoje',
   'vazspoje.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazukoly',
   'vazukoly.adi',
   'INUNIQID',
   'UPPER(CINUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazukoly',
   'vazukoly.adi',
   'OUUNIQID',
   'UPPER(COUUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazukoly',
   'vazukoly.adi',
   'INUNIQIDIT',
   'UPPER(CINUNIQID) +STRZERO(NITEM,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazukoly',
   'vazukoly.adi',
   'RLUNIQID',
   'UPPER(CRLUNIQID)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vazukoly',
   'vazukoly.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_1',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3) +STRZERO(NPORADI,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_2',
   'UPPER(COBDOBIDAN) +UPPER(CDENIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_3',
   'UPPER(COBDOBIDAN) +STRZERO(NGEN_DOKL,1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_4',
   'UPPER(CDENIK) +STRZERO(NDOKLAD,10) +STRZERO(NODDIL_DPH,2) +STRZERO(NRADEK_DPH,3) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_5',
   'UPPER(CDENIK_PAR) +STRZERO(NCISFAK,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'VYKDPH_6',
   'UPPER(CDENIK) +STRZERO(NCISFAK,10) +STRZERO(NDOKLAD_OR,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykdph_i',
   'vykdph_i.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykresy',
   'vykresy.adi',
   'VYKRES1',
   'UPPER(CCISVYK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vykresy',
   'vykresy.adi',
   'VYKRES2',
   'STRZERO(NPORVYK,8)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_03',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CVYPLMIST) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_04',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_05',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_06',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5) +STRZERO(NPORPRAVZT,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'VYPL_07',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +UPPER(CVYPLMIST) +UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vypl',
   'vypl.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CVYROBCIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC2',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLAD,10) +UPPER(CVYROBCIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC3',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLADV,10) +UPPER(CVYROBCIS)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC4',
   'NDOKLADV',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC5',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLAD,10) +STRZERO(NORDITEM,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC6',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NDOKLADV,10) +STRZERO(NORDITEM,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC7',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'C_VYRC8',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL) +STRZERO(NORDITEM,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrcis',
   'vyrcis.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL2',
   'UPPER(CNAZEV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL3',
   'UPPER(CCISVYK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL4',
   'UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL5',
   'UPPER(CCISZAKAZ) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL6',
   'UPPER(CSKLPOL) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL7',
   'UPPER(CCISZAKAZ) +UPPER(CVYSPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL8',
   'UPPER(CCISZAKAZ) +UPPER(CNIZPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'VYRPOL9',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpol',
   'vyrpol.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpoldt',
   'vyrpoldt.adi',
   'VYRDT1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrpoldt',
   'vyrpoldt.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK1',
   'UPPER(CCISZAKAZ) +UPPER(CVYRPOL) +STRZERO(NVARCIS,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK2',
   'UPPER(CVYRPOL) +STRZERO(NVARCIS,3) +DTOS (DODVEDZAKA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK3',
   'UPPER(CNAZEVZAK1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK4',
   'STRZERO(NCISFIRMY,5) +STRZERO(NSTAVFAKT,1) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK5',
   'UPPER(CSTAVZAKAZ) +UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK6',
   'UPPER(CNAZPOL1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK7',
   'UPPER(CNAZPOL3) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK8',
   'UPPER(CCISLOOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzak',
   'vyrzak.adi',
   'VYRZAK9',
   'UPPER(CNAZFIRMY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_1',
   'UPPER(CCISZAKAZ) + STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_2',
   'UPPER(CVYROBCISL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_3',
   'DTOS(DMOZODVZAK) +STRZERO(NCISLOEL,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_4',
   'UPPER(CCISZAKAZI)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_5',
   'DTOS(DMOZODVZAK) +STRZERO(NCISLOEL,10) +STRZERO(NCISFIRMY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_6',
   'STRZERO(NROKODV,4) +STRZERO(NTYDENODV,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_7',
   'NCISFIRMY',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyrzakit',
   'vyrzakit.adi',
   'ZAKIT_8',
   'NSTAVFAKT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyucdane',
   'vyucdane.adi',
   'VYUCDA01',
   'STRZERO(NROK,4) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyucdane',
   'vyucdane.adi',
   'VYUCDA02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyucdane',
   'vyucdane.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyucdani',
   'vyucdani.adi',
   'VYUCDA01',
   'STRZERO(NROK,4) +STRZERO(NOBDOBI,2) +STRZERO(NOSCISPRAC,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyucdani',
   'vyucdani.adi',
   'VYUCDA02',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NROK,4) +STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vyucdani',
   'vyucdani.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_02',
   'UPPER(CRODCISPRA) +STRZERO(NPORADI,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_03',
   'UPPER(CRODCISPRA) +UPPER(CZKRVZDEL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzdelani',
   'vzdelani.adi',
   'VZDEL_04',
   'UPPER(CPRACOVNIK)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzdelani',
   'vzdelani.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'OBJPVP1',
   'UPPER(CCISOBJ) +STRZERO(NDOKLAD,6) +STRZERO(NORDITEM,5) +UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'OBJPVP2',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'OBJPVP3',
   'UPPER(CCISOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vzobjpvp',
   'vzobjpvp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB1',
   'UPPER(CCISSKLAD) +UPPER(CSKLPOL)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB2',
   'UPPER(CCISLOBINT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB3',
   'UPPER(CCISOBJ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB4',
   'UPPER(CCISOBJ) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB5',
   'UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'vztahobj',
   'vztahobj.adi',
   'VZTAHOB6',
   'UPPER(CCISOBJ) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CCISLOBINT) +STRZERO(NCISLPOLOB) +STRZERO(NINTCOUNT)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'wds_hd',
   'wds_hd.adi',
   'WDS_HD_1',
   'UPPER(WDS_KEY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'wds_it',
   'wds_it.adi',
   'WDS_IT_1',
   'UPPER(WDS_KEY)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'wds_it',
   'wds_it.adi',
   'WDS_IT_2',
   'UPPER(WDS_KEY) +UPPER(CFILE_IV) +STRZERO(NRECS_IV,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zakapar',
   'zakapar.adi',
   'ZAKAPA_1',
   'UPPER(CCISZAKAZ) +STRZERO(NCISATRIBZ,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zakapar',
   'zakapar.adi',
   'ZAKAPA_2',
   'UPPER(CATRIB) + UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zakapprn',
   'zakapprn.adi',
   'ZAKAPA1',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zakoprav',
   'zakoprav.adi',
   'ZAKOPR1',
   'UPPER(CCISZAKAZ)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zakoprav',
   'zakoprav.adi',
   'ZAKOPR2',
   'DTOS ( DDATZKOPAC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zakoprav',
   'zakoprav.adi',
   'ZAKOPR3',
   'NROKPROTME',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_01',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(ZD,3)+UPPER(CL)+STRZERO(NDRUHMZDY,4)+UPPER(CKMENSTRPR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_02',
   'STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_03',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamezd',
   'zamezd.adi',
   'ZAMEZ_04',
   'STRZERO(NROK,4)+STRZERO(NOBDOBI,2)+UPPER(CKMENSTRPR)+STRZERO(NDRUHMZDY,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamezd',
   'zamezd.adi',
   'ONLY_DEL',
   'RECNO()',
   'DELETED()',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamezd',
   'zamezd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamrodpr',
   'zamrodpr.adi',
   'ZAROP_01',
   'UPPER(CRODCISPRA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamrodpr',
   'zamrodpr.adi',
   'ZAROP_02',
   'UPPER(CRODCISRP)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zamrodpr',
   'zamrodpr.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajn',
   'zmajn.adi',
   'ZMAJN1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NCISZMENY,8)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajn',
   'zmajn.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajnz',
   'zmajnz.adi',
   'ZMAJNZ1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NCISZMENY,8)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajnz',
   'zmajnz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU1',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU2',
   'UPPER(COBDOBI)+STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU3',
   'STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU4',
   'UPPER(CDENIK)+ STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU5',
   'NKARTA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU6',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU7',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'ZMAJU8',
   'STRZERO(NTYPMAJ,3)+STRZERO(NINVCIS,10)+ STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmaju',
   'zmaju.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ1',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ2',
   'UPPER(COBDOBI)+STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NPORZMENY,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ3',
   'STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ4',
   'UPPER(CDENIK)+ STRZERO(NDOKLAD,10)+STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ5',
   'NKARTA',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ6',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ7',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ8',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'ZMAJUZ9',
   'STRZERO(NUCETSKUP,3)+STRZERO(NINVCIS,10)+ STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmajuz',
   'zmajuz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmeelnar',
   'zmeelnar.adi',
   'C_ZMDIM1',
   'STRZERO(NINVCISDIM,6) +DTOS (DDATPOSKON)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmeelnar',
   'zmeelnar.adi',
   'C_ZMDIM2',
   'STRZERO(NINVCISDIM,6) +STRZERO(NCISKONTR)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmeelnar',
   'zmeelnar.adi',
   'C_ZMDIM3',
   'NCISKONTR',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmeelnar',
   'zmeelnar.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM1',
   'STRZERO(NINVCISDIM,6) +DTOS (DDATZMDIM) +UPPER(CCASZMDIM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM2',
   'STRZERO(NINVCISDIM,6) +STRZERO(NCISZMDIM,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM3',
   'STRZERO(NINVCISDIM,6) +STRZERO(NPOH_DIM,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM4',
   'STRZERO(NINVCISDIM,6) +UPPER(CKLICSKMIS) +UPPER(CKLICODMIS) +IF (LPOH_DIM, ''1'', ''0'') +STRZERO(NCISZMDIM,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM5',
   'NCISZMDIM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'C_ZMDIM6',
   'LPOH_DIM',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydim',
   'zmenydim.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenydmz',
   'zmenydmz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenymsp',
   'zmenymsp.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenyper',
   'zmenyper.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenysrz',
   'zmenysrz.adi',
   'OSCISPOR',
   'STRZERO(NOSCISPRAC,5) +STRZERO(NPORADISRZ,3)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zmenysrz',
   'zmenysrz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS, 10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA02',
   'STRZERO(NZVIRKAT, 6) +STRZERO(NINVCIS, 10) +DTOS (DDATKDYKAM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA03',
   'NINVCIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA04',
   'UPPER(CFARMA) + STRZERO(NPORCISLIS,10) +STRZERO( NPORCISRAD, 2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA05',
   'STRZERO( NINVCIS, 10) + DTOS(DDATKDYKAM)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA06',
   'STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)+ UPPER(CFARMA) + DTOS( DDATPZV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA07',
   'UPPER(CFARMA) + STRZERO(NROK, 4) + STRZERO( NOBDOBI, 2)+ STRZERO(NPORCISLIS,10) +STRZERO( NPORCISRAD, 2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA08',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NINVCIS, 10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'ZVIRATA09',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS, 10) + STRZERO(NKUSY, 1)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirata',
   'zvirata.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvirataz',
   'zvirataz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD02',
   'UPPER(COBDOBI) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD03',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarobd',
   'zvkarobd.adi',
   'ZVKAROBD04',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2) + UPPER(CTYPZVR) + UPPER(CFARMA)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarobd',
   'zvkarobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty',
   'zvkarty.adi',
   'ZVKARTY_01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty',
   'zvkarty.adi',
   'ZVKARTY_02',
   'UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty',
   'zvkarty.adi',
   'ZVKARTY_03',
   'NZVIRKAT',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty',
   'zvkarty.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'ZVKARPS_01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NROK,4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'ZVKARPS_02',
   'STRZERO(NROK,4) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'ZVKARPS_03',
   'STRZERO(NROK,4) + STRZERO(NZVIRKAT,6) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkarty_ps',
   'zvkarty_ps.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkartyz',
   'zvkartyz.adi',
   'ZVKARTYZ01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkartyz',
   'zvkartyz.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkatobd',
   'zvkatobd.adi',
   'ZVKATOBD01',
   'STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkatobd',
   'zvkatobd.adi',
   'ZVKATOBD02',
   'UPPER(COBDOBI) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkatobd',
   'zvkatobd.adi',
   'ZVKATOBD03',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2) + STRZERO(NZVIRKAT,6)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvkatobd',
   'zvkatobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NORDITEM,5) + STRZERO(NPORZMENY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD02',
   'UPPER(COBDOBI) +UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD03',
   'STRZERO(NDOKLAD,10) + STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD04',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NPORZMENY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD05',
   'NDOKLADUSR',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD06',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD07',
   'STRZERO(NROK,4)+ UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NDRPOHYB,5) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD08',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2)+ STRZERO(NDOKLAD,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD09',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)+ IF(LZMENAZAKL, ''1'', ''0'') + STRZERO(NORDITEM,5) + STRZERO(NPORZMENY,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD10',
   'STRZERO(NROK,4)+ STRZERO(NOBDOBI,2)+ UPPER(CTYPZVR) + UPPER(CFARMA) + DTOS(DDATZMZV)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD11',
   'NDOKLAD',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD12',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)+ DTOS(DDATPORIZ)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD13',
   'STRZERO(NZVIRKAT,6) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'ZVZMENHD14',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6)+ STRZERO(NDOKLAD,10)',
   '',
   10,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenhd',
   'zvzmenhd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT,6) + STRZERO(NINVCIS,10)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT02',
   'STRZERO(NDOKLAD,10) + STRZERO(NORDITEM,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT03',
   'NINVCIS',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenit',
   'zvzmenit.adi',
   'ZVZMENIT04',
   'STRZERO(NFARMA,10) +   STRZERO(NPORCISLIS,10) + STRZERO(NPORCISRAD,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmenit',
   'zvzmenit.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmobd',
   'zvzmobd.adi',
   'ZVZMOBD_01',
   'UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT, 6) + STRZERO(NDRPOHYB,5) + STRZERO(NROK,4) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmobd',
   'zvzmobd.adi',
   'ZVZMOBD_02',
   'STRZERO(NROK,4) + STRZERO(NOBDOBI,2) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT, 6) + STRZERO(NDRPOHYB,5)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmobd',
   'zvzmobd.adi',
   'ZVZMOBD_03',
   'STRZERO(NROK,4) + UPPER(CNAZPOL1) + UPPER(CNAZPOL4) + STRZERO(NZVIRKAT, 6) + STRZERO(NDRPOHYB,5) + STRZERO(NOBDOBI,2)',
   '',
   2,
   512,'' );


EXECUTE PROCEDURE sp_CreateIndex90( 
   'zvzmobd',
   'zvzmobd.adi',
   'UNIQEIDREC',
   'UPPER(CUNIQIDREC)',
   '',
   2,
   512,'' );

