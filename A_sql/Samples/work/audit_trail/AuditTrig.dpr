
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

library AuditTrig;

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
  adscnnct,
  adsset,
  adsdata,
  adstable,
  dialogs;

// Utility Function Prototype
procedure SetError ( conn : TAdsConnection; code : UNSIGNED32; err  : string ); forward;


{**********************************************************
*  Module:  AuditTrail
*  Input:   Standard trigger inputs (see ADS documentation).
*  Output:  Standard trigger outputs (see ADS documentation).
*  Description: This trigger compares the old and new values
*        from update changes.  It logs
*        these changes into an audit table. Note: this demo
*        logs updates only.  Additional logic is needed to
*        handle inserts and deletes.
**********************************************************}
function AuditTrail
(
  ulConnectionID : UNSIGNED32; // (I) Unique ID identifying the user causing this trig
  hConnection    : ADSHANDLE;  // (I) Active ACE connection handle user can perform
                               //     operations on
  pcTriggerName  : PChar;      // (I) Name of the trigger object in the dictionary
  pcTableName    : PChar;      // (I) Name of the base table that caused the trigger
  ulEventType    : UNSIGNED32; // (I) Flag with event type (insert, update, etc.)
  ulTriggerType  : UNSIGNED32; // (I) Flag with trigger type (before, after, etc.)
  ulRecNo        : UNSIGNED32  // (I) Record number of the record being modified
) : UNSIGNED32;
{$IFDEF WIN32}stdcall;{$ENDIF}{$IFDEF LINUX}cdecl;{$ENDIF} // Do not change the prototype.
var
  oNew : TAdsQuery;
  oOld : TAdsQuery;
  oTable : TAdsTable;
  oConn  : TAdsConnection;
  slChanges : TStringList;
  iField : Integer;

begin
  // Result is currently reserved and not used. Always return zero.
  Result := 0;

  oNew := nil;
  oOld := nil;
  oTable := nil;
  oConn  := nil;
  slChanges := nil;

  // Allocate a connection object using an active connection, no need to open it after this.
  oConn := TAdsConnection.CreateWithHandle( nil, hConnection );

  try
    try
      oConn.Name := 'conn';

      slChanges := TStringList.Create;
      oNew := TAdsQuery.Create( nil );
      oOld := TAdsQuery.Create( nil );
      oTable := TAdsTable.Create( nil );

      oNew.DatabaseName := 'conn';
      oOld.DatabaseName := 'conn';
      oTable.DatabaseName := 'conn';


      // open the __new and __old tables
      oNew.SQL.Text := 'SELECT * FROM __new';
      oNew.Open;
      oOld.SQL.Text := 'SELECT * FROM __old';
      oOld.Open;

      try
        // check for changed fields
        for iField := 0 to (oNew.FieldCount -1) do
        begin
          if CompareStr( oOld.Fields[iField].AsString, oNew.Fields[iField].AsString ) <> 0 then
          begin
            slChanges.Add( 'Field: ' + oNew.Fields[iField].FieldName );
            slChanges.Add( 'Original Value: ' + oOld.Fields[iField].AsString );
            slChanges.Add( 'New Value: ' + oNew.Fields[iField].AsString );
            slChanges.Add( ' ' );
          end; // if
        end; // for
      finally
        oNew.Close;
        oOld.Close;
      end; // try

      // insert a record of changes into the audit table
      oTable.TableName := 'Audit';
      oTable.Open;

      try
        oTable.Insert;
        oTable.Fields[0].Value := StrPas( pcTableName );
        oTable.Fields[1].Value := 'Updated';
        oTable.Fields[2].Value := Now;
        oTable.Fields[3].Value := oConn.Username;
        oTable.Fields[4].Value := slChanges.Text;
        oTable.Post;
      finally
        oTable.Close;
      end; // try

    except
      on E : EADSDatabaseError do
        SetError( oConn, E.ACEErrorCode, E.message );
      on E : Exception do
        SetError( oConn, 0, E.message );
    end;
  finally

    if ( Assigned( oOld ) ) then
      FreeAndNil( oOld );
    if ( Assigned( oNew ) ) then
      FreeAndNil( oNew );
    if ( Assigned( oTable ) ) then
      FreeAndNil( oTable );
    if ( Assigned( slChanges ) ) then
      FreeAndNil( slChanges );
    if ( Assigned( oConn ) ) then
      FreeAndNil( oConn );

  end;

end;


// Utility function to return an error from a trigger.
procedure SetError
(
  conn : TAdsConnection;
  code : UNSIGNED32;
  err  : string
);
begin
  // Errors can be returned by placing a row into the __error table.
  conn.Execute( 'INSERT INTO __error VALUES( ' + IntToStr( code ) +
                ', ' + QuotedStr( err ) + ' )' );
end;


exports
  AuditTrail;

begin
  // Because this dll is used by a multi-threaded application (the Advantage
  // server), we must set the Delphi IsMultiThread global variable to TRUE.
  IsMultiThread := TRUE;
end.



