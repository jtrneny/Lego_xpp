

' ADSHelper.vb
'
' This file contains the implementations of the AdsHelper and AdsHelperParameterCache
' classes.

' ==============================================================================
' Portions of the Software may contain material from Microsoft Corporation, Inc.
' or its subsidiaries. Copyright (C) 2000-2001 Microsoft Corporation. All rights
' reserved.
'
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
' OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
' LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR
' FITNESS FOR A PARTICULAR PURPOSE.
' ==============================================================================
'
' Copyright (c) 2004 Extended Systems, Inc.  ALL RIGHTS RESERVED.
'
' Extended Systems Inc. does not warrant that the operation of this
' software will meet your requirements or that the operation of the software
' will be uninterrupted, be error free, or that defects in software will be
' corrected.  This software is provided "AS IS" without warranty of any
' kind, either expressed or implied, including but not limited to the
' implied warranties of merchantability and/or fitness for a particular
' purpose.  The entire risk as to the quality and performance of this
' software is with the purchaser.  If this software proves defective or
' inadequate, purchaser assumes the entire cost of servicing or repair.  No
' oral or written information or advice given by an Extended Systems Inc.
' representative shall create a warranty or in any way increase the scope of
' this warranty.
'
' ==============================================================================


Imports Advantage.Data.Provider
Public NotInheritable Class AdsHelper

#Region "private utility methods & constructors"

    ' Since this class provides only static methods, make the default constructor private to prevent
    ' instances from being created with "new AdsHelper()".
    Private Sub New()
    End Sub ' New

    ' This method is used to attach array of AdsParameters to a AdsCommand.
    ' This method will assign a value of DbNull to any parameter with a direction of
    ' InputOutput and a value of null.
    ' This behavior will prevent default values from being used, but
    ' this will be the less common case than an intended pure output parameter (derived as InputOutput)
    ' where the user provided no input value.
    ' Parameters:
    ' -command - The command to which the parameters will be added
    ' -commandParameters - an array of AdsParameters to be added to command
    Private Shared Sub AttachParameters(ByVal command As AdsCommand, ByVal commandParameters() As AdsParameter)
        If (command Is Nothing) Then Throw New ArgumentNullException("command")
        If (Not commandParameters Is Nothing) Then
            Dim p As AdsParameter
            For Each p In commandParameters
                If (Not p Is Nothing) Then
                    ' Check for derived output value with no value assigned
                    If (p.Direction = ParameterDirection.InputOutput OrElse p.Direction = ParameterDirection.Input) AndAlso p.Value Is Nothing Then
                        p.Value = DBNull.Value
                    End If
                    command.Parameters.Add(p)
                End If
            Next p
        End If
    End Sub ' AttachParameters

    ' This method assigns dataRow column values to an array of AdsParameters.
    ' Parameters:
    ' -commandParameters: Array of AdsParameters to be assigned values
    ' -dataRow: the dataRow used to hold the stored procedure' s parameter values
    Private Overloads Shared Sub AssignParameterValues(ByVal commandParameters() As AdsParameter, ByVal dataRow As DataRow)

        If commandParameters Is Nothing OrElse dataRow Is Nothing Then
            ' Do nothing if we get no data
            Exit Sub
        End If

        ' Set the parameters values
        Dim commandParameter As AdsParameter
        Dim i As Integer
        For Each commandParameter In commandParameters
            ' Check the parameter name
            If (commandParameter.ParameterName Is Nothing OrElse commandParameter.ParameterName.Length <= 1) Then
                Throw New Exception(String.Format("Please provide a valid parameter name on the parameter #{0}, the ParameterName property has the following value: ' {1}' .", i, commandParameter.ParameterName))
            End If
            If dataRow.Table.Columns.IndexOf(commandParameter.ParameterName) <> -1 Then
                commandParameter.Value = dataRow(commandParameter.ParameterName)
            End If
            i = i + 1
        Next
    End Sub

    ' This method assigns an array of values to an array of AdsParameters.
    ' Parameters:
    ' -commandParameters - array of AdsParameters to be assigned values
    ' -array of objects holding the values to be assigned
    Private Overloads Shared Sub AssignParameterValues(ByVal commandParameters() As AdsParameter, ByVal parameterValues() As Object)

        Dim i As Integer
        Dim j As Integer

        If (commandParameters Is Nothing) AndAlso (parameterValues Is Nothing) Then
            ' Do nothing if we get no data
            Return
        End If

        ' We must have the same number of values as we pave parameters to put them in
        If commandParameters.Length <> parameterValues.Length Then
            Throw New ArgumentException("Parameter count does not match Parameter Value count.")
        End If

        ' Value array
        j = commandParameters.Length - 1
        For i = 0 To j
            ' If the current array value derives from IDbDataParameter, then assign its Value property
            If TypeOf parameterValues(i) Is IDbDataParameter Then
                Dim paramInstance As IDbDataParameter = CType(parameterValues(i), IDbDataParameter)
                If (paramInstance.Value Is Nothing) Then
                    commandParameters(i).Value = DBNull.Value
                Else
                    commandParameters(i).Value = paramInstance.Value
                End If
            ElseIf (parameterValues(i) Is Nothing) Then
                commandParameters(i).Value = DBNull.Value
            Else
                commandParameters(i).Value = parameterValues(i)
            End If
        Next
    End Sub ' AssignParameterValues

    ' This method opens (if necessary) and assigns a connection, transaction, command type and parameters
    ' to the provided command.
    ' Parameters:
    ' -command - the AdsCommand to be prepared
    ' -connection - a valid AdsConnection, on which to execute this command
    ' -transaction - a valid AdsTransaction, or ' null'
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParameters to be associated with the command or ' null' if no parameters are required
    Private Shared Sub PrepareCommand(ByVal command As AdsCommand, _
                                      ByVal connection As AdsConnection, _
                                      ByVal transaction As AdsTransaction, _
                                      ByVal commandType As CommandType, _
                                      ByVal commandText As String, _
                                      ByVal commandParameters() As AdsParameter, ByRef mustCloseConnection As Boolean)

        If (command Is Nothing) Then Throw New ArgumentNullException("command")
        If (commandText Is Nothing OrElse commandText.Length = 0) Then Throw New ArgumentNullException("commandText")

        ' If the provided connection is not open, we will open it
        If connection.State <> ConnectionState.Open Then
            connection.Open()
            mustCloseConnection = True
        Else
            mustCloseConnection = False
        End If

        ' Associate the connection with the command
        command.Connection = connection

        ' Set the command text (stored procedure name or SQL statement)
        command.CommandText = commandText

        ' If we were provided a transaction, assign it.
        If Not (transaction Is Nothing) Then
            If transaction.Connection Is Nothing Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
            command.Transaction = transaction
        End If

        ' Set the command type
        command.CommandType = commandType

        ' Attach the command parameters if they are provided
        If Not (commandParameters Is Nothing) Then
            AttachParameters(command, commandParameters)
        End If
        Return
    End Sub ' PrepareCommand

#End Region

