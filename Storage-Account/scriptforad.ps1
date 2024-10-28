# Define the SafeMode Administrator Password explicitly (change the password as needed)
$Password = ConvertTo-SecureString 'Lan-main-2009' -AsPlainText -Force

# Install Active Directory Domain Services (AD DS)
$adInstall = Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Confirm:$false
if ($adInstall.Success) {
    Write-Host "AD-Domain-Services installed successfully."

    # Set the parameters for installing the new AD DS forest
    $Params = @{
        CreateDnsDelegation           = $false
        DatabasePath                  = 'C:\Windows\NTDS'
        DomainMode                    = 'WinThreshold'
        DomainName                    = 'juhayna.com'
        DomainNetbiosName             = 'juhayna'
        ForestMode                    = 'WinThreshold' # 2016 Forest Mode
        InstallDns                    = $true
        LogPath                       = 'C:\Windows\NTDS'
        NoRebootOnCompletion          = $true
        SafeModeAdministratorPassword = $Password
        SysvolPath                    = 'C:\Windows\SYSVOL'
        Force                         = $true
    }

    # Install a new AD DS forest
    $forestInstall = Install-ADDSForest @Params
    if ($forestInstall.Success) {
        Write-Host "AD DS Forest installed successfully."

        # Install the AD DS and AD LDS Tools without any prompts
        $rsatInstall = Install-WindowsFeature RSAT-ADDS -IncludeManagementTools -Confirm:$false
        if ($rsatInstall.Success) {
            Write-Host "RSAT-ADDS tools installed successfully."
        } else {
            Write-Host "Failed to install RSAT-ADDS tools." -ForegroundColor Red
        }
    } else {
        Write-Host "Failed to install AD DS Forest." -ForegroundColor Red
    }
} else {
    Write-Host "Failed to install AD-Domain-Services." -ForegroundColor Red
}

# Enforce a server restart
Write-Host "Restarting the server now..." -ForegroundColor Yellow
Restart-Computer -Force
