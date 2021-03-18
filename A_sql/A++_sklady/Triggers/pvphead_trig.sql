ALTER TRIGGER pvpHead_after_insert
   ON PVPHEAD
   AFTER 
   INSERT 
BEGIN 
// pvpHead
declare @ndoklad    Double;
declare @nrange_beg Double, @nrange_end Double;
declare @nsid       Integer;

declare @nrecCnt   Integer;
declare @ndoklad_n Double;

@ndoklad     = ( select [ndoklad]    from __new );
@nrange_beg  = ( select [nrange_beg] from __new );
@nrange_end  = ( select [nrange_end] from __new );
@nsid        = ( select [sID]        from __new );

@nrecCnt     = ( select count(*)     from pvpHead where [ndoklad]  = @ndoklad );
@ndoklad_n   = ( select max(ndoklad) from pvpHead where [ndoklad] >= @nrange_beg and [ndoklad] <= @nrange_end );


if ( @ndoklad = 0 or @nrecCnt > 1 ) then
  
  TRY
    // vyèerpal øadu ?
    if @ndoklad_n = @nrange_end then
      @ndoklad_n  = ( select max(ndoklad) from pvpHead );
    endif; 

    update pvpHead set ndoklad   = @ndoklad_n +1 , 
                       ncisloPvp = @ndoklad_n +1
                   where [sID] = @nsid; 
  FINALLY
  END;

endif;


END;