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

library BackupTrig;

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
  adstable;

// Utility Function Prototype
procedure SetError ( conn : TAdsConnection; code : UNSIGNED32; err  : string ); forward;

{********************************************************************
*  Module:  Backup
*  Input:   Standard trigger inputs (see ADS documentation).
*  Output:  Standard trigger outputs (see ADS documentation).
*  Description:  This is a sample function for executing
*      inserts, updates and deletes to another server.  Note
*      that this type of trigger could have significant
*      performance implications -- especially for batch jobs.
*      For example purposes, this function assumes that
*      primary keys exist in the first field.  It also
*      has a hard-coded connect path to the backup server.
*      This information could be read from an ADT table.
*
**********************************************************************}
function Backup
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
  oConn        : TAdsConnection;
  oConnBackup  : TAdsConnection;  //connection to backup server
  oNew         : TAdsQuery;
  oOld         : TAdsQuery;
  oBackup      : TAdsQuery;
  iField       : Integer;

begin
  // Result is currently reserved and not used. Always return zero.
  Result := 0;
  oNew := Nil;
  oOld := Nil;
  oConnBackup := Nil;

   // Allocate a connection object using an active connection, no need to open it after this.
  oConn := TAdsConnection.CreateWithHandle( nil, hConnection );
  oConnBackup := TAdsConnection.Create( nil );

  try
    try
      oConn.Name := 'conn';
      oConnBackup.Name := 'connBackup';

      oConnBackup.AdsServerTypes := [stADS_REMOTE];
      oConnBackup.ConnectPath := '\\server\c$\data';
      oConnBackup.LoginPrompt := FALSE;
      oConnBackup.IsConnected := TRUE;


      oOld := TAdsQuery.Create( nil );
      oOld.DatabaseName := 'conn';
      oOld.SQL.Text := 'SELECT * FROM __old';

      oNew := TAdsQuery.Create( nil );
      oNew.DatabaseName := 'conn';
      oNew.SQL.Text := 'SELECT * FROM __new';

      oBackup := TAdsQuery.Create( nil );
      oBackup.RequestLive := TRUE;
      oBackup.DatabaseName := 'connBackup';

      try
        case ulEventType of
          ADS_TRIGEVENT_INSERT:
            begin
              oNew.Open;

              oBackup.SQL.Text := 'SELECT * FROM ' + pcTableName + '';
              oBackup.Open;
              oBackup.append;
              for iField := 0 to (oNew.FieldCount -1) do
                oBackup.Fields[iField] := oNew.Fields[iField];
              oBackup.Post;
            end;
          ADS_TRIGEVENT_UPDATE:
            begin
              oNew.Open;
              oOld.Open;

              oBackup.SQL.Text := 'SELECT * FROM ' + pcTableName +
                           ' WHERE CUST_NUM = '+ oOld.Fields[0].asstring + '';
              oBackup.Open;
              oBackup.Edit;
              for iField := 0 to (oNew.FieldCount -1) do
                oBackup.Fields[iField] := oNew.Fields[iField];
              oBackup.Post;
            end;
          ADS_TRIGEVENT_DELETE:
            begin
              oOld.Open;
              oBackup.SQL.Text := 'SELECT * FROM ' + pcTableName +
                           ' WHERE CUST_NUM = '+ oOld.Fields[0].asstring + '';
              oBackup.Open;
              oBackup.Delete;
            end;
        end;  //end case
      finally
        oOld.Close;
        oNew.Close;
      end; // try

    except
      on E : EADSDatabaseError do
        SetError( oConn, E.ACEErrorCode, E.message );
      on E : Exception do
        SetError( oConn, 0, E.message );
    end;

  finally

    if ( Assigned( oNew ) ) then
      FreeAndNil( oNew );
    if ( Assigned( oOld ) ) then
      FreeAndNil( oOld );
    if ( Assigned( oConn ) ) then
      FreeAndNil( oConn );
    if ( Assigned( oConnBackup ) ) then
      FreeAndNil( oConnBackup );
    if ( Assigned( oBackup ) ) then
      FreeAndNil( oBackup );
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
  Backup;

begin
  // Because this dll is used by a multi-threaded application (the Advantage
  // server), we must set the Delphi IsMultiThread global variable to TRUE.
  IsMultiThread := TRUE;
end.
