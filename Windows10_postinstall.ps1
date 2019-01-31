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
7-zip
audacity
audacity-lame
authy-desktop
awscli
chocolateygui
cpu-z
curl
docker-kitematic
docker-toolbox
etcher
ffmpeg
firefox
foxitreader
git
google-backup-and-sync
googlechrome
hwmonitor
jdk8
kubernetes-cli
kubernetes-helm
lastpass
leagueoflegends
minikube
openssh
openvpn
packer
postman
putty
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
yubico-authenticator
yubikey-manager
"@

choco install $packages -y

# Install and configure ssh-agent
"C:\Program Files\OpenSSH-Win64\install-sshd.ps1"
ssh-agent

# Upgrade all packages
choco upgrade all -y
