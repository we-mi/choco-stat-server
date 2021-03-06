<#
    .DESCRIPTION
        This script will return the specified data to the Client.
    .EXAMPLE
        Invoke-GetProcess.ps1 -RequestArgs $RequestArgs -Body $Body
    .NOTES
    	This will return data
#>

param(
    $RequestArgs,
    $Body
)

# This section Parses the RequestArgs Parameter

<# if ($RequestArgs -like '*&*') {
    # Split the Argument Pairs by the '&' character
    $ArgumentPairs = $RequestArgs.split('&')
    $RequestObj = New-Object System.Object
    foreach ($ArgumentPair in $ArgumentPairs) {
        # Split the Pair data by the '=' character
        $Property, $Value = $ArgumentPair.split('=')
        $RequestObj | Add-Member -MemberType NoteProperty -Name $Property -value $Value
    }

    # Edit the Area below to utilize the Values of the new Request Object
    $ProcessName = $RequestObj.Name
    $WindowTitle = $RequestObj.MainWindowTitle
    if ($RequestObj.Name) {
        $Message = Get-Process -Name $ProcessName | Where-Object {$_.Name -like "*$ProcessName*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
    else {
        $Message = Get-Process -Name $WindowTitle | Where-Object {$_.WindowTitle -like "*$WindowTitle*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
}
else {
    $Property, $ProcessName = $RequestArgs.split("=")
    $Message = Get-Process -Name $ProcessName | Select-Object ProcessName, Id, MainWindowTitle
} #>

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
Write-Host $body
$newbody = $body | ConvertFrom-Json

Remove-Module choco-stat-server -ErrorAction SilentlyContinue
Import-Module C:\Users\Michael\Documents\git\github.com\choco-stat-server\choco-stat-server.psd1

Connect-ChocoStatServerDatabase -File "C:\Users\michael\ChocoStatistics.db" | Out-Null

$all = Get-ChocoStatComputerPackage

Write-Host $newbody.PackageName
if ($newbody.ComputerName) {
    $all = $all | Where-Object { $_.ComputerName -like $newbody.ComputerName }
}

if ($newbody.PackageName) {
    $all = $all | Where-Object { $_.PackageName -like $newbody.PackageName }
}

return $all