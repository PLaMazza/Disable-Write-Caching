# REM Run a Powershell script to check what SSD is in use 
# Turn Drive cacheing off 
# Find the type of drive in reg path 
$DrivePath=$(Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\SCSI\Disk*" | Select-Object "name")
#$TrimmedPath=$($DrivePath.name.trim("HKEY_LOCAL_MACHINE\"))
$TrimmedPath=$($DrivePath.name.Replace('HKEY_LOCAL_MACHINE\',''))

# Find the Drive ID Path 
$DriveID=$(Get-ChildItem -Path "HKLM:\$TrimmedPath" | Select-Object "name")

# In case of multiple drives check all their paths 
Foreach ($Drive in $DriveID) { $TrimmedID=$($DriveID.name.Trim("HKEY_LOCAL_MACHINE\")) } 

# Find if reg key exists already either way set it to 0 
Foreach ($ID in $TrimmedID) {
If (Test-Path "HKLM:\$ID\Device Parameters\Disk") {
    Set-ItemProperty -Path "HKLM:\$ID\Device Parameters\Disk\" -Name "UserWriteCacheSetting" -Value 0
    write-host Key Already Present Setting Value to 0
} else {
    New-Item -Path "HKLM:\$ID\Device Parameters\Disk\"
    New-ItemProperty -Path "HKLM:\$ID\Device Parameters\Disk\" -Name "UserWriteCacheSetting" -Value 0
    New-ItemProperty -Path "HKLM:\$ID\Device Parameters\Disk\" -Name "CacheIsPowerProtected" -Value 0
    write-host Key NOT Present creating value and setting to 0
}
}