#Region "ExecuteNonQuery"

    ' Execute a AdsCommand (that returns no resultset and takes no parameters) against the database specified in
    ' the connection string.
    ' e.g.:
    '  Dim result As Integer =  ExecuteNonQuery(connString, CommandType.StoredProcedure, "PublishOrders")
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal connectionString As String, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As Integer
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteNonQuery(connectionString, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteNonQuery

    ' Execute a AdsCommand (that returns no resultset) against the database specified in the connection string
    ' using the provided parameters.
    ' e.g.:
    ' Dim result As Integer = ExecuteNonQuery(connString, CommandType.StoredProcedure, "PublishOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal connectionString As String, _
                                                     ByVal commandType As CommandType, _
                                                     ByVal commandText As String, _
                                                     ByVal ParamArray commandParameters() As AdsParameter) As Integer
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        ' Create & open a AdsConnection, and dispose of it after we are done
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)
            connection.Open()

            ' Call the overload that takes a connection in place of the connection string
            Return ExecuteNonQuery(connection, commandType, commandText, commandParameters)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Function ' ExecuteNonQuery

    ' Execute a stored procedure via a AdsCommand (that returns no resultset) against the database specified in
    ' the connection string using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    '  Dim result As Integer = ExecuteNonQuery(connString, "PublishOrders", 24, 36)
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal connectionString As String, _
                                                     ByVal spName As String, _
                                                     ByVal ParamArray parameterValues() As Object) As Integer

        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)

            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, commandParameters)
            ' Otherwise we can just call the SP without params
        Else
            Return ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteNonQuery

    ' Execute a AdsCommand (that returns no resultset and takes no parameters) against the provided AdsConnection.
    ' e.g.:
    ' Dim result As Integer = ExecuteNonQuery(conn, CommandType.StoredProcedure, "PublishOrders")
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal connection As AdsConnection, _
                                                     ByVal commandType As CommandType, _
                                                     ByVal commandText As String) As Integer
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteNonQuery(connection, commandType, commandText, CType(Nothing, AdsParameter()))

    End Function ' ExecuteNonQuery

    ' Execute a AdsCommand (that returns no resultset) against the specified AdsConnection
    ' using the provided parameters.
    ' e.g.:
    '  Dim result As Integer = ExecuteNonQuery(conn, CommandType.StoredProcedure, "PublishOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal connection As AdsConnection, _
                                                     ByVal commandType As CommandType, _
                                                     ByVal commandText As String, _
                                                     ByVal ParamArray commandParameters() As AdsParameter) As Integer

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")

        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Dim retval As Integer
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, connection, CType(Nothing, AdsTransaction), commandType, commandText, commandParameters, mustCloseConnection)

        ' Finally, execute the command
        retval = cmd.ExecuteNonQuery()

        ' Detach the AdsParameters from the command object, so they can be used again
        cmd.Parameters.Clear()

        If (mustCloseConnection) Then connection.Close()

        Return retval
    End Function ' ExecuteNonQuery

    ' Execute a stored procedure via a AdsCommand (that returns no resultset) against the specified AdsConnection
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    '  Dim result As integer = ExecuteNonQuery(conn, "PublishOrders", 24, 36)
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal connection As AdsConnection, _
                                                     ByVal spName As String, _
                                                     ByVal ParamArray parameterValues() As Object) As Integer
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")
        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteNonQuery(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteNonQuery(connection, CommandType.StoredProcedure, spName)
        End If

    End Function ' ExecuteNonQuery

    ' Execute a AdsCommand (that returns no resultset and takes no parameters) against the provided AdsTransaction.
    ' e.g.:
    '  Dim result As Integer = ExecuteNonQuery(trans, CommandType.StoredProcedure, "PublishOrders")
    ' Parameters:
    ' -transaction - a valid AdsTransaction associated with the connection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal transaction As AdsTransaction, _
                                                     ByVal commandType As CommandType, _
                                                     ByVal commandText As String) As Integer
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteNonQuery(transaction, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteNonQuery

    ' Execute a AdsCommand (that returns no resultset) against the specified AdsTransaction
    ' using the provided parameters.
    ' e.g.:
    ' Dim result As Integer = ExecuteNonQuery(trans, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal transaction As AdsTransaction, _
                                                     ByVal commandType As CommandType, _
                                                     ByVal commandText As String, _
                                                     ByVal ParamArray commandParameters() As AdsParameter) As Integer

        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")

        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Dim retval As Integer
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, transaction.Connection, transaction, commandType, commandText, commandParameters, mustCloseConnection)

        ' Finally, execute the command
        retval = cmd.ExecuteNonQuery()

        ' Detach the AdsParameters from the command object, so they can be used again
        cmd.Parameters.Clear()

        Return retval
    End Function ' ExecuteNonQuery

    ' Execute a stored procedure via a AdsCommand (that returns no resultset) against the specified AdsTransaction
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim result As Integer = AdsHelper.ExecuteNonQuery(trans, "PublishOrders", 24, 36)
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: An int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQuery(ByVal transaction As AdsTransaction, _
                                                     ByVal spName As String, _
                                                     ByVal ParamArray parameterValues() As Object) As Integer
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteNonQuery

#End Region

