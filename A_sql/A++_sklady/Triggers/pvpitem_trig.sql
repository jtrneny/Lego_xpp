ALTER TRIGGER pvpItem_insted_of_insert
   ON pvpitem
   INSTEAD OF
   INSERT
BEGIN
// pvpItem
declare @ccisSklad   String , @csklPol    String, @ccisObj String;
declare @ntypPoh     Integer;
declare @ntypPVP     Integer;
declare @nmnozPrDod  Double , @nmnozReOdb  Double, @nmnozVyObj Double;
declare @ncenaCelk   Double , @ncenaCelk_o Double;
declare @nsid        Integer;

// cenZboz
declare @nrecCnt      Integer, @nsid_cenZboz Integer;
declare @nmnozSZbo    Double,  @nmnozDZbo Double , @nmnozRZbo Double;
declare @ncenaCZbo    Double,  @ncenaSZbo Double , @ncenaNZbo Double;

// objitem
declare @nsumREodb    Double;

declare curs_cenZboz  Cursor;

@ccisSklad   = ( select [ccisSklad]  from __new );
@csklPol     = ( select [csklPol]    from __new );
@ccisObj     = ( select [ccisObj]    from __new );
@ntypPoh     = ( select [ntypPoh]    from __new );
@ntypPVP     = ( select [ntypPVP]    from __new );

@nmnozPrDod  = ( select [nmnozPrDod] from __new ) * @ntypPoh;
@nmnozReOdb  = ( select [nmnozREodb] from __new ) * @ntypPoh;
@nmnozVyObj  = ( select [nmnozVyObj] from __new ) * @ntypPoh;
@ncenaCelk   = ( select [ncenaCelk]  from __new ) * @ntypPoh;
@ncenaCelk_o = ( select [ncenaCelk]  from __new );

@nrecCnt     = ( select count(*)    from cenZboz where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol );
@nsid        = ( select [sID]       from __new);

@nsumREodb   = ( select sum(nmnozREodb) from objitem where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol and [nmnozREodb] <> 0 );


if ( @nrecCnt = 1 and @nmnozPrDod <> 0 and @ncenaCelk <> 0 )  or ( @nrecCnt = 1 and @ntypPVP = 4 ) then

  open curs_cenZboz as select * from cenZboz where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol;

  TRY
    if  fetch curs_cenZboz  then
      @nmnozSZbo = curs_cenZboz.nmnozSZbo + iif( @ntypPVP = 4, 0, @nmnozPrDod);
      @ncenaCZbo = curs_cenZboz.ncenaCZbo + @ncenaCelk;
      @ncenaSZbo = curs_cenZboz.ncenaSZbo;
      @ncenaNZbo = iif( (select [ncenNapDod] from __new) = 0, curs_cenZboz.ncenaNZbo, (select [ncenNapDod] from __new));

      if @ntypPVP = 4 then
        @ncenaSZbo = ( select [ncenNapDod] from __new );
        @ncenaCZbo = @ncenaSZbo * @nmnozSZbo;

      else
        if curs_cenZboz.cpolCen = 'C'  then

          if  ( upper(curs_cenZboz.ctypSklCen) = 'PRU' )  then
            @nmnozSzbo = iif( @nmnozSzbo < 0, 0, @nmnozSzbo);
            @ncenaCZbo = iif( @ncenaCZbo < 0, 0, @ncenaCZbo);

            if ( @nmnozSZbo = 0 and @ncenaCZbo <> 0 ) then

              INSERT INTO pvpitTOnul (  ccisSklad,  csklPol,   ncenaCELKd,  nrozTOnul,                 ncenaCelk, nPVPITEM )
                          values     ( @ccisSklad, @csklPol, @ncenaCelk_o, @ncenaCZbo, @ncenaCelk_o + @ncenaCZbo, @nsid    );

              @ncenaCelk_o = @ncenaCelk_o + @ncenaCZbo;
              @ncenaCZbo   = 0;
            end;

            @ncenaSZbo = iif( @ncenaCZbo <> 0 and @nmnozSZbo <> 0, round(@ncenaCZbo/@nmnozSZbo, 4), curs_cenZboz.ncenaSZbo );
          end;
        else
          @ncenaSZbo =  iif( @ntypPVP = 4, @ncenaNZbo, @ncenaSZbo );
        end;
      end;

      @nmnozRzbo = iif( @nsumREodb IS NULL, 0, @nsumREodb );
      @nmnozDzbo = iif( @nmnozSZbo - @nmnozRzbo > 0, @nmnozSZbo - @nmnozRzbo, 0 );

      update cenZboz set nmnozSZbo = @nmnozSZbo,
                         ncenaCZbo = @ncenaCZbo,
                         ncenaSZbo = @ncenaSZbo,
                         nmnozDZbo = @nmnozDZbo,
                         nmnozRZbo = @nmnozRzbo,
                         ncenaSVZm = @ncenaSZbo,
                         ncenaNZbo = @ncenaNZbo,
                         ddatPzbo  = ( select [ddatPvp] from __new )
                     where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol;

      close curs_cenZboz;

      update __new set  nmnozSZbo = @nmnozSZbo  ,
                        ncenaCZbo = @ncenaCZbo  ,
                        ncenaCelk = @ncenaCelk_o,
                        dpohPvp   = CurDate()   ,
                        ccasPvp   = CONVERT( CurTime(), SQL_CHAR);
      INSERT INTO pvpitem SELECT * FROM __new;
    end;
  FINALLY

  END;

