//update osoby set osoby.nporpravzt = msprc_mo.nporpravzt from msprc_mo where osoby.ncisosoby = msprc_mo.ncisosoby and osoby.nporpravzt <> msprc_mo.nporpravzt and  
//                                                                              msprc_mo.cobdobi = '09/16'


//update dspohyby set dspohyby.nporpravzt = msprc_mo.nporpravzt from msprc_mo where dspohyby.noscisprac = msprc_mo.noscisprac and dspohyby.nporpravzt <> msprc_mo.nporpravzt and  
//                                                                              msprc_mo.cobdobi = '09/16'

update dspohyby set dspohyby.croobcpppv = msprc_mo.croobcpppv from msprc_mo where dspohyby.cobdobi = '09/16' and dspohyby.noscisprac = msprc_mo.noscisprac and dspohyby.nporpravzt = msprc_mo.nporpravzt and  
                                                                                      msprc_mo.cobdobi = '09/16'            