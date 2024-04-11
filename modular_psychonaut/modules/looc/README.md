## LOOC

MODULE ID: LOOC

### Açıklama

Anksiyetesi olan insanlar için uygun OOC.

### TG Değişiklikleri

- `code/__DEFINES/admin.dm`: `MUTE_OOC`
- `code/__DEFINES/logging.dm`: `LOG_OOC`, `INDIVIDUAL_LOOC_LOG`, `INDIVIDUAL_SHOW_ALL_LOG`
- `code/__DEFINES/preferences.dm`: `CHAT_LOOC`, `TOGGLES_DEFAULT_CHAT`
- `code/__HELPERS/logging/_logging.dm`: `/atom/proc/log_message()`
- `code/__HELPERS/logging/mob.dm`: `/mob/log_message()`
- `code/datums/cinematics/_cinematic.dm`: `/datum/cinematic/proc/start_cinematic()`, `/datum/cinematic/proc/clean_up_cinematic()`
- `code/datums/keybinding/living.dm`: `/datum/keybinding/living/look_up/var/hotkey_keys`, `/datum/keybinding/living/look_down/var/hotkey_keys`
- `code/modules/admin/verbs/admin.dm`: `/proc/cmd_admin_mute()`
- `code/modules/admin/verbs/admingame.dm`: `/datum/admins/proc/show_player_panel()`
- `code/modules/admin/verbs/individual_logging.dm`: `/proc/show_individual_logging_panel*()`,
- `code/modules/admin/admin_verbs.dm`: `/world/proc/AVerbsAdmin()`
- `code/modules/tgui_input/say_modal/modal.dm`: `/datum/tgui_say/proc/open()`
- `code/modules/tgui_input/say_modal/speech.dm`: `/datum/tgui_say/proc/handle_entry()`
- `config/logging.txt`: `LOG_LOOC`
- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/legacy_chat_toggles.tsx`: `chat_looc`
- `tgui/packages/tgui-panel/chat/constants.ts`: `MESSAGE_TYPE_LOOC`, `MESSAGE_TYPES`
- `tgui/packages/tgui-panel/styles/tgchat/chat-dark.scss`: `.looc`, `.loocplain`
- `tgui/packages/tgui-panel/styles/tgchat/chat-light.scss`: `.looc`, `.loocplain`
- `tgui/packages/tgui-say/styles/colors.scss`: `$_channel_map.LOOC`
- `tgui/packages/tgui-say/ChannelIterator.test.ts`
- `tgui/packages/tgui-say/ChannelIterator.ts`: [`ChannelIterator`: `channels`, `quiet`]

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/_globalvars/configuration.dm`: `GLOB.looc_allowed`
- `modular_psychonaut/master_files/code/controllers/configuration/entries/game_options.dm`: `/datum/config_entry/flag/looc_enabled`
- `modular_psychonaut/master_files/code/controllers/configuration/entries/general.dm`: `/datum/config_entry/flag/log_looc`
- `modular_psychonaut/master_files/code/game/world.dm`: `/world/ConfigLoaded()`
- `modular_psychonaut/master_files/code/modules/client/preferences/ooc.dm`: `/datum/preference/toggle/enable_looc`
- `modular_psychonaut/master_files/code/modules/logging/categories/log_category_game.dm`: `/datum/log_category/game_looc`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/chat.dm`: `MESSAGE_TYPE_LOOC`
- `code/__DEFINES/~psychonaut_defines/keybinding.dm`: `COMSIG_KB_CLIENT_LOOC_DOWN`
- `code/__DEFINES/~psychonaut_defines/speech_channels.dm`: `LOOC_CHANNEL`
- `code/__HELPERS/~psychonaut_helpers/logging.dm`: `/proc/log_looc`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot, Seefaaa
