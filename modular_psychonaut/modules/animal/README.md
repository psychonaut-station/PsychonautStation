## ANIMAL

MODULE ID: ANIMAL

### Açıklama

İstasyona evcil hayvan olarak gelebilmek için hayvan mesleği ekler.

### TG Değişiklikleri

- `code/datums/mind/_mind.dm`: `/datum/mind/serialize_list()`
- `code/modules/mob/dead/new_player/preferences_setup.dm`: `/datum/preferences/proc/render_new_preview_appearance()`
- `tgui/packages/tgui/interfaces/common/JobToIcon.ts`: `JOB2ICON`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/datums/components/pet_commands/fetch.dm`: `/datum/pet_command/fetch/Destroy()`
- `modular_psychonaut/master_files/code/datums/elements/ai_held_item.dm`: `/datum/element/ai_held_item/Detach()`
- `modular_psychonaut/master_files/code/_globalvars/lists/names.dm`: `GLOB.animal_names`
- `modular_psychonaut/master_files/code/modules/client/preferences/animal_type.dm`: `/datum/preference/choiced/animal_type`
- `modular_psychonaut/master_files/code/modules/client/preferences/names.dm`: `/datum/preference/name/animal`
- `modular_psychonaut/master_files/strings/names/animal.txt`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/jobs.dm`: `JOB_ANIMAL`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/animal_type.tsx`

### Katkıda Bulunanlar

Seefaaa
