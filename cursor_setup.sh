#!/bin/bash
mkdir -p ~/Applications
mv ~/Downloads/Cursor-1.2.1-x86_64.AppImage ~/Applications/cursor.AppImage
chmod +x ~/Applications/cursor.AppImage

mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/cursor.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Name=Cursor AI IDE
Exec=/home/mark/Applications/cursor.AppImage --no-sandbox
Icon=/home/mark/Applications/cursor.png
Type=Application
Categories=Development;
Comment=Cursor AI IDE
Terminal=false
DESKTOP_EOF

curl -L "https://us1.discourse-cdn.com/flex020/uploads/cursor1/original/2X/a/a4f78589d63edd61a2843306f8e11bad9590f0ca.png" -o ~/Applications/cursor.png

cat > ~/Applications/cursor << 'LAUNCHER_EOF'
#!/bin/bash
/home/mark/Applications/cursor.AppImage --no-sandbox "$@" > /dev/null 2>&1 & disown
LAUNCHER_EOF
chmod +x ~/Applications/cursor

echo 'export PATH="$HOME/Applications:$PATH"' >> ~/.bashrc
source ~/.bashrc
update-desktop-database ~/.local/share/applications/

echo "✅ Cursor setup complete!"
