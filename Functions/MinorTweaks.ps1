function tweakMinorSettings() {
    disableFeedbackRequests
    minimiseDiagnosticData
    showHiddenFiles
    showFileExtensions
    hide3dObjectsFolder
    hideWindowsInk
    hideMeetNow
    setDarkMode
    setWallpaperJPEGMaxQuality
    setExpandedTaskManagerDefault
    disableHibernate
    updateMicrosoftProductsWithWindowsUpdate
    setHighPerformancePowerCfg
    enableNumLockAtStartup
    hideBitlockerContextMenuItem
}

#Change Windows feedback frequency to "Never"
function disableFeedbackRequests() {
    if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules))
    {
        New-Item -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules -Force
    }
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules -Name NumberOfSIUFInPeriod -PropertyType DWord -Value 0 -Force
}

#Set the OS level of diagnostic data gathering to minimum
function minimiseDiagnosticData() {
    if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education"})
    {
        # Security level
        New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
    }
    else
    {
        # Optional diagnostic data
        New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force
    }
}

function showHiddenFiles(){
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force
}

function showFileExtensions(){
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force
}

#When I snap a window, do not show what I can snap next to it
function disableSnapAssist(){
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force
}


# Hide the "3D Objects" folder in "This PC" and Quick access
function hide3dObjectsFolder(){
    if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
			{
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
			}
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force
}

#Hide the Windows Ink Workspace button on the taskbar
function hideWindowsInk(){
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
}

#Hide the Meet Now icon in the notification area
function hideMeetNow(){
    $Settings = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -ErrorAction Ignore
			$Settings[9] = 128
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -PropertyType Binary -Value $Settings -Force
}

function setDarkMode(){
    #Windows dark theme
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force

    #App dark theme
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
}

function setWallpaperJPEGMaxQuality(){
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force
}

function setExpandedTaskManagerDefault(){
    $Taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore

	Start-Sleep -Seconds 1

	if ($Taskmgr)
	{
		$Taskmgr.CloseMainWindow()
	}
	Start-Process -FilePath Taskmgr.exe -PassThru

	Start-Sleep -Seconds 3

	do
	{
		Start-Sleep -Milliseconds 100
		$Preferences = Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences
	}
	until ($Preferences)

	Stop-Process -Name Taskmgr -ErrorAction Ignore

    $Preferences[28] = 0
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
}

function disableHibernate(){
    POWERCFG /HIBERNATE OFF
}

function updateMicrosoftProductsWithWindowsUpdate(){
    (New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")
}

function setHighPerformancePowerCfg(){
    POWERCFG /SETACTIVE SCHEME_MIN
}

function enableNumLockAtStartup(){
    New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force
}

function hideBitlockerContextMenuItem(){
    
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
    
}
