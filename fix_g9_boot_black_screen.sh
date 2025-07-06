#!/bin/bash
#
# G9-REBORN Boot Repair Script
# This script helps repair Ubuntu 24.04 boot issues that result in black screen with blinking cursor
# Created: January 16, 2025

# Text formatting
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

echo -e "${BOLD}${BLUE}G9-REBORN Boot Repair Tool${RESET}"
echo -e "${YELLOW}==========================${RESET}"
echo "This script helps fix black screen boot issues on Ubuntu 24.04"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (use sudo)${RESET}"
  exit 1
fi

# Function to identify NVMe drives
identify_drives() {
  echo -e "${BLUE}Identifying available drives...${RESET}"
  lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,MODEL
  echo
  
  # Try to find target NVMe drives
  if [ -b /dev/nvme1n1p2 ]; then
    echo -e "${GREEN}Found target drive /dev/nvme1n1p2 (likely your 4TB iDSONiX drive)${RESET}"
    ROOT_PART="/dev/nvme1n1p2"
    EFI_PART="/dev/nvme1n1p1"
  else
    echo -e "${YELLOW}Could not auto-detect target drives${RESET}"
    echo -e "Please enter the root partition device (e.g., /dev/nvme1n1p2):"
    read ROOT_PART
    echo -e "Please enter the EFI partition device (e.g., /dev/nvme1n1p1):"
    read EFI_PART
  fi
}

# Function to mount partitions
mount_partitions() {
  echo -e "${BLUE}Mounting partitions...${RESET}"
  
  # Create mount points
  mkdir -p /mnt/ubuntu
  mkdir -p /mnt/ubuntu/boot/efi
  
  # Mount root partition
  mount $ROOT_PART /mnt/ubuntu
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to mount root partition. Exiting.${RESET}"
    exit 1
  fi
  
  # Mount EFI partition
  mount $EFI_PART /mnt/ubuntu/boot/efi
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to mount EFI partition. Unmounting root and exiting.${RESET}"
    umount /mnt/ubuntu
    exit 1
  fi
  
  echo -e "${GREEN}Partitions mounted successfully!${RESET}"
}

# Function to check fstab
check_fstab() {
  echo -e "${BLUE}Checking fstab configuration...${RESET}"
  
  if [ -f /mnt/ubuntu/etc/fstab ]; then
    echo -e "${GREEN}fstab exists. Contents:${RESET}"
    cat /mnt/ubuntu/etc/fstab
  else
    echo -e "${RED}fstab file is missing! Creating it now...${RESET}"
    
    # Get UUIDs
    ROOT_UUID=$(blkid -s UUID -o value $ROOT_PART)
    EFI_UUID=$(blkid -s UUID -o value $EFI_PART)
    
    # Create fstab file
    cat > /mnt/ubuntu/etc/fstab << EOL
# /etc/fstab: static file system information
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed.
#
# <file system>                           <mount point>  <type>  <options>  <dump>  <pass>
UUID=$ROOT_UUID  /              ext4    defaults   0       1
UUID=$EFI_UUID   /boot/efi      vfat    umask=0077 0       1
EOL
    
    echo -e "${GREEN}Created new fstab file with correct UUIDs.${RESET}"
  fi
}

# Function to set up chroot environment
setup_chroot() {
  echo -e "${BLUE}Setting up chroot environment...${RESET}"
  
  mount --bind /dev /mnt/ubuntu/dev
  mount --bind /proc /mnt/ubuntu/proc
  mount --bind /sys /mnt/ubuntu/sys
  
  echo -e "${GREEN}Chroot environment prepared.${RESET}"
}

# Function to update GRUB
update_grub() {
  echo -e "${BLUE}Updating GRUB configuration...${RESET}"
  
  chroot /mnt/ubuntu update-grub
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to update GRUB. Continuing anyway...${RESET}"
  fi
  
  chroot /mnt/ubuntu grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu --recheck
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to reinstall GRUB. Check for errors above.${RESET}"
  else
    echo -e "${GREEN}GRUB updated and reinstalled successfully!${RESET}"
  fi
}

# Function to fix graphics driver issues
fix_graphics() {
  echo -e "${BLUE}Adding nomodeset parameter to GRUB for graphics compatibility...${RESET}"
  
  # Update GRUB defaults
  sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"/' /mnt/ubuntu/etc/default/grub
  
  chroot /mnt/ubuntu update-grub
  echo -e "${GREEN}Added nomodeset parameter to help with graphics compatibility.${RESET}"
}

# Function to check and update EFI boot entries
check_efi_entries() {
  echo -e "${BLUE}Checking EFI boot entries...${RESET}"
  
  # Install efibootmgr if not present
  if ! chroot /mnt/ubuntu which efibootmgr &>/dev/null; then
    echo -e "${YELLOW}efibootmgr not found, attempting to install...${RESET}"
    chroot /mnt/ubuntu apt-get update
    chroot /mnt/ubuntu apt-get install -y efibootmgr
  fi
  
  # Display current boot entries
  echo -e "${BLUE}Current EFI boot entries:${RESET}"
  chroot /mnt/ubuntu efibootmgr -v
  
  # Ask if user wants to modify boot order
  echo
  echo -e "${YELLOW}Do you want to modify boot order? (y/n)${RESET}"
  read modify_boot
  
  if [ "$modify_boot" = "y" ]; then
    echo -e "${YELLOW}Enter the boot numbers in order (e.g., 0003,0002,0000):${RESET}"
    read boot_order
    chroot /mnt/ubuntu efibootmgr -o $boot_order
    echo -e "${GREEN}Boot order updated.${RESET}"
  fi
}

# Function to clean up
cleanup() {
  echo -e "${BLUE}Cleaning up...${RESET}"
  
  umount /mnt/ubuntu/sys
  umount /mnt/ubuntu/proc
  umount /mnt/ubuntu/dev
  umount /mnt/ubuntu/boot/efi
  umount /mnt/ubuntu
  
  echo -e "${GREEN}Cleanup complete. You can now reboot and test.${RESET}"
}

# Main execution
echo -e "${YELLOW}Starting boot repair process...${RESET}"
identify_drives
mount_partitions
check_fstab
setup_chroot
update_grub
fix_graphics
check_efi_entries
cleanup

echo
echo -e "${BOLD}${GREEN}Boot repair process completed!${RESET}"
echo -e "${YELLOW}Next steps:${RESET}"
echo "1. Reboot the system without the USB drive"
echo "2. If still getting black screen, try accessing BIOS/UEFI settings"
echo "3. Verify boot order and disable Secure Boot if needed"
echo
echo -e "${BOLD}${BLUE}Good luck with your G9-REBORN project!${RESET}" 