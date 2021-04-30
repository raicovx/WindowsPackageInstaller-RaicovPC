#Some Discussion about Out-Null / Pipe performance - removed pipes to shave some milliseconds
#https://stackoverflow.com/questions/5260125/whats-the-better-cleaner-way-to-ignore-output-in-powershell

#Nice config script
#https://github.com/farag2/Windows-10-Sophia-Script

#Ryzen Master - https://download.amd.com/Desktop/AMD-Ryzen-Master.exe
#MSI Afterburner - https://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip
#Samsung Magician - https://www.samsung.com/semiconductor/minisite/ssd/download/tools/



#Requires -RunAsAdministrator

. .\Functions\OneDrive.ps1
. .\Functions\WSL.ps1
. .\Functions\MinorTweaks.ps1

#--------------------------
# Tweaks
#--------------------------
tweakMinorSettings

#--------------------------
#Install WSL
#--------------------------
installWSL
installWSL2

#--------------------------
# Browsers
#--------------------------
Out-Null -InputObject (winget install --id Google.Chrome -e -h )
if( $? ){
    Write-Output "Google Chrome installed successfully"
}

Out-Null -InputObject (winget install --id VivaldiTechnologies.Vivaldi -e -h)
if( $? ){
    Write-Output "Vivaldi installed successfully"
}

Out-Null -InputObject (winget install --id Mozilla.Firefox -e -h)
if( $? ){
    Write-Output "Firefox installed successfully"
}

#--------------------------
# Productivity
#--------------------------
Out-Null -InputObject (winget install --id Microsoft.Office -e -h)
if( $? ){
    Write-Output "Microsoft Office installed successfully"
}

Out-Null -InputObject (winget install --id Microsoft.Teams -e -h)
if( $? ){
    Write-Output "Microsoft Teams installed successfully"
}

#--------------------------
# Development
#--------------------------
Out-Null -InputObject (winget install --id Microsoft.VisualStudioCode.System-x64 -e -h)
if( $? ){
    Write-Output "VS Code installed successfully"
}

Out-Null -InputObject (winget install --id Microsoft.VisualStudio.Enterprise -e -h)
if( $? ){
    Write-Output "Visual Studio Enterprise installed successfully"
}

Out-Null -InputObject (winget install --id Google.AndroidStudio -e -h) 
if( $? ){
    Write-Output "Android Studio installed successfully"
}

Out-Null -InputObject (winget install --id JetBrains.IntelliJIDEA.Community -e -h)
if( $? ){
    Write-Output "IntelliJIDEA Community installed successfully"
} 

Out-Null -InputObject (winget install --id Git.Git -e -h)
if( $? ){
    Write-Output "Git installed successfully"
}

Out-Null -InputObject (winget install --id OpenJS.NodeJS -e -h)
if( $? ){
    Write-Output "Node.JS installed successfully"
} 

Out-Null -InputObject (winget install --id Postman.Postman -e -h)
if( $? ){
    Write-Output "Postman installed successfully"
}

Out-Null -InputObject (winget install --id ApacheFriends.Xampp -e -h)
if( $? ){
    Write-Output "Xampp installed successfully"
}

Out-Null -InputObject (winget install --id Canonical.Ubuntu -e -h)
if( $? ){
    Write-Output "Ubuntu installed successfully"
}

#--------------------------
# Game Development
#--------------------------
Out-Null -InputObject (winget install --id BlenderFoundation.Blender -e -h)
if( $? ){
    Write-Output "Blender installed successfully"
} 

Out-Null -InputObject (winget install --id UnityTechnologies.UnityHub -e -h)
if( $? ){
    Write-Output "Unity Hub installed successfully"
} 

#--------------------------
# Gaming
#--------------------------
Out-Null -InputObject (winget install --id Nvidia.GeForceExperience -e -h)
if( $? ){
    Write-Output "Nvidia Geforce Experience installed successfully"
}

