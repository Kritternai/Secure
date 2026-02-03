#!/bin/bash
# Script to setup sudo password for kasm_user in Kali Linux container
# Run this script from your Mac terminal

echo "Setting up sudo password for Kali Linux container..."
echo ""

# Method 1: Try using usermod (works better in containers)
echo "Method 1: Using usermod to set password..."
docker exec -it --user root attacker-kali bash -c "usermod -p \$(openssl passwd -1 password) kasm_user" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Password set successfully for kasm_user using usermod"
else
    echo "✗ Method 1 failed, trying alternative method..."
    
    # Method 2: Use passwd with expect or direct password hash
    echo "Method 2: Setting password using passwd with password hash..."
    docker exec -it --user root attacker-kali bash -c "echo 'kasm_user:\$1\$salt123\$password_hash' | chpasswd -e" 2>/dev/null || \
    docker exec -it --user root attacker-kali bash -c "usermod -p '\$1\$salt123\$password_hash' kasm_user" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓ Password set using alternative method"
    else
        echo "⚠ Warning: Automatic password setup failed"
        echo "You may need to set password manually inside the container"
    fi
fi

# Set password for root using usermod
echo "Setting password for root..."
docker exec -it --user root attacker-kali bash -c "usermod -p \$(openssl passwd -1 password) root" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Password set successfully for root"
else
    echo "⚠ Root password setup failed, but you can use root user directly"
fi

echo ""
echo "Alternative: Use root user directly (no password needed)"
echo "Run: docker exec -it --user root attacker-kali bash"
echo ""
echo "Or set password manually inside Kali container:"
echo "1. Enter Kali container: docker exec -it --user root attacker-kali bash"
echo "2. Run: passwd kasm_user"
echo "3. Enter password when prompted"

