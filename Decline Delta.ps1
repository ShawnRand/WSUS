#Change server name and port number and $True if it is on SSL

$Computer = $env:COMPUTERNAME
$Domain = $env:USERDNSDOMAIN
$FQDN = "$Computer" + "." + "$Domain"
[String]$updateServer1 = $FQDN
[Boolean]$useSecureConnection = $False
[Int32]$portNumber = 8530

# Load .NET assembly

[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")

$count = 0

# Connect to WSUS Server

$updateServer = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($updateServer1,$useSecureConnection,$portNumber)

write-host "<<<Connected sucessfully >>>" -foregroundcolor "yellow"

$updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

$u=$updateServer.GetUpdates($updatescope )

foreach ($u1 in $u )

{
#if ($u1.IsDeclined -ne 'True' -and $u1.IsSuperseded -eq 'True'-and $u1.Title -like '*Defender*' ) 
if (($u1.IsDeclined -ne 'True' -and $u1.IsSuperseded -eq 'True') -Or ($u1.IsDeclined -ne 'True' -and $u1.Title -like '*Itanium*') -Or ($u1.IsDeclined -ne 'True' -and $u1.Title -like '*ARM64*') -Or ($u1.IsDeclined -ne 'True' -and $u1.Title -like '*x86*') -Or ($u1.IsDeclined -ne 'True' -and $u1.Title -like '*Preview*'))
#if ($u1.IsDeclined -eq 'False' -Or $u1.IsSuperseded -eq 'True' -Or $u1.Title -like '*Itanium*' -Or $u1.Title -like '*ARM64*'-Or $u1.Title -like '*x86*' -Or $u1.Title -like '*Preview*')

{

write-host Decline Update : $u1.Title, Is Declined: $u1.isDeclined

$u1.Decline()

$count=$count + 1

}

}

write-host Total Declined Updates: $count

trap

{

write-host "Error Occurred"

write-host "Exception Message: "

write-host $_.Exception.Message

write-host $_.Exception.StackTrace

exit

}

# EOF