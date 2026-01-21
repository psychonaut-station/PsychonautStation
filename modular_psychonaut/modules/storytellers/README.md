## Storytellers

MODULE ID: STORYTELLERS

### Açıklama

Eventlerin atılış biçimini değiştiren storyteller'ler ekler.

### TG Değişiklikleri

- `code/controllers/subsystem/events.dm`: `/datum/controller/subsystem/events/reschedule()`, `/datum/controller/subsystem/events/spawnEvent()`
- `code/controllers/subsystem/statpanel.dm`: `/datum/controller/subsystem/statpanels/fire()`
- `code/controllers/subsystem/ticker.dm`: `/datum/controller/subsystem/ticker/setup()`
- `code/controllers/subsystem/dynamic/_dynamic_ruleset.dm`: `/datum/dynamic_ruleset/get_weight()`, `/datum/dynamic_ruleset/execute()`
- `code/controllers/subsystem/dynamic/dynamic.dm`: `/datum/controller/subsystem/dynamic/set_tier()`, `/datum/controller/subsystem/dynamic/pick_roundstart_rulesets()`, `/datum/controller/subsystem/dynamic/get_ruleset_cooldown()`, `/datum/controller/subsystem/dynamic/build_dynamic_toml()`
- `code/modules/events/_event.dm`: `/datum/round_event_control/run_event()`
- `code/modules/shuttle/mobile_port/variants/emergency/emergency.dm`: `/obj/docking_port/mobile/emergency/check()`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/game_options.dm`:
- `modular_psychonaut/master_files/code/modules/logging/categories/log_category_misc.dm`: `/datum/log_category/storyteller`

### Definelar ve Helperlar

- `code/__DEFINES/logging.dm`: `LOG_CATEGORY_STORYTELLER`
- `code/__DEFINES/~psychonaut_defines/storytellers.dm`: `/datum/config_entry/flag/enable_storyteller`, `/datum/config_entry/flag/public_storyteller`, `/datum/config_entry/flag/auto_vote_storyteller`, `/datum/config_entry/flag/allow_storyteller_vote`, `/datum/config_entry/string/default_storyteller`
- `code/__HELPERS/~psychonaut_helpers/logging.dm`: `/proc/log_storyteller()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `modular_psychonaut/master_files/code/controllers/subsystem/storytellers.dm`
- `tgui/packages/tgui/interfaces/StorytellerAdmin.tsx`

### Katkıda Bulunanlar

Rengan
