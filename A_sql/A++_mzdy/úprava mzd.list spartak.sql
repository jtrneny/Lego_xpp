update msosb_mo set ltiskmzdli = false  ;
update msosb_mo set msosb_mo.ltiskmzdli = true from mzdlisth where msosb_mo.nrok = mzdlisth.nrok and msosb_mo.noscisprac = mzdlisth.noscisprac ;