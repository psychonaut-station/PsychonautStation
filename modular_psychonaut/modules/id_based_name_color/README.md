## Id Based Name Color

MODULE ID: ID_BASED_NAME_COLOR

### Açıklama

Sohbetteki IC isimlerin, oyuncuların taşıdığı ID karta kayıtlı mesleğe bağlı olarak departmanlara özgü belirlenmiş farklı, hiyerarşiye göre açık/koyu tonlarda görünmesini sağlar.

### TG Değişiklikleri

- `code/controllers/subsystem/networks/id_access.dm`: `/datum/controller/subsystem/id_access/proc/apply_trim_override()`, `/datum/controller/subsystem/id_access/proc/remove_trim_override()`
- `code/game/say.dm`: `/atom/movable/proc/compose_message()`
- `tgui/packages/tgui-panel/chat/renderer.tsx`: `stripColoredNames`, `ChatRenderer`
- `tgui/packages/tgui-panel/settings/atoms.ts`: `defaultSettings`
- `tgui/packages/tgui-panel/settings/helpers.ts`: `generalSettingsHandler`
- `tgui/packages/tgui-panel/settings/SettingsGeneral.tsx`: `SettingsGeneral`
- `tgui/packages/tgui-panel/settings/types.ts`: `settingsSchema`
- `tgui/packages/tgui-panel/styles/tgchat/chat-dark.scss`: `$job-colors`
- `tgui/packages/tgui-panel/styles/tgchat/chat-light.scss`: `$job-colors`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Homek
