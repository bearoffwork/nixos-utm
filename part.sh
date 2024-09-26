disk="vda"

sgdisk -Z "/dev/$disk"
sgdisk -o "/dev/$disk"
# 600M boot
sgdisk -n 1::+600M -t 1:ef00 -p "/dev/$disk"
# 100G nix
sgdisk -n 2::+100G -t 2:8300 -p "/dev/$disk"
# 60G home
sgdisk -n 3::+60G -t 3:8300 -p "/dev/$disk"
# rest for root
sgdisk -n 4:: -t 4:8300 -p "/dev/$disk"

# make filesystem
mkfs.vfat -F32 -n "EFI" /dev/"$disk"1
mkfs.xfs /dev/"$disk"2
mkfs.xfs /dev/"$disk"3
mkfs.xfs /dev/"$disk"4

# mount to /mnt for install
mount /dev/"$disk"4 /mnt
mount -m /dev/"$disk"1 /mnt/boot
mount -m /dev/"$disk"2 /mnt/nix
mount -m /dev/"$disk"3 /mnt/home

nixos-generate-config --root /mnt

# export NIX_CONFIG="extra-experimental-features = nix-command flakes"

# linux 安裝的時候其實只是把東西複製到新的根目錄(/)
# 通常預設是 /mnt 當作新的根目錄(/)

# 所以磁碟這樣切的話
# /dev/vda1 -> /boot 
# /dev/vda2 -> /nix
# /dev/vda3 -> /home 
# /dev/vda4 -> / 

# 先 mount vda4 /mnt
# 然後把其他資料夾 mount 到 /mnt
# mount /dev/vda1 -> /mnt/boot 
# mount /dev/vda2 -> /mnt/nix
# mount /dev/vda3 -> /mnt/home

# 安裝的時候會把東西都裝到 /mnt 底下
# 重開機之後 / 就會指到 /dev/vda4
