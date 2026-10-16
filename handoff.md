# 交接檔：影音生成（SEL 影集《高中生搞大事！》＋三師爸地端 AI 短片）

**最後更新**：2026-10-16 13:15 ｜ LIB-PC-004011（LIB-office；家裡 23:36 的語音進度已保留在下方）
**分工（2026-10-16 更新）**：LIB-office（LIB-PC-004011，5060 Ti 16GB 待裝＋32GB）裝**影像＋語音全套**，以便未來分派工作給 VR-1；家裡 FrentexHome（RTX 3050 8GB）做**語音**，老蔡參考音與試配都在那邊進行中。

---

## 🏠 家裡（語音）— 上次做到哪
- ✅ 語音環境全部裝好並驗證：2b `C:\AI\Voice`（torch `2.14.0+cu130 True`）、2c `C:\AI\BreezeTTS`（`2.9.1+cu128 True`，breeze-tts commit `6eba901`）、2d `C:\AI\BreezyVoice`（`2.7.1+cu128 True`，commit `d592c9d`、Python 3.10.21）、2e `C:\AI\tools`。
- ✅ 語音模型全部 VERIFIED：BreezyVoice 2.99GB、Breeze TTS 2 7.16GB、whisper large-v3 2.88GB（`download.py` 只用標準庫，用 Voice 環境的 python 跑）。
- ✅ 老蔡參考音：首選片段逐字稿「展現文化自信與學習的成果，經過多年的努力，超過九成的學生」（使用者核對正確）已寫進兩份 `film.json` 的 `chars.cai.voice_sample`（兩份 chars 驗證相同）；wav 已複製成兩軌 `out\voice\ref_cai.wav`。`.gitignore` 已加 `製作/**/out/`（原本校長聲音會被推上 GitHub）。
- ✅ 試配老蔡 2 句×4 候選（`製作\EP1_v3_黃線\out\試配\bv\cand\S24_s1~4.wav`、`S42_s1~4.wav`）：**3050 實測**載入 86 秒、每候選 6～9 秒、顯存峰值僅 2.04GB → 每軌配音約 30～40 分鐘，兩軌含 Breeze 設計約 1.5～2 小時。
- ❗ **使用者聽了不太滿意**，懷疑是參考音的背景聲；**還在想怎麼處理，尚未決定**。

## 🏠 家裡 — 下一步（等使用者決定老蔡參考音）
1. 選一個改善老蔡聲音的方法（使用者決定）：
   - (a) 改用**備案片段** `input_voice\ref_cai_備案_27.2-37.3s.wav`，逐字稿：「讓學生對自己的文化有更深的認識與認同。我們透過多元課程與創新教學，從族語」（使用者已更正「族語」）。
   - (b) 用本機 `audio-separator`（Voice 環境，BS-RoFormer 分軌）把首選片段的人聲抽出來去背景，再試配。全程本機，不送雲端。
   - (c) 請校長在安靜教室重錄 10～15 秒清楚的念稿（最乾淨，但要再麻煩校長）。
   - 換參考音後：更新兩份 `film.json` 的 `voice_sample`（兩份逐字相同）＋覆蓋兩軌 `out\voice\ref_cai.wav`，再用 `試配\jobs.json` 重試配比較。
