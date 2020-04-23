Param(
    [string]$InstallPath = "c:/work/EST"
)

Import-Module $PSScriptRoot\zip\modules\Constants.psm1 -Force;

$InstallPath

$searchBatch = Join-Path -Path $InstallPath -ChildPath $ElasticsearchConfigConstants.ElasticsearchServiceBatPath
$commandPath = Split-Path $searchBatch

& "$commandPath\elasticsearch.bat"