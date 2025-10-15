## Modular Rooms

MODULE ID: MODULAR_ROOMS

### Açıklama

İstasyona yeni bi oda eklemek veya bi odayı düzenlemek/değiştirmek için kullanılabilecek Modular Room sistemi.

### TG Değişiklikleri

- `code/controllers/subsystem/mapping.dm`: `/datum/controller/subsystem/mapping/Initialize()`, `/datum/controller/subsystem/mapping/proc/LoadGroup()`, `/datum/controller/subsystem/mapping/proc/loadWorld()`
- `code/datums/map_config.dm`: `/datum/map_config/var/picked_rooms`, `/datum/map_config/proc/LoadConfig()`
- `code/modules/mapping/reader.dm`: `/datum/parsed_map/proc/load()`, `/datum/parsed_map/proc/_load_impl()`, `/datum/parsed_map/proc/_tgm_load()`, `/datum/parsed_map/proc/_dmm_load()`, `/datum/parsed_map/proc/build_coordinate()`
- `config/game_options.txt`: `ALLOW_RANDOMIZED_ROOMS`, `MODULAR_ROOM_WEIGHT`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/game_options.dm`: `flag/allow_randomized_rooms`, `keyed_list/modular_room_weight`
- `modular_psychonaut/master_files/code/controllers/subsystem/mapping.dm`: [`/datum/controller/subsystem/mapping`: `var/all_offsets`, `var/machines_delete_after`, `var/modular_room_templates`, `var/modular_room_spawners`, `var/picked_rooms`, `/datum/controller/subsystem/mapping/Recover()`,`/datum/controller/subsystem/mapping/proc/machiness_post_init()`,`/datum/controller/subsystem/mapping/proc/locate_spawner_turf()`,`/datum/controller/subsystem/mapping/proc/load_room_templates()`,`/datum/controller/subsystem/mapping/proc/create_room_spawner()`,`/datum/controller/subsystem/mapping/proc/pick_room_types()`,`/datum/controller/subsystem/mapping/proc/pick_room()`,`/datum/controller/subsystem/mapping/proc/load_random_rooms()`,`/datum/controller/subsystem/mapping/proc/load_random_room()`]
- `modular_psychonaut/master_files/code/game/objects/effects/landmarks.dm`: `/obj/effect/landmark/random_room`, `/obj/effect/landmark/keep`, `/obj/effect/landmark/keep/apc`, `/obj/effect/landmark/keep/duct`, `/obj/effect/landmark/keep/plumbing`, `/obj/effect/landmark/keep/lightning`
- `modular_psychonaut/master_files/code/modules/admin/verbs/maprotation.dm`: `admin_change_map_templates`
- `modular_psychonaut/master_files/code/modules/mapping/map_template.dm`: `/datum/map_template/proc/stationinitload()`
- `modular_psychonaut/master_files/icons/effects/landmarks_static.dmi`: `x`, `xapc`, `xduct`, `xplumbing`, `xlight`

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Rengan
