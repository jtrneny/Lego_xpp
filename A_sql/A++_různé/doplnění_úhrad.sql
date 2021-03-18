update fakvyshd set fakvyshd.nuhrcelfak = fakvyshd.nuhrcelfak + banvypit.ncenzakcel
        from banvypit
         where banvypit.cdenik = 'H' and banvypit.cdenik_par = fakvyshd.cdenik and banvypit.ncisfak = fakvyshd.ncisfak    ;
update fakprihd set fakprihd.nuhrcelfak = fakprihd.nuhrcelfak + banvypit.ncenzakcel
        from banvypit
         where banvypit.cdenik = 'H' and banvypit.cdenik_par = fakprihd.cdenik and banvypit.ncisfak = fakprihd.ncisfak    
