$Version = 109
Import-Module .\crgarAcaDeployment.psm1 -Force
#Remove-CrgarAcaDeployment -Version $Version -Verbose
New-CrgarAcaDeployment -Version $Version -Location "westeurope" -Verbose
#New-CrgarAcaDemoAppDeployment  -Version $Version -Location "WestEurope" -Verbose