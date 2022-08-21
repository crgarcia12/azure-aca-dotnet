#Import-Module Az

function New-crgarAcaDeployment {
    [CmdletBinding()]
    param (
        $Version,
        
        $Location,
        
        [switch]
        $WhatIf
    )

    $params = @{
        Version = $Version;
        Location = $Location
    }
    New-AzSubscriptionDeployment `
        -Location $Location `
        -Name "$($PSCmdLet.MyInvocation.MyCommand.Name)$Version" `
        -TemplateFile .\main.bicep `
        -TemplateParameterObject $params `
        -WhatIf:$WhatIf
}

1..100 | % {
    Start-Job -ScriptBlock {
        New-crgarAcaDeployment -Version $_ -Location "East US" -Verbose
    }
}