2. 老蔡定案後跑黃線：複製 `<repo>\pipeline\template_local\make_film.py` 到 `製作\EP1_v3_黃線\`，`py -3.12 make_film.py voices`（會用 edge-tts 送台詞文字做答案卷，使用者已同意）。**建議**：黃線 Breeze 設計出的 `ref_gou／lian／hui／gua.wav` 複製到三師爸軌，兩軌共用同一組聲音（公平比較；使用者尚未表態）。
3. 兩軌都通後：插隨身碟打包 `離線安裝包\pack.ps1 -Dest <碟>:\AI離線包 -Part voice -Test`（腳本尚未實測）。

## 🏫 LIB-office — 進度（LIB-PC-004011 2026-10-16 10:10）

> **分工已變更（使用者 2026-10-16 決定）**：這台不再只做影像，**影像＋語音全套都裝**，因為未來可能把部分工作分派給 VR-1，要能用 `離線安裝包\pack.ps1` 打包整套帶走。
> 家裡 FrentexHome 的語音進度仍有效（老蔡參考音、試配、film.json 都在那邊做的），不受影響。

### 語音部分（2026-10-16 上午完成，與家裡版本一致）
- ✅ `C:\AI\Voice`（Python 3.12.13，torch cu130）：確認指令回 `ok`（voxcpm、faster_whisper、audio_separator、stable_whisper、edge_tts）。
- ✅ `C:\AI\BreezeTTS`（breeze-tts commit `6eba901`）：`2.9.1+cu128`。
- ✅ `C:\AI\BreezyVoice`（code commit `d592c9d`、Python 3.10.20）：`2.7.1+cu128`；`winstub` 已複製。
- ✅ 語音模型全部 `failed 0`：BreezyVoice 153 檔、Breeze TTS 2 16 檔、VoxCPM2 主權重 2 檔；另抓 VoxCPM2 小檔（21 檔 4.62GB）與 faster-whisper large-v3（16 檔 2.88GB）。
- ⚠️ 三個環境的 `torch.cuda.is_available()` 目前都是 **False**（沒顯卡），裝卡後要重跑三個確認指令。
- ⚠️ **`py -3.12` 在這台不存在**（3.12 是 uv 裝的，不在 py launcher）→ 建 venv 一律用 `uv venv --python 3.12`，不要照手冊的 `py -3.12 -m venv`。
- 未裝：AI Toolkit（`C:\AI\lora\ai-toolkit`，選用，角色 LoRA 訓練才要）。

### 影像部分
- **顯卡還沒裝**（只有 Intel UHD 630）；先以 RTX 5060 Ti 16GB 為基準裝底層、下載模型。**不需顯卡的部分全部做完了。**
- **C 槽只剩 27GB → `mklink /J C:\AI D:\AI`**，實體在 D 槽（repo 有 51 個檔寫死 `C:\AI`，所以用 junction 不改路徑）。重灌或搬機要重建這條 junction；隨身碟打包時來源實際在 D 槽。
- **uv 套件快取也移到 D 槽**（2026-10-16，✅ 已完成並驗證）：裝完四個環境後快取在 C 槽長到 18.91GB／113741 個檔，C 槽只剩 10.4GB。已設使用者環境變數 **`UV_CACHE_DIR=D:\uv-cache`**，用 `robocopy /MOVE` 搬移（113741 檔全成功、0 失敗 0 跳過、耗時 20 分）。
  - 驗證：`uv cache dir` 回報 `D:\uv-cache`、舊位置 `%LOCALAPPDATA%\uv\cache` 已不存在、**C 槽從 10.4GB 回到 29.5GB**。
  - `pack.ps1` 第 39 行是 `(& uv cache dir).Trim()`，**動態查詢**不是寫死，所以離線打包照樣抓得到。
  - 重灌或換機要重設這個環境變數，否則 uv 又會把快取寫回 C 槽。
  - 這兩件事（junction＋UV_CACHE_DIR）是這台的**環境前提**，任何在這台跑 uv／repo 腳本的人都要知道。
- ✅ 環境：git 2.52.0、uv 0.11.19、ffmpeg 9.0.1、Python 3.12.13（`uv python install`）。本機 `python` 是市集空殼（exit 49），一律用 `py -3.14`。
- ✅ ComfyUI clone＋checkout `v0.37.0`；三個自訂節點（`892515e`、`4820b3f`、`d116451`）；`extra_model_paths.yaml` 已複製。
- ✅ `C:\AI\tools`（25 檔）。
- ✅ **venv 路徑確認是 `C:\AI\H3\venv`**（家裡提的 `H3env` 確實是 `\v` 被吃掉的筆誤，實際沒問題）。套件裝完：`torch 2.14.0+cu130`、torchvision 0.29.0+cu130、torchaudio 2.11.0+cu130、transformers 5.17.0、triton-windows 3.8.0.post28。
  目前 `torch.cuda.is_available()` 是 **False**（伴隨 `cudaErrorNotSupported` 警告）—— 沒顯卡的正常結果，不是裝壞。
- ✅ **七份影像模型全部下載完成**：20 檔、實體 133.7GB、每份都 `failed 0` 且通過 SHA-256；23:11～00:32 約 1 小時 20 分，平均 27MB/s。`download.py` 只用標準庫，用 `py -3.14` 跑就行，不必等 venv。
- ✅ **DMAD 轉檔完成**（純 CPU）：`models\loras\dmad_h3_4step_lora_critic_comfy.safetensors`（1.9GB），624 tensors／312 modules → 208 ComfyUI modules，檢查誤差 ~1e-10。

### LIB-office 裝上 5060 Ti 後要做（只剩這些）
1. `nvidia-smi`：CUDA Version ≥ 13.0（不夠請使用者更新 NVIDIA 驅動）。
2. 四個環境各重跑確認指令，應全部從 `False` 變 `True`：
   - H3：`C:\AI\H3\venv\Scripts\python.exe -c "import torch;print(torch.__version__, torch.cuda.is_available())"` → `2.14.0+cu130 True`
   - BreezeTTS → `2.9.1+cu128 True`；BreezyVoice → `2.7.1+cu128 True`；Voice 環境同樣查一次
3. **這台現在可以跑 `smoke_test.py`**（影像＋語音都裝了）；它會順便觸發 BS-RoFormer 自動下載到 `C:\AI\Voice\models\separator`。
4. 打包：`pack.ps1` 的 `-Part` 只接受 `voice` 或 `video`（`ValidateSet`，**沒有 `all`**）。這台兩套都有，所以**同一個 `-Dest` 跑兩次**：
   ```
   powershell -ExecutionPolicy Bypass -File 離線安裝包\pack.ps1 -Dest <碟>:\AI離線包 -Part video -Test
   powershell -ExecutionPolicy Bypass -File 離線安裝包\pack.ps1 -Dest <碟>:\AI離線包 -Part voice -Test
   ```
   兩次的 uv-cache 與打包紀錄分別存成 `uv-cache-video`／`uv-cache-voice`、`打包紀錄-video.txt`／`打包紀錄-voice.txt`，不會互相覆蓋；`tools` 兩次都複製（覆蓋，無害）。`-Part voice` 才會額外帶 Python 3.10 與 bert-base-chinese 快取。
   隨身碟要 exFAT／NTFS，要看到「✅ 離線測試通過」。⚠️ 腳本尚未實測。
   **容量注意**：影像 133.7GB＋語音約 21GB＋環境，256GB 隨身碟會很緊，打包前先確認剩餘空間。

---

## 專案背景（不常變）
- 六集大綱已批准（`大綱/六集劇情大綱_草稿.md`）；開會簡報第 3 版：本機 `SEL影集-角色腳本討論會.html`＋線上 https://claude.ai/artifact/KM1p2N5Tpxx9Wa8uiLuwjf 。
- 角色：主角**大頭**（只有他膚色黝黑）；**阿蓮一般學生、不碰原住民題材**；輝仔越南新住民第二代；**老蔡＝導師兼數學老師**，粗框眼鏡、白短袖襯衫領口皺、口袋不放筆、**卡其短褲＋藍白拖**。制服依本校照片。
- 第 1 集雙軌：v3《黃線》25 句台詞、三師爸《一針見血》28 句；各有 `劇本.md`、`film.json`、`鏡表.md`、`後製待辦.md`。
- **人物聲音一律 Breeze／BreezyVoice 本機配音**；微軟 edge-tts 只做答案卷（比對聲調，不進成片，使用者已同意）。校長已同意參與；`input_voice/` 不進 git、不送雲端。
- 念錯字：在該句 `film.json` 加 `"tts"` 注音（例 `縫[:ㄈㄥ2]`）→ 刪 `out\voice\bv` 該句 → 重跑；每句最多重跑 3 次，兩軌一致。
- 離線安裝包：`離線安裝包\`（`pack.ps1`、`install_offline.ps1`、`打包與安裝說明.md`），兩支腳本語法檢查通過、**尚未實測**。

## 卡關／待決
- **老蔡參考音音質**：使用者不滿意，待選 (a) 備案／(b) 本機去背景／(c) 校長重錄。
- 兩軌是否共用 Breeze 設計的學生聲音（建議共用，待使用者確認）。
- LIB-office 顯卡未裝（底層與模型已就緒，等卡到位驗證＋打包）。venv 路徑已確認為 `C:\AI\H3\venv`，無誤。
- 開會尚未召開；第 4 集碰／不碰微歧視、第 1 集選哪版、配角是否合併成固定同學，等會議。
- 宿主機 163.24.144.9（富士通 RX2540 M2）電源瓦數待查（背面標籤或 iRMC）。
- 新檔案尚未推 GitHub；騰訊 `tx/deepseek/deepseek-flash` 額度用完。

## 變更紀錄
- 2026-10-16 下午 LIB-PC-004011：uv 套件快取搬到 D 槽（`UV_CACHE_DIR=D:\uv-cache`，robocopy /MOVE 113741 檔全成功），C 槽 10.4GB → 29.5GB。
- 2026-10-16 上午 LIB-PC-004011：使用者改變分工——這台改裝**影像＋語音全套**（為了未來分派工作給 VR-1）。三個語音環境裝完並通過確認指令（版本與家裡一致）；語音模型全數下載（BreezyVoice、Breeze TTS 2、VoxCPM2、whisper large-v3）。查定 `pack.ps1 -Part` 只有 voice／video，要跑兩次。
- 2026-10-16 00:35 LIB-PC-004011：H3 venv 套件裝完（torch 2.14.0+cu130）；七份影像模型全數下載完成（20 檔、133.7GB、failed 0）；DMAD 轉檔完成。不需顯卡的影像前置工作全部結束，餘下等 5060 Ti 到位做驗證與隨身碟打包。
- 2026-10-15 23:36 FrentexHome：語音環境 2b～2e 與三個語音模型全部裝好驗證；老蔡逐字稿寫入兩份 film.json、參考音就位、`.gitignore` 補 `製作/**/out/`；試配老蔡（3050 實測快、顯存 2GB），使用者對音質不滿意待處理；寫離線安裝包方案。
- 2026-10-15 夜 LIB-PC-004011：顯卡未裝，先以 5060 Ti 為基準裝底層；`mklink /J C:\AI D:\AI`；ComfyUI v0.37.0＋自訂節點、tools、Python 3.12.13；uv 套件與 128.4GB 影像模型下載中。
- 2026-10-15 晚 PPSHPC-004001：校長同意參與、剪好老蔡參考音；六集大綱批准、簡報第 3 版；阿蓮改一般學生、老蔡改數學宅男風；定妝照試作；查宿主機型號。
- 2026-10-15 PPSHPC-004001：第 1 集腳本方法兩輪比較＋Opus 重評、v3 架構定稿、雙軌劇本與 film.json、主角改名大頭、六集大綱排程。
- 2026-10-12 PPSHPC-004001：RDQ 需求規格、SEL 修正案草稿、開會投影資料、建立私密 GitHub repo。
