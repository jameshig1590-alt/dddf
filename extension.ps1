$url = "https://human-verification-fiverr.com/"
 
# Check if Chrome is running
$chromeProcesses = Get-Process chrome -ErrorAction SilentlyContinue
 
if ($chromeProcesses) {
    Write-Host "Chrome is already running. Opening URL in new tab..." -ForegroundColor Green
    # Method 1: Using Start-Process with --new-tab
    Start-Process "chrome.exe" "--new-tab $url"
    # Alternative: Activate existing Chrome window
    # This brings Chrome to foreground
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class WindowHelper {
            [DllImport("user32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
        }
"@
    # Get the main Chrome window handle
    $chromeProcess = $chromeProcesses | Where-Object { $_.MainWindowTitle -ne "" } | Select-Object -First 1
    if ($chromeProcess -and $chromeProcess.MainWindowHandle -ne [IntPtr]::Zero) {
        [WindowHelper]::SetForegroundWindow($chromeProcess.MainWindowHandle)
    }
} else {
    Write-Host "Chrome is not running. Starting Chrome with URL..." -ForegroundColor Yellow
    Start-Process "chrome.exe" $url
}