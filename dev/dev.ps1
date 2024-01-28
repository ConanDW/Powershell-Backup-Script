<#OSLPB Open Source Lightweight Powershell Backup - Copyright Cameron Day (2024)#>
<#Distrubuted under GNU GPLv2 License.#>
#region Declorations
$LinePart = "--------`r`n"
$script:GetBackupDirectoriesRH = [PSCustomObject]@{}
# Set variables to indicate value and key to set
$script:RegistryPath = 'HKCU:\Software\OSLPB\'
$script:Name         = 'OSLPB Restart Value'
$script:restartValue        = '0'
# Create the key if it does not exist
If (-NOT (Test-Path $script:RegistryPath)) {
  New-Item -Path $script:RegistryPath -Force | Out-Null
  New-ItemProperty -Path $script:RegistryPath -Name $script:Name -Value $script:restartValue -PropertyType DWORD -Force #update value
}
$script:theRegTester = Test-Path -Path $script:RegistryPath 
#New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force #update value
#endregion
#--region
function QuickLocalBackupSingle { #Option 1
    function StartDirCollection { #Function container for 
        function AddDirToColllection {
            Write-Output "Please type the directories you wish to back up (Ex: C:\Users\):"
            $LinePart
            Write-Output "Seperate the directories you wish to back up with a comma. (Ex: C:\Users\, C:\Program Files\)"
            $LinePart
            <#
            Write-Output "Do you wish to force the backup force backup? ('y' or 'n')"
            $script:ForceOrNot = Read-Host ""
            if ($script:ForceOrNot -eq "y") {
                $script:ForceOrNot = "-Force"
            } elseif ($script:ForceOrNot -eq "n") {
                $script:ForceOrNot = " "
            } else {
                while ($script:ForceOrNot -ne "y" -or " ") {
                    Write-Error "Please type 'y' or 'n'!"
                    Write-Output "Do you wish to force the backup force backup? ('y' or 'n')"
                    $script:ForceOrNot = Read-Host ""
                }
            }
            #> 
            $script:GetBackupDirectoriesRH = @()
            [string]$script:GetBackupDirectoriesRH = Read-Host "Directory Path(s)"
            #Set-Variable -Name "RequestedDirectories" -Value ($GetBackupDirectoriesRH) -Scope global -Description "Variable for Backup Directories"
        }
        AddDirToColllection 
    }
    StartDirCollection
    #TO DO FIGURE OUT HOW TO ADD MULTIPLE PATHS TO COMPRESS ARCHIVE
    [string]$DestinationPath = "C:\OSLWUB"
    <#--
    [string]$Paths = $RequestedDirectories
    If (-Not (Test-Path $Paths)) {  #error catch to see if the path exists
        Throw "The source directory $Paths does not exist, please specify an existing directory"
    }
    --#>
    try {
        Invoke-Expression "Copy-Item -Path $GetBackupDirectoriesRH -Destination $DestinationPath -Recurse $ForceOrNot -ErrorAction Inquire" -ErrorVariable CopyError
        
    } catch {

        Write-Error "Copy failed. Please try again"
        return $script:RestartScript = $True

    }
}
function uploadToFTPServer {
    param (
        $remote,
        $local
    )
    $client = New-Object System.Net.WebClient #creates a web client for the ftp transfer
    $client.Credentials = New-Object System.Net.NetworkCredential($Env:GetFTPUserName, $Env:GetFTPPassword) #sends the credintals.
    $client.UploadFile($remote, $local)
}
function FTPConnect() {
    $SendNumberToDartFile = null
    Write-Output "Please select to upload or download the most recent backup. Select 'u' for upload or 'd' for download`r`n"
    $GetActionForFtp = Read-Host
    Start-Sleep -Seconds 1
    Write-Output "Select Backup to Send (Ex: C:\test.zip)"
    $BackupFile = Read-Host
    [ipaddress]$GetFTPAddress = Read-Host
    [securestring]$Env:GetFTPUserName = Read-Host
    [securestring]$Env:GetFTPPassword = Read-Host
    if ($GetActionForFtp -eq "u") {
        uploadToFTPServer
    } elseif ($GetActionForFtp -eq "d") {
        #dont know how to interlope dart yey
    }
    
}
#--endregion Functions
Do {
        <#
        # Init PowerShell Gui
        Add-Type -AssemblyName System.Windows.Forms
        # Create a new form
        $LocalPrinterForm                    = New-Object system.Windows.Forms.Form
        # Define the size, title and background color
        $LocalPrinterForm.ClientSize         = '1920,1080'
        $LocalPrinterForm.text               = "OSLWUB Manager "
        $LocalPrinterForm.BackColor          = "#ffffff"
        # Display the form
        [void]$LocalPrinterForm.ShowDialog()
        #>
        #Option selection
        $LinePart
        Write-Output "Please Make A Selection:"
        $LinePart
        Write-Output "Mode 1: Quick Local Multi-Directory Backup (Backups Directory or Multiple Directories into a Compressed Zip File)"
        <#
        $LinePart
        Write-Output "Mode 2: Backup to External Device (Ex: Another Internal SSD, External HDD)"
        $LinePart
        Write-Output "Mode 3: Send Backup to FTP Server"
        $LinePart
        Write-Output "4: Settings"
        $LinePart
        #>
        Write-Output "5: Exit Script and Return to PS"
        $LinePart
        Write-Output "6: Exit & Shutdown PWSH"
        try {
            [Int]$OptionSelection = Read-Host "Make Selection"
        }
        catch {
            Write-Error "You Must Select a Valid Option."
        }
        $LinePart
        Write-Output "You have selected $OptionSelection"
        $LinePart
        switch ($OptionSelection) {
            1 {QuickLocalBackupSingle}
            3 {FTPConnect}
            5 {$script:restartValue = 1}
            6 {Exit}
            Default {$RestartScript = $True}
        }
    #--endregion Script Start
    
} until ($script:restartValue -eq 1)