Out-Null -InputObject (winget install --id EpicGames.EpicGamesLauncher -e -h)
if( $? ){
    Write-Output "Epic Games Launcher installed successfully"
}

Out-Null -InputObject (winget install --id ElectronicArts.EADesktop -e -h)
if( $? ){
    Write-Output "Origin installed successfully"
}

Out-Null -InputObject (winget install --id Ubisoft.Connect -e -h)
if( $? ){
    Write-Output "Ubisoft Connect installed successfully"
}

Out-Null -InputObject (winget install --id Valve.Steam -e -h)
if( $? ){
    Write-Output "Steam installed successfully"
}

Out-Null -InputObject (winget install --id Blizzard.BattleNet -e -h)
if( $? ){
    Write-Output "Battle.net installed successfully"
}

Out-Null -InputObject (winget install --id GOG.Galaxy -e -h)
if( $? ){
    Write-Output "GOG Galaxy installed successfully"
}

Out-Null -InputObject (winget install --id Logitech.LGH -e -h)
if( $? ){
    Write-Output "Logitech Gaming Hub installed successfully"
}

Out-Null -InputObject (winget install --id Discord.Discord -e -h)
if( $? ){
    Write-Output "Discord installed successfully"
}

#--------------------------
# Media / Audio
#--------------------------
Out-Null -InputObject (winget install --id File-New-Project.EarTrumpet -e -h)
if( $? ){
    Write-Output "EarTrumpet installed successfully"
}

Out-Null -InputObject (winget install --id plex.plexmediaserver -e -h)
if( $? ){
    Write-Output "Plex Media Server installed successfully"
}

Out-Null -InputObject (winget install --id plex.Plex -e -h)
if( $? ){
    Write-Output "Plex installed successfully"
}

Out-Null -InputObject (winget install --id VideoLAN.VLC -e -h)
if( $? ){
    Write-Output "VLC installed successfully"
}

Out-Null -InputObject (winget install --id OBSProject.OBSStudio -e -h)
if( $? ){
    Write-Output "OBS Studio installed successfully"
}

#--------------------------
# Utils
#--------------------------
Out-Null -InputObject (winget install --id Google.DriveFileStream -e -h)
if( $? ){
    Write-Output "Google Drive for Windows installed successfully"
}

Out-Null -InputObject (winget install --id Microsoft.PowerToys -e -h)
if( $? ){
    Write-Output "Powertoys installed successfully"
}

Out-Null -InputObject (winget install --id Microsoft.WindowsTerminal -e -h) 
if( $? ){
    Write-Output "Windows Terminal installed successfully"
}

Out-Null -InputObject (winget install --id 7zip.7zip -e -h)
if( $? ){
    Write-Output "7Zip installed successfully"
}

Out-Null -InputObject (winget install --id NZXT.CAM -e -h)
if( $? ){
    Write-Output "NZXT CAM installed successfully"
}

Out-Null -InputObject (winget install --id Surfshark.SurfsharkVPN -e -h)
if( $? ){
    Write-Output "Surfshark installed successfully"
}

Out-Null -InputObject (winget install --id DelugeTeam.Deluge -e -h)
if( $? ){
    Write-Output "Deluge installed successfully"
}

Out-Null -InputObject (winget install --id TimKosse.FilezillaClient -e -h)
if( $? ){
    Write-Output "Filezilla installed successfully"
}

Out-Null -InputObject (winget install --id PuTTY.PuTTY -e -h)
if( $? ){
    Write-Output "Putty installed successfully"
}

Out-Null -InputObject (winget install --id WinSCP.WinSCP -e -h)
if( $? ){
    Write-Output "WinSCP installed successfully"
}

Out-Null -InputObject (winget install --id Toinane.Colorpicker -e -h)
if( $? ){
    Write-Output "ColorPicker installed successfully"
}

#--------------------------
# Clean up scripts
#--------------------------
uninstallOneDrive