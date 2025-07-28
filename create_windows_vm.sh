#!/bin/bash

# Windows VM Creation Script
# Usage: ./create_windows_vm.sh [path_to_windows_iso]

echo "🖥️ Creating Windows VM for G9 server..."

# Default values
VM_NAME="windows11"
VM_DISK="/mnt/storage/vm-images/windows11.qcow2"
VM_MEMORY="4096"  # 4GB RAM
VM_CPUS="4"       # 4 CPU cores
WINDOWS_ISO="${1:-/mnt/storage/Windows11.iso}"

# Check if ISO exists
if [ ! -f "$WINDOWS_ISO" ]; then
    echo "❌ Windows ISO not found at: $WINDOWS_ISO"
    echo "💡 Please download Windows 11 ISO from Microsoft and place it at:"
    echo "   $WINDOWS_ISO"
    echo ""
    echo "🔗 Download link: https://www.microsoft.com/software-download/windows11"
    echo ""
    echo "📋 Then run: ./create_windows_vm.sh /path/to/your/windows.iso"
    exit 1
fi

# Create VM
echo "🚀 Creating Windows VM with:"
echo "   💾 Disk: $VM_DISK (100GB)"
echo "   🧠 Memory: ${VM_MEMORY}MB"
echo "   🔧 CPUs: $VM_CPUS"
echo "   📀 ISO: $WINDOWS_ISO"
echo ""

virt-install \
    --name "$VM_NAME" \
    --memory "$VM_MEMORY" \
    --vcpus "$VM_CPUS" \
    --disk path="$VM_DISK",format=qcow2,bus=virtio \
    --cdrom "$WINDOWS_ISO" \
    --os-variant win11 \
    --network network=default \
    --graphics spice,listen=0.0.0.0 \
    --video qxl \
    --channel spicevmc \
    --console pty,target_type=serial \
    --boot uefi \
    --features smm.state=on \
    --clock offset=localtime \
    --noautoconsole

echo ""
echo "🎉 Windows VM created successfully!"
echo "🖥️ You can access it via virt-manager or:"
echo "   virsh start $VM_NAME"
echo "   virt-viewer $VM_NAME"
echo ""
echo "💡 The VM will be accessible via SPICE on all interfaces"
echo "🔗 Connect from your MacBook using a SPICE client to:"
echo "   spice://100.100.71.107:5900" 