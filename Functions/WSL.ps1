function installWSL()
{
    $WSLFeatures = @(
		# Windows Subsystem for Linux
		"Microsoft-Windows-Subsystem-Linux",

		# Virtual Machine Platform
		"VirtualMachinePlatform"

        Enable-WindowsOptionalFeature -Online -FeatureName $WSLFeatures -NoRestart

        Write-Warning -Message $Localization.RestartWarning
	)
}

function installWSL2()
{
    $WSLFeatures = @(
		# Windows Subsystem for Linux
		"Microsoft-Windows-Subsystem-Linux",

		# Virtual Machine Platform
		"VirtualMachinePlatform"
	)
	$WSLFeaturesDisabled = Get-WindowsOptionalFeature -Online | Where-Object -FilterScript {($_.FeatureName -in $WSLFeatures) -and ($_.State -eq "Disabled")}

	if ($null -eq $WSLFeaturesDisabled)
	{
		if ((Get-Package -Name "Windows Subsystem for Linux Update" -ProviderName msi -Force -ErrorAction Ignore).Status -ne "Installed")
		{
			# Downloading and installing the Linux kernel update package
			try
			{
				if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
				{
					Write-Verbose -Message $Localization.WSLUpdateDownloading -Verbose

					$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
					$Parameters = @{
						Uri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
						OutFile = "$DownloadsFolder\wsl_update_x64.msi"
						SslProtocol = "Tls12"
						Verbose = [switch]::Present
					}
					Invoke-WebRequest @Parameters

					Write-Verbose -Message $Localization.WSLUpdateInstalling -Verbose

					Start-Process -FilePath "$DownloadsFolder\wsl_update_x64.msi" -ArgumentList "/passive" -Wait

					Remove-Item -Path "$DownloadsFolder\wsl_update_x64.msi" -Force

					Write-Warning -Message $Localization.RestartWarning
				}
			}
			catch [System.Net.WebException]
			{
				Write-Warning -Message $Localization.NoInternetConnection
				Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
				return
			}
		}
		else
		{
			# Set WSL 2 as the default architecture when installing a new Linux distribution
			wsl --set-default-version 2
		}
    }
}