#Region "ExecuteDataset"

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the database specified in
    ' the connection string.
    ' e.g.:
    ' Dim ds As DataSet = AdsHelper.ExecuteDataset("", commandType.StoredProcedure, "GetOrders")
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal connectionString As String, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String) As DataSet
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteDataset(connectionString, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteDataset

    ' Execute a AdsCommand (that returns a resultset) against the database specified in the connection string
    ' using the provided parameters.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(connString, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal connectionString As String, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String, _
                                                    ByVal ParamArray commandParameters() As AdsParameter) As DataSet

        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")

        ' Create & open a AdsConnection, and dispose of it after we are done
        Dim connection As AdsConnection
        Try
            connection =  New AdsConnection(connectionString)
            connection.Open()

            ' Call the overload that takes a connection in place of the connection string
            Return ExecuteDataset(connection, commandType, commandText, commandParameters)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Function ' ExecuteDataset

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the database specified in
    ' the connection string using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim ds As Dataset= ExecuteDataset(connString, "GetOrders", 24, 36)
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal connectionString As String, _
                                                    ByVal spName As String, _
                                                    ByVal ParamArray parameterValues() As Object) As DataSet

        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")
        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteDataset(connectionString, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteDataset(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteDataset

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the provided AdsConnection.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(conn, CommandType.StoredProcedure, "GetOrders")
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal connection As AdsConnection, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String) As DataSet

        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteDataset(connection, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteDataset

    ' Execute a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the provided parameters.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(conn, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal connection As AdsConnection, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String, _
                                                    ByVal ParamArray commandParameters() As AdsParameter) As DataSet
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Dim ds As New DataSet
        Dim dataAdapter As AdsDataAdapter
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, connection, CType(Nothing, AdsTransaction), commandType, commandText, commandParameters, mustCloseConnection)

        Try
            ' Create the DataAdapter & DataSet
            dataAdapter = New AdsDataAdapter(cmd)

            ' Fill the DataSet using default values for DataTable names, etc
            dataAdapter.Fill(ds)

            ' Detach the AdsParameters from the command object, so they can be used again
            cmd.Parameters.Clear()
        Finally
            If (Not dataAdapter Is Nothing) Then dataAdapter.Dispose()
        End Try
        If (mustCloseConnection) Then connection.Close()

        ' Return the dataset
        Return ds
    End Function ' ExecuteDataset

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(conn, "GetOrders", 24, 36)
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal connection As AdsConnection, _
                                                    ByVal spName As String, _
                                                    ByVal ParamArray parameterValues() As Object) As DataSet

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteDataset(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteDataset(connection, CommandType.StoredProcedure, spName)
        End If

    End Function ' ExecuteDataset

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the provided AdsTransaction.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(trans, CommandType.StoredProcedure, "GetOrders")
    ' Parameters
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal transaction As AdsTransaction, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String) As DataSet
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteDataset(transaction, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteDataset

    ' Execute a AdsCommand (that returns a resultset) against the specified AdsTransaction
    ' using the provided parameters.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(trans, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal transaction As AdsTransaction, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String, _
                                                    ByVal ParamArray commandParameters() As AdsParameter) As DataSet
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")

        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Dim ds As New DataSet
        Dim dataAdapter As AdsDataAdapter
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, transaction.Connection, transaction, commandType, commandText, commandParameters, mustCloseConnection)

        Try
            ' Create the DataAdapter & DataSet
            dataAdapter = New AdsDataAdapter(cmd)

            ' Fill the DataSet using default values for DataTable names, etc
            dataAdapter.Fill(ds)

            ' Detach the AdsParameters from the command object, so they can be used again
            cmd.Parameters.Clear()
        Finally
            If (Not dataAdapter Is Nothing) Then dataAdapter.Dispose()
        End Try

        ' Return the dataset
        Return ds

    End Function ' ExecuteDataset

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified
    ' AdsTransaction using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim ds As Dataset = ExecuteDataset(trans, "GetOrders", 24, 36)
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: A dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDataset(ByVal transaction As AdsTransaction, _
                                                    ByVal spName As String, _
                                                    ByVal ParamArray parameterValues() As Object) As DataSet

        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteDataset(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteDataset(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteDataset

#End Region

#Region "ExecuteReader"
    ' this enum is used to indicate whether the connection was provided by the caller, or created by AdsHelper, so that
    ' we can set the appropriate CommandBehavior when calling ExecuteReader()
    Private Enum AdsConnectionOwnership
        ' Connection is owned and managed by AdsHelper
        Internal
        ' Connection is owned and managed by the caller
        [External]
    End Enum ' AdsConnectionOwnership

    ' Create and prepare a AdsCommand, and call ExecuteReader with the appropriate CommandBehavior.
    ' If we created and opened the connection, we want the connection to be closed when the DataReader is closed.
    ' If the caller provided the connection, we want to leave it to them to manage.
    ' Parameters:
    ' -connection - a valid AdsConnection, on which to execute this command
    ' -transaction - a valid AdsTransaction, or ' null'
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParameters to be associated with the command or ' null' if no parameters are required
    ' -connectionOwnership - indicates whether the connection parameter was provided by the caller, or created by AdsHelper
    ' Returns: AdsDataReader containing the results of the command
    Private Overloads Shared Function ExecuteReader(ByVal connection As AdsConnection, _
                                                    ByVal transaction As AdsTransaction, _
                                                    ByVal commandType As CommandType, _
                                                    ByVal commandText As String, _
                                                    ByVal commandParameters() As AdsParameter, _
                                                    ByVal connectionOwnership As AdsConnectionOwnership) As AdsDataReader

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")

        Dim mustCloseConnection As Boolean = False
        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Try
            ' Create a reader
            Dim dataReader As AdsDataReader

            PrepareCommand(cmd, connection, transaction, commandType, commandText, commandParameters, mustCloseConnection)

            ' Call ExecuteReader with the appropriate CommandBehavior
            If connectionOwnership = AdsConnectionOwnership.External Then
                dataReader = cmd.ExecuteReader()
            Else
                dataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
            End If

            ' Detach the AdsParameters from the command object, so they can be used again
            Dim canClear As Boolean = True
            Dim commandParameter As AdsParameter
            For Each commandParameter In cmd.Parameters
                If commandParameter.Direction <> ParameterDirection.Input Then
                    canClear = False
                End If
            Next

            If (canClear) Then cmd.Parameters.Clear()

            Return dataReader
        Catch
            If (mustCloseConnection) Then connection.Close()
            Throw
        End Try
    End Function ' ExecuteReader

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the database specified in
    ' the connection string.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(connString, CommandType.StoredProcedure, "GetOrders")
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal connectionString As String, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As AdsDataReader
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteReader(connectionString, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteReader

    ' Execute a AdsCommand (that returns a resultset) against the database specified in the connection string
    ' using the provided parameters.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(connString, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal connectionString As String, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String, _
                                                   ByVal ParamArray commandParameters() As AdsParameter) As AdsDataReader
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")

        ' Create & open a AdsConnection
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)
            connection.Open()
            ' Call the private overload that takes an internally owned connection in place of the connection string
            Return ExecuteReader(connection, CType(Nothing, AdsTransaction), commandType, commandText, commandParameters, AdsConnectionOwnership.Internal)
        Catch
            ' If we fail to return the AdsDatReader, we need to close the connection ourselves
            If Not connection Is Nothing Then connection.Dispose()
            Throw
        End Try
    End Function ' ExecuteReader

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the database specified in
    ' the connection string using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(connString, "GetOrders", 24, 36)
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal connectionString As String, _
                                                   ByVal spName As String, _
                                                   ByVal ParamArray parameterValues() As Object) As AdsDataReader
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteReader(connectionString, CommandType.StoredProcedure, spName, commandParameters)
            ' Otherwise we can just call the SP without params
        Else
            Return ExecuteReader(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteReader

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the provided AdsConnection.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(conn, CommandType.StoredProcedure, "GetOrders")
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal connection As AdsConnection, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As AdsDataReader

        Return ExecuteReader(connection, commandType, commandText, CType(Nothing, AdsParameter()))

    End Function ' ExecuteReader

    ' Execute a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the provided parameters.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(conn, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal connection As AdsConnection, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String, _
                                                   ByVal ParamArray commandParameters() As AdsParameter) As AdsDataReader
        ' Pass through the call to private overload using a null transaction value
        Return ExecuteReader(connection, CType(Nothing, AdsTransaction), commandType, commandText, commandParameters, AdsConnectionOwnership.External)

    End Function ' ExecuteReader

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(conn, "GetOrders", 24, 36)
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal connection As AdsConnection, _
                                                   ByVal spName As String, _
                                                   ByVal ParamArray parameterValues() As Object) As AdsDataReader
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()
        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            AssignParameterValues(commandParameters, parameterValues)

            Return ExecuteReader(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteReader(connection, CommandType.StoredProcedure, spName)
        End If

    End Function ' ExecuteReader

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the provided AdsTransaction.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(trans, CommandType.StoredProcedure, "GetOrders")
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal transaction As AdsTransaction, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As AdsDataReader
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteReader(transaction, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteReader

    ' Execute a AdsCommand (that returns a resultset) against the specified AdsTransaction
    ' using the provided parameters.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(trans, CommandType.StoredProcedure, "GetOrders", new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal transaction As AdsTransaction, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String, _
                                                   ByVal ParamArray commandParameters() As AdsParameter) As AdsDataReader
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        ' Pass through to private overload, indicating that the connection is owned by the caller
        Return ExecuteReader(transaction.Connection, transaction, commandType, commandText, commandParameters, AdsConnectionOwnership.External)
    End Function ' ExecuteReader

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsTransaction
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim dr As AdsDataReader = ExecuteReader(trans, "GetOrders", 24, 36)
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: A AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReader(ByVal transaction As AdsTransaction, _
                                                   ByVal spName As String, _
                                                   ByVal ParamArray parameterValues() As Object) As AdsDataReader
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            AssignParameterValues(commandParameters, parameterValues)

            Return ExecuteReader(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteReader(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteReader

#End Region

#Region "ExecuteScalar"

    ' Execute a AdsCommand (that returns a 1x1 resultset and takes no parameters) against the database specified in
    ' the connection string.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(connString, CommandType.StoredProcedure, "GetOrderCount"))
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal connectionString As String, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As Object
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteScalar(connectionString, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteScalar

    ' Execute a AdsCommand (that returns a 1x1 resultset) against the database specified in the connection string
    ' using the provided parameters.
    ' e.g.:
    ' Dim orderCount As Integer = Cint(ExecuteScalar(connString, CommandType.StoredProcedure, "GetOrderCount", new AdsParameter("@prodid", 24)))
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal connectionString As String, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String, _
                                                   ByVal ParamArray commandParameters() As AdsParameter) As Object
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        ' Create & open a AdsConnection, and dispose of it after we are done.
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)
            connection.Open()

            ' Call the overload that takes a connection in place of the connection string
            Return ExecuteScalar(connection, commandType, commandText, commandParameters)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Function ' ExecuteScalar

    ' Execute a stored procedure via a AdsCommand (that returns a 1x1 resultset) against the database specified in
    ' the connection string using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(connString, "GetOrderCount", 24, 36))
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal connectionString As String, _
                                                   ByVal spName As String, _
                                                   ByVal ParamArray parameterValues() As Object) As Object
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteScalar(connectionString, CommandType.StoredProcedure, spName, commandParameters)
            ' Otherwise we can just call the SP without params
        Else
            Return ExecuteScalar(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteScalar

    ' Execute a AdsCommand (that returns a 1x1 resultset and takes no parameters) against the provided AdsConnection.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(conn, CommandType.StoredProcedure, "GetOrderCount"))
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal connection As AdsConnection, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As Object
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteScalar(connection, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteScalar

    ' Execute a AdsCommand (that returns a 1x1 resultset) against the specified AdsConnection
    ' using the provided parameters.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(conn, CommandType.StoredProcedure, "GetOrderCount", new AdsParameter("@prodid", 24)))
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal connection As AdsConnection, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String, _
                                                   ByVal ParamArray commandParameters() As AdsParameter) As Object

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")

        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Dim retval As Object
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, connection, CType(Nothing, AdsTransaction), commandType, commandText, commandParameters, mustCloseConnection)

        ' Execute the command & return the results
        retval = cmd.ExecuteScalar()

        ' Detach the AdsParameters from the command object, so they can be used again
        cmd.Parameters.Clear()

            If (mustCloseConnection) Then connection.Close()

        Return retval

    End Function ' ExecuteScalar

    ' Execute a stored procedure via a AdsCommand (that returns a 1x1 resultset) against the specified AdsConnection
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(conn, "GetOrderCount", 24, 36))
    ' Parameters:
    ' -connection - a valid AdsConnection
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal connection As AdsConnection, _
                                                   ByVal spName As String, _
                                                   ByVal ParamArray parameterValues() As Object) As Object
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()

        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteScalar(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteScalar(connection, CommandType.StoredProcedure, spName)
        End If

    End Function ' ExecuteScalar

    ' Execute a AdsCommand (that returns a 1x1 resultset and takes no parameters) against the provided AdsTransaction.
    ' e.g.:
    ' Dim orderCount As Integer  = CInt(ExecuteScalar(trans, CommandType.StoredProcedure, "GetOrderCount"))
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal transaction As AdsTransaction, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String) As Object
        ' Pass through the call providing null for the set of AdsParameters
        Return ExecuteScalar(transaction, commandType, commandText, CType(Nothing, AdsParameter()))
    End Function ' ExecuteScalar

    ' Execute a AdsCommand (that returns a 1x1 resultset) against the specified AdsTransaction
    ' using the provided parameters.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(trans, CommandType.StoredProcedure, "GetOrderCount", new AdsParameter("@prodid", 24)))
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -commandType - the CommandType (stored procedure, text, etc.)
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters used to execute the command
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal transaction As AdsTransaction, _
                                                   ByVal commandType As CommandType, _
                                                   ByVal commandText As String, _
                                                   ByVal ParamArray commandParameters() As AdsParameter) As Object
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")

        ' Create a command and prepare it for execution
        Dim cmd As New AdsCommand
        Dim retval As Object
        Dim mustCloseConnection As Boolean = False

        PrepareCommand(cmd, transaction.Connection, transaction, commandType, commandText, commandParameters, mustCloseConnection)

        ' Execute the command & return the results
        retval = cmd.ExecuteScalar()

        ' Detach the AdsParameters from the command object, so they can be used again
        cmd.Parameters.Clear()

        Return retval
    End Function ' ExecuteScalar

    ' Execute a stored procedure via a AdsCommand (that returns a 1x1 resultset) against the specified AdsTransaction
    ' using the provided parameter values.  This method will discover the parameters for the
    ' stored procedure, and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' Dim orderCount As Integer = CInt(ExecuteScalar(trans, "GetOrderCount", 24, 36))
    ' Parameters:
    ' -transaction - a valid AdsTransaction
    ' -spName - the name of the stored procedure
    ' -parameterValues - an array of objects to be assigned as the input values of the stored procedure
    ' Returns: An object containing the value in the 1x1 resultset generated by the command
    Public Overloads Shared Function ExecuteScalar(ByVal transaction As AdsTransaction, _
                                                   ByVal spName As String, _
                                                   ByVal ParamArray parameterValues() As Object) As Object
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        Dim commandParameters As AdsParameter()
        ' If we receive parameter values, we need to figure out where they go
        If Not (parameterValues Is Nothing) AndAlso parameterValues.Length > 0 Then
            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            commandParameters = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            Return ExecuteScalar(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else ' Otherwise we can just call the SP without params
            Return ExecuteScalar(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function ' ExecuteScalar

#End Region


#Region "FillDataset"
    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the database specified in
    ' the connection string.
    ' e.g.:
    '   FillDataset (connString, CommandType.StoredProcedure, "GetOrders", ds, new String() {"orders"})
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '               by a user defined name (probably the actual table name)
    Public Overloads Shared Sub FillDataset(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String, ByVal dataSet As DataSet, ByVal tableNames() As String)

        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (dataSet Is Nothing ) Then Throw New ArgumentNullException( "dataSet" )

        ' Create & open a AdsConnection, and dispose of it after we are done
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)

            connection.Open()

            ' Call the overload that takes a connection in place of the connection string
            FillDataset(connection, commandType, commandText, dataSet, tableNames)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Sub

    ' Execute a AdsCommand (that returns a resultset) against the database specified in the connection string
    ' using the provided parameters.
    ' e.g.:
    '   FillDataset (connString, CommandType.StoredProcedure, "GetOrders", ds, new String() = {"orders"}, new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '               by a user defined name (probably the actual table name)
    ' -commandParameters: An array of AdsParamters used to execute the command
    Public Overloads Shared Sub FillDataset(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String, ByVal dataSet As DataSet, _
        ByVal tableNames() As String, ByVal ParamArray commandParameters() As AdsParameter)

        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (dataSet Is Nothing ) Then Throw New ArgumentNullException( "dataSet" )

        ' Create & open a AdsConnection, and dispose of it after we are done
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)

            connection.Open()

            ' Call the overload that takes a connection in place of the connection string
            FillDataset(connection, commandType, commandText, dataSet, tableNames, commandParameters)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Sub

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the database specified in
    ' the connection string using the provided parameter values.  This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    '   FillDataset (connString, CommandType.StoredProcedure, "GetOrders", ds, new String() {"orders"}, 24)
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -spName: the name of the stored procedure
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '             by a user defined name (probably the actual table name)
    ' -parameterValues: An array of objects to be assigned As the input values of the stored procedure
    Public Overloads Shared Sub FillDataset(ByVal connectionString As String, ByVal spName As String, _
        ByVal dataSet As DataSet, ByVal tableNames As String(), ByVal ParamArray parameterValues() As Object)

        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (dataSet Is Nothing ) Then Throw New ArgumentNullException( "dataSet" )

        ' Create & open a AdsConnection, and dispose of it after we are done
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)

            connection.Open()

            ' Call the overload that takes a connection in place of the connection string
            FillDataset(connection, spName, dataSet, tableNames, parameterValues)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Sub

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the provided AdsConnection.
    ' e.g.:
    '   FillDataset (conn, CommandType.StoredProcedure, "GetOrders", ds, new String() {"orders"})
    ' Parameters:
    ' -connection: A valid AdsConnection
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    ' by a user defined name (probably the actual table name)
    Public Overloads Shared Sub FillDataset(ByVal connection As AdsConnection, ByVal commandType As CommandType, _
        ByVal commandText As String, ByVal dataSet As DataSet, ByVal tableNames As String())

        FillDataset(connection, commandType, commandText, dataSet, tableNames, Nothing)

    End Sub

    ' Execute a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the provided parameters.
    ' e.g.:
    '   FillDataset (conn, CommandType.StoredProcedure, "GetOrders", ds, new String() {"orders"}, new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connection: A valid AdsConnection
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    ' by a user defined name (probably the actual table name)
    ' -commandParameters: An array of AdsParamters used to execute the command
    Public Overloads Shared Sub FillDataset(ByVal connection As AdsConnection, ByVal commandType As CommandType, _
    ByVal commandText As String, ByVal dataSet As DataSet, ByVal tableNames As String(), _
        ByVal ParamArray commandParameters() As AdsParameter)

        FillDataset(connection, Nothing, commandType, commandText, dataSet, tableNames, commandParameters)

    End Sub

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the provided parameter values.  This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    ' FillDataset (conn, "GetOrders", ds, new string() {"orders"}, 24, 36)
    ' Parameters:
    ' -connection: A valid AdsConnection
    ' -spName: the name of the stored procedure
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '             by a user defined name (probably the actual table name)
    ' -parameterValues: An array of objects to be assigned as the input values of the stored procedure
    Public Overloads Shared Sub FillDataset(ByVal connection As AdsConnection, ByVal spName As String, ByVal dataSet As DataSet, _
        ByVal tableNames() As String, ByVal ParamArray parameterValues() As Object)

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (dataSet Is Nothing ) Then Throw New ArgumentNullException( "dataSet" )
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If we receive parameter values, we need to figure out where they go
        If Not parameterValues Is Nothing AndAlso parameterValues.Length > 0 Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            FillDataset(connection, CommandType.StoredProcedure, spName, dataSet, tableNames, commandParameters)
        Else ' Otherwise we can just call the SP without params
            FillDataset(connection, CommandType.StoredProcedure, spName, dataSet, tableNames)
        End If

    End Sub

    ' Execute a AdsCommand (that returns a resultset and takes no parameters) against the provided AdsTransaction.
    ' e.g.:
    '   FillDataset (trans, CommandType.StoredProcedure, "GetOrders", ds, new string() {"orders"})
    ' Parameters:
    ' -transaction: A valid AdsTransaction
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '             by a user defined name (probably the actual table name)
    Public Overloads Shared Sub FillDataset(ByVal transaction As AdsTransaction, ByVal commandType As CommandType, _
        ByVal commandText As String, ByVal dataSet As DataSet, ByVal tableNames() As String)

        FillDataset(transaction, commandType, commandText, dataSet, tableNames, Nothing)
    End Sub

    ' Execute a AdsCommand (that returns a resultset) against the specified AdsTransaction
    ' using the provided parameters.
    ' e.g.:
    '   FillDataset(trans, CommandType.StoredProcedure, "GetOrders", ds, new string() {"orders"}, new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -transaction: A valid AdsTransaction
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    ' by a user defined name (probably the actual table name)
    ' -commandParameters: An array of AdsParamters used to execute the command
    Public Overloads Shared Sub FillDataset(ByVal transaction As AdsTransaction, ByVal commandType As CommandType, _
        ByVal commandText As String, ByVal dataSet As DataSet, ByVal tableNames() As String, _
        ByVal ParamArray commandParameters() As AdsParameter)

        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        FillDataset(transaction.Connection, transaction, commandType, commandText, dataSet, tableNames, commandParameters)

    End Sub

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified
    ' AdsTransaction using the provided parameter values.  This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' This method provides no access to output parameters or the stored procedure' s return value parameter.
    ' e.g.:
    '   FillDataset(trans, "GetOrders", ds, new String(){"orders"}, 24, 36)
    ' Parameters:
    ' -transaction: A valid AdsTransaction
    ' -spName: the name of the stored procedure
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '             by a user defined name (probably the actual table name)
    ' -parameterValues: An array of objects to be assigned as the input values of the stored procedure
    Public Overloads Shared Sub FillDataset(ByVal transaction As AdsTransaction, ByVal spName As String, _
        ByVal dataSet As DataSet, ByVal tableNames() As String, ByVal ParamArray parameterValues() As Object)

        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (dataSet Is Nothing) Then Throw New ArgumentNullException("dataSet")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If we receive parameter values, we need to figure out where they go
        If Not parameterValues Is Nothing AndAlso parameterValues.Length > 0 Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Assign the provided values to these parameters based on parameter order
            AssignParameterValues(commandParameters, parameterValues)

            ' Call the overload that takes an array of AdsParameters
            FillDataset(transaction, CommandType.StoredProcedure, spName, dataSet, tableNames, commandParameters)
        Else ' Otherwise we can just call the SP without params
            FillDataset(transaction, CommandType.StoredProcedure, spName, dataSet, tableNames)
        End If
    End Sub

    ' Private helper method that execute a AdsCommand (that returns a resultset) against the specified AdsTransaction and AdsConnection
    ' using the provided parameters.
    ' e.g.:
    '   FillDataset(conn, trans, CommandType.StoredProcedure, "GetOrders", ds, new String() {"orders"}, new AdsParameter("@prodid", 24))
    ' Parameters:
    ' -connection: A valid AdsConnection
    ' -transaction: A valid AdsTransaction
    ' -commandType: the CommandType (stored procedure, text, etc.)
    ' -commandText: the stored procedure name or SQL command
    ' -dataSet: A dataset wich will contain the resultset generated by the command
    ' -tableNames: this array will be used to create table mappings allowing the DataTables to be referenced
    '             by a user defined name (probably the actual table name)
    ' -commandParameters: An array of AdsParamters used to execute the command
    Private Overloads Shared Sub FillDataset(ByVal connection As AdsConnection, ByVal transaction As AdsTransaction, ByVal commandType As CommandType, _
        ByVal commandText As String, ByVal dataSet As DataSet, ByVal tableNames() As String, _
        ByVal ParamArray commandParameters() As AdsParameter)

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (dataSet Is Nothing) Then Throw New ArgumentNullException("dataSet")

        ' Create a command and prepare it for execution
        Dim command As New AdsCommand

        Dim mustCloseConnection As Boolean = False
        PrepareCommand(command, connection, transaction, commandType, commandText, commandParameters, mustCloseConnection)

        ' Create the DataAdapter & DataSet
        Dim dataAdapter As AdsDataAdapter = New AdsDataAdapter(command)

        Try
            ' Add the table mappings specified by the user
            If Not tableNames Is Nothing AndAlso tableNames.Length > 0 Then

                Dim tableName As String = "Table"
                Dim index As Integer

                For index = 0 To tableNames.Length - 1
                    If (tableNames(index) Is Nothing OrElse tableNames(index).Length = 0) Then Throw New ArgumentException("The tableNames parameter must contain a list of tables, a value was provided as null or empty string.", "tableNames")
                    dataAdapter.TableMappings.Add(tableName, tableNames(index))
                    tableName = tableName & (index + 1).ToString()
                Next
            End If

            ' Fill the DataSet using default values for DataTable names, etc
            dataAdapter.Fill(dataSet)

            ' Detach the AdsParameters from the command object, so they can be used again
            command.Parameters.Clear()
        Finally
            If (Not dataAdapter Is Nothing) Then dataAdapter.Dispose()
        End Try

        If (mustCloseConnection) Then connection.Close()

    End Sub
