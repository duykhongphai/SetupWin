# ======================================
#     WINDOWS AUTO SETUP (PRO)
# ======================================

$ErrorActionPreference = "SilentlyContinue"

# ===== DOWNLOAD apps.json =====
$appsFile = "$env:TEMP\apps.json"
$appsUrl = "https://raw.githubusercontent.com/duykhongphai/SetupWin/main/apps.json"

Log "Downloading apps.json..."
Invoke-WebRequest $appsUrl -OutFile $appsFile

$logFile = "install.log"

function Log($msg) {
    Write-Host $msg
    Add-Content -Path $logFile -Value $msg
}

function Install-IfNotExists($id) {
    $installed = winget list --id $id | Out-String
    if ($installed -notmatch $id) {
        Log "Installing $id ..."
        winget install --id $id -e --accept-package-agreements --accept-source-agreements
    } else {
        Log "$id already installed, skipping..."
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
    Log "❌ Winget chưa có. Hãy cài 'App Installer' từ Microsoft Store."
    exit
}

# ===== IMPORT JSON =====
Log "=== IMPORT FROM $appsFile ==="
winget import -i $appsFile --accept-package-agreements --accept-source-agreements

# ===== CORE TOOLS =====
Log "=== INSTALL CORE TOOLS ==="
Install-IfNotExists "Git.Git"
Install-IfNotExists "Microsoft.VisualStudioCode"
Install-IfNotExists "Notepad++.Notepad++"
Install-IfNotExists "7zip.7zip"

# ===== OPTIONAL =====
Log "=== TRY INSTALL OPTIONAL ==="
Install-IfNotExists "Discord.Discord"
Install-IfNotExists "RARLab.WinRAR"
Install-IfNotExists "voidtools.Everything"
Install-IfNotExists "BlueStack.BlueStacks"

# ===== MANUAL =====
Log "=== MANUAL INSTALL REQUIRED ==="

Open-Download "IDA Professional 9.2" "https://www.hex-rays.com/"
Open-Download "GlassFish Server" "https://glassfish.org/"
Open-Download "JDK 8u321" "https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html"
Open-Download "Visual Studio Installer" "https://visualstudio.microsoft.com/"
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
