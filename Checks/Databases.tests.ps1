#Requires -Modules @{ModuleName='SqlChecks';ModuleVersion='2.0';Guid='998f41a0-c4b4-4ec5-9e11-cb807d98d969'}

# PsScriptAnalyzer reports false positive for $vars defined in `Discovery` not used until `It`
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]

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
    . $PSScriptRoot/Set-DxPesterVariables.ps1
}

Describe "Databases.OversizedIndexes " -Tag Databases.OversizedIndexes {
    BeforeDiscovery {
        [string[]]$Database = Get-DxDatabasesToCheck -EntityName $EntityName -Tag Databases.OversizedIndexes

        $ConfigData = $DxEntity.Databases.OversizedIndexes.AllowList | Select-Object *, @{
            Name = 'FourPartName' 
            Expression = {
                @(
                    $_.Database
                    $_.Schema
                    $_.Table
                    $_.Index
                ) -join '.'
            }
        }

        $OversizedIndexData = @{
            ServerData = Get-DxState Databases.OversizedIndexes @Connect -Database $Database
            ConfigData = $ConfigData 
            KeyName = 'FourPartName'
        }
        $OversizedIndexCollection = Join-DxConfigAndState @OversizedIndexData
    }

    It "OversizedIndex test is running " -ForEach $OversizedIndexCollection[0] {
        ($_.ExistsInConfig).Count | Should -BeExactly 1 -Because "In order to confirm the test ran, an empty object is returned from `Join-DxConfigAndState` when there is a null set on both server and config "
    }

    Context "OversizedIndex: <_.Name> " -ForEach $OversizedIndexCollection {
        It "Is properly allowlisted " {
            $_.ExistsInConfig | Should -BeTrue -Because "Oversized indexes may not exist unless they are allowlisted. "
        }
        It "Exists when it is allowlisted " {
            $Database = (Get-DxDatabasesToCheck -Tag Databases.OversizedIndexes -EntityName $EntityName)
            $_.Config.Database | Should -BeIn $Database -Because "You have allowlisted an index in a database that is not checked by config rules.  "
            $_.ExistsOnServer | Should -BeTrue -Because "Oversized indexes that are dropped from the server should be removed from the allowlist. "
        }
    }
}

Describe "Databases.DuplicateIndexes " -Tag Databases.DuplicateIndexes {
    BeforeDiscovery {
        [string[]]$Database = Get-DxDatabasesToCheck -EntityName $EntityName -Tag Databases.DuplicateIndexes

        $ConfigData = $DxEntity.Databases.DuplicateIndexes.AllowList | Select-Object *, @{
            Name = 'FourPartName' 
            Expression = {
                @(
                    $_.Database
                    $_.Schema
                    $_.Table
                    $_.Index
                ) -join '.'
            }
        }

        $DuplicateIndexesData = @{
            ServerData = Get-DxState Databases.DuplicateIndexes @Connect -Database $Database
            ConfigData = $ConfigData 
            KeyName = 'FourPartName'
        }
        $DuplicateIndexesCollection = Join-DxConfigAndState @DuplicateIndexesData
    }

    It "DuplicateIndex test is running " -ForEach $DuplicateIndexesCollection[0] {
        ($_.ExistsInConfig).Count | Should -BeExactly 1 -Because "In order to confirm the test ran, an empty object is returned from `Join-DxConfigAndState` when there is a null set on both server and config "
    }
    Context "DuplicateIndex: <_.Name> " -ForEach $DuplicateIndexesCollection {
        It "Is properly allowlisted " {
            $_.ExistsInConfig | Should -BeTrue -Because "Duplicate indexes that are dropped from the server should be removed from the allowlist. "
        }
        It "Exists when it is allowlisted " {
            $Database = (Get-DxDatabasesToCheck -Tag Databases.DuplicateIndexes -EntityName $EntityName)
            $_.Config.Database | Should -BeIn $Database -Because "You have allowlisted an index in a database that is not checked by config rules.  "
            $_.ExistsOnServer | Should -BeTrue -Because "Duplicate indexes that are dropped from the server should be removed from the allowlist. "
        }
    }
}