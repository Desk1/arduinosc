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
$outputFilePath = "C:\Users\guh\Documents\duckdump\hacke.txt"

# Export network information to a text file
$networkInfo | Format-Table -AutoSize | Out-File -FilePath $outputFilePath

Write-Host "Network information exported to $outputFilePath"
