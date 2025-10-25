## Electrical Jukebox

MODULE ID: JUKEBOX

### Açıklama

Oyuna youtube'dan müzik oynatabilen bir jukebox ekler.

### TG Değişiklikleri

- `code/__DEFINES/logging.dm`: `LOG_CATEGORY_GAME_JUKEBOX`
- `code/datums/proximity_monitor/proximity_monitor.dm`: `/datum/proximity_monitor/var/loc_connections`
- `code/modules/admin/verbs/playsound.dm`: `/proc/web_sound()`
- `code/modules/client/client_procs.dm`: `/client/verb/stop_client_sounds()`
- `config/config.txt`: `REQUEST_INTERNET_ALLOWED`, `YTDL_COOKIES`
- `tgui/packages/tgui-panel/audio/middleware.js`
- `tgui/packages/tgui-panel/audio/NowPlayingWidget.jsx`
- `tgui/packages/tgui-panel/audio/player.js`
- `tgui/packages/tgui-panel/audio/reducer.ts`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/game/machinery/dance_machine.dm`: `/obj/machinery/jukebox/Initialize()`
- `modular_psychonaut/master_files/code/game/objects/structures/crates_lockers/closets/secure/bar.dm`: `/obj/structure/closet/secure_closet/bar/PopulateContents()`
- `modular_psychonaut/master_files/code/modules/client/client_procs.dm`: `/client/stop_client_sounds()`
- `modular_psychonaut/master_files/code/modules/categories/log_category_game.dm`: `/datum/log_category/game_jukebox`
- `modular_psychonaut/master_files/code/controllers/configuration/entries/general.dm`: `flag/log_jukebox`, `string/ytdl_cookies`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/signals.dm`: `COMSIG_PROXIMITY_MOB_ENTERED`, `COMSIG_PROXIMITY_MOB_LEFT`, `COMSIG_PROXIMITY_MOB_MOVED`, `COMSIG_WEB_SOUND_STARTED`, `COMSIG_WEB_SOUND_ENDED`, `COMSIG_WEB_SOUND_STOPPED`
- `code/__DEFINES/~psychonaut_defines/traits/declarations.dm`: `TRAIT_CAN_USE_JUKEBOX`
- `code/__DEFINES/~psychonaut_defines/web_sound.dm`: `WEB_SOUND_ERR_YTDL_NOT_CONFIGURED`, `WEB_SOUND_ERR_INVALID_URL`, `WEB_SOUND_ERR_NOT_HTTPS`, `WEB_SOUND_ERR_JSON_RETRIEVAL`, `WEB_SOUND_ERR_JSON_PARSING`, `WEB_SOUND_ERR_DURATION`, `WEB_SOUND_CACHE_DURATION`, `WEB_SOUND_MAX_DURATION`
- `code/__HELPERS/~psychonaut_helpers/logging.dm`: `/proc/log_jukebox()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/ElectricalJukebox.tsx`

### Katkıda Bulunanlar

Seefaaa
