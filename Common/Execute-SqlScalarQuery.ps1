﻿Function Execute-SqlScalarQuery
{
	param
	( 
		[Parameter(Position=0, Mandatory=$true)] [string] $sqlScript,
		[Parameter(Position=1, Mandatory=$true)] [AllowEmptyString()] [string] $sqlInstance,
        [Parameter(Position=2, Mandatory=$false)] [string] $serverName = $Global:LogicalComputerName,
        [Parameter(Position=3, Mandatory=$false)] [string] $databaseName = "master"
	)
    
	$conn = new-Object System.Data.SqlClient.SqlConnection("Server=$serverName\$sqlInstance;DataBase=$databaseName;Integrated Security=SSPI;")
	$sqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$sqlCommand.Connection = $conn
	$sqlCommand.CommandType = [System.Data.CommandType]'Text'
	$sqlCommand.CommandTimeout = 300
	
	try
	{
		$conn.Open() | out-null	
		
		$sqlCommand.CommandText = $sqlScript
		[int] $retVal = $sqlCommand.ExecuteScalar()
		
        $strResult = "Command(s) completed successfully."
	}
	catch [System.Exception]
	{
		$strResult = $_
	}
	finally
	{
		if ($conn.State -ne [System.Data.ConnectionState]'Closed')
		{
			$conn.Close()
		}
	}
	
	return $retVal
}
