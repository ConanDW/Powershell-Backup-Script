Param (
    # Parameter help description
    [Parameter(Mandatory, HelpMessage = "Please provide a valid path")]
    [string]$Path = '.\app',
    [string]$DestinationPath = '.\'
)
If (-Not (Test-Path $Path)) {  #error catch to see if the path exists
    Throw "The source directory $Path does not exist, please specify an existing directory"
}
$date = Get-Date -format "yyyy-MM-dd" #creates a date var to store date variable 
Compress-Archive -Path $Path -CompressionLevel 'Fastest' -DestinationPath ".\backup-$date" #sets desitnation (path), compressionlevel, and destination (backup-date)
Write-Host "Created backup at $('.\backup-' + $date + '.zip')" #lets user know where and what the file is called
