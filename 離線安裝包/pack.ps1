# pack.ps1 — 把本機已裝好的 AI 環境「原料」打包到隨身碟
# 用法（PowerShell）：
#   powershell -ExecutionPolicy Bypass -File pack.ps1 -Dest E:\AI離線包 -Part voice
#   -Part voice ：Voice／BreezeTTS／BreezyVoice（家裡 FrentexHome）
#   -Part video ：H3（ComfyUI＋影像模型）（學校 LIB-office）
#   -Test       ：打包後用隨身碟上的套件快取「離線」裝一個測試環境，證明換位置也能用
# 不打包 venv（venv 綁死本機路徑），到新電腦用 install_offline.ps1 離線重建。
param(
    [Parameter(Mandatory = $true)][string]$Dest,
    [Parameter(Mandatory = $true)][ValidateSet('voice', 'video')][string]$Part,
    [switch]$Test
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$repo = Join-Path (Split-Path $here -Parent) 'repo-16gvram-32gram'

# 1. 檢查：uv 不能在跑（避免快取寫一半）、隨身碟不能是 FAT32（模型單檔超過 4GB）
if (Get-Process uv -ErrorAction SilentlyContinue) { throw 'uv 還在執行，等安裝結束再打包' }
$drive = (Split-Path $Dest -Qualifier).TrimEnd(':')
$vol = Get-Volume -DriveLetter $drive
if ($vol.FileSystem -eq 'FAT32') { throw "隨身碟是 FAT32，模型單檔超過 4GB 放不下；請先格式化成 exFAT 或 NTFS" }
New-Item -ItemType Directory -Force $Dest | Out-Null

# 2. 依 Part 決定要複製的 C:\AI 子資料夾
$dirs = if ($Part -eq 'voice') { @('Voice', 'BreezeTTS', 'BreezyVoice', 'tools') } else { @('H3', 'tools') }

# robocopy 回傳碼 0~7 都算成功
function Copy-Tree($from, $to, [string[]]$extra) {
    robocopy $from $to /E /R:2 /W:5 /NFL /NDL /NP /MT:8 @extra | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy 失敗（$LASTEXITCODE）：$from" }
}

foreach ($d in $dirs) {
    Write-Host "複製 C:\AI\$d（不含 venv）..."
    Copy-Tree "C:\AI\$d" (Join-Path $Dest "AI\$d") @('/XD', 'venv', '__pycache__')
}

# 3. uv 套件快取：voice 與 video 分開放，避免兩台的索引互相覆蓋
$cacheSrc = (& uv cache dir).Trim()
Write-Host "複製 uv 套件快取 $cacheSrc ..."
Copy-Tree $cacheSrc (Join-Path $Dest "uv-cache-$Part") @('/XD', '.tmp*')

# 4. uv 管理的 Python（3.10 給 BreezyVoice、3.12 給其他環境），新電腦就不必另裝 Python
$pySrc = Join-Path $env:APPDATA 'uv\python'
if (-not (Get-ChildItem $pySrc -Directory -Filter 'cpython-3.12.*' -ErrorAction SilentlyContinue)) {
    & uv python install 3.12 | Out-Null
}
if ($Part -eq 'voice' -and -not (Get-ChildItem $pySrc -Directory -Filter 'cpython-3.10.*' -ErrorAction SilentlyContinue)) {
    & uv python install 3.10 | Out-Null
}
Get-ChildItem $pySrc -Directory -Filter 'cpython-*' | ForEach-Object {
    Copy-Tree $_.FullName (Join-Path $Dest "uv-python\$($_.Name)") @()
}

# 5. uv.exe 與 ffmpeg／ffprobe（解開 WinGet 的捷徑，複製真正的檔案）
$bin = Join-Path $Dest 'bin'
New-Item -ItemType Directory -Force $bin | Out-Null
$uvItem = Get-Item (Get-Command uv).Source
$uvReal = if ($uvItem.Target) { @($uvItem.Target)[0] } else { $uvItem.FullName }
Copy-Item $uvReal $bin -Force
$ff = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Recurse -Filter 'ffmpeg.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($ff) { Copy-Item (Join-Path $ff.DirectoryName '*') $bin -Force } else { Write-Warning '找不到 ffmpeg，請自行把 ffmpeg.exe／ffprobe.exe 放進 bin\' }

# 6. 小東西：bert-base-chinese tokenizer（BreezyVoice 第一次執行會下載）、三師爸 repo、安裝腳本與說明
$hf = Join-Path $env:USERPROFILE '.cache\huggingface\hub\models--bert-base-chinese'
if ($Part -eq 'voice' -and (Test-Path $hf)) { Copy-Tree $hf (Join-Path $Dest 'hf-cache\models--bert-base-chinese') @() }
Copy-Tree $repo (Join-Path $Dest 'repo-16gvram-32gram') @('/XD', '.git')
Copy-Item (Join-Path $here 'install_offline.ps1'), (Join-Path $here '打包與安裝說明.md') $Dest -Force

# 7. 清單：記錄這次打包的內容與大小
$sum = Get-ChildItem $Dest -Directory | ForEach-Object {
    $gb = (Get-ChildItem $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1GB
    '{0,-28} {1,8:N2} GB' -f $_.Name, $gb
}
$log = @("打包時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm')", "來源電腦：$env:COMPUTERNAME", "部分：$Part", '') + $sum
$log | Out-File (Join-Path $Dest "打包紀錄-$Part.txt") -Encoding utf8
$log | Write-Host

# 8. 選用：離線自我測試（裝到 C:\AI\_offline_test，測完刪掉）
if ($Test) {
    $t = 'C:\AI\_offline_test'
    $py = (Get-ChildItem (Join-Path $Dest 'uv-python') -Directory -Filter 'cpython-3.12.*' | Select-Object -First 1).FullName + '\python.exe'
    $req = if ($Part -eq 'voice') { 'requirements_voice_venv.txt' } else { 'requirements_h3_venv.txt' }
    $env:UV_CACHE_DIR = Join-Path $Dest "uv-cache-$Part"
    & (Join-Path $bin 'uv.exe') venv --python $py $t
    & (Join-Path $bin 'uv.exe') pip install --offline --python "$t\Scripts\python.exe" --no-deps -r (Join-Path $repo "setup\env\$req") --extra-index-url https://download.pytorch.org/whl/cu130 --index-strategy unsafe-best-match
    $ok = $LASTEXITCODE -eq 0
    & "$t\Scripts\python.exe" -c "import torch;print('離線測試 torch', torch.__version__, torch.cuda.is_available())"
    Remove-Item $t -Recurse -Force
    Remove-Item Env:UV_CACHE_DIR
    if ($ok) { Write-Host '✅ 離線測試通過：隨身碟上的快取換位置也能安裝' } else { Write-Warning '❌ 離線測試失敗，見上方訊息' }
}
