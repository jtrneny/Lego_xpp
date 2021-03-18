INSERT INTO UCETPRSY (cTypUct,cMAINFILE,cNazTypUct,dPlatnyOd,dPlatnyDo,mUCTUJ_MD,mUCTUJ_DAL,mPODMINKA,mPOPISUCT,dVznikZazn,
                       dZmenaZazn,mPOZNAMKA,mUserZmenR)
SELECT                 cTypUct,cMAINFILE,cNazTypUct,dPlatnyOd,dPlatnyDo,mUCTUJ_MD,mUCTUJ_DAL,mPODMINKA,mPOPISUCT,dVznikZazn,
                       dZmenaZazn,mPOZNAMKA,mUserZmenR 
FROM UCETPRSY_  
