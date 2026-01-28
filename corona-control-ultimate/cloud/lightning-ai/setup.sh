#!/bin/bash
# =============================================================================
# Lightning AI Studio - Setup für Corona Control Ultimate
# EMPFOHLEN: 16GB RAM, Persistent, Keine Kreditkarte
# =============================================================================

set -e

echo "⚡ Lightning AI Studio Setup"
echo "============================"
echo "RAM: 16 GB | CPU: 4 vCPU | Persistent Storage"
echo ""

# 1. System Update
echo "📦 System Update..."
sudo apt update && sudo apt upgrade -y

# 2. Desktop-Umgebung installieren
echo "🖥️ Desktop-Umgebung installieren..."
sudo apt install -y \
    xfce4 xfce4-goodies \
    tightvncserver \
    websockify \
    novnc \
    dbus-x11 \
    xfonts-base \
    xfonts-75dpi \
    xfonts-100dpi

# 3. Node.js 20 installieren
echo "📗 Node.js 20 installieren..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 4. Git & Entwicklertools
echo "🔧 Entwicklertools..."
sudo apt install -y git curl wget htop nano build-essential

# 5. Projekt klonen
echo "📂 Corona Control klonen..."
if [ ! -d "/teamspace/studios/this_studio/corona-control" ]; then
    git clone https://github.com/strazzusochr/CoronaControl.git /teamspace/studios/this_studio/corona-control
fi

cd /teamspace/studios/this_studio/corona-control/corona-control-ultimate

# 6. Dependencies installieren
echo "📦 NPM Dependencies..."
npm install

# 7. VNC einrichten
echo "🔐 VNC Password setzen..."
mkdir -p ~/.vnc
echo "antigravity" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# 8. VNC Startup Script erstellen
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# 9. Start-Script erstellen
cat > ~/start_desktop.sh << 'EOF'
#!/bin/bash
# VNC Server stoppen falls läuft
vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

# VNC starten
vncserver :1 -geometry 1920x1080 -depth 24

# NoVNC starten (Port 6080)
websockify --web=/usr/share/novnc 6080 localhost:5901 &

echo ""
echo "✅ Desktop gestartet!"
echo "📺 Öffne Port 6080 im Lightning AI Port Viewer"
echo "🔑 VNC Password: antigravity"
EOF
chmod +x ~/start_desktop.sh

# 10. Game-Server Start Script
cat > ~/start_game.sh << 'EOF'
#!/bin/bash
cd /teamspace/studios/this_studio/corona-control/corona-control-ultimate
npm run dev -- --host 0.0.0.0 --port 3000
EOF
chmod +x ~/start_game.sh

echo ""
echo "============================================="
echo "✅ LIGHTNING AI SETUP ABGESCHLOSSEN!"
echo "============================================="
echo ""
echo "🖥️ Desktop starten:  ~/start_desktop.sh"
echo "🎮 Game starten:     ~/start_game.sh"
echo ""
echo "📺 Im Lightning AI Port Viewer:"
echo "   - Port 6080 öffnen für Desktop"
echo "   - Port 3000 öffnen für Game"
echo ""
echo "🔑 VNC Password: antigravity"
echo "============================================="
