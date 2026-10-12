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
- 本機（FrentexHome）顯卡為 RTX 3050 8GB／RAM 32GB，**不適合跑**；要跑請用 ppsh-VR-1。

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
- **SEL 影集角色**：原住民、新住民身分不當笑點，也不疊加弱勢標籤；涉及原住民的內容要請原住民教師把關（本校為原住民重點學校）。
- 開會資料改一份要同步另一份（本機版有 doctype 開頭，線上版沒有）。
- **授權**：程式 MIT、文件 CC BY-NC 4.0。Qwen-Image 2.1、Breeze TTS 2 僅限非商業；MiniMax H3 授權排除美國／歐盟／英國／南韓；公開內容須標示 AI 生成。校內教學用途沒問題，上 YouTube 營利前先讀 THIRD_PARTY_NOTICES.md。
- repo 不含模型權重，要另外下載約 150GB；下載前先確認磁碟空間。
- 評估報告中的網友經驗多來自部落格彙整，未能取得 Reddit 原串，請當交叉參考。
- 地端模型以外的雲端服務（edge-tts）會連網，不要送學生個資。