END IF;

END
   NO TRANSACTION
   PRIORITY 1;



ALTER TRIGGER pvpItem_after_delete
   ON pvpitem
   AFTER
   DELETE
BEGIN
// pvpItem
declare @ccisSklad   String , @csklPol    String, @ccisObj String;
declare @ntypPoh     Integer;
declare @ntypPVP     Integer;
declare @nmnozPrDod  Double , @nmnozReOdb Double, @nmnozVyObj Double;
declare @ncenaCelk   Double ;
declare @nsid        Integer;

// cenZboz
declare @nrecCnt      Integer, @nsid_cenZboz Integer;
declare @nmnozSZbo    Double,  @nmnozDZbo Double , @nmnozRZbo Double;
declare @ncenaCZbo    Double,  @ncenaSZbo Double , @ncenaNZbo Double;

// objitem
declare @nsumREodb    Double;

declare curs_cenZboz  Cursor;

@ccisSklad   = ( select [ccisSklad]  from __old );
@csklPol     = ( select [csklPol]    from __old );
@ccisObj     = ( select [ccisObj]    from __old );
@ntypPoh     = ( select [ntypPoh]    from __old );
@ntypPVP     = ( select [ntypPVP]    from __old );

@nmnozPrDod  = ( select [nmnozPrDod] from __old ) * @ntypPoh;
@nmnozReOdb  = ( select [nmnozREodb] from __old ) * @ntypPoh;
@nmnozVyObj  = ( select [nmnozVyObj] from __old ) * @ntypPoh;
@ncenaCelk   = ( select [ncenaCelk]  from __old ) * @ntypPoh;

@nrecCnt     = ( select count(*)    from cenZboz where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol );
@nsid        = ( select [sID]       from __old);

@nsumREodb   = ( select sum(nmnozREodb) from objitem where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol and [nmnozREodb] <> 0 );

// rušíme pvpItem
@nmnozPrDod  = @nmnozPrDod * -1 ;
@nmnozReOdb  = @nmnozReOdb * -1 ;
@nmnozVyObj  = @nmnozVyObj * -1 ;
@ncenaCelk   = @ncenaCelk  * -1 ;


if ( @nrecCnt = 1 and @nmnozPrDod <> 0 and @ncenaCelk <> 0 ) then

  open curs_cenZboz as select * from cenZboz where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol;

  TRY
    if  fetch curs_cenZboz  then
      @nmnozSZbo = curs_cenZboz.nmnozSZbo + iif( @ntypPVP = 4, 0, @nmnozPrDod);
      @ncenaCZbo = curs_cenZboz.ncenaCZbo + @ncenaCelk;
      @ncenaSZbo = curs_cenZboz.ncenaSZbo;
      @ncenaNZbo = iif( (select [ncenNapDod] from __old) = 0, curs_cenZboz.ncenaNZbo, (select [ncenNapDod] from __old));

      if curs_cenZboz.cpolCen = 'C'  then

        if  ( upper(curs_cenZboz.ctypSklCen) = 'PRU' )  then
          @nmnozSzbo = iif( @nmnozSzbo < 0, 0, @nmnozSzbo);
          @ncenaCZbo = iif( @ncenaCZbo < 0, 0, @ncenaCZbo);
          @ncenaSZbo = iif( @ncenaCZbo <> 0 and @nmnozSZbo <> 0, round(@ncenaCZbo/@nmnozSZbo, 4), curs_cenZboz.ncenaSZbo );
        end;

      else
        @ncenaSZbo =  iif( @ntypPVP = 4, @ncenaNZbo, @ncenaSZbo );
      end;

      @nmnozRzbo = iif( @nsumREodb IS NULL, 0, @nsumREodb );
      @nmnozDzbo = iif( @nmnozSZbo - @nmnozRzbo > 0, @nmnozSZbo - @nmnozRzbo, 0 );

      update cenZboz set nmnozSZbo = @nmnozSZbo,
                         ncenaCZbo = @ncenaCZbo,
                         ncenaSZbo = @ncenaSZbo,
                         nmnozDZbo = @nmnozDZbo,
                         nmnozRZbo = @nmnozRzbo,
                         ncenaSVZm = @ncenaSZbo,
                         ncenaNZbo = @ncenaNZbo,
                         ddatPzbo  = ( select [ddatPvp] from __old )
                     where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol;

    end;

  FINALLY
    close curs_cenZboz;

  END;

END IF;


