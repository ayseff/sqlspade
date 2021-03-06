#/* 2005,2008,2008R2,2012,2014,2016 */

###############################################################################################################
# PowerShell Script Template
###############################################################################################################
# For use with the Auto-Install process
#
# When called, the script will recieve a single hashtable object passed as a 
# parameter.  This object contains the following properties:
#	$params["SqlVersion"] - Version of SQL being installed (SQL2005, SQL2008, SQL2008R2)
#   $params["SqlEdition"] - Edition of SQL being installed (Standard, Enterprise)
#	$params["ProcessorArch"] - CPU Architecture (x86, X64)
#	$params["InstanceName"] - The name that the instance will be installed with (sqldev1)
#   $params["ServiceAccount"] - The name of the account to run the services under (domain\user)
#   $params["FilePath"] - path to save the configuration ini file
#
# To add additional parameters - add them to the hashtable passed to the Run-Install function
#
# This script should be placed in the appropriate scripts folder and will be automatically called during the 
# auto-install process.
#
# The script should be saved using the following naming convention:
# 
# Pre Install Script (Save to PreScripts Folder) -
# -------------------------------------------------
# Pre-100-OS-[ScriptName].ps1
# Pre-200-Service-[ScriptName].ps1
#
# Post Install Script (Save to SQLScripts Folder) -
# -------------------------------------------------
# 100-OS-[ScriptName].ps1
# 200-Service-[ScriptName].ps1
# 300-Server-[ScriptName].ps1
# 400-Database-[ScriptName].ps1
# 500-Table-[ScriptName].ps1
# 600-View-[ScriptName].ps1
# 700-Procedure-[ScriptName].ps1
# 800-Agent-[ScriptName].ps1
# 900-Management-[ScriptName].ps1
###############################################################################################################

$configParams = $args[0]
$instance = $configParams["InstanceName"]

if ($instance -eq "mssqlserver" -or $instance -eq "")
{
	$serviceName = "mssqlserver"
#	$agentService = "SQLAgent"
}
else
{
	$serviceName = "MSSQL`$$instance"
#	$agentService = "SQLAgent`$$instance"
}

#if ((get-service $service).Status -eq "Stopped") 
#{
#	Write-Log -level "Info" -message "Starting the SQL Service"
#    start-service $service
#}
#else
#{
#    restart-service $service -force
#	Write-Log -level "Info" -message "Restarting the SQL Service"
#}

#get-service | ?{$_.Name -eq "mssqlserver" -or $_.Name -like 'MSSQL$*'} | restart-service -force
get-service | ?{$_.Name -eq $serviceName} | restart-service -force
Write-Log -level "Info" -message "Restarting the SQL Service: $serviceName"

#get-service | ?{$_.Name -eq $agentService} | restart-service -force
#Write-Log -level "Info" -message "Restarting the SQL Agent Service: $agentService"

# while (([array](get-service | ?{$_.Status -ne "Running"} | ?{$_.Name -eq "mssqlserver" -or $_.Name -like 'MSSQL$*'})).Count -gt 0)
# {
   # #wait
   # write-host "Waiting for SQL Service to restart"
# }
