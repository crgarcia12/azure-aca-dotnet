#Import-Module Az
function New-CrgarAcaDeployment {
    [CmdletBinding()]
    param (
        $Version,
        $Location,
        [switch] $WhatIf
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

function New-CrgarAcaApp1Deployment {
    [CmdletBinding()]
    param (
        $Version,
        $Location,
        [switch] $WhatIf
    )

    $params = @{
        Version = $Version;
        Location = $Location
    }
    New-AzResourceGroupDeployment `
        -Location $Location `
        -Name "$($PSCmdLet.MyInvocation.MyCommand.Name)$Version" `
        -ResourceGroupName crgar-aca-dotnet102-rg `
        -TemplateFile .\main-apponly.bicep `
        -TemplateParameterObject $params `
        -WhatIf:$WhatIf
}

function Remove-CrgarAcaDeployment {
    [CmdletBinding()]
    param (
        $Version,
        [switch] $WhatIf
    )

    Remove-AzResourceGroup -Name "crgar-aca-dotnet${Version}-rg" -WhatIf:$WhatIf -Force
}

Export-ModuleMember *