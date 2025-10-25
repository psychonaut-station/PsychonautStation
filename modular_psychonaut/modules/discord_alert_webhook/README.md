## Discord Alert Webhook

MODULE ID: DISCORD_ALERT_WEBHOOK

### Açıklama

Tur başlarken discorddaki bir kanala webhook aracılığı ile bildirim atar.

### TG Değişiklikleri

- `code/controllers/subsystem/ticker.dm`: `/datum/controller/subsystem/ticker/fire()`
- `config/config.txt`: `ENABLE_DISCORD_ROUND_ALERTS`, `DISCORD_ROUND_ALERT_WEBHOOK_URL`, `DISCORD_ROUND_ALERT_ROLE_ID`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/general.dm`: `/datum/config_entry/flag/enable_discord_round_alerts`, `/datum/config_entry/string/discord_round_alert_webhook_url`, `/datum/config_entry/string/discord_round_alert_role_id`

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot
