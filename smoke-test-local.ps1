param(
    [string]$BaseUrl,
    [string]$Password = "DishaTest123"
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

function Resolve-BaseUrl {
    param([hashtable]$EnvValues)

    if ($BaseUrl) {
        return $BaseUrl.TrimEnd("/")
    }

    $port = $EnvValues["APP_PORT"]
    if (-not $port) { $port = "8081" }

    $appName = $EnvValues["APP_NAME"]
    if (-not $appName) { $appName = "Disha" }
    $appName = $appName.Trim("/")

    return "http://localhost:$port/$appName"
}

function New-AppSession {
    return New-Object Microsoft.PowerShell.Commands.WebRequestSession
}

function Assert-Status {
    param($Response, [int]$Expected, [string]$Message)
    if ($Response.StatusCode -ne $Expected) {
        throw "$Message Expected HTTP $Expected, got HTTP $($Response.StatusCode)."
    }
}

function Assert-UrlContains {
    param($Response, [string]$ExpectedFragment, [string]$Message)
    $url = $Response.BaseResponse.ResponseUri.AbsoluteUri
    if ($url -notlike "*$ExpectedFragment*") {
        throw "$Message Expected URL to contain '$ExpectedFragment', got '$url'."
    }
}

function Assert-ContentMatches {
    param($Response, [string]$Pattern, [string]$Message)
    if ($Response.Content -notmatch $Pattern) {
        throw $Message
    }
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$envValues = Read-EnvFile (Join-Path $repoRoot ".env")
$appBaseUrl = Resolve-BaseUrl $envValues

$health = Invoke-WebRequest -UseBasicParsing -Uri "$appBaseUrl/" -TimeoutSec 5
Assert-Status $health 200 "Application health check failed."

$stamp = Get-Date -Format "yyyyMMddHHmmss"
$suffix = Get-Random -Minimum 1000 -Maximum 9999
$counselorEmail = "smoke.counselor.$stamp.$suffix@example.com"
$studentEmail = "smoke.student.$stamp.$suffix@example.com"

$counselorSession = New-AppSession
$counselorRegister = Invoke-WebRequest -UseBasicParsing -WebSession $counselorSession -Uri "$appBaseUrl/auth/register" -Method Post -Body @{
    fullName = "Smoke Counselor"
    email = $counselorEmail
    password = $Password
    confirmPassword = $Password
    role = "COUNSELOR"
    phone = "9800000001"
    address = "Kathmandu"
}
Assert-Status $counselorRegister 200 "Counselor registration failed."
Assert-UrlContains $counselorRegister "/JSP/auth/login.jsp" "Counselor registration did not reach login."

$counselorLogin = Invoke-WebRequest -UseBasicParsing -WebSession $counselorSession -Uri "$appBaseUrl/auth/login" -Method Post -Body @{
    email = $counselorEmail
    password = $Password
}
Assert-Status $counselorLogin 200 "Counselor login failed."
Assert-UrlContains $counselorLogin "/counselor/dashboard" "Counselor login did not reach dashboard."
Assert-ContentMatches $counselorLogin "Counselor Dashboard|Student Overview|Add Student" "Counselor dashboard content check failed."

$studentSession = New-AppSession
$studentRegister = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/auth/register" -Method Post -Body @{
    fullName = "Smoke Student"
    email = $studentEmail
    password = $Password
    confirmPassword = $Password
    role = "STUDENT"
    phone = "9800000002"
    address = "Kathmandu"
}
Assert-Status $studentRegister 200 "Student registration failed."
Assert-UrlContains $studentRegister "/JSP/auth/login.jsp" "Student registration did not reach login."

$studentLogin = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/auth/login" -Method Post -Body @{
    email = $studentEmail
    password = $Password
}
Assert-Status $studentLogin 200 "Student login failed."

$profile = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/profile"
Assert-Status $profile 200 "Profile page failed."
Assert-ContentMatches $profile "Profile|Account Details" "Profile page content check failed."

$decisionPlan = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/decision/plan"
Assert-Status $decisionPlan 200 "Decision planning page failed."
Assert-ContentMatches $decisionPlan "Programme Finder|Filters" "Decision planning content check failed."

$careerScores = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/career?action=retake"
Assert-Status $careerScores 200 "Career discovery page failed."
Assert-ContentMatches $careerScores "Career Fit Scores|Score Profile" "Career discovery content check failed."

$start = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/assessment/start"
Assert-Status $start 200 "Assessment start page failed."
Assert-ContentMatches $start "Answer 30 questions|stat-card-value`">30" "Assessment start page did not show the 30-question test."

$questionnaire = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/assessment/start" -Method Post
Assert-Status $questionnaire 200 "Assessment questionnaire failed."

$attemptMatch = [regex]::Match($questionnaire.Content, 'name="attemptId"\s+value="(\d+)"')
if (-not $attemptMatch.Success) {
    throw "Questionnaire did not include an attemptId."
}
$attemptId = $attemptMatch.Groups[1].Value

$optionMatches = [regex]::Matches($questionnaire.Content, 'name="q_(\d+)"\s+value="(\d+)"')
$answers = @{}
foreach ($match in $optionMatches) {
    $questionKey = "q_$($match.Groups[1].Value)"
    if (-not $answers.ContainsKey($questionKey)) {
        $answers[$questionKey] = $match.Groups[2].Value
    }
}
if ($answers.Count -ne 30) {
    throw "Expected 30 assessment questions, found $($answers.Count)."
}

$submitBody = @{ attemptId = $attemptId }
foreach ($questionKey in $answers.Keys) {
    $submitBody[$questionKey] = $answers[$questionKey]
}

$result = Invoke-WebRequest -UseBasicParsing -WebSession $studentSession -Uri "$appBaseUrl/assessment/submit" -Method Post -Body $submitBody
Assert-Status $result 200 "Assessment submit failed."
Assert-UrlContains $result "/assessment/result?attemptId=$attemptId" "Assessment submit did not reach result page."
Assert-ContentMatches $result "Assessment Result" "Result page heading check failed."
Assert-ContentMatches $result "Recommended Careers" "Result page recommendation check failed."

Write-Host "Smoke test passed."
[pscustomobject]@{
    BaseUrl = $appBaseUrl
    CounselorEmail = $counselorEmail
    StudentEmail = $studentEmail
    AttemptId = $attemptId
    QuestionCount = $answers.Count
    ResultUrl = $result.BaseResponse.ResponseUri.AbsoluteUri
    Profile = "OK"
    DecisionPlan = "OK"
    CareerDiscovery = "OK"
} | Format-List