END

   NO TRANSACTION
   PRIORITY 1;



ALTER TRIGGER pvpItem_after_update
   ON pvpitem
   AFTER
   UPDATE
BEGIN
// pvpItem
declare @ccisSklad   String , @csklPol    String, @ccisObj String;
declare @ntypPoh     Integer, @nstav_Polo Integer;
declare @ntypPVP     Integer;
declare @nmnozPrDod  Double , @nmnozReOdb Double, @nmnozVyObj Double;
declare @ncenaCelk   Double ;
declare @nsid        Integer;

// cenZboz
declare @nrecCnt      Integer, @nsid_cenZboz Integer;
declare @nmnozSZbo    Double,  @nmnozDZbo Double , @nmnozRZbo Double;
declare @ncenaCZbo    Double,  @ncenaSZbo Double , @ncenaNZbo Double;

// objitem
declare @nsumREodb    Double;

declare curs_cenZboz  Cursor;

@ccisSklad   = ( select [ccisSklad]  from __new );
@csklPol     = ( select [csklPol]    from __new );
@ccisObj     = ( select [ccisObj]    from __new );
@ntypPoh     = ( select [ntypPoh]    from __new );
@ntypPVP     = ( select [ntypPVP]    from __new );
@nstav_Polo  = ( select [nstav_Polo] from __new );

@nmnozPrDod  = ( select [nmnozPrDod] from __new ) - ( select [nmnozPrDod] from __old );
@nmnozReOdb  = ( select [nmnozREodb] from __new ) - ( select [nmnozREodb] from __old );
@nmnozVyObj  = ( select [nmnozVyObj] from __new ) - ( select [nmnozVyObj] from __old );
@ncenaCelk   = ( select [ncenaCelk]  from __new ) - ( select [ncenaCelk]  from __old );

@nrecCnt     = ( select count(*)    from cenZboz where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol );
@nsid        = ( select [sID]       from __new);

@nsumREodb   = ( select sum(nmnozREodb) from objitem where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol and [nmnozREodb] <> 0 );

// opravujeme pvpItem
@nmnozPrDod  = @nmnozPrDod * @ntypPoh;
@nmnozReOdb  = @nmnozReOdb * @ntypPoh;
@nmnozVyObj  = @nmnozVyObj * @ntypPoh;
@ncenaCelk   = @ncenaCelk  * @ntypPoh;


if ( @nrecCnt = 1 and (@nmnozPrDod <> 0 or @ncenaCelk <> 0 ) and @nstav_Polo <> 9 ) then

  open curs_cenZboz as select * from cenZboz where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol;

  TRY
    if  fetch curs_cenZboz  then
      @nmnozSZbo = curs_cenZboz.nmnozSZbo + iif( @ntypPVP = 4, 0, @nmnozPrDod);
      @ncenaCZbo = curs_cenZboz.ncenaCZbo + @ncenaCelk;
      @ncenaSZbo = curs_cenZboz.ncenaSZbo;
      @ncenaNZbo = iif( (select [ncenNapDod] from __new) = 0, curs_cenZboz.ncenaNZbo, (select [ncenNapDod] from __new));

      if curs_cenZboz.cpolCen = 'C'  then

        if  ( upper(curs_cenZboz.ctypSklCen) = 'PRU' )  then
          @nmnozSzbo = iif( @nmnozSzbo < 0, 0, @nmnozSzbo);
          @ncenaCZbo = iif( @ncenaCZbo < 0, 0, @ncenaCZbo);
          @ncenaSZbo = iif( @ncenaCZbo <> 0 and @nmnozSZbo <> 0, round(@ncenaCZbo/@nmnozSZbo, 4), curs_cenZboz.ncenaSZbo );
        end;

      else
        @ncenaSZbo =  iif( @ntypPVP = 4, @ncenaNZbo, @ncenaSZbo );
      end;  

      @nmnozRzbo = iif( @nsumREodb IS NULL, 0, @nsumREodb );
      @nmnozDzbo = iif( @nmnozSZbo - @nmnozRzbo > 0, @nmnozSZbo - @nmnozRzbo, 0 );

      update cenZboz set nmnozSZbo = @nmnozSZbo,
                         ncenaCZbo = @ncenaCZbo,
                         ncenaSZbo = @ncenaSZbo,
                         nmnozDZbo = @nmnozDZbo,
                         nmnozRZbo = @nmnozRzbo,
                         ncenaSVZm = @ncenaSZbo,
                         ncenaNZbo = @ncenaNZbo,
                         ddatPzbo  = ( select [ddatPvp] from __new )
                     where [ccisSklad] = @ccisSklad and [csklPol] = @csklPol;

     update pvpItem set nmnozSZbo = @nmnozSZbo,
                        ncenaCZbo = @ncenaCZbo
                    where [sID] = @nsid;

    end;

  FINALLY
    close curs_cenZboz;

  END;

END IF;

END

   NO TRANSACTION
   PRIORITY 2;
