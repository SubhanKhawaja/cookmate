# Script to package CookMate into a clean, submission-ready ZIP file

$sourceDir = $PSScriptRoot
$zipOutput = Join-Path (Split-Path $sourceDir -Parent) "CookMate_Project.zip"

Write-Host "Creating clean submission ZIP for CookMate..." -ForegroundColor Cyan

# Remove existing zip if present
if (Test-Path $zipOutput) {
    Remove-Item $zipOutput -Force
}

# Temporary staging folder
$stagingDir = Join-Path $env:TEMP ("cookmate_staging_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $stagingDir | Out-Null

# Exclude build artifacts and caches
$excludeDirs = @(".dart_tool", "build", ".idea", ".git")

Get-ChildItem -Path $sourceDir | Where-Object {
    $item = $_
    -not ($excludeDirs -contains $item.Name)
} | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $stagingDir -Recurse -Force
}

# Compress into zip
Compress-Archive -Path "$stagingDir\*" -DestinationPath $zipOutput -Force

# Clean up staging
Remove-Item -Path $stagingDir -Recurse -Force

Write-Host "Successfully generated clean submission ZIP at:" -ForegroundColor Green
Write-Host $zipOutput -ForegroundColor Yellow
