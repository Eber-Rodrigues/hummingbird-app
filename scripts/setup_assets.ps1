$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
New-Item -ItemType Directory -Force -Path "assets\images", "assets\audio" | Out-Null

$logo = "C:\Users\Eudo\.cursor\projects\empty-window\assets\c__Users_Eudo_AppData_Roaming_Cursor_User_workspaceStorage_empty-window_images_logo-e209b9b7-e0b4-4760-bdef-ffbf32863c6f.png"
$word = "C:\Users\Eudo\.cursor\projects\empty-window\assets\c__Users_Eudo_AppData_Roaming_Cursor_User_workspaceStorage_empty-window_images_wordmarkwhitebg-a61b6536-7b10-4a75-be02-f60c6bf15988.png"
Copy-Item $logo "assets\images\logo.png" -Force
Copy-Item $word "assets\images\wordmark.png" -Force

$path = Join-Path $root "assets\audio\alarm.wav"
$sampleRate = 22050
$seconds = 2
$samples = $sampleRate * $seconds
$dataSize = $samples * 2
$fs = [System.IO.File]::Create($path)
$bw = New-Object System.IO.BinaryWriter $fs
$bw.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
$bw.Write([int](36 + $dataSize))
$bw.Write([System.Text.Encoding]::ASCII.GetBytes("WAVEfmt "))
$bw.Write([int]16)
$bw.Write([int16]1)
$bw.Write([int16]1)
$bw.Write([int]$sampleRate)
$bw.Write([int]($sampleRate * 2))
$bw.Write([int16]2)
$bw.Write([int16]16)
$bw.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
$bw.Write([int]$dataSize)
for ($i = 0; $i -lt $samples; $i++) {
  $t = $i / $sampleRate
  $f = 740.0
  if ($t -gt 0.5) { $f = 880.0 }
  if ($t -gt 1.0) { $f = 988.0 }
  if ($t -gt 1.5) { $f = 1174.0 }
  $v = [math]::Sin(2 * [math]::PI * $f * $t) * 0.3
  $s = [int16]([math]::Round($v * 32767))
  $bw.Write($s)
}
$bw.Close()
$fs.Close()
Write-Output "assets ready"
