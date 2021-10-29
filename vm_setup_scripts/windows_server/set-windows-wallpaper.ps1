# This script sets each user's desktop background to "target_background.jpg"
# The script syntax was largely taken from: https://stackoverflow.com/questions/39002129/changing-all-users-wallpaper

# Get each folder under "Users"
$drive = (Get-Location).Drive.Root
$users = Get-ChildItem "$($drive)Users"

# For each user, load and edit their registry
foreach ( $user in $users ) {

    # If this isn't us, load their hive and set the directory
    # If this is us, use HKEY_CURRENT_USER
    if ( $user.Name -ne $env:username ) {
        reg.exe LOAD HKU\Temp "$($drive)Users\$($user.Name)\NTUSER.DAT"
        $dir = "Registry::HKEY_USERS\Temp\Control Panel\Desktop"
    }
    else {
        $dir = "Registry::HKEY_CURRENT_USER\Control Panel\Desktop"
    }

    # We don't care about users that don't have this directory
    if ( (Test-Path $dir) ) {

        # Set the image
        Set-ItemProperty -Path $dir -Name "Wallpaper" -value "$($drive)Users\Public\Pictures\target-background.png"

        # Set the style to stretch
        Set-ItemProperty -Path $dir -Name "WallpaperStyle" -value 2

    }

    # Unload user's hive
    if ( $user.Name -ne $env:username ) {
        [gc]::Collect()
        reg.exe UNLOAD HKU\Temp
    }
    rundll32.exe user32.dll, UpdatePerUserSystemParameters, 1, $true
}