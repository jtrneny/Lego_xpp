select sum( select msodppol.nDanUlObd from msodppol where msprc_mo.cobdobi = '05/16' and msprc_mo.nDanUlObd > 0 and msprc_mo.nDanUlObd <> 2070 and
											   msprc_mo.nrok = msodppol.nrok and
											    msprc_mo.noscisprac = msodppol.noscisprac and
                                                 msprc_mo.nporpravzt = msodppol.nporpravzt and
												  msprc_mo.lstavem and msodppol.cObdDo >= '05/16')
     from msprc_mo where msprc_mo.cobdobi = '05/16' and msprc_mo.nDanUlObd > 0 and msprc_mo.nDanUlObd <> 2070 and msprc_mo.lstavem 												  
 