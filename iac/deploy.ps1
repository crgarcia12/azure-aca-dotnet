
# 1..10 | % {
#     Start-Job -ScriptBlock {
#         $Version = $args[0]
#         Import-Module .\crgarAcaDeployment.psm1 -Force
#         #New-CrgarAcaDeployment -Version $Version -Location "East US" -Verbose
#         #Remove-CrgarAcaDeployment -Version $Version -Verbose
#     } -ArgumentList $_
# }
#
# get-Job | receive-job -Wait

$Version = 102
Import-Module .\crgarAcaDeployment.psm1 -Force
#Remove-CrgarAcaDeployment -Version $Version -Verbose
#New-CrgarAcaDeployment -Version $Version -Location "WestEurope" -Verbose -WhatIf
New-CrgarAcaApp1Deployment  -Version $Version -Location "WestEurope" -Verbose