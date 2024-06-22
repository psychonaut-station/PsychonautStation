## Electrical Jukebox

MODULE ID: JUKEBOX

### Açıklama

Oyuna youtube'dan müzik oynatabilen bir jukebox ekler.

### TG Değişiklikleri

- `code/datums/proximity_monitor/proximity_monitor.dm`: `/datum/proximity_monitor/var/loc_connections`
- `config/config.txt`: `REQUEST_INTERNET_ALLOWED`
- `tgui/packages/tgui-panel/audio/middleware.js`
- `tgui/packages/tgui-panel/audio/NowPlayingWidget.jsx`
- `tgui/packages/tgui-panel/audio/player.js`
- `tgui/packages/tgui-panel/audio/reducer.ts`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/game/machinery/dance_machine.dm`: `/obj/machinery/jukebox/Initialize()`
- `modular_psychonaut/master_files/code/game/objects/structures/crates_lockers/closets/secure/bar.dm`: `/obj/structure/closet/secure_closet/bar/PopulateContents()`
- `modular_psychonaut/master_files/code/modules/client/client_procs.dm`: `/client/stop_client_sounds()`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/signals.dm`: `COMSIG_PROXIMITY_MOB_ENTERED`, `COMSIG_PROXIMITY_MOB_LEFT`, `COMSIG_PROXIMITY_MOB_MOVED`, `COMSIG_WEB_SOUND_STARTED`, `COMSIG_WEB_SOUND_ENDED`, `COMSIG_WEB_SOUND_STOPPED`
- `code/__DEFINES/~psychonaut_defines/web_sound.dm`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/ElectricalJukebox.tsx`

### Katkıda Bulunanlar

Seefaaa
