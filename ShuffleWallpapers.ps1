Function Set-WallPaper($Value)
{
    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $Value
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}

if (-not (Test-Path Env:WALLPAPER_DIR)) {
    Write-Host "Please set WALLPAPER_DIR, giving up..."
    exit
}

$wallpaper_path = $Env:WALLPAPER_DIR

Write-Debug "Shuffling wallpapers, using folder $wallpaper_path"

$wallpapers = Get-ChildItem -Path $wallpaper_path -Name
$wallpaper_count = $wallpapers.Count

if ($wallpaper_count -le 1) {
    Write-Host "Need at least 2 wallpapers to operate $Env:WALLPAPER_DIR, giving up..."
    exit
}

Write-Debug "Found $wallpaper_count wallpapers in folder..."

$current_wallpaper = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\' -name wallpaper).WallPaper

Write-Debug "Current wallpaper is $current_wallpaper"

while ($true) {
    $random_selection = Get-Random -Minimum 0 -Maximum ($wallpaper_count)
    $new_wallpaper = $wallpaper_path + "\" + $wallpapers[$random_selection]
    if ($new_wallpaper -ne $current_wallpaper) {
        Write-Debug "Setting new wallpaper to $new_wallpaper"
        Set-WallPaper($new_wallpaper)
        break
    } else {
        Write-Debug "Whoops, got the current wallpaper ($new_wallpaper), trying again..."
    }
}