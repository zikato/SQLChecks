#Requires -Modules @{ModuleName='SqlChecks';ModuleVersion='2.0';Guid='998f41a0-c4b4-4ec5-9e11-cb807d98d969'}

[CmdletBinding()]
Param(
    [string]$EntityName = $DxDefaults.EntityName
)

BeforeAll {
    if ($PSBoundParameters.Keys -contains 'EntityName') {
        Write-Verbose "User-selected entity will be used. "
    }
    else {
        Write-Verbose "Default entity will be used. "
    }

    Write-Host "Selected entity is '$EntityName' "
    Write-Host "The connection string to be used is '$($DxEntityLibrary.$EntityName.ConnectionString)' "
}

BeforeDiscovery {    
    $DxEntity = $DxEntityLibrary.$EntityName

    $ConnectionString = $DxEntity.ConnectionString

    New-Variable -Name Connect -Value @{SqlInstance = $ConnectionString}
}

Describe "Service.TraceFlags" -Tag Service.TraceFlags {
    BeforeDiscovery {
        $TraceFlagData = @{
            ServerData = Get-DxState Service.TraceFlags @Connect 
            ConfigData = $DxEntity.Service.TraceFlags 
            KeyName = 'TraceFlag'
        }
        New-Variable -Name TraceFlagCollection -Value (Join-DxConfigAndState @TraceFlagData)
    }

    It "TraceFlag: <_.Name> " -ForEach $TraceFlagCollection {
        $_.ExistsInConfig | Should -BeTrue
        $_.ExistsOnServer | Should -BeTrue
    }
}

Describe "Service.SysConfigurations " -Tag Service.SysConfigurations, SpConfigure {
    BeforeDiscovery {
        $SpConfigData = @{
            ConfigData = $DxEntity.Service.SysConfigurations 
            ServerData = Get-DxState Service.SysConfigurations @Connect 
        }

        New-Variable -Name SpConfigCollection -Value (Join-DxConfigAndState @SpConfigData)
    }

    It "SysConfiguration: '<_.Name>' " -ForEach $SpConfigCollection {
        $_.ExistsInConfig | Should -BeTrue
        $_.ExistsOnServer | Should -BeTrue
        $_.Server.Value | Should -BeExactly $_.Config.Value
        $_.Server.ValueInUse | Should -BeExactly $_.Server.Value
    }
}
