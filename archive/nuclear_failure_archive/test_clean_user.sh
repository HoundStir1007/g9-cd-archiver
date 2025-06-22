#!/bin/bash

# LEVEL 2: Clean User Test - Create fresh user to test X server
echo "🧪 LEVEL 2: Clean User Test"
echo "Creating a completely fresh user account to test X server functionality"
echo ""

# Create test user
TEST_USER="xtest"
echo "👤 Creating test user: $TEST_USER"
sudo useradd -m -s /bin/bash $TEST_USER
echo "testpass123" | sudo passwd $TEST_USER --stdin 2>/dev/null || echo "testpass123" | sudo chpasswd

# Add to required groups
sudo usermod -a -G ssl-cert,video,render,input,tty $TEST_USER

# Create fresh .xsession
sudo -u $TEST_USER tee /home/$TEST_USER/.xsession > /dev/null << 'EOF'
#!/bin/bash
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11
exec startxfce4
EOF
sudo chmod +x /home/$TEST_USER/.xsession

echo "✅ Test user created: $TEST_USER (password: testpass123)"
echo ""
echo "🎯 TEST PLAN:"
echo "1. Try RDP connection with test user"
echo "2. Server: 100.91.157.19:3389"
echo "3. Username: $TEST_USER"
echo "4. Password: testpass123"
echo ""
echo "If test user works → gmk user profile is corrupted"
echo "If test user fails → System-level X server issue" 