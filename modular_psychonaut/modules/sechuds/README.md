## Sechuds

MODULE ID: SECHUDS

### Açıklama

Yeni id trim oluşturmak veya sechudunu düzenlemeniz durumunda iconların düzgün gözükmesini sağlar.
Yeni iconun [`hud.dmi`](/modular_psychonaut/master_files/icons/mob/huds/hud.dmi "modular_psychonaut/master_files/icons/mob/huds/hud.dmi") ve [`sechuds.dm`](code/sechuds.dm "modular_psychonaut/modules/sechuds/code/sechuds.dm") dosyalarına eklenmesi gerekiyor.

### TG Değişiklikleri

- `code/game/data_huds.dm`: `/mob/living/carbon/human/proc/update_ID_card()`, `/atom/proc/set_hud_image()`
- `code/modules/mob/dead/observer/orbit.dm`: `/datum/orbit_menu/proc/get_living_data()`
- `tgui/packages/tgui/interfaces/Orbit/JobIcon.tsx`
- `tgui/packages/tgui/interfaces/Orbit/OrbitItem.tsx`
- `tgui/packages/tgui/interfaces/Orbit/types.ts`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/icons/mob/huds/hud.dmi`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/atom_hud.dm`: `DEFAULT_HUD_FILE`, `PSYCHONAUT_HUD_FILE`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Rengan

<!-- Bir rol eklediysen adını buraya yazma, sadece eklediğin müdüle yazman yeterli. -->