#End Region

#Region "UpdateDataset"
    ' Executes the respective command for each inserted, updated, or deleted row in the DataSet.
    ' e.g.:
    '   UpdateDataset(conn, insertCommand, deleteCommand, updateCommand, dataSet, "Order")
    ' Parameters:
    ' -insertCommand: A valid SQL statement or stored procedure to insert new records into the data source
    ' -deleteCommand: A valid SQL statement or stored procedure to delete records from the data source
    ' -updateCommand: A valid SQL statement or stored procedure used to update records in the data source
    ' -dataSet: the DataSet used to update the data source
    ' -tableName: the DataTable used to update the data source
    Public Overloads Shared Sub UpdateDataset(ByVal insertCommand As AdsCommand, ByVal deleteCommand As AdsCommand, ByVal updateCommand As AdsCommand, ByVal dataSet As DataSet, ByVal tableName As String)

        If (insertCommand Is Nothing) Then Throw New ArgumentNullException("insertCommand")
        If (deleteCommand Is Nothing) Then Throw New ArgumentNullException("deleteCommand")
        If (updateCommand Is Nothing) Then Throw New ArgumentNullException("updateCommand")
        If (dataSet Is Nothing) Then Throw New ArgumentNullException("dataSet")
        If (tableName Is Nothing OrElse tableName.Length = 0) Then Throw New ArgumentNullException("tableName")

        ' Create a AdsDataAdapter, and dispose of it after we are done
        Dim dataAdapter As New AdsDataAdapter
        Try
            ' Set the data adapter commands
            dataAdapter.UpdateCommand = updateCommand
            dataAdapter.InsertCommand = insertCommand
            dataAdapter.DeleteCommand = deleteCommand

            ' Update the dataset changes in the data source
            dataAdapter.Update(dataSet, tableName)

            ' Commit all the changes made to the DataSet
            dataSet.AcceptChanges()
        Finally
            If (Not dataAdapter Is Nothing) Then dataAdapter.Dispose()
        End Try
    End Sub
