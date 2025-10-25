## Account Link

MODULE ID: ACCOUNT_LINK

### Açıklama

Byond hesabınızı discord hesabınıza linkleyebilmenizi sağlar, geliştirir.

### TG Değişiklikleri

- `code/controllers/subsystem/discord.dm`: `/datum/controller/subsystem/discord/proc/generate_one_time_token()`
- `code/modules/admin/IsBanned.dm`: `/world/IsBanned()`
- `code/modules/admin/verbs/admingame.dm`: `show_player_panel`
- `code/modules/client/client_procs.dm`: `/client/New()`
- `code/modules/discord/accountlink.dm`: `/client/verb/verify_in_discord()`
- `config/config.txt`: `DISCORDURL`, `REQUIRE_DISCORD_LINKING`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/general.dm`: `/datum/config_entry/string/discordurl`: `/datum/config_entry/flag/require_discord_linking`

### Definelar ve Helperlar

- `code/__HELPERS/~psychonaut_helpers/randoms.dm`: `/proc/random_code()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/DiscordVerification.tsx`

### Katkıda Bulunanlar
