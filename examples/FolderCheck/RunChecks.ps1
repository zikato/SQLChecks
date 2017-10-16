#Requires -Modules DBATools, SQLChecks

$instances = Get-ChildItem -Path .\Instances -Filter *.config.json
$configs = @()

foreach($instance in $instances) {
    [string]$configData = Get-Content -Path $instance.PSPath -Raw
    $configData | ConvertFrom-Json -OutVariable +configs | Out-Null
}
Invoke-Pester -Script @{Path='..\..\tests';Parameters= @{configs=$configs}}