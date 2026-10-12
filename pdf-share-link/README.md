# 整合測試

在「整合測試機」上一次啟動前端、後端、Postgres。

```
瀏覽器 → 前端 Nginx（FRONTEND_PORT）→ /api → 後端 → Postgres
```

只有前端對外開放，後端與資料庫不開埠。

## 需求
Docker、Docker Compose、git（能存取兩個 repo）。

## 一行啟動
```bash
cp .env.example .env     # 填 POSTGRES_PASSWORD、BACKEND_REPO、FRONTEND_REPO
./deploy.sh
```
第一次會 clone 兩個 repo，之後每次執行會 `git pull` 並重新建置啟動。

停止：`docker compose down`（保留資料）；`docker compose down -v`（連資料一起刪）。

## 驗證清單
- [ ] 用主機公網 IP 從外部開啟前端頁面
- [ ] 上傳 PDF 並取得連結
- [ ] 用連結下載（回 200）
- [ ] 第 11 次下載回 403（次數用完）
- [ ] 將資料庫中的 expire_at 改成過去，下載回 410
- [ ] `docker compose down` 再啟動，先前的連結仍有效
