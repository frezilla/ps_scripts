[CmdletBinding()]
param(
    [int]$DurationMinutes = 480,
    [int]$IntervalSeconds = 300
)

if (-not ("PowerManager" -as [type])) {
    Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class Win32
{
    [DllImport("user32.dll")]
    public static extern void keybd_event(
        byte bVk,
        byte bScan,
        uint dwFlags,
        UIntPtr dwExtraInfo);
}

public static class PowerManager
{
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
"@
}


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[uint32]$ES_CONTINUOUS       = [Convert]::ToUInt32("80000000", 16)
[uint32]$ES_SYSTEM_REQUIRED  = [Convert]::ToUInt32("00000001", 16)
[uint32]$ES_DISPLAY_REQUIRED = [Convert]::ToUInt32("00000002", 16)

[uint32]$flags = `
    $ES_CONTINUOUS -bor `
    $ES_SYSTEM_REQUIRED -bor `
    $ES_DISPLAY_REQUIRED


function Invoke-MaintainActivity {
	[uint32]$result = [PowerManager]::SetThreadExecutionState($flags)
}


function Invoke-NumLockPulse {

    $initialState = [System.Windows.Forms.Control]::IsKeyLocked([System.Windows.Forms.Keys]::NumLock)

    [Win32]::keybd_event(0x90, 0x45, 0, [System.UIntPtr]::Zero)
    [Win32]::keybd_event(0x90, 0x45, 0x0002, [System.UIntPtr]::Zero)

    Start-Sleep -Milliseconds 1000

    $currentState = [System.Windows.Forms.Control]::IsKeyLocked([System.Windows.Forms.Keys]::NumLock)

    if ($currentState -ne $initialState) {
        [Win32]::keybd_event(0x90, 0x45, 0, [System.UIntPtr]::Zero)
        [Win32]::keybd_event(0x90, 0x45, 0x0002,[System.UIntPtr]::Zero)
    }
}


$ascii = @"
                  ) _     _
                 ( (^)-~-(^)
_______________,-.\_( 6 6 )__,-.________________
               'M'   \   /   'M'
             hjw      >o<

"@

$startTime = Get-Date
$endTime   = $startTime.AddMinutes($DurationMinutes)

Clear-Host
Write-Host $ascii -ForegroundColor Blue
Write-Host ""
Write-Host "Démarrage  : $startTime"
Write-Host "Fin prévue : $endTime"
Write-Host "Intervalle : $IntervalSeconds seconde(s)"
Write-Host "Appuyez sur Ctrl+C pour arrêter le script."
Write-Host ""

try {
    while ((Get-Date) -lt $endTime) {

        $originalPos = [System.Windows.Forms.Cursor]::Position

        try {
            # Déplacement imperceptible de la souris
            [System.Windows.Forms.Cursor]::Position =
                New-Object System.Drawing.Point(
                    ($originalPos.X + 1),
                    $originalPos.Y
                )

            Start-Sleep -Milliseconds 50

            # Retour à la position initiale
            [System.Windows.Forms.Cursor]::Position = $originalPos
			
        }
        finally {
            # Sécurité : garantit le retour à la position initiale
            [System.Windows.Forms.Cursor]::Position = $originalPos
        }
		
		Invoke-NumLockPulse
			
		Invoke-MaintainActivity

        Write-Host `r("Date dernière activité simulée : {0}" -f (Get-Date -Format "HH:mm:ss")) -NoNewline

        Start-Sleep -Seconds $IntervalSeconds

    }

    Write-Host ""
	Write-Host ""
    Write-Host "Durée prévue atteinte."
}
finally {
	[void][PowerManager]::SetThreadExecutionState($ES_CONTINUOUS)
	
    Write-Host ""
	Write-Host ""
    Write-Host "Script arrêté proprement à $(Get-Date)." -ForegroundColor Green
}
