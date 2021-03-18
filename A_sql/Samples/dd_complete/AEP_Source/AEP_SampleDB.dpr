// Copyright (c) 2003 Extended Systems, Inc.  ALL RIGHTS RESERVED.
//
// This source code can be used, modified, or copied by the licensee as long as
// the modifications (or the new binary resulting from a copy or modification of
// this source code) are used with Extended Systems' products.
//
// Extended Systems Inc. does not warrant that the operation of this software
// will meet your requirements or that the operation of the software will be
// uninterrupted, be error free, or that defects in software will be corrected.
// This software is provided "AS IS" without warranty of any kind. The entire
// risk as to the quality and performance of this software is with the purchaser.
// If this software proves defective or inadequate, purchaser assumes the entire
// cost of servicing or repair. No oral or written information or advice given
// by an Extended Systems Inc. representative shall create a warranty or in any
// way increase the scope of this warranty.

library AEP_SampleDB;

{$INCLUDE versions.inc}

{$IFDEF ADSDELPHI7_OR_NEWER}
   {$WARN UNSAFE_TYPE OFF}
   {$WARN UNSAFE_CODE OFF}
   {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
  SysUtils,
  Classes,
  ace,
  adsdata,
  adstable,
  {$IFDEF ADSDELPHI6_OR_NEWER}
  HTTPApp,
  {$ENDIF}
  dm in 'dm.pas' {dm1: TDataModule},
  AdsAEPSessionMgr;

{$E aep}

{$IFDEF LINUX}
{$ENDIF}

var
   SaveExit      : Pointer;
   AEPSessionMgr : TAdsAEPSessionMgr;


{*******************************************************************************
 * This is the AEP startup function.  This is called the first time an Advantage
 * connection calls a procedure in this AEP module. It is called once for each
 * Advantage connection that calls a procedure in this module.
 * Do any per-connection initialization here. Use the ulConnectionID as a
 * unique identifier for each connection.
 ******************************************************************************}
function Startup( ulConnectionID: UNSIGNED32;
                  hConnection: ADSHANDLE
                ): UNSIGNED32;
                {$IFDEF WIN32}stdcall;{$ENDIF}{$IFDEF LINUX}cdecl;{$ENDIF} // Do not change the prototype.
var
   DM1 : TDM1;
begin

   DM1 := nil;
   Result := AE_SUCCESS;

   try
      DM1 := TDM1.Create( nil );

      {* Configure DataConn to use the active handle hConnection. *}
      DM1.DataConn.SetHandle( hConnection );
      {* No need to activate the connection, SetHandle does that automatically. *}

      {* Place tables on the data module, assign DataConn as their Databasname
       * property, and then open them here. *}

      {* Add this data module to the session manager, so we can retrieve it for
       * the user identified by ulConnectionID the next time they need it. *}
      AEPSessionMgr.AddDM( ulConnectionID, DM1 );

   except
      on E : EAdsDatabaseError do
         {* ADS-specific error, use ACE error code *}
         if assigned( DM1 ) then
            DM1.DataConn.Execute( 'INSERT INTO __error VALUES ( ' + IntToStr( E.ACEErrorCode ) + ', ' + QuotedStr( E.Message ) + ' )' )
         else
            Result := E.ACEErrorCode;
      on E : exception do
         {* other error *}
         if assigned( DM1 ) then
            DM1.DataConn.Execute( 'INSERT INTO __error VALUES ( 1, ' + QuotedStr( E.Message ) + ' )' )
         else
            Result := 1;
   end;

end;



{*******************************************************************************
 * This is the AEP shutdown function.  This is called once for each Advantage
 * connection that has called a procedure in this module, and is called when
 * the connection is terminating.
 * The prototype must be exactly as it is in the example.
 * Do your per-connection clean-up here. Use the ulConnectionID as a
 * unique identifier for each connection.
 ******************************************************************************}
function Shutdown( ulConnectionID: UNSIGNED32;
                   hConnection: ADSHANDLE
                 ): UNSIGNED32;
                 {$IFDEF WIN32}stdcall;{$ENDIF}{$IFDEF LINUX}cdecl;{$ENDIF} // Do not change the prototype.
begin

   try
      Result := AE_SUCCESS;

      if assigned( AEPSessionMgr ) then
         AEPSessionMgr.FreeDM( ulConnectionID );

   except
      on E : EAdsDatabaseError do
         Result := E.ACEErrorCode;
      on E : exception do
         result := 1;
   end;

end;



{* Sample exported Advantage Extended Procedure. This procedure will get the
 * next invoice number and verify the customer id and employee id *}
function CreateInvoice( ulConnectionID: UNSIGNED32;
                        hConnection: ADSHANDLE;
                        pulNumRowsAffected: PUNSIGNED32 ): UNSIGNED32;
                        {$IFDEF WIN32}stdcall;{$ENDIF}{$IFDEF LINUX}cdecl;{$ENDIF} // Do not change prototype
var
   DM1        : TDM1;
   tblSearch  : TAdsTable;
   strCust    : String;
   strEmp     : String;
   strInvoice : String;
   iCust      : Integer;
   iEmp       : Integer;
   iInvNum    : Integer;
begin

   Result := AE_SUCCESS;

   {* Get this connection's data module from the session manager. *}
   DM1 := TDM1( AEPSessionMgr.GetDM( ulConnectionID ) );

   try
      with DM1 do
      begin

         {* Read the input values *}
          tblInput.open;
          iCust := tblInput.FieldByName( 'CustID' ).Value;
          iEmp  := tblInput.FieldByName( 'EmpID' ).Value;
          tblInput.close;

         {* Calculate the Invoice Number based on the date *}
          ShortDateFormat := 'YYYYMMDD';
          strInvoice := DateToStr( Date()) + '-';

          tblSearch := TAdsTable.Create(nil);
          tblSearch.DatabaseName := DataConn.Name;
          tblSearch.TableName := 'invoice';
          tblSearch.Open;
          tblSearch.IndexName := 'invoice no';

          iInvNum := 1;

          while tblSearch.FindKey( [strInvoice + IntToStr(iInvNum)] ) do
          begin
            iInvNum := iInvNum + 1
          end;

          strInvoice := strInvoice + IntToStr(iInvNum);

          {* Verify the customer number and get the company name *}
          tblSearch.Close;
          tblSearch.TableName := 'customer';
          tblSearch.IndexName := 'customer id';
          tblSearch.Open;


          if tblSearch.FindKey( [iCust] ) then
          begin
            strCust := tblSearch.FieldByName('Last Name').Value  + ', ' +
                       tblSearch.FieldByName('First Name').Value
          end
          else
          begin
            DM1.DataConn.Execute( 'INSERT INTO __error VALUES ( 101, ''Customer not found'' )' );
            exit;
          end;

          {* Verify the employee number and get the employee name *}
          tblSearch.Close;
          tblSearch.TableName := 'employee';
          tblSearch.IndexName := 'employee number';
          tblSearch.Open;

          if tblSearch.FindKey( [iEmp] ) then
            strEmp := tblSearch.FieldByName('Last Name').Value  + ', ' +
                      tblSearch.FieldByName('First Name').Value
          else
          begin
            DM1.DataConn.Execute( 'INSERT INTO __error VALUES ( 102, ''Employee not found'' )' );
            exit;
          end;

         {* Finally return the output parameters. *}
          tblOutput.open;
          tblOutput.append;
          tblOutput.FieldByName( 'InvoiceNo' ).Value := strInvoice;
          tblOutput.FieldByName( 'Customer' ).Value := strCust;
          tblOutput.FieldByName( 'Employee' ).Value := strEmp;
          tblOutput.FieldByName( 'InvoiceDate' ).Value := Date();
          tblOutput.post;
          tblOutput.close;

      end;   {* with DM1 *}

   except
      on E : EADSDatabaseError do
         {* ADS-specific error, use ACE error code *}
         DM1.DataConn.Execute( 'INSERT INTO __error VALUES ( ' + IntToStr( E.ACEErrorCode ) + ', ' + QuotedStr( E.Message ) + ' )' );
      on E : Exception do
         {* other error *}
         DM1.DataConn.Execute( 'INSERT INTO __error VALUES ( 1, ' + QuotedStr( E.Message ) + ' )' );
   end;

end;


{* Do not modify this function, it is used internally by the Advantage server. *}
function GetInterfaceVersion : UNSIGNED32;
{$IFDEF WIN32}stdcall;{$ENDIF}{$IFDEF LINUX}cdecl;{$ENDIF} // Do not change the prototype.
begin
   Result := 2;
end;


{* Put any global clean-up code here. *}
procedure LibExit;
begin
   AEPSessionMgr.Free;
   ExitProc := SaveExit;
end;

exports
   GetInterfaceVersion,
   CreateInvoice,
   Startup,
   Shutdown;


{* Put any global initialization code here. *}
begin
   {* Let the VCL memory manager know we will be used by a multi-threaded exe. *}
   IsMultiThread := TRUE;

   {* Initialize the session manager for this dll here, where it's thread-safe, as
    * opposed to inside of the Startup function, which can be called by multiple
    * Advantage threads at the same time. *}
   AEPSessionMgr := TAdsAEPSessionMgr.Create( nil );

   {* Save the current ExitProc pointer, and assign our own cleanup procedure. *}
   SaveExit := ExitProc;
   ExitProc := @LibExit;
end.
