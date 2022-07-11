@{
    RootModule        = 'SqlChecks.psm1'
    ModuleVersion     = '2.0.0'
    GUID              = '998f41a0-c4b4-4ec5-9e11-cb807d98d969'
    Author            = 'Timothy Addison & DBTrenches'
    Copyright         = '(c) 2017-2022 Timothy Addison & DBTrenches. All rights reserved.'
    RequiredModules   = @(
        @{
            ModuleName = 'dbatools'
            ModuleVersion = '1.1.95'
            Guid = '9d139310-ce45-41ce-8e8b-d76335aa1789'
        }
        @{
            ModuleName = 'Pester'
            ModuleVersion = '5.0'
            Guid = 'a699dea5-2c73-4616-a270-1f7abb777e71'
        }
    )
    FunctionsToExport = @(
        'Get-DxConfig'
        'Get-DxQuery'
        'Get-DxState'
        'Resolve-DxEntityConfig'
    )
    VariablesToExport = @(
        'DxDefaults'    
        'DxEntityConfig'
        'DxSqlLibrary'
        'DxProfileConfig'
        'DxTemplateConfig'
    )
}