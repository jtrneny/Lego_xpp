update c_naklst set c_naklst.lrezvyrob = c_nakstr.lrezvyrob, c_naklst.lrezsprav=c_nakstr.lrezsprav from c_nakstr
          where c_naklst.cnazpol1=c_nakstr.cnazpol1 and c_naklst.cnazpol2=c_nakstr.cnazpol2 and c_naklst.cnazpol3=c_nakstr.cnazpol3 and 
                  c_naklst.cnazpol4=c_nakstr.cnazpol5 and c_naklst.cnazpol5=c_nakstr.cnazpol5 and c_naklst.cnazpol6=c_nakstr.cnazpol6  