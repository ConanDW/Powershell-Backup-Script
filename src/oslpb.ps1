<#OSLPB Open Source Lightweight Powershell Backup - Copyright Cameron Day (2024)#>
<#Distrubuted under GNU GPLv2 License.#>
$Env:blnExit
do {
    ##region Declorations
    $LinePart = "--------`r`n"
    ##endregion Declorations
    ##region Functions
    function QuickLocalBackupSingle { #Option 1
        function StartDirCollection { #Function container for 
            function AddDirToColllection {
                Write-Output "Please type the directories you wish to back up (Ex: C:\Users\):"
                $LinePart
                Write-Output "Seperate the directories you wish to back up with a comma. (Ex: C:\Users\, C:\Program Files\)"
                $LinePart
                $script:GetBackupDirectoriesRH = @()
                $script:GetBackupDirectoriesRH = Read-Host "Directory Path(s)"
                #Set-Variable -Name "RequestedDirectories" -Value ($GetBackupDirectoriesRH) -Scope global -Description "Variable for Backup Directories"
            }
            AddDirToColllection 
        }
        StartDirCollection
        $DestinationPath = "C:\OSLPB"
        $script:GetBackupDirectoriesRH = $script:GetBackupDirectoriesRH.Split(",")
        try {
            foreach ($Path in $script:GetBackupDirectoriesRH) {
                Copy-Item -Path $Path -Destination $DestinationPath -Recurse -Force -ErrorAction Inquire
            }
        } catch {
            Write-Error "Copy failed. Please try again"
        }
    }
    ##endregion Functions
    ##region ScriptStart
    $script:restartValue = 0
    while ($script:restartValue -eq 0) {
        if (-not(Test-Path -Path "C:\OSLPB" )) {
            New-Item -ItemType Directory -Path "C:\OSLPB"
        }
        $LinePart
        Write-Output "Please Make A Selection:"
        $LinePart
        Write-Output "'1': Quick Local Multi-Directory Backup (Backups Directory or Multiple Directories into C:\OSLPB)"
        $LinePart
        Write-Output "'2': Exit"
        $LinePart
        try {
        [Int]$OptionSelection = Read-Host "Make Selection"
        }
        catch {
        if ($OptionSelection -ne "1" -or "2") {
            Write-Error "You Must Select a Valid Option."
            $script:restartValue = 1
        }
        }
        $LinePart
        Write-Output "You have selected $OptionSelection"
        $LinePart
        switch ($OptionSelection) {
            1 {
                try {
                    QuickLocalBackupSingle
                }
                catch {
                    Write-Error "Backup Failed. Restarting Script"
                }
                finally {
                    Write-Output "Backup complete unless red error appears, if read error appears backup has failed."
                    Write-Warning "Script will restart."
                    Start-Sleep 5
                    Clear-Host
                }
            }
            2 {
                $script:restartValue = 1
                Start-Sleep 2
                Clear-Host
            }
        }
    }
    ##endregion ScriptStart
} while ($Env:blnExit -eq "")