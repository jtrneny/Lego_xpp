//update mzdzavhd set mzdzavhd.nExiPriUhr=mzdzavhd_.nExiPriUhr,
//                    mzdzavhd.dDatPriUhr=mzdzavhd_.dDatPriUhr,
//					mzdzavhd.nPriUhrCel=mzdzavhd_.nPriUhrCel,
//					mzdzavhd.dPosUhrFak=mzdzavhd_.dPosUhrFak,
//					mzdzavhd.nUhrCelFak=mzdzavhd_.nUhrCelFak,
//					mzdzavhd.nUhrCelFaZ=mzdzavhd_.nUhrCelFaZ
//	            from mzdzavhd_
//				where mzdzavhd.cobdobi='08/14' and mzdzavhd.nCisFak=mzdzavhd_.nCisFak 				


update mzdzavhd set mzdzavhd.nExiPriUhr=1,
                    mzdzavhd.dDatPriUhr=prikuhit.dPorizPri,
					mzdzavhd.nPriUhrCel=prikuhit.nPriUhrCel,
					mzdzavhd.dPosUhrFak=prikuhit.dUhrBanDne,
					mzdzavhd.nUhrCelFak=prikuhit.nPriUhrCel,
   				    mzdzavhd.nUhrCelFaZ=prikuhit.nPriUhrCel
	            from prikuhit
				where mzdzavhd.cobdobi='04/19' and
				     prikuhit.csubtask = 'MZD' and   
					   mzdzavhd.nCisFak=prikuhit.nCisFak  				