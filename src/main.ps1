<#OSLWB Open Source Lightweight Windows Backup - Copyright Cameron Day (2023)#>
<#Distrubuted under GNU GPLv2 License.#>
<#--Declorations--#>
$linePart ="------"
<#--End Declorations--#>
<#Functions Section#>
function QuickLocalBackupSingle { #Option 1
        function StartDirCollection { #Function container for 
        function AddDirToColllection {
            $linePart + "--------"
            Write-Output "Please type the directories you wish to back up (Ex: C:\Users\):"
            $linePart
            Write-Output "Seperate the directories you wish to back up with a comma. (Ex: C:\Users\, C:\Program Files\)"
            $linePart + "--------"
            " "
            $linePart + "--------"
            [string]$GetBackupDirectoriesRH = Read-Host "Directory Path(s)"
            $linePart + "--------"
            Set-Variable -Name "RequestedDirectoriesTempVar" -Value ($GetBackupDirectoriesRH) -Scope global -Description "Variable for Backup Directories"
        }
        AddDirToColllection 
    }
    StartDirCollection
    $RequestedDirectories = $RequestedDirectoriesTempVar.Split(",")
    $RequestedDirectories
    [string]$DestinationPath = "C:\test"
    [string]$Paths = $RequestedDirectories
    <#
    If (-Not (Test-Path $Paths)) {  #error catch to see if the path exists
        Throw "The source directory $Paths does not exist, please specify an existing directory"
    }
    #>
    $date = Get-Date -format "yyyy-MM-dd" #creates a date var to store date variable 
    Compress-Archive -Path $(foreach ($part in $RequestedDirectories) {}) -CompressionLevel 'Fastest' -DestinationPath "$($DestinationPath + '\' + 'backup-' + $date)" #compresses the files, sets path as the destination path then adds the word backup and the date
    Write-Host "Created backup at $($DestinationPath + '\' + 'backup-' + $date)"
    
}
<#End Functions Section#>
<#Start Section#>
$RestartScript = $False
Do {
    " "
    $linePart + "--------"
    Write-Output "Please Make A Selection:"
    $linePart + "--------"
    " "
    Write-Output "Mode 1: Quick Local Multi-Directory Backup (Backups Directories or Full Drives into a Compressed Zip File)"
    $linePart
    Write-Output "Mode 2: Backup to External Device (Ex: Another Internal SSD, External HDD)"
    $linePart
    Write-Output "Mode 3: Full Local Backup (FTP)"
    $linePart
    Write-Output "4: Settings"
    $linePart
    Write-Output "5: Exit"
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
    " "
    switch ($OptionSelection) {
        1 {QuickLocalBackupSingle}
        5 {Exit-PSHostProcess}
        6 {
            Exit 
        }
        Default {
            $RestartScript = $True
        }
    }
} Until ($RestartScript -eq $False)
<#End Start Section#>



