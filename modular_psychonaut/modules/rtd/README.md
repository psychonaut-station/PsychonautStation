## Rapid Tiling Device

MODULE ID: RTD

### Açıklama

Rapid Tiling Device (RTD)'ye ikincil şarj birimi (cloth) ile beraber oyundaki halıları ekler.

### TG Değişiklikleri

- `code/_globalvars/lists/rtd.dm`: `GLOB.floor_designs`
- `code/game/objects/items/rcd/RHD.dm`: `/obj/item/construction/examine()`
- `code/game/objects/items/rcd/RTD.dm`: [`/obj/item/construction/rtd`: `proc/try_tiling()`, `interact_with_atom_secondary()`]
- `code/modules/asset_cache/assets/rtd.dm`: `/datum/asset/spritesheet/rtd/create_spritesheets()`
- `tgui/packages/tgui/interfaces/RapidConstructionDevice.tsx`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/game/objects/items/rcd/RHD.dm`: [`/obj/item/construction`: `var/secondary_matter`, `var/max_secondary_matter`, `var/list/secondary_matter_types`, `loadwithsheets()`, `useResource()`, `checkResource()`, `ui_data()`]
- `modular_psychonaut/master_files/code/game/objects/items/rcd/RTD.dm`: [`/obj/item/construction/rtd`: `var/max_secondary_matter`, `var/secondary_matter_types`], `/datum/tile_info/var/secondary`, `/obj/item/construction/rtd/loaded/var/secondary_matter`, [`/obj/item/construction/rtd/admin`: `var/secondary_matter`, `var/max_secondary_matter`]

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Seefaaa