#End Region

#Region "CreateCommand"
    ' Simplify the creation of a Ads command object by allowing
    ' a stored procedure and optional parameters to be provided
    ' e.g.:
    ' Dim command As AdsCommand = CreateCommand(conn, "AddCustomer", "CustomerID", "CustomerName")
    ' Parameters:
    ' -connection: A valid AdsConnection object
    ' -spName: the name of the stored procedure
    ' -sourceColumns: An array of string to be assigned as the source columns of the stored procedure parameters
    ' Returns:
    ' a valid AdsCommand object
    Public Overloads Shared Function CreateCommand(ByVal connection As AdsConnection, ByVal spName As String, ByVal ParamArray sourceColumns() As String) As AdsCommand

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        ' Create a AdsCommand
        Dim cmd As New AdsCommand(spName, connection)
        cmd.CommandType = CommandType.StoredProcedure

        ' If we receive parameter values, we need to figure out where they go
        If Not sourceColumns Is Nothing AndAlso sourceColumns.Length > 0 Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Assign the provided source columns to these parameters based on parameter order
            Dim index As Integer
            For index = 0 To sourceColumns.Length - 1
                commandParameters(index).SourceColumn = sourceColumns(index)
            Next

            ' Attach the discovered parameters to the AdsCommand object
            AttachParameters(cmd, commandParameters)
        End If

        CreateCommand = cmd
    End Function
