  local typCeny := '00001'
  local cky     := typCeny +upper(?? -> ccissklad) +upper(?? -> csklpol) +strzero(?? -> ncisfirmy,5)

  if      procenho->(dbseek(cky))
*-  v�b�r hodnoty

  else if procenfi->(dbseek(typCeny +strzero(?? -> ncisfirmy,5)
*-  nen� index v procenfi -- doplnit
     
    cky := typCeny +upper(procenfi->ccissklad) +upper(procenfi->csklpol) +strzero(procenfi->ncisfirmy,5)
    if procenho->(dbseek(cky))
*-  v�b�r hodnoty


do funkce p�edat ncisFirmy, cisSklad, csklPol, kategZbo, datumDokladu




- cen�k pro firmu bez opezen� data platnosti
1. nastaven� procenhd pro firmu nen� nastavena platnost od-do
    

- ak�n� cen�k pro firmy
2. nastaven� procenhd pro firmu   je nastavna platnost od-do


- ak�n� cen�k pro v�echny bez omezen� platnosti
3. nastaven� procenhd bez firmy nen� nastavena platnost od-do      


- ak�n� cen�k pro v�echny   s omezen�m platnosti
4. nastaven� procenhd bez firmy   je nastavna platnost od-do


 


* OK procenhd

(ntypProCen = 1 .and. (ncisFirmy = 47 .or. ncisFirmy = 0)) .and. 
(empty(dplatnyOD) .or. 
(dplatnyDO <= '16.12.2008' .and. '16.12.2008' >= dplatnyOD))


* OK PROCENIT
ntypProCen = 1 .and. 
(ncisProCen = 2 .or.  ncisProcen = 4 .or. ncisProCen = 30) .and.
((nzboziKat = 30) .or. (ccisSklad = '2' .and. CSKLPOL = '40025'))

* OK procenho
ntypProCen = 1 .and. 
((ncisProcen = 4 .and. npolProcen = 14) .or.
 (ncisProcen = 30 .and. npolProcen = 5))



************ALL
(ntypProCen = 1 .and. (ncisFirmy = 47 .or. ncisFirmy = 0)) .and. 
(empty(dplatnyOD) .or. 
(dplatnyDO <= '16.12.2008' .and. '16.12.2008' >= dplatnyOD)) .and.
((nzboziKat = 30) .or. (ccisSklad = '2' .and. CSKLPOL = '40025'))


