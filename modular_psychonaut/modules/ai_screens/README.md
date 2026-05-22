## AI Screens

MODULE ID: AI_SCREENS

### Açıklama

Tarafımızca aiye eklenen ekranlar.

### TG Değişiklikleri

- `code/game/machinery/status_display.dm`: `/obj/machinery/status_display/var/current_picture_icon`, `/obj/machinery/status_display/set_picture()`, `/obj/machinery/status_display/update_overlays()`, `/obj/machinery/status_display/ai/process()`
- `code/modules/client/preferences/ai_core_display.dm`: `/datum/preference/choiced/ai_core_display/icon_for()`
- `code/modules/client/preferences/ai_emote_display.dm`: `/datum/preference/choiced/ai_emote_display/icon_for()`
- `code/modules/mob/dead/new_player/preferences_setup.dm`: `/datum/preferences/render_new_preview_appearance()`
- `code/modules/mob/living/silicon/ai/_preferences.dm`: `/proc/init_ai_status_display_options()`
- `code/modules/mob/living/silicon/ai/ai.dm`: `/mob/living/silicon/ai/set_core_display_icon()`, `/mob/living/silicon/ai/update_overlays()`
- `code/modules/mob/living/silicon/ai/ai_core_display_picker.dm`: `/datum/ai_core_display_picker/ui_data()`
- `code/modules/mob/living/silicon/ai/ai_defines.dm`: `/mob/living/silicon/ai/var/display_icon_file_override`
- `code/modules/mob/living/silicon/ai/ai_portrait_picker.dm`: `/datum/portrait_picker/ui_act()`
- `code/modules/mob/living/silicon/ai/ai_status_display_picker.dm`: `/datum/ai_status_display_picker/ui_static_data()`, `/datum/ai_status_display_picker/ui_data()`
- `code/modules/mob/living/silicon/ai/death.dm`: `/mob/living/silicon/ai/death()`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `modular_psychonaut/master_files/icons/mob/silicon/ai.dmi`

### Katkıda Bulunanlar

Rengan
Nukkun
