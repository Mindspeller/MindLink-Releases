# generate-page.ps1
# Called by CI after updating the product-specific version file.
# Reads both version files and writes index.html with correct download links.

param()

$brainlink = (Get-Content brainlink-version.txt -Raw).Trim()
$mindrove  = (Get-Content mindrove-version.txt  -Raw).Trim()

function Make-Button($label, $version, $filename) {
    if ($version -eq 'unreleased') {
        return "<span class='btn disabled'>$label &nbsp;<small>(coming soon)</small></span>"
    }
    $encoded = [Uri]::EscapeDataString($filename -replace '\{version\}', $version)
    $url = "https://github.com/Mindspeller/MindLink-Releases/releases/latest/download/$encoded"
    return "<a class='btn' href='$url'>$label &nbsp;<small>v$version</small></a>"
}

$blBtn = Make-Button "Download – Single Channel (BrainLink)" $brainlink "Mindlink Analyzer Setup {version}.exe"
$mrBtn = Make-Button "Download – 4-Channel (MindRove)"       $mindrove  "Mindlink Analyzer 4C Setup {version}.exe"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>MindLink Analyzer – Downloads</title>
  <style>
    * { box-sizing: border-box; }
    body { font-family: system-ui, sans-serif; max-width: 680px; margin: 60px auto; padding: 0 24px; color: #1a1a2e; }
    h1 { font-size: 2rem; margin-bottom: 4px; }
    .subtitle { color: #57606a; margin-bottom: 32px; }
    .card { border: 1px solid #d0d7de; border-radius: 8px; padding: 20px 24px; margin-bottom: 16px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; }
    .card-label { font-weight: 600; font-size: 15px; }
    .card-desc { color: #57606a; font-size: 13px; margin-top: 2px; }
    .btn { display: inline-block; padding: 10px 20px; background: #0969da; color: #fff; text-decoration: none; border-radius: 6px; font-size: 14px; white-space: nowrap; }
    .btn:hover { background: #0860ca; }
    .btn.disabled { background: #8c959f; cursor: default; pointer-events: none; }
    footer { margin-top: 40px; font-size: 12px; color: #8c959f; }
  </style>
</head>
<body>
  <h1>MindLink Analyzer</h1>
  <p class="subtitle">Windows 10/11 &middot; 64-bit &middot; Auto-updates after install</p>

  <div class="card">
    <div>
      <div class="card-label">Single Channel</div>
      <div class="card-desc">BrainLink headset &middot; TGAM protocol</div>
    </div>
    $blBtn
  </div>

  <div class="card">
    <div>
      <div class="card-label">4-Channel</div>
      <div class="card-desc">MindRove headset &middot; Multi-channel EEG</div>
    </div>
    $mrBtn
  </div>

  <footer>Once installed, the app updates itself automatically when new versions are released.</footer>
</body>
</html>
"@

Set-Content -Path index.html -Value $html -Encoding UTF8
Write-Host "index.html updated — BrainLink: $brainlink | MindRove: $mindrove"
