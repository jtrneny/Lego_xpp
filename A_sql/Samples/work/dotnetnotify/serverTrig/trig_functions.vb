' Copyright (c) 2003 Extended Systems, Inc.  ALL RIGHTS RESERVED.
'
' This source code can be used, modified, or copied by the licensee as long as
' the modifications (or the new binary resulting from a copy or modification of
' this source code) are used with Extended Systems' products.
'
' Extended Systems Inc. does not warrant that the operation of this software
' will meet your requirements or that the operation of the software will be
' uninterrupted, be error free, or that defects in software will be corrected.
' This software is provided "AS IS" without warranty of any kind. The entire
' risk as to the quality and performance of this software is with the purchaser.
' If this software proves defective or inadequate, purchaser assumes the entire
' cost of servicing or repair. No oral or written information or advice given
' by an Extended Systems Inc. representative shall create a warranty or in any
' way increase the scope of this warranty.

Imports Advantage.Data.Provider
Imports System.Threading
Imports System.Net
Imports System.Net.Sockets
Imports System.Text

<ComClass(trig_functions.ClassId, trig_functions.InterfaceId, trig_functions.EventsId)> _
Public Class trig_functions

#Region "COM GUIDs"
    ' These  GUIDs provide the COM identity for this class
    ' and its COM interfaces. If you change them, existing
    ' clients will no longer be able to access the class.
    Public Const ClassId As String = "BCE2B3D4-0357-4E09-BF1F-D1C5A3E2E330"
    Public Const InterfaceId As String = "DD6EEBC6-6429-4509-9CFF-8F10708C3CC4"
    Public Const EventsId As String = "1C0732A7-510C-4F0C-B512-4C92A8AE70C9"
#End Region

    ' A creatable COM class must have a Public Sub New()
    ' with no parameters, otherwise, the class will not be
    ' registered in the COM registry and cannot be created
    ' via CreateObject.
    Public Sub New()
        MyBase.New()
    End Sub
    '*********************************************************************
    '  Function:  SendNotification
    '  Input:   
    '  Output:
    '  Description: This Advantage Trigger sends a TCP packet to the
    '               specified IP address and port.  This implements
    '               a server-side notification that data has been 
    '               updated.
    '**********************************************************************}

    Public Function SendNotification(ByVal ulConnectionID As Int32, _
                               ByVal hConnection As Int32, _
                               ByVal strTriggerName As String, _
                               ByVal strTableName As String, _
                               ByVal ulEventType As Int32, _
                               ByVal ulTriggerType As Int32, _
                               ByVal ulRecNo As Int32) As Int32  ' Do not change prototype

        Const ADS_TRIGEVENT_INSERT = 1
        Const ADS_TRIGEVENT_UPDATE = 2
        Const ADS_TRIGEVENT_DELETE = 3
        ' Must listen on correct port- must be same as port client wants to connect on.
        Const PORTNUMBER As Integer = 8000

        Dim oConn As AdsConnection
        Dim oCommand As IDbCommand
        Dim sMessage As String

        Dim groupEP As New IPEndPoint(IPAddress.Parse("255.255.255.255"), PORTNUMBER)

        Try
            oConn = New AdsConnection("ConnectionHandle=" & hConnection)
            oConn.Open()

            ' Setup a command object to use
            oCommand = oConn.CreateCommand

            ' Get the current user
            oCommand.CommandText = "SELECT user FROM system.iota"
            sMessage = oCommand.ExecuteScalar

            ' Add the trigger type to the send message (sMessage)
            Select Case ulEventType
                Case ADS_TRIGEVENT_UPDATE : sMessage = sMessage + " Updated Record #" + ulRecNo.ToString
                Case ADS_TRIGEVENT_INSERT : sMessage = sMessage + " Inserted Record #" + ulRecNo.ToString
                Case ADS_TRIGEVENT_DELETE : sMessage = sMessage + " Deleted Record #" + ulRecNo.ToString
            End Select

            'Create a udpClient 
            Dim UdpClient As New System.Net.Sockets.UdpClient

            ' Do a write.
            Dim sendBytes As [Byte]() = Encoding.ASCII.GetBytes(sMessage)
            UdpClient.Send(sendBytes, sendBytes.Length, groupEP)

        Catch Ex As Exception
            Dim oErrCommand As IDbCommand

            ' Handle any exceptions here. Errors can be returned by placing a
            ' row into the __error table. Use a new command, in case currently
            ' using a reader on the other command.
            oErrCommand = oConn.CreateCommand
            oErrCommand.CommandText = "INSERT INTO __error VALUES( 0, '" & Ex.Message & "' )"
            oErrCommand.ExecuteNonQuery()
        Finally
            ' Result is currently reserved and not used. Always return zero.
            SendNotification = 0

        End Try

    End Function

    Protected Overrides Sub Finalize()
        MyBase.Finalize()
    End Sub
End Class


