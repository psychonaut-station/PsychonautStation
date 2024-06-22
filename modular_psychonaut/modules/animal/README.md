## Animal

MODULE ID: ANIMAL

### Açıklama

Oyuncunun belirli hayvanlardan biri olabileceği meslek.

### TG Değişiklikleri

- `code/datums/mind/_mind.dm`: `/datum/mind/serialize_list()`
- `code/modules/mob/dead/new_player/preferences_setup.dm`: `/datum/preferences/proc/render_new_preview_appearance()`
- `tgui/packages/tgui/interfaces/common/JobToIcon.ts`: `Animal`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/_globalvars/lists/names.dm`: `GLOB.animal_names`
- `modular_psychonaut/master_files/code/datums/components/pet_commands/fetch.dm`: `/datum/pet_command/point_targetting/fetch/Destroy()`
- `modular_psychonaut/master_files/code/datums/components/pet_commands/obeys_commands.dm`: `/datum/component/obeys_commands/Destroy()`
- `modular_psychonaut/master_files/code/datums/elements/ai_held_item.dm`: `/datum/element/ai_held_item/Detach()`
- `modular_psychonaut/modules/protected_roles/code/protected_roles.dm`: `/datum/job/animal/var/antagonist_restricted`
- `modular_psychonaut/modules/spawn_point/code/spawn_point.dm`: `/datum/job/animal/var/roundstart_spawn_point`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/jobs.dm`: `JOB_ANIMAL`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/animal_type.tsx`

### Katkıda Bulunanlar

Seefaaa
