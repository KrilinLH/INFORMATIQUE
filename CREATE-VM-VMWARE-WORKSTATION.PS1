# === Configuration de la VM ===
$VMName      = "Windows-Server-2025"
$VMPath      = "C:\VMs\$VMName"
$DiskSizeGB  = 100
$RAM         = 4096
$CPU         = 2
$ISOPath     = "C:\ISOs\WS-SERVER-2025.iso"
$GuestOS     = "windows2022srv-64"

# === Chemins vers les outils VMware ===
$VMrunPath   = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"
$VDiskTool   = "C:\Program Files (x86)\VMware\VMware Workstation\vmware-vdiskmanager.exe"

# === Création du dossier de VM ===
if (-Not (Test-Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath | Out-Null
}

# === Création du disque dur .vmdk ===
$VMDKPath = "$VMPath\$VMName.vmdk"
& "$VDiskTool" -c -s ${DiskSizeGB}GB -a lsilogic -t 0 "$VMDKPath"

# === Contenu du fichier .vmx ===
$VMXPath = "$VMPath\$VMName.vmx"
$VMXContent = @"
.encoding = "UTF-8"
config.version = "8"
virtualHW.version = "16"
memsize = "$RAM"
numvcpus = "$CPU"
displayName = "$VMName"
guestOS = "$GuestOS"
nvram = "$VMName.nvram"

ide0:0.present = "TRUE"
ide0:0.fileName = "$VMName.vmdk"

ide1:0.present = "TRUE"
ide1:0.deviceType = "cdrom-image"
ide1:0.fileName = "$ISOPath"

ethernet0.present = "TRUE"
ethernet0.connectionType = "nat"
ethernet0.virtualDev = "e1000"
ethernet0.addressType = "generated"

usb.present = "TRUE"
sound.present = "TRUE"
sound.virtualDev = "hdaudio"
floppy0.present = "FALSE"
"@

$VMXContent | Set-Content -Path $VMXPath -Encoding ASCII

# === Démarrage de la VM ===
& "$VMrunPath" start "$VMXPath"

Write-Host "✅ VM '$VMName' creee et demarree avec succes."