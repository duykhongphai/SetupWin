#!/bin/bash

echo "======================================"
echo "     WINDOWS AUTO SETUP (PRO)         "
echo "======================================"

# ===== CONFIG =====
APPS_FILE="apps-clean.json"
LOG_FILE="install.log"

# ===== FUNCTION =====
log() {
    echo "$1"
    echo "$1" >> $LOG_FILE
}

pause_install() {
    echo ""
    echo "👉 CẦN CÀI THỦ CÔNG: $1"
    read -p "Mở trang download? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
        start "$2"
    fi
}

install_if_not_exists() {
    winget list --id "$1" &> /dev/null
    if [ $? -ne 0 ]; then
        log "Installing $1 ..."
        winget install --id "$1" -e --accept-package-agreements --accept-source-agreements
    else
        log "$1 already installed, skipping..."
    fi
}

# ===== START =====

log "=== CHECK WINGET ==="
if ! command -v winget &> /dev/null
then
    log "❌ Winget chưa có. Cài Microsoft App Installer trước."
    exit
fi

# ===== IMPORT JSON =====
log "=== IMPORT FROM $APPS_FILE ==="
winget import -i $APPS_FILE --accept-package-agreements --accept-source-agreements

# ===== CORE DEV TOOLS =====
log "=== INSTALL CORE TOOLS ==="
install_if_not_exists "Git.Git"
install_if_not_exists "Microsoft.VisualStudioCode"
install_if_not_exists "Notepad++.Notepad++"
install_if_not_exists "7zip.7zip"

# ===== OPTIONAL (có thể lỗi nhưng thử) =====
log "=== TRY INSTALL OPTIONAL APPS ==="
install_if_not_exists "Discord.Discord"
install_if_not_exists "RARLab.WinRAR"
install_if_not_exists "voidtools.Everything"
install_if_not_exists "BlueStack.BlueStacks"

# ===== MANUAL INSTALL =====
log "=== MANUAL INSTALL REQUIRED ==="

pause_install "IDA Professional 9.2" "https://www.hex-rays.com/"
pause_install "GlassFish Server" "https://glassfish.org/"
pause_install "JDK 8u321" "https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html"
pause_install "Visual Studio Installer" "https://visualstudio.microsoft.com/"
pause_install "NetBeans 8.2" "https://archive.apache.org/dist/netbeans/"
pause_install "Java Wireless Toolkit" "https://www.oracle.com/java/technologies/"
pause_install "Cốc Cốc" "https://coccoc.com/"
pause_install "Riot Client" "https://www.riotgames.com/"

# ===== FINAL =====
log ""
log "======================================"
log "        ✅ SETUP COMPLETED            "
log "======================================"

echo ""
echo "📄 Log file: $LOG_FILE"
echo "👉 Nếu có lỗi, mở log để xem chi tiết."
