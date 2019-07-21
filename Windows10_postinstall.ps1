<#
   This script automates the installation of various packages on Windows 10
   Last updated: 2018-12-27
#>

# Source: https://blogs.msdn.microsoft.com/virtual_pc_guy/2010/09/23/a-self-elevating-powershell-script/
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"

if ($myWindowsPrincipal.IsInRole($adminRole))
    {

    # We are running "as Administrator" - so change the title and background color to indicate this

    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"

    $Host.UI.RawUI.BackgroundColor = "DarkBlue"

    clear-host

    }
else
    {
    # We are not running "as Administrator" - so relaunch as administrator
    # Create a new process object that starts PowerShell

    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"; 

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition; 

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";
   
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess); 

    # Exit from the current, unelevated, process

    exit
}

# Run your code that needs to be elevated here

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv

# Install user-defined packages

$packages = @"
7zip.install
advanced-ip-scanner
audacity
audacity-lame
authy-desktop
awscli
chocolateygui
cmder
cpu-z
curl
docker-kitematic
docker-toolbox
etcher
ext2fsd
ffmpeg
firefox
foxitreader
git
google-backup-and-sync
googlechrome
gpg4win-vanilla
hwmonitor
jdk8
kubernetes-cli
kubernetes-helm
lastpass
minikube
netcat
openssh
openvpn
packer
postman
putty.install
python3
riot-web
rsync
slack
steam
terraform
tixati
vagrant
virtualbox
vlc
vnc-viewer
vscode
windirstat
youtube-dl
yubico-authenticator
yubikey-manager
"@

choco install $packages -y

# These are optional packages that are probably not for everyone

$optional_packages = @"
cue
leagueoflegends
onetastic
pdfsam
telegram
vdhcoapp
"@

choco install $optional_packages -y

# These packages do not have checksums that can be verified
# Install these at your own risk

$unverified_packages = @"
whatsapp
"@

choco install $unverified_packages -y --ignore-checksums

# Install and configure ssh-agent
"C:\Program Files\OpenSSH-Win64\install-sshd.ps1"
ssh-agent

# Upgrade all packages
choco upgrade all -y
