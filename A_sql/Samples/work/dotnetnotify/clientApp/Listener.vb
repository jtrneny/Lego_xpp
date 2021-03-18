Imports System.Threading
Imports System.Net
Imports System.Net.Sockets
Imports System.IO
Imports System.Text
Imports Microsoft.VisualBasic
Imports System

'*********************************************************************
'  Module: Listener
'  Input:  stateInfo As Object
'  Output:  Event is raised and sends message from server
'  Description: This class runs in a separate thread from the main
'               application and listens for a message from the 
'               server.  When a message is received, it raises an
'               event (ReceivedMessage) and passes the message with
'               the event.
'**********************************************************************}

Public Class Listener
    Public Event ReceivedMessage(ByVal sMessage As String)


    Public Sub main(ByVal stateInfo As Object)

        ' Must listen on correct port- must be same as port client wants to connect on.
        Const PORTNUMBER As Integer = 8000

        Dim done As Boolean = False
        Dim endPoint As New IPEndPoint(IPAddress.Any, PORTNUMBER)
        Dim s As New Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp)

        s.Bind(endPoint)

        While Not done
            Try
                Dim lingerOption As New LingerOption(True, 10)
                Dim bytesReceived(255) As [Byte]
                Dim bytes(255) As Byte
                Dim clientData As [String]
                Dim ascii As Encoding = Encoding.ASCII
                s.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.Broadcast, 1)

                s.Receive(bytes, 0, 255, SocketFlags.None)
                clientData = Encoding.UTF8.GetString(bytes)   'Accept the pending client connection and return 

                RaiseEvent ReceivedMessage(clientData)

            Catch ex As Exception
                RaiseEvent ReceivedMessage(ex.ToString)
            End Try

        End While

    End Sub


End Class
