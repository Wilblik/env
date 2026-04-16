$distro = "archlinux"
$setupScriptUrl = "https://raw.githubusercontent.com/Wilblik/env/master/scripts/setup-arch.sh"
$targetUser = "wilblik"

Write-Host "Initiating WSL provisioning for $distro..." -ForegroundColor Cyan

wsl --install $distro --no-launch

Start-Sleep -Seconds 3

$installedDistros = (wsl.exe --list --quiet) -replace "`0", "" -replace "\r", ""

if ($installedDistros -contains $distro)
{
    Write-Host "`n$distro is successfully registered and active." -ForegroundColor Green
    Write-Host "Setting up $distro..." -ForegroundColor Cyan
        
    $downloadCmd = "curl -sL '$setupScriptUrl' -o /tmp/setup-arch.sh"
    wsl.exe -d $distro -u root -- bash -c $downloadCmd
    
    $execCmd = "bash /tmp/setup-arch.sh --wsl --user $targetUser"
    wsl.exe -d $distro -u root -- bash -c $execCmd
        
    if ($LASTEXITCODE -ne 0) 
    {    
        Write-Host "Error: $distro setup failed with exit code $LASTEXITCODE." -ForegroundColor Red                    
        exit $LASTEXITCODE
    }
    
    Write-Host "Setup complete." -ForegroundColor Green
}
else
{
    Write-Host "`nInstallation initiated, but $distro is not yet registered." -ForegroundColor Yellow
    Write-Host "Please restart Windows and run this script again." -ForegroundColor Red
}
