Imports System.Threading
Imports System.Net
Imports System.Net.Sockets
Imports Microsoft.VisualBasic
Imports Advantage.Data.Provider

Public Class Form1
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend Shared WithEvents ListBox1 As System.Windows.Forms.ListBox
    Friend Shared WithEvents lbStatus As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label

    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ListBox1 = New System.Windows.Forms.ListBox
        Me.lbStatus = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'lbListBox
        '
        Me.ListBox1.ItemHeight = 18
        Me.ListBox1.Location = New System.Drawing.Point(16, 16)
        Me.ListBox1.Name = "lbListBox"
        Me.ListBox1.Size = New System.Drawing.Size(416, 220)
        Me.ListBox1.TabIndex = 0
        '
        'lbStatus
        '
        Me.lbStatus.Font = New System.Drawing.Font("Verdana", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lbStatus.ForeColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(0, Byte), CType(192, Byte))
        Me.lbStatus.Location = New System.Drawing.Point(112, 256)
        Me.lbStatus.Name = "lbStatus"
        Me.lbStatus.Size = New System.Drawing.Size(320, 40)
        Me.lbStatus.TabIndex = 1
        Me.lbStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Verdana", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(16, 256)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(80, 40)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Status:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(9, 20)
        Me.ClientSize = New System.Drawing.Size(480, 317)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.lbStatus)
        Me.Controls.Add(Me.ListBox1)
        Me.Font = New System.Drawing.Font("Verdana", 12.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "Form1"
        Me.Text = "Server Notification"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Shared WithEvents listen As New Listener

    Private Shared Sub listen_ReceivedMessage(ByVal sMessage As String) Handles listen.ReceivedMessage
        getData()
        lbStatus.Text = sMessage
    End Sub
    '*********************************************************************
    '  Module: getData
    '  Input:  
    '  Output:  
    '  Description: This module clears the listbox and fills it with
    '               data.
    '**********************************************************************}
    Private Shared Sub getData()
        Dim rdr As AdsDataReader

        ListBox1.Items.Clear()

        Try
            rdr = AdsHelper.ExecuteReader("data source = E:\training\trigger\data\customers.add; user id = adssys" _
                                            , CommandType.Text, "SELECT * FROM customers")
        Catch ex As Exception
            MsgBox(ex.ToString)
        End Try

        While rdr.Read
            If Not rdr.IsDBNull(2) Then
                ListBox1.Items.Add(rdr.GetString(1))
            End If
        End While

        rdr.Close()
    End Sub

    Private Sub Form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'On load, full the listbox with data.
        getData()

        'Run the listener class in a separate thread.
        ThreadPool.QueueUserWorkItem(New WaitCallback(AddressOf listen.main))
    End Sub
End Class
