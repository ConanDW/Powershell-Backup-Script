<#OSLWUB Open Source Lightweight Windows/Unix Backup - Copyright Cameron Day (2023)#>
<#Distrubuted under GNU GPLv2 License.#>
$linePart = "--------`r`n"
#--region Functions
function QuickLocalBackupSingle { #Option 1
    function StartDirCollection { #Function container for 
        function AddDirToColllection {
            $linePart + "--------"
            Write-Output "Please type the directories you wish to back up (Ex: C:\Users\):"
            $linePart
            Write-Output "Seperate the directories you wish to back up with a comma. (Ex: C:\Users\, C:\Program Files\)"
            $linePart + "--------"
            [string]$GetBackupDirectoriesRH = Read-Host "Directory Path(s)"
            $linePart + "--------"
            Set-Variable -Name "RequestedDirectories" -Value ($GetBackupDirectoriesRH) -Scope global -Description "Variable for Backup Directories"
        }
        AddDirToColllection 
    }
    StartDirCollection
    #TO DO FIGURE OUT HOW TO ADD MULTIPLE PATHS TO COMPRESS ARCHIVE
    [string]$DestinationPath = "C:\test"
    <#--
    [string]$Paths = $RequestedDirectories
    If (-Not (Test-Path $Paths)) {  #error catch to see if the path exists
        Throw "The source directory $Paths does not exist, please specify an existing directory"
    }
    --#>
    Robocopy.exe 
 
    $date = Get-Date -format "yyyy-MM-dd" #creates a date var to store date variable 
    Compress-Archive -Path $Paths -CompressionLevel 'Fastest' -DestinationPath "$($DestinationPath + '\' + 'backup-' + $date)" #compresses the files, sets path as the destination path then adds the word backup and the date
    Write-Host "Created backup at $($DestinationPath + '\' + 'backup-' + $date)"
    
}
function FTPConnect() {
    $SendNumberToDartFile = null
    Write-Output "Please select to upload or download the most recent backup. Select 'u' for upload or 'd' for download`r`n"
    $GetActionForFtp = Read-Host
    [ipaddress]$GetFTPAddress = Read-Host
    [securestring]$GetFTPUserName = Read-Host
    [securestring]$GetFTPPassword = Read-Host
    if ($GetActionForFtp -eq "u") {
        $SendToDartJson = [PSCustomObject]@{}
        $SendToDartJson | Add-Member -MemberType AliasProperty -Name FTPAddress -Value $GetActionForFtp
        $SendToDartJson | Add-Member -MemberType AliasProperty -Name FTPUserName -Value $GetFTPUserName
        $SendToDartJson | Add-Member -MemberType AliasProperty -Name FTPPassword -Vaue $GetFTPPassword
        $SendToDartJson | ConvertTo-Json | Out-File -FilePath ".\C:\OSLWUB"
    } elseif ($GetActionForFtp -eq "d") {
        #dont know how to interlope dart yey
    }
    
}
#--endregion Functions
#--region Script Start--
$script:RestartScript = $False
$script:firstStart = $True
if (-not(Test-Path "C:\OSLWUB")) {mkdir -Path "C:\OSLWUB"} #Check for folder path, create one if it doesn't exist
Do {
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
    #Option selection
    $linePart + "--------"
    Write-Output "Please Make A Selection:"
    $linePart + "--------"
    Write-Output "Mode 1: Quick Local Multi-Directory Backup (Backups Directory or Multiple Directories into a Compressed Zip File)"
    $linePart
    Write-Output "Mode 2: Backup to External Device (Ex: Another Internal SSD, External HDD)"
    $linePart
    Write-Output "Mode 3: Send Backup to FTP Server"
    $linePart
    Write-Output "4: Settings"
    $linePart
    Write-Output "5: Exit Script and Return to PS"
    $linePart
    Write-Output "6: Exit & Shutdown PWSH"
    try {
        " "
        $linePart + "--------"
        [Int]$OptionSelection = Read-Host "Make Selection"
        $linePart + "--------"
        " "
    }
    catch {
        Write-Error "You Must Select a Valid Option."
        StartOSLWB
    }
    $linePart
    Write-Output "You have selected $OptionSelection"
    $linePart
    switch ($OptionSelection) {
        1 {QuickLocalBackupSingle}
        3 {FTPConnect}
        5 {Exit-PSHostProcess}
        6 {Exit}
        Default {$RestartScript = $True}
    }
} Until ($RestartScript -eq $False)
#--endregion Script Start



