# install_offline.ps1 — 在新電腦用隨身碟離線重建 AI 環境（不必再上網下載套件與模型）
# 用法：插上隨身碟，以 PowerShell 執行（路徑換成隨身碟上的位置）
#   powershell -ExecutionPolicy Bypass -File E:\AI離線包\install_offline.ps1 -Part voice
#   -Part voice ：Voice／BreezeTTS／BreezyVoice（台詞配音、聽寫）
#   -Part video ：H3（ComfyUI＋影像模型）
#   -Part all   ：兩者都裝
#   -AddPath    ：把 C:\AI\_bin（uv、ffmpeg）加進「使用者」PATH
# 前提：Windows 11 64 位元、NVIDIA 顯卡、驅動支援 CUDA 13（nvidia-smi 右上角 ≥ 13.0）、C 槽空間足夠。
param(
    [ValidateSet('voice', 'video', 'all')][string]$Part = 'all',
    [switch]$AddPath
)
$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$repo = Join-Path $src 'repo-16gvram-32gram'
$req = Join-Path $repo 'setup\env'

# 1. 前置檢查
if (-not (Get-Command nvidia-smi -ErrorAction SilentlyContinue)) { throw '找不到 nvidia-smi：請先安裝 NVIDIA 驅動' }
nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv
$freeGB = [math]::Round((Get-PSDrive C).Free / 1GB)
Write-Host "C 槽可用 $freeGB GB"

function Copy-Tree($from, $to, [string[]]$extra) {
    robocopy $from $to /E /R:2 /W:5 /NFL /NDL /NP /MT:8 @extra | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy 失敗（$LASTEXITCODE）：$from" }
}

# 2. 工具與 Python 放到 C:\AI\_bin、C:\AI\_python（不必另裝 Python／uv／ffmpeg）
Copy-Tree (Join-Path $src 'bin') 'C:\AI\_bin' @()
Copy-Tree (Join-Path $src 'uv-python') 'C:\AI\_python' @()
$uv = 'C:\AI\_bin\uv.exe'
$py312 = (Get-ChildItem 'C:\AI\_python' -Directory -Filter 'cpython-3.12.*' | Select-Object -First 1).FullName + '\python.exe'
$py310 = (Get-ChildItem 'C:\AI\_python' -Directory -Filter 'cpython-3.10.*' -ErrorAction SilentlyContinue | Select-Object -First 1).FullName + '\python.exe'

# 3. 各環境的設定：資料夾、Python 版本、套件清單、torch 來源、用哪份快取
$envs = @(
    @{ Name = 'Voice';       Py = $py312; Req = 'requirements_voice_venv.txt';       Cu = 'cu130'; Part = 'voice' },
    @{ Name = 'BreezeTTS';   Py = $py312; Req = 'requirements_breeze_venv.txt';      Cu = 'cu128'; Part = 'voice' },
    @{ Name = 'BreezyVoice'; Py = $py310; Req = 'requirements_breezyvoice_venv.txt'; Cu = 'cu128'; Part = 'voice' },
    @{ Name = 'H3';          Py = $py312; Req = 'requirements_h3_venv.txt';          Cu = 'cu130'; Part = 'video' }
) | Where-Object { $Part -eq 'all' -or $_.Part -eq $Part }

# 4. 程式碼與模型：整包複製回 C:\AI（隨身碟上的 AI\ 已不含 venv）
foreach ($e in $envs) {
    $from = Join-Path $src "AI\$($e.Name)"
    if (-not (Test-Path $from)) { throw "隨身碟上沒有 AI\$($e.Name)，這部分還沒打包" }
    Write-Host "複製 $($e.Name) 的程式碼與模型到 C:\AI\$($e.Name) ..."
    Copy-Tree $from "C:\AI\$($e.Name)" @()
}
Copy-Tree (Join-Path $src 'AI\tools') 'C:\AI\tools' @()

# 5. 離線重建 venv：照原本的套件清單，只從隨身碟的快取安裝（--offline 保證不連網）
foreach ($e in $envs) {
    $venv = "C:\AI\$($e.Name)\venv"
    $vpy = "$venv\Scripts\python.exe"
    $env:UV_CACHE_DIR = Join-Path $src "uv-cache-$($e.Part)"
    Write-Host "`n=== 建立 $venv ==="
    & $uv venv --python $e.Py $venv
    $args2 = @('pip', 'install', '--offline', '--python', $vpy, '--no-deps', '-r', (Join-Path $req $e.Req),
               '--extra-index-url', "https://download.pytorch.org/whl/$($e.Cu)", '--index-strategy', 'unsafe-best-match')
    if ($e.Name -eq 'BreezyVoice') {
        # BreezyVoice 要先有舊版 setuptools，openai-whisper 才能用 --no-build-isolation 建置
        & $uv pip install --offline --python $vpy 'setuptools<70' wheel
        $args2 += '--no-build-isolation'
    }
    & $uv @args2
    if ($LASTEXITCODE -ne 0) { throw "$($e.Name) 套件安裝失敗（見上方訊息）" }
}
Remove-Item Env:UV_CACHE_DIR -ErrorAction SilentlyContinue

# 6. bert-base-chinese tokenizer 放回使用者的 Hugging Face 快取
$hf = Join-Path $src 'hf-cache\models--bert-base-chinese'
if (Test-Path $hf) { Copy-Tree $hf (Join-Path $env:USERPROFILE '.cache\huggingface\hub\models--bert-base-chinese') @() }

# 7. 選用：PATH
if ($AddPath) {
    $p = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($p -notlike '*C:\AI\_bin*') { [Environment]::SetEnvironmentVariable('Path', "C:\AI\_bin;$p", 'User') }
    Write-Host '已把 C:\AI\_bin 加進使用者 PATH（重開 PowerShell 才生效）'
}

# 8. 驗證（手冊的確認指令）
Write-Host "`n=== 驗證 ==="
foreach ($e in $envs) {
    $vpy = "C:\AI\$($e.Name)\venv\Scripts\python.exe"
    Write-Host "[$($e.Name)]"
    & $vpy -c "import torch;print(torch.__version__, torch.cuda.is_available())"
}
if ($envs.Name -contains 'Voice') {
    & 'C:\AI\Voice\venv\Scripts\python.exe' -W ignore -c "import voxcpm, faster_whisper, audio_separator, stable_whisper, edge_tts;print('Voice 套件 ok')"
}
Write-Host "`n完成。每個環境都應印出 True（顯卡抓得到）。"
