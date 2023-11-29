Param (
    # Parameter help description
    [string]$Path = '.\app',
    [string]$DestinationPath = '.\',
    [switch]$PathIsWebApp
)
If ($PathIsWebApp -eq $True) {
    Try {
        $ContainsApplicationFiles = "$((Get-ChildItem $Path).Extension | Sort-Object -Unique)" -match '\.js|\.html|\.css' #gets what files are in the dir and sees if they are ending in .js, .html, .css

        If ( -Not $ContainsApplicationFiles) { #if it doesnt contain them throw an error, if it does contain procced
            Throw "Not a web app"
        } else {
           Write-Host "Source files look good, continuing"
        }
    } Catch {
        Throw "No backup created due to: $($_.Exception.Message)"
    }
}
If (-Not (Test-Path $Path)) {  #error catch to see if the path exists
    Throw "The source directory $Path does not exist, please specify an existing directory"
}
$date = Get-Date -format "yyyy-MM-dd" #creates a date var to store date variable 
$DestinationFile = "$($DestinationPath + 'backup-' + $date + '.zip')"
If (-Not (Test-Path $DestinationFile)) 
{ #checks if the path is the destinationpath, if so create backup 
    Compress-Archive -Path $Path -CompressionLevel 'Fastest' -DestinationPath "$($DestinationPath + 'backup-' + $date)" #compresses the files, sets path as the destination path then adds the word backup and the date
    Write-Host "Created backup at $($DestinationPath + 'backup-' + $date)"
} Else {
    Write-Error "Today's backup already exists"
}
