TYPE(drgForm) DTYPE(0) TITLE(Výbìr firmy pro stup dokladu ...) SIZE(50,17) GUILOOK(Message:n,Action:n,IconBar:n,Menu:n )


TYPE(Browse) FILE(FIRMY) INDEXORD(1) FIELDS(cNAZEV,nCISFIRMY,cDIC) ;
             SIZE(50,15) CURSORMODE(3) SCROLL(ny)  PP(1);
             PRE(SetPrijem) ITEMSELECTED( SelectCARD)


