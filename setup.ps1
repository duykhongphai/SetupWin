# ======================================
#     WINDOWS AUTO SETUP (STABLE)
# ======================================

$ErrorActionPreference = "Continue"

$logFile = "$PSScriptRoot\install.log"

function Log($msg) {
    $time = Get-Date -Format "HH:mm:ss"
    $line = "[$time] $msg"
    Write-Host $line
    Add-Content -Path $logFile -Value $line
}

# ===== DOWNLOAD apps.json =====
$appsFile = "$env:TEMP\apps.json"
$appsUrl = "https://raw.githubusercontent.com/duykhongphai/SetupWin/main/apps.json"

Log "Downloading apps.json..."
try {
    Invoke-WebRequest $appsUrl -OutFile $appsFile -UseBasicParsing
} catch {
    Log "❌ Failed to download apps.json"
}

# ===== SAFE INSTALL (KHÔNG CHECK NỮA) =====
function Install-App($id) {
    Log "Installing $id ..."

    winget install --id $id -e `
        --accept-package-agreements `
        --accept-source-agreements `
        --silent `
        --disable-interactivity `
        --force

    if ($LASTEXITCODE -eq 0) {
        Log "✅ $id done"
    } else {
        Log "⚠️ $id may failed or already installed"
    }
}

function Open-Download($name, $url) {
    Write-Host ""
    Write-Host "👉 CẦN CÀI THỦ CÔNG: $name"
    $choice = Read-Host "Mở trang download? (y/n)"
    if ($choice -eq "y") {
        Start-Process $url
    }
}

# ===== CHECK WINGET =====
Log "=== CHECK WINGET ==="
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Log "❌ Winget chưa có. Cài 'App Installer' từ Microsoft Store."
    exit
}

# ===== IMPORT JSON =====
Log "=== IMPORT APPS ==="
try {
    winget import -i $appsFile `
        --accept-package-agreements `
        --accept-source-agreements
} catch {
    Log "⚠️ Import lỗi (có thể do package không tồn tại)"
}

# ===== CORE TOOLS =====
Log "=== INSTALL CORE TOOLS ==="
Install-App "Git.Git"
Install-App "Microsoft.VisualStudioCode"
Install-App "Notepad++.Notepad++"
Install-App "7zip.7zip"

# ===== OPTIONAL =====
Log "=== OPTIONAL ==="
Install-App "Discord.Discord"
Install-App "RARLab.WinRAR"
Install-App "voidtools.Everything"
Install-App "BlueStack.BlueStacks"

# ===== MANUAL =====
Log "=== MANUAL INSTALL REQUIRED ==="

Open-Download "IDA Professional 9.2" "https://www.hex-rays.com/"
Open-Download "GlassFish Server" "https://glassfish.org/"
Open-Download "JDK 8u321" "https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html"
Open-Download "Visual Studio" "https://visualstudio.microsoft.com/"
Open-Download "NetBeans 8.2" "https://archive.apache.org/dist/netbeans/"
Open-Download "Java Wireless Toolkit" "https://www.oracle.com/java/technologies/"
Open-Download "Cốc Cốc" "https://coccoc.com/"
Open-Download "Riot Client" "https://www.riotgames.com/"

# ===== DONE =====
Log ""
Log "======================================"
Log "        ✅ SETUP COMPLETED            "
Log "======================================"

Write-Host ""
Write-Host "📄 Log file: $logFile"