#End Region

#Region "ExecuteNonQueryTypedParams"
    ' Execute a stored procedure via a AdsCommand (that returns no resultset) against the database specified in
    ' the connection string using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on row values.
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values
    ' Returns:
    ' an int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQueryTypedParams(ByVal connectionString As String, ByVal spName As String, ByVal dataRow As DataRow) As Integer
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteNonQueryTypedParams = AdsHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteNonQueryTypedParams = AdsHelper.ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns no resultset) against the specified AdsConnection
    ' using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on row values.
    ' Parameters:
    ' -connection:a valid AdsConnection object
    ' -spName: the name of the stored procedure
    ' -dataRow:The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' an int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQueryTypedParams(ByVal connection As AdsConnection, ByVal spName As String, ByVal dataRow As DataRow) As Integer
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteNonQueryTypedParams = AdsHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteNonQueryTypedParams = AdsHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns no resultset) against the specified
    ' AdsTransaction using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on row values.
    ' Parameters:
    ' -transaction:a valid AdsTransaction object
    ' -spName:the name of the stored procedure
    ' -dataRow:The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' an int representing the number of rows affected by the command
    Public Overloads Shared Function ExecuteNonQueryTypedParams(ByVal transaction As AdsTransaction, ByVal spName As String, ByVal dataRow As DataRow) As Integer

        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteNonQueryTypedParams = AdsHelper.ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else

            ExecuteNonQueryTypedParams = AdsHelper.ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function
#End Region

