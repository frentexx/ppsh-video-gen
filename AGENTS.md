# 影音生成（三師爸地端 AI 短片工作流備份與評估）

> 備份三師爸（mathruffian-dot）公開的「地端生成 AI 短片」工作流 repo，並評估其硬體需求是否合理、本校機器能不能跑。
> 建立日期：2026-10-09

## 產出
- `repo/`、`repo-16gvram-64gram/`、`repo-16gvram-32gram/`：三份 GitHub repo 完整複製（各 53 MB，含 git 歷史），防止原作者日後下架
- `評估報告-硬體需求.md`：32GB VRAM＋64GB RAM 需求是否合理、本校機器對照、升級建議、兩台平行作業與 tool-compute 評估
- Obsidian 筆記 `07-專案計畫\屏北高中影音地端LLM生成方案.md`：VR-1（16GB RAM 不升級）的做法
- （之後）依該筆記「驗證計畫」在 ppsh-VR-1 實測
- `SEL社會情緒學習影集企劃.md`：Gemini 產出的 6 集企劃原稿（不修改）
- `SEL影集-修正案草稿.md`：接地氣修正案（角色、六集、地雷清單）
- `SEL影集-角色腳本討論會.html`：同仁討論會投影資料（線上版原始檔 `.artifact/sel-meeting.html`）
- `rdq/`：RDQ 需求規格卡
- `SEL影集腳本生成架構-v3.md`：**定稿**的腳本生成架構（含分工鐵則：評審一律 Opus、不得兼任寫手；主編不動筆）
- `比較實驗/`、`比較實驗2/`：第 1 集三種方法比較（題目、發想、劇本、盲評、報告；`比較實驗2/評審總表_Opus.md` 為最終評分）
- `離線安裝包/`：`pack.ps1`（打包到隨身碟）、`install_offline.ps1`（新電腦離線重建）、`打包與安裝說明.md`；家裡打包語音、LIB-office 打包影像
- `製作/`：雙軌製作（`EP1_v3_黃線/`、`EP1_三師爸_一針見血/`，各含劇本.md、film.json、鏡表.md、後製待辦.md；`共用_角色外觀.md` 兩軌共用）

## 時程
| 節點 | 日期 | 狀態 |
|------|------|------|
| 複製 repo 備份 | 2026-10-09 | ✅ 完成 |
| 硬體需求評估 | 2026-10-09 | ✅ 完成（見評估報告） |
| 其餘兩份硬體版本 repo 備份 | 2026-10-09 | ✅ 完成 |
| VR-1（16GB RAM）方案筆記 | 2026-10-09 | ✅ 完成（尚未實測） |
| ppsh-VR-1 依驗證計畫實測 | — | 待使用者決定 |
| VR-1 升級 RAM／LIB-office 分工 | — | 暫不升級，視實測結果再決定 |
| SEL 影集修正案＋開會資料 | 2026-10-12 | ✅ 完成 |
| 同仁討論會（角色＋六集） | — | 待使用者召開 |
| 依會議意見確認角色與腳本 | — | 會後 |
| 第 1 集腳本方法比較（兩輪＋Opus 重評） | 2026-10-15 | ✅ v3 82、三師爸 77、原案 28 |
| v3 架構定稿、第 1 集雙軌劇本定稿 | 2026-10-15 | ✅ |
| 第 1 集雙軌製作設定檔（film.json，不需顯卡） | 2026-10-15 | ✅ 完成 |
| 六集劇情大綱（排程 18:30）→ 使用者批准 → 更新開會簡報 | 2026-10-15 | ✅ 正式簡報第 3 版 |
| 家裡語音環境＋模型（2b～2e、Breeze／BreezyVoice／whisper） | 2026-10-15 | ✅ 完成 |
| LIB-office 影像環境＋模型（2a、7 份清單 128GB） | 2026-10-15 | ⏳ 下載中，顯卡未裝 |
| 離線安裝包（隨身碟） | — | 腳本已寫，待實測 |
| 第 1 集雙軌語音生成（家裡 RTX 3050，BreezyVoice） | — | 老蔡試配音質不滿意，待處理參考音 |
| LIB-office 影像底層環境＋模型下載（不需顯卡） | 2026-10-16 | ✅ 完成（H3 venv、ComfyUI 0.37.0、133.7GB 模型、DMAD 轉檔；`C:\AI` junction 到 D 槽） |
| LIB-office 加裝語音全套（為分派 VR-1 做準備） | 2026-10-16 | ✅ 完成（Voice／BreezeTTS／BreezyVoice 三環境＋BreezyVoice、Breeze TTS 2、VoxCPM2、whisper large-v3） |
| LIB-office 裝 RTX 5060 Ti → 四環境 torch 驗證＋smoke_test＋隨身碟打包 | — | 等顯卡 |
| 第 1 集雙軌生成影片（需顯卡）→ Opus 盲評成片 | — | 等顯卡 |

