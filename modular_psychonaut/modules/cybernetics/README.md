## Cybernetics

MODULE ID: CYBERNETICS

### Açıklama

Eklediğimiz çeşitli cyberneticler.

### TG Değişiklikleri

- `code/__DEFINES/DNA.dm`: `GLOB.organ_process_order`
- `code/_onclick/item_attack.dm`: `/obj/attackby()`, `/obj/item/proc/attack()`
- `code/modules/projectiles/projectile.dm`: `/obj/projectile/proc/process_movement()`
- `code/modules/research/techweb/nodes/cyborg_nodes.dm`: `/datum/techweb_node/cyber/combat_implants`, `/datum/techweb_node/cyber/integrated_toolsets`
- `code/modules/research/techweb/nodes/engi_nodes.dm`: `/datum/techweb_node/hud`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/_onclick/hud/cybernetics.dm`: `/atom/movable/screen/cybernetics/ammo_counter`
- `modular_psychonaut/master_files/code/_onclick/hud/hud.dm`: `/datum/hud/var/cybernetics_ammo`, `/datum/hud/Destroy()`
- `modular_psychonaut/master_files/code/datums/components/after_image.dm`: `/datum/component/after_image`
- `modular_psychonaut/master_files/code/datums/components/slowing_field.dm`: `/datum/component/slowing_field`
- `modular_psychonaut/master_files/code/game/objects/items/storage/uplink_kits.dm`: `/obj/item/storage/box/syndicate/sandy`, `/obj/item/storage/box/syndicate/mantis`
- `modular_psychonaut/master_files/code/modules/actionspeed/modifiers/status_effects.dm`: `/datum/actionspeed_modifier/status_effect/sandevistan`, `/datum/actionspeed_modifier/status_effect/slowing_field`
- `modular_psychonaut/master_files/code/modules/movespeed/modifiers/status_effects.dm`: `/datum/movespeed_modifier/status_effect/sandevistan`, `/datum/movespeed_modifier/status_effect/slowing_field`
- `modular_psychonaut/master_files/code/modules/projectiles/projectile.dm`: `/obj/projectile/var/speed_multiplier`
- `modular_psychonaut/master_files/code/modules/surgery/organs/autosurgeon.dm`: `/obj/item/autosurgeon/syndicate/sandy`, `/obj/item/autosurgeon/syndicate/mantis`
- `modular_psychonaut/master_files/code/modules/uplink/uplink_items/bundle.dm`: `/datum/uplink_item/bundles_tc/sandevistan`, `/datum/uplink_item/bundles_tc/mantis`
- `modular_psychonaut/master_files/icons/effects/96x96.dmi`: `chempunk`
- `modular_psychonaut/master_files/icons/hud/screen_cybernetics.dmi`: `basic_interface`
- `modular_psychonaut/master_files/icons/mob/clothing/back.dmi`: `chemvat_back`
- `modular_psychonaut/master_files/icons/mob/clothing/mask.dmi`: `chemvat_mask`
- `modular_psychonaut/master_files/icons/mob/human/species/misc/bodypart_overlay_augmentations.dmi`: `sandy`
- `modular_psychonaut/master_files/icons/mob/inhands/weapons/swords_lefthand.dmi`: `mantis`, `syndie_mantis`, `shield_mantis`
- `modular_psychonaut/master_files/icons/mob/inhands/weapons/swords_righthand.dmi`: `mantis`, `syndie_mantis`, `shield_mantis`
- `modular_psychonaut/master_files/icons/obj/clothing/back.dmi`: `chemvat_back`
- `modular_psychonaut/master_files/icons/obj/clothing/masks.dmi`: `chemvat_mask`
- `modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi`: `toolkit_atmosph`, `toolkit_janitor`, `toolkit_hydro`, `toolkit_paramedic`, `eye_implant_science`, `hand_implant`, `sandy`
- `modular_psychonaut/master_files/icons/obj/weapons/sword.dmi`: `mantis`, `syndie_mantis`, `shield_mantis`
- `modular_psychonaut/modules/reagents/chemistry/reagents/medicine_reagents.dm`: `/datum/reagent/medicine/brain_healer`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/traits/declarations.dm`: `TRAIT_CANT_ATTACK`
- `code/__HELPERS/~psychonaut_helpers/hud.dm`: `/proc/ui_hand_position_y()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Rengan