#Region "ExecuteDatasetTypedParams"
    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the database specified in
    ' the connection string using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on row values.
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' a dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDatasetTypedParams(ByVal connectionString As String, ByVal spName As String, ByVal dataRow As DataRow) As DataSet
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteDatasetTypedParams = AdsHelper.ExecuteDataset(connectionString, CommandType.StoredProcedure, spName, commandParameters)
        Else

            ExecuteDatasetTypedParams = AdsHelper.ExecuteDataset(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the dataRow column values as the store procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on row values.
    ' Parameters:
    ' -connection: A valid AdsConnection object
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' a dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDatasetTypedParams(ByVal connection As AdsConnection, ByVal spName As String, ByVal dataRow As DataRow) As DataSet

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteDatasetTypedParams = AdsHelper.ExecuteDataset(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else

            ExecuteDatasetTypedParams = AdsHelper.ExecuteDataset(connection, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsTransaction
    ' using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on row values.
    ' Parameters:
    ' -transaction: A valid AdsTransaction object
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' a dataset containing the resultset generated by the command
    Public Overloads Shared Function ExecuteDatasetTypedParams(ByVal transaction As AdsTransaction, ByVal spName As String, ByVal dataRow As DataRow) As DataSet
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteDatasetTypedParams = AdsHelper.ExecuteDataset(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else

            ExecuteDatasetTypedParams = AdsHelper.ExecuteDataset(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function
#End Region

#Region "ExecuteReaderTypedParams"
    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the database specified in
    ' the connection string using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' a AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReaderTypedParams(ByVal connectionString As String, ByVal spName As String, ByVal dataRow As DataRow) As AdsDataReader
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteReaderTypedParams = AdsHelper.ExecuteReader(connectionString, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteReaderTypedParams = AdsHelper.ExecuteReader(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsConnection
    ' using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' Parameters:
    ' -connection: A valid AdsConnection object
    ' -spName: The name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' a AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReaderTypedParams(ByVal connection As AdsConnection, ByVal spName As String, ByVal dataRow As DataRow) As AdsDataReader
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteReaderTypedParams = AdsHelper.ExecuteReader(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteReaderTypedParams = AdsHelper.ExecuteReader(connection, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns a resultset) against the specified AdsTransaction
    ' using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' Parameters:
    ' -transaction: A valid AdsTransaction object
    ' -spName" The name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' a AdsDataReader containing the resultset generated by the command
    Public Overloads Shared Function ExecuteReaderTypedParams(ByVal transaction As AdsTransaction, ByVal spName As String, ByVal dataRow As DataRow) As AdsDataReader
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteReaderTypedParams = AdsHelper.ExecuteReader(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteReaderTypedParams = AdsHelper.ExecuteReader(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function
#End Region

#Region "ExecuteScalarTypedParams"
    ' Execute a stored procedure via a AdsCommand (that returns a 1x1 resultset) against the database specified in
    ' the connection string using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' Parameters:
    ' -connectionString: A valid connection string for a AdsConnection
    ' -spName: The name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' An object containing the value in the 1x1 resultset generated by the command</returns>
    Public Overloads Shared Function ExecuteScalarTypedParams(ByVal connectionString As String, ByVal spName As String, ByVal dataRow As DataRow) As Object
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")
        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connectionString, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteScalarTypedParams = AdsHelper.ExecuteScalar(connectionString, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteScalarTypedParams = AdsHelper.ExecuteScalar(connectionString, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns a 1x1 resultset) against the specified AdsConnection
    ' using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' Parameters:
    ' -connection: A valid AdsConnection object
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' an object containing the value in the 1x1 resultset generated by the command</returns>
    Public Overloads Shared Function ExecuteScalarTypedParams(ByVal connection As AdsConnection, ByVal spName As String, ByVal dataRow As DataRow) As Object
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteScalarTypedParams = AdsHelper.ExecuteScalar(connection, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteScalarTypedParams = AdsHelper.ExecuteScalar(connection, CommandType.StoredProcedure, spName)
        End If
    End Function

    ' Execute a stored procedure via a AdsCommand (that returns a 1x1 resultset) against the specified AdsTransaction
    ' using the dataRow column values as the stored procedure' s parameters values.
    ' This method will query the database to discover the parameters for the
    ' stored procedure (the first time each stored procedure is called), and assign the values based on parameter order.
    ' Parameters:
    ' -transaction: A valid AdsTransaction object
    ' -spName: the name of the stored procedure
    ' -dataRow: The dataRow used to hold the stored procedure' s parameter values.
    ' Returns:
    ' an object containing the value in the 1x1 resultset generated by the command</returns>
    Public Overloads Shared Function ExecuteScalarTypedParams(ByVal transaction As AdsTransaction, ByVal spName As String, ByVal dataRow As DataRow) As Object
        If (transaction Is Nothing) Then Throw New ArgumentNullException("transaction")
        If Not (transaction Is Nothing) AndAlso (transaction.Connection Is Nothing) Then Throw New ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        ' If the row has values, the store procedure parameters must be initialized
        If (Not dataRow Is Nothing AndAlso dataRow.ItemArray.Length > 0) Then

            ' Pull the parameters for this stored procedure from the parameter cache (or discover them & populate the cache)
            Dim commandParameters() As AdsParameter = AdsHelperParameterCache.GetSpParameterSet(transaction.Connection, spName)

            ' Set the parameters values
            AssignParameterValues(commandParameters, dataRow)

            ExecuteScalarTypedParams = AdsHelper.ExecuteScalar(transaction, CommandType.StoredProcedure, spName, commandParameters)
        Else
            ExecuteScalarTypedParams = AdsHelper.ExecuteScalar(transaction, CommandType.StoredProcedure, spName)
        End If
    End Function
#End Region

End Class ' AdsHelper

' AdsHelperParameterCache provides functions to leverage a static cache of procedure parameters, and the
' ability to discover parameters for stored procedures at run-time.
Public NotInheritable Class AdsHelperParameterCache

#Region "private methods, variables, and constructors"


    ' Since this class provides only static methods, make the default constructor private to prevent
    ' instances from being created with "new AdsHelperParameterCache()".
    Private Sub New()
    End Sub ' New

    Private Shared paramCache As Hashtable = Hashtable.Synchronized(New Hashtable)

    ' resolve at run time the appropriate set of AdsParameters for a stored procedure
    ' Parameters:
    ' - connectionString - a valid connection string for a AdsConnection
    ' - spName - the name of the stored procedure
    ' - includeReturnValueParameter - whether or not to include their return value parameter>
    ' Returns: AdsParameter()
    Private Shared Function DiscoverSpParameterSet(ByVal connection As AdsConnection, _
                                                       ByVal spName As String, _
                                                       ByVal includeReturnValueParameter As Boolean, _
                                                       ByVal ParamArray parameterValues() As Object) As AdsParameter()

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")
        Dim cmd As New AdsCommand(spName, connection)
        cmd.CommandType = CommandType.StoredProcedure
        Dim discoveredParameters() As AdsParameter
        dim currState as ConnectionState
        currState = connection.State
        if currState <> ConnectionState.Open then
            connection.Open()
        end if
        AdsCommandBuilder.DeriveParameters(cmd)
        if currState <> ConnectionState.Open then
            connection.Close()
        end if

        ' Remove output parameters
        dim iParam as integer
        for iParam = cmd.Parameters.Count - 1 to 0 step -1
           if cmd.Parameters(iParam).Direction = ParameterDirection.Output then
              cmd.Parameters.RemoveAt( iParam )
           end if
        next

        discoveredParameters = New AdsParameter(cmd.Parameters.Count - 1) {}
        cmd.Parameters.CopyTo(discoveredParameters, 0)

        ' Init the parameters with a DBNull value
        Dim discoveredParameter As AdsParameter
        For Each discoveredParameter In discoveredParameters
            discoveredParameter.Value = DBNull.Value
        Next

        Return discoveredParameters

    End Function ' DiscoverSpParameterSet

    ' Deep copy of cached AdsParameter array
    Private Shared Function CloneParameters(ByVal originalParameters() As AdsParameter) As AdsParameter()

        Dim i As Integer
        Dim j As Integer = originalParameters.Length - 1
        Dim clonedParameters(j) As AdsParameter

        For i = 0 To j
            clonedParameters(i) = New AdsParameter( originalParameters(i).ParameterName, _
                                                    originalParameters(i).DbType, _
                                                    originalParameters(i).Size, _
                                                    originalParameters(i).Direction, _
                                                    originalParameters(i).IsNullable, _
                                                    originalParameters(i).Precision, _
                                                    originalParameters(i).Scale, _
                                                    originalParameters(i).SourceColumn, _
                                                    originalParameters(i).SourceVersion, _
                                                    originalParameters(i).Value )
        Next

        Return clonedParameters
    End Function ' CloneParameters

#End Region

#Region "caching functions"

    ' add parameter array to the cache
    ' Parameters
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandText - the stored procedure name or SQL command
    ' -commandParameters - an array of AdsParamters to be cached
    Public Shared Sub CacheParameterSet(ByVal connectionString As String, _
                                        ByVal commandText As String, _
                                        ByVal ParamArray commandParameters() As AdsParameter)
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (commandText Is Nothing OrElse commandText.Length = 0) Then Throw New ArgumentNullException("commandText")

        Dim hashKey As String = connectionString + ":" + commandText

        paramCache(hashKey) = commandParameters
    End Sub ' CacheParameterSet

    ' retrieve a parameter array from the cache
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -commandText - the stored procedure name or SQL command
    ' Returns: An array of AdsParamters
    Public Shared Function GetCachedParameterSet(ByVal connectionString As String, ByVal commandText As String) As AdsParameter()
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        If (commandText Is Nothing OrElse commandText.Length = 0) Then Throw New ArgumentNullException("commandText")

        Dim hashKey As String = connectionString + ":" + commandText
        Dim cachedParameters As AdsParameter() = CType(paramCache(hashKey), AdsParameter())

        If cachedParameters Is Nothing Then
            Return Nothing
        Else
            Return CloneParameters(cachedParameters)
        End If
    End Function ' GetCachedParameterSet

#End Region

#Region "Parameter Discovery Functions"
    ' Retrieves the set of AdsParameters appropriate for the stored procedure.
    ' This method will query the database for this information, and then store it in a cache for future requests.
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -spName - the name of the stored procedure
    ' Returns: An array of AdsParameters
    Public Overloads Shared Function GetSpParameterSet(ByVal connectionString As String, ByVal spName As String) As AdsParameter()
        Return GetSpParameterSet(connectionString, spName, False)
    End Function ' GetSpParameterSet

    ' Retrieves the set of AdsParameters appropriate for the stored procedure.
    ' This method will query the database for this information, and then store it in a cache for future requests.
    ' Parameters:
    ' -connectionString - a valid connection string for a AdsConnection
    ' -spName - the name of the stored procedure
    ' -includeReturnValueParameter - a bool value indicating whether the return value parameter should be included in the results
    ' Returns: An array of AdsParameters
    Public Overloads Shared Function GetSpParameterSet(ByVal connectionString As String, _
                                                       ByVal spName As String, _
                                                       ByVal includeReturnValueParameter As Boolean) As AdsParameter()
        If (connectionString Is Nothing OrElse connectionString.Length = 0) Then Throw New ArgumentNullException("connectionString")
        Dim connection As AdsConnection
        Try
            connection = New AdsConnection(connectionString)
            GetSpParameterSet = GetSpParameterSetInternal(connection, spName, includeReturnValueParameter)
        Finally
            If Not connection Is Nothing Then connection.Dispose()
        End Try
    End Function ' GetSpParameterSet

    ' Retrieves the set of AdsParameters appropriate for the stored procedure.
    ' This method will query the database for this information, and then store it in a cache for future requests.
    ' Parameters:
    ' -connection - a valid AdsConnection object
    ' -spName - the name of the stored procedure
    ' -includeReturnValueParameter - a bool value indicating whether the return value parameter should be included in the results
    ' Returns: An array of AdsParameters
    Public Overloads Shared Function GetSpParameterSet(ByVal connection As AdsConnection, _
                                                       ByVal spName As String) As AdsParameter()

        GetSpParameterSet = GetSpParameterSet(connection, spName, False)
    End Function ' GetSpParameterSet

    ' Retrieves the set of AdsParameters appropriate for the stored procedure.
    ' This method will query the database for this information, and then store it in a cache for future requests.
    ' Parameters:
    ' -connection - a valid AdsConnection object
    ' -spName - the name of the stored procedure
    ' -includeReturnValueParameter - a bool value indicating whether the return value parameter should be included in the results
    ' Returns: An array of AdsParameters
    Public Overloads Shared Function GetSpParameterSet(ByVal connection As AdsConnection, _
                                                       ByVal spName As String, _
                                                       ByVal includeReturnValueParameter As Boolean) As AdsParameter()
        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")
        GetSpParameterSet = GetSpParameterSetInternal(connection, spName, includeReturnValueParameter)
    End Function ' GetSpParameterSet

    ' Retrieves the set of AdsParameters appropriate for the stored procedure.
    ' This method will query the database for this information, and then store it in a cache for future requests.
    ' Parameters:
    ' -connection - a valid AdsConnection object
    ' -spName - the name of the stored procedure
    ' -includeReturnValueParameter - a bool value indicating whether the return value parameter should be included in the results
    ' Returns: An array of AdsParameters
    Private Overloads Shared Function GetSpParameterSetInternal(ByVal connection As AdsConnection, _
                                                    ByVal spName As String, _
                                                    ByVal includeReturnValueParameter As Boolean) As AdsParameter()

        If (connection Is Nothing) Then Throw New ArgumentNullException("connection")

        Dim cachedParameters() As AdsParameter
        Dim hashKey As String

        If (spName Is Nothing OrElse spName.Length = 0) Then Throw New ArgumentNullException("spName")

        hashKey = connection.ConnectionString + ":" + spName + IIf(includeReturnValueParameter = True, ":include ReturnValue Parameter", "").ToString

        cachedParameters = CType(paramCache(hashKey), AdsParameter())

        If (cachedParameters Is Nothing) Then
            Dim spParameters() As AdsParameter = DiscoverSpParameterSet(connection, spName, includeReturnValueParameter)
            paramCache(hashKey) = spParameters
            cachedParameters = spParameters

        End If

        Return CloneParameters(cachedParameters)

    End Function ' GetSpParameterSet
#End Region

End Class ' AdsHelperParameterCache