無外部期限。

## 資料夾結構
```
影音生成/
├─ AGENTS.md / CLAUDE.md / handoff.md
├─ 評估報告-硬體需求.md
├─ repo-16gvram-32gram/       VR-1 要參考的版本（唯讀備份）
├─ repo-16gvram-64gram/       日後升級 64GB 用（唯讀備份）
└─ repo/                      shanshiba-workflow-32gvram-64gram（唯讀備份，勿在裡面改檔）
   ├─ README.md / AGENT_SETUP.md     總覽與給 AI agent 的安裝手冊
   ├─ docs/                          01~07 文件 + hardware.md（硬體實測）
   ├─ setup/                         模型下載清單、requirements、smoke_test、16gb_sim 模擬數據
   ├─ tools/ pipeline/ agent/ sfx/ templates/ configs/
   └─ THIRD_PARTY_NOTICES.md         各模型授權（含地區限制）
```

## 環境與工具
- 原始 repo 需 Windows 11＋NVIDIA（CUDA 13）＋ComfyUI 0.37＋Python 3.12＋uv＋ffmpeg，模型約 150GB。
- 本機（FrentexHome）顯卡為 RTX 3050 8GB／RAM 32GB，**不適合跑影像**；語音可以（BreezyVoice 實測顯存峰值 2GB、每候選 6～9 秒）。影像用 LIB-office（5060 Ti 16GB＋32GB）或 ppsh-VR-1。
- **LIB-office 的 `C:\AI` 是 junction**（`mklink /J C:\AI D:\AI`，C 槽不夠）；repo 寫死 `C:\AI`，重灌或搬機要重建。
- 三師爸 `download.py` 只用標準庫，任何 Python 都能跑（不必等 H3 venv）。

## 對照表
| 類型 | 位置 |
|------|------|
| 專案資料夾 | `07專案開發\影音生成` |
| 原始 repo | https://github.com/mathruffian-dot/shanshiba-workflow-32gvram-64gram |
| 本專案私密 repo | https://github.com/frentexx/ppsh-video-gen （不含 `repo*/` 備份） |
| 開會資料線上版 | https://claude.ai/artifact/KM1p2N5Tpxx9Wa8uiLuwjf |
| 同系列（16GB 顯卡）| `shanshiba-workflow-16gvram-64gram`、`shanshiba-workflow-16gvram-32gram`（同帳號，已備份） |
| 主要 Obsidian 筆記 | `07-專案計畫\屏北高中影音地端LLM生成方案.md` |
| 相關 Obsidian | `07-專案計畫\地端LLM影片生成.md`（VR-1 上的 Wan2.2／Qwen-Image，入口筆記）、`02-AI工具\地端模型-Wan2.2-S2V-對嘴影片.md` |

## 注意事項
- **主角名「大頭」**（原「黑狗」）；只有大頭膚色黝黑；**阿蓮一般學生、全劇不碰原住民題材**；輝仔越南新住民第二代；**老蔡＝數學老師，宅男風、短褲＋藍白拖**。`input_voice/`（校長聲音）需當事人同意、不進 git、不送雲端。`input_pic/` 是真實學生照片，只取制服款式、不進 git、不送外部模型。
- **雙軌製作**：v3 與三師爸兩個版本平行到成片才比較；兩軌共用角色外觀、由同一轉換者產出 film.json；v3 軌不得借用三師爸軌台詞，反之亦然。
- **評審一律 Opus、不得兼任寫手；主編只寫意見、退回原寫手修改。**
- 製作檔放 `製作/`，`repo*/` 備份不改；film.json 的 `repo_dir` 指向 `../../repo-16gvram-32gram`（VR-1 版本）。
- **SEL 影集角色**：原住民、新住民身分不當笑點，也不疊加弱勢標籤；涉及原住民的內容要請原住民教師把關（本校為原住民重點學校）。
- 開會資料改一份要同步另一份（本機版有 doctype 開頭，線上版沒有）。
- **授權**：程式 MIT、文件 CC BY-NC 4.0。Qwen-Image 2.1、Breeze TTS 2 僅限非商業；MiniMax H3 授權排除美國／歐盟／英國／南韓；公開內容須標示 AI 生成。校內教學用途沒問題，上 YouTube 營利前先讀 THIRD_PARTY_NOTICES.md。
- repo 不含模型權重，要另外下載約 150GB；下載前先確認磁碟空間。
- 評估報告中的網友經驗多來自部落格彙整，未能取得 Reddit 原串，請當交叉參考。
- 地端模型以外的雲端服務（edge-tts）會連網，不要送學生個資。
