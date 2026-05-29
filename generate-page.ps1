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
    $resolved = $filename -replace '\{version\}', $version
    $encoded = [Uri]::EscapeDataString($resolved)
    $url = "https://github.com/Mindspeller/MindLink-Releases/releases/download/v$version/$encoded"
    return "<a class='btn' href='$url'>Download &nbsp;<small>v$version</small></a>"
}

$mlBtn = Make-Button $mindlink "Mindlink-Analyzer-Setup-{version}.exe"
$mrBtn = Make-Button $mindrove "Mindlink-Analyzer-4C-Setup-{version}.exe"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Mindspeller Releases</title>
  <link rel="icon" href="favicon.png" type="image/png">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: system-ui, -apple-system, sans-serif; background: #f6f8fa; color: #1a1a2e; min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px 20px; }
    .site-logo { height: 52px; width: auto; margin-bottom: 8px; }
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
  <img src="logo.png" alt="Mindspeller" class="site-logo">
  <p class="subtitle">Windows 10/11 &middot; 64-bit &middot; Auto-updates after install</p>

  <div class="cards">
    <div class="card">
      <img src="mindlink.png" alt="MindLink headset">
      <div class="card-title">Low End</div>
      <div class="card-desc">Macrotellect Headset<br>Press download below if you own a headset that looks like the image above.</div>
      $mlBtn
    </div>
    <div class="card">
      <img src="mindrove.png" alt="MindRove headset">
      <div class="card-title">High End</div>
      <div class="card-desc">MindRove Headset<br>Press download below if you own a headset that looks like the image above.</div>
      $mrBtn
    </div>
  </div>

  <footer>Once installed, the app checks for updates automatically.</footer>
</body>
</html>
"@

Set-Content -Path index.html -Value $html -Encoding UTF8
Write-Host "index.html updated - MindLink: $mindlink | MindRove: $mindrove"
