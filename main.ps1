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
$outputFilePath = Joth-Path $folderPath "network.txt"

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
$outputFilePath = Joth-Path $folderPath "computer.txt"

# Create a formatted output
$output = $computerInfo | Format-Table -AutoSize | Out-String

# Export the information to a text file
$output | Out-File -FilePath $outputFilePath

Write-Host "Computer information exported to $outputFilePath"
