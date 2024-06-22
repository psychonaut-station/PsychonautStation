## Accountlink

MODULE ID: ACCOUNTLINK

### Açıklama

TG'de olan Discord link sistemi kötü olduğu için üzerine yapılan ve güzel gözüken sistemimiz.

### TG Değişiklikleri

- `code/modules/discord/accountlink.dm`: `/client/verb/verify_in_discord()`
- `config/config.txt`: `DISCORDBOTTOKEN`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/general.dm`: `/datum/config_entry/string/discordbottoken`
- `modular_psychonaut/master_files/code/modules/client/client_defines.dm`: `/client/var/verification_menu`

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/DiscordVerification.tsx`

### Katkıda Bulunanlar

Seefaaa
