param(
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

function Read-EnvFile {
    param([string]$Path)
    $values = @{}
    if (-not (Test-Path $Path)) {
        return $values
    }
    Get-Content $Path | ForEach-Object {
        $line = $_.Trim()
        if ($line.Length -eq 0 -or $line.StartsWith("#") -or -not $line.Contains("=")) {
            return
        }
        $parts = $line.Split("=", 2)
        $values[$parts[0].Trim()] = $parts[1].Trim()
    }
    return $values
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$envValues = Read-EnvFile (Join-Path $repoRoot ".env")

$dbHost = $envValues["DB_HOST"]; if (-not $dbHost) { $dbHost = "localhost" }
$dbPort = $envValues["DB_PORT"]; if (-not $dbPort) { $dbPort = "3306" }
$dbName = $envValues["DB_NAME"]; if (-not $dbName) { $dbName = "disha_career_portal" }
$dbUser = $envValues["DB_USER"]; if (-not $dbUser) { $dbUser = "root" }
$dbPassword = $envValues["DB_PASSWORD"]; if ($null -eq $dbPassword) { $dbPassword = "" }

if (-not $SkipBuild) {
    & (Join-Path $repoRoot "build-local.bat")
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed."
    }
}

$mysql = Get-Command mysql -ErrorAction SilentlyContinue
if (-not $mysql) {
    throw "mysql CLI was not found in PATH."
}

$requiredTables = @(
    "users",
    "aptitude_questions",
    "aptitude_options",
    "assessment_attempts",
    "attempt_answers",
    "attempt_skills",
    "nepal_careers",
    "attempt_career_recs",
    "counselor_assignments",
    "parent_student_links",
    "college_programmes"
)

$quotedTables = ($requiredTables | ForEach-Object { "'" + $_ + "'" }) -join ","
$query = "SELECT table_name FROM information_schema.tables WHERE table_schema='$dbName' AND table_name IN ($quotedTables) ORDER BY table_name;"
$tableOutput = & mysql -h $dbHost -P $dbPort -u $dbUser "-p$dbPassword" -N -e $query
if ($LASTEXITCODE -ne 0) {
    throw "Database table check failed."
}

$present = @{}
$tableOutput | ForEach-Object { $present[$_.Trim()] = $true }
$missing = $requiredTables | Where-Object { -not $present.ContainsKey($_) }

if ($missing.Count -gt 0) {
    Write-Host "Missing tables:" ($missing -join ", ")
    Write-Host "Run: mysql -h $dbHost -P $dbPort -u $dbUser -p $dbName < database/migrations/2026-05-21-assessment-module.sql"
    exit 1
}

$countQuery = "SELECT (SELECT COUNT(*) FROM aptitude_questions) AS questions, (SELECT COUNT(*) FROM aptitude_options) AS options, (SELECT COUNT(*) FROM nepal_careers) AS careers;"
$counts = & mysql -h $dbHost -P $dbPort -u $dbUser "-p$dbPassword" -N -e $countQuery $dbName
if ($LASTEXITCODE -ne 0) {
    throw "Seed count check failed."
}

Write-Host "Build and database integration checks passed."
Write-Host "Seed counts: $counts"
