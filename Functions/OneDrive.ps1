function uninstallOneDrive()
{
    #Hide Ad
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force

    #Uninstall 
    [xml]$Uninstall = Get-Package -Name "Microsoft OneDrive" -ProviderName Programs -ErrorAction Ignore | ForEach-Object -Process {$_.SwidTagText}
    [xml]$Uninstall = $Uninstall.SoftwareIdentity.InnerXml
    [string]$UninstallString = $Uninstall.Meta.UninstallString
    if ($UninstallString)
    {
        Write-Verbose -Message $Localization.OneDriveUninstalling -Verbose

        Stop-Process -Name OneDrive -Force -ErrorAction Ignore
        Stop-Process -Name OneDriveSetup -Force -ErrorAction Ignore
        Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

        # Getting link to the OneDriveSetup.exe and its' argument(s)
        [string[]]$OneDriveSetup = ($UninstallString -Replace("\s*/",",/")).Split(",").Trim()
        if ($OneDriveSetup.Count -eq 2)
        {
            Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..1] -Wait
        }
        else
        {
            Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..2] -Wait
        }

        # Getting the OneDrive user folder path and removing it
        $OneDriveUserFolder = Get-ItemPropertyValue -Path HKCU:\Environment -Name OneDrive
        Remove-Item -Path $OneDriveUserFolder -Recurse -Force -ErrorAction Ignore

        # https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa
        # The system does not move the file until the operating system is restarted
        # The system moves the file immediately after AUTOCHK is executed, but before creating any paging files
        $Signature = @{
            Namespace = "WinAPI"
            Name = "DeleteFiles"
            Language = "CSharp"
            MemberDefinition = @"
public enum MoveFileFlags
{
MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004
}
[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);
public static bool MarkFileDelete (string sourcefile)
{
return MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);
}
"@
        }

        # If there are some files or folders left in $env:LOCALAPPDATA\Temp
        if ((Get-ChildItem -Path $OneDriveUserFolder -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
        {
            if (-not ("WinAPI.DeleteFiles" -as [type]))
            {
                Add-Type @Signature
            }

            try
            {
                Remove-Item -Path $OneDriveUserFolder -Recurse -Force -ErrorAction Stop
            }
            catch
            {
                # If files are in use remove them at the next boot
                Get-ChildItem -Path $OneDriveUserFolder -Recurse -Force | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
            }
        }

        Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive, OneDriveConsumer -Force -ErrorAction Ignore
        Remove-Item -Path HKCU:\SOFTWARE\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
        Remove-Item -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
        Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction Ignore
        Remove-Item -Path $env:SystemDrive\OneDriveTemp -Recurse -Force -ErrorAction Ignore
        Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false

        # Getting the OneDrive folder path
        $OneDriveFolder = Split-Path -Path (Split-Path -Path $OneDriveSetup[0] -Parent)

        # Save all opened folders in order to restore them after File Explorer restarting
        Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
        $OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

        # Terminate File Explorer process
        TASKKILL /F /IM explorer.exe

        # Attempt to unregister FileSyncShell64.dll and remove
        $FileSyncShell64dlls = Get-ChildItem -Path "$OneDriveFolder\*\amd64\FileSyncShell64.dll" -Force
        foreach ($FileSyncShell64dll in $FileSyncShell64dlls.FullName)
        {
            Start-Process -FilePath regsvr32.exe -ArgumentList "/u /s $FileSyncShell64dll" -Wait
            Remove-Item -Path $FileSyncShell64dll -Force -ErrorAction Ignore

            if (Test-Path -Path $FileSyncShell64dll)
            {
                if (-not ("WinAPI.DeleteFiles" -as [type]))
                {
                    Add-Type @Signature
                }

                # If files are in use remove them at the next boot
                Get-ChildItem -Path $FileSyncShell64dll -Recurse -Force | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
            }
        }

        Start-Sleep -Seconds 1

        # Restoring closed folders
        Start-Process -FilePath explorer

        foreach ($OpenedFolder in $OpenedFolders)
        {
            if (Test-Path -Path $OpenedFolder)
            {
                Invoke-Item -Path $OpenedFolder
            }
        }

        Remove-Item -Path $OneDriveFolder -Recurse -Force -ErrorAction Ignore
        Remove-Item -Path $env:LOCALAPPDATA\OneDrive -Recurse -Force -ErrorAction Ignore
        Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
        Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force -ErrorAction Ignore
    }
}