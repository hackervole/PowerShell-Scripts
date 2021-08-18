# ShuffleWallpapers.ps1
#
# Sets the desktop wallpaper to a random image from the folder specified by
# `WALLPAPER_DIR`. This folder should -only- contain suitable image files (there
# is no filetype checking).

# Sets registry value for wallpaper filename
Function Set-WallPaper($Value)
{
    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $Value
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}

# Check that wallpaper directory is set
if (-not (Test-Path Env:WALLPAPER_DIR)) {
    Write-Host "Please set WALLPAPER_DIR, giving up..."
    exit
}

$wallpaper_path = $Env:WALLPAPER_DIR

Write-Debug "Shuffling wallpapers, using folder $wallpaper_path"

# Get list of wallpapers in directory
$wallpapers = Get-ChildItem -Path $wallpaper_path -Name
$wallpaper_count = $wallpapers.Count
Write-Debug "Found $wallpaper_count wallpapers in folder..."

if ($wallpaper_count -le 1) {
    Write-Host "Need at least 2 wallpapers to operate $Env:WALLPAPER_DIR, giving up..."
    exit
}

# Get current wallpaper
$current_wallpaper = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\' -name wallpaper).WallPaper
Write-Debug "Current wallpaper is $current_wallpaper"

while ($true) {
    # Get a random image from the folder
    $random_selection = Get-Random -Minimum 0 -Maximum ($wallpaper_count)
    $new_wallpaper = $wallpaper_path + "\" + $wallpapers[$random_selection]

    # Set the wallpaper to the new image, unless it is already the wallpaper,
    # then try again
    if ($new_wallpaper -ne $current_wallpaper) {
        Write-Debug "Setting new wallpaper to $new_wallpaper"
        Set-WallPaper($new_wallpaper)
        break
    } else {
        Write-Debug "Whoops, got the current wallpaper ($new_wallpaper), trying again..."
    }
}