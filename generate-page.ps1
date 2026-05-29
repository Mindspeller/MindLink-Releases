# generate-page.ps1
# Called by CI after updating the product-specific version file.
# Reads both version files and writes index.html with correct download links.

param()

$mindlink = (Get-Content mindlink-version.txt -Raw).Trim()
$mindrove = (Get-Content mindrove-version.txt  -Raw).Trim()

function Make-Button($version, $filename) {
    if ($version -eq 'unreleased') {
        return "<span class='btn disabled'>Coming Soon</span>"
    }
    $encoded = [Uri]::EscapeDataString($filename -replace '\{version\}', $version)
    $url = "https://github.com/Mindspeller/MindLink-Releases/releases/latest/download/$encoded"
    return "<a class='btn' href='$url'>Download &nbsp;<small>v$version</small></a>"
}

$mlBtn = Make-Button $mindlink "Mindlink Analyzer Setup {version}.exe"
$mrBtn = Make-Button $mindrove "Mindlink Analyzer 4C Setup {version}.exe"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>MindLink Analyzer – Downloads</title>
  <link rel="icon" href="favicon.ico" type="image/x-icon">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: system-ui, -apple-system, sans-serif; background: #f6f8fa; color: #1a1a2e; min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px 20px; }
    .logo { font-size: 1.5rem; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 6px; }
    .subtitle { color: #57606a; font-size: 14px; margin-bottom: 48px; }
    .cards { display: flex; gap: 24px; flex-wrap: wrap; justify-content: center; max-width: 760px; width: 100%; }
    .card { background: #fff; border: 1px solid #d0d7de; border-radius: 12px; padding: 28px 24px; display: flex; flex-direction: column; align-items: center; gap: 16px; width: 320px; box-shadow: 0 1px 3px rgba(0,0,0,.06); }
    .card img { width: 160px; height: 120px; object-fit: contain; }
    .card-title { font-weight: 700; font-size: 16px; text-align: center; }
    .card-desc { color: #57606a; font-size: 13px; text-align: center; line-height: 1.5; }
    .btn { display: inline-block; padding: 11px 28px; background: #0969da; color: #fff; text-decoration: none; border-radius: 8px; font-size: 14px; font-weight: 600; white-space: nowrap; margin-top: 4px; }
    .btn:hover { background: #0860ca; }
    .btn.disabled { background: #8c959f; cursor: default; pointer-events: none; }
    footer { margin-top: 48px; font-size: 12px; color: #8c959f; text-align: center; }
  </style>
</head>
<body>
  <div class="logo">MindLink Analyzer</div>
  <p class="subtitle">Windows 10/11 &middot; 64-bit &middot; Auto-updates after install</p>

  <div class="cards">
    <div class="card">
      <img src="mindlink.png" alt="MindLink Single Channel headset">
      <div class="card-title">Single Channel</div>
      <div class="card-desc">MindLink headset<br>TGAM single-channel EEG</div>
      $mlBtn
    </div>
    <div class="card">
      <img src="mindrove.png" alt="MindRove 4-channel headset">
      <div class="card-title">4-Channel</div>
      <div class="card-desc">MindRove headset<br>Multi-channel EEG</div>
      $mrBtn
    </div>
  </div>

  <footer>Once installed, the app checks for updates automatically.</footer>
</body>
</html>
"@

Set-Content -Path index.html -Value $html -Encoding UTF8
Write-Host "index.html updated — MindLink: $mindlink | MindRove: $mindrove"
