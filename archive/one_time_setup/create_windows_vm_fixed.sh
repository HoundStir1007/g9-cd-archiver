#!/bin/bash

# Fixed Windows VM Creation Script with proper boot configuration
echo "🔧 Creating Windows VM with corrected boot settings..."

# Configuration
VM_NAME="windows11"
VM_DISK="/mnt/storage/vm-images/windows11.qcow2"
VM_MEMORY="4096"
VM_CPUS="4"
WINDOWS_ISO="/mnt/storage/Windows11.iso"

# Check if ISO exists
if [ ! -f "$WINDOWS_ISO" ]; then
    echo "❌ Windows ISO not found at: $WINDOWS_ISO"
    exit 1
fi

# Remove existing VM if it exists
virsh undefine windows11 --remove-all-storage 2>/dev/null || true

# Ensure VM disk directory exists
mkdir -p "$(dirname "$VM_DISK")"

# Create VM with proper boot configuration
echo "🚀 Creating Windows VM with proper UEFI boot..."
virt-install \
    --name "$VM_NAME" \
    --memory "$VM_MEMORY" \
    --vcpus "$VM_CPUS" \
    --disk path="$VM_DISK",format=qcow2,bus=virtio,size=100 \
    --cdrom "$WINDOWS_ISO" \
    --os-variant win11 \
    --network network=default \
    --graphics vnc,listen=0.0.0.0,port=5900 \
    --video qxl \
    --console pty,target_type=serial \
    --boot uefi,cdrom,hd \
    --machine q35 \
    --features smm.state=on \
    --clock offset=localtime \
    --noautoconsole

echo ""
echo "🎉 Windows VM created successfully!"
echo "🔧 Boot order: CD-ROM first, then hard drive"
echo "🖥️ Access via:"
echo "   virt-manager (GUI)"
echo "   virt-viewer windows11 (Direct console)"
echo "   VNC: localhost:5900"
echo ""
echo "💡 The VM should now boot from the Windows 11 ISO!" 