#!/bin/bash

echo "🚀 Setting up 4TB M.2 SSD (nvme1n1)..."
echo "====================================="

# Safety check
echo "⚠️  WARNING: This will FORMAT /dev/nvme1n1 (4TB SSD)"
echo "All data on this drive will be ERASED!"
echo ""
read -p "Are you sure you want to continue? (type 'YES' to proceed): " confirm

if [ "$confirm" != "YES" ]; then
    echo "❌ Operation cancelled. Exiting safely."
    exit 1
fi

echo ""
echo "🔧 Step 1: Creating partition table and partition..."
sudo parted /dev/nvme1n1 --script mklabel gpt
sudo parted /dev/nvme1n1 --script mkpart primary ext4 0% 100%

echo ""
echo "💾 Step 2: Formatting with ext4 filesystem..."
sudo mkfs.ext4 -F /dev/nvme1n1p1 -L "4TB-Internal"

echo ""
echo "📁 Step 3: Creating mount point..."
sudo mkdir -p /mnt/4tb-internal

echo ""
echo "🔗 Step 4: Mounting the drive..."
sudo mount /dev/nvme1n1p1 /mnt/4tb-internal

echo ""
echo "👤 Step 5: Setting ownership..."
sudo chown $USER:$USER /mnt/4tb-internal
sudo chmod 755 /mnt/4tb-internal

echo ""
echo "💾 Step 6: Adding to /etc/fstab for permanent mounting..."
UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1p1)
echo "UUID=$UUID /mnt/4tb-internal ext4 defaults 0 2" | sudo tee -a /etc/fstab

echo ""
echo "✅ Setup complete! Verifying..."
echo "================================"
df -h /mnt/4tb-internal
echo ""
echo "🎯 Your 4TB SSD is ready at: /mnt/4tb-internal"
echo "📦 Next: Data migration from external drives (1.315TB)" 