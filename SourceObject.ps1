#################################################################################
#
# The sample scripts are not supported under any Microsoft standard support 
# program or service. The sample scripts are provided AS IS without warranty 
# of any kind. Microsoft further disclaims all implied warranties including, without 
# limitation, any implied warranties of merchantability or of fitness for a particular 
# purpose. The entire risk arising out of the use or performance of the sample scripts 
# and documentation remains with you. In no event shall Microsoft, its authors, or 
# anyone else involved in the creation, production, or delivery of the scripts be liable 
# for any damages whatsoever (including, without limitation, damages for loss of business 
# profits, business interruption, loss of business information, or other pecuniary loss) 
# arising out of the use of or inability to use the sample scripts or documentation, 
# even if Microsoft has been advised of the possibility of such damages.
#
# Author: Thomas Rudolf (Senior Premier Field Engineer)
# Date: 2020-07-02
#
#################################################################################
param(
	[Parameter(Mandatory=$true)][string] $source,
	[string]$filename = "C:\temp\source.csv"
)

#!!! MODIFY VALUE BELOW to specified MailboxMovePublishedScopes group in OrganizationRelationship !!!
$T2Tgroup = "T2T-Migration"
#!!! MODIFY VALUE ABOVE !!!

if(!(Get-Command Get-Mailbox -ErrorAction SilentlyContinue))
{
	Write-Host "Exchange PowerShell module not loaded" -foregroundcolor red
	break
}

$mbx = Get-Mailbox $source
$email = $mbx | foreach { $_.EmailAddresses -like "smtp:*.onmicrosoft.com" } | select -First 1
$mbx | select @{name="EmailAddress";expression={$_.PrimarySmtpAddress}},ExchangeGuid,ArchiveGuid,LegacyExchangeDN,@{name="TargetAddress";expression={$email}} | export-csv $filename -NoTypeInformation
Add-DistributionGroupMember $T2Tgroup -Member $source
Invoke-Item C:\temp
