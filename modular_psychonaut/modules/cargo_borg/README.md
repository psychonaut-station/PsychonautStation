## Cargo Borg

MODULE ID: CARGO_BORG

### Açıklama

Kargocu mesleği yapacak olan yeni bir cyborg türü ekler.

<sub>Dönüşüm animasyonu ve modül iconu eksik.</sub>

### TG Değişiklikleri

- `code/__DEFINES/exosuit_fab.dm`: `BORG_MODEL_CARGO`
- `code/__DEFINES/research/research_categories.dm`: `RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO`
- `code/modules/asset_cache/assets/paper.dm`: `/datum/asset/spritesheet/simple/paper/var/assets`
- `code/modules/mob/living/silicon/robot/robot_model.dm`: `/obj/item/robot_model/proc/respawn_consumable()`
- `code/modules/mob/living/silicon/robot/robot.dm`: `/mob/living/silicon/robot/proc/pick_model()`
- `code/modules/paperwork/paperplane.dm`: [`/obj/item/paperplane`: `suicide_act()`, `throw_impact()`]
- `code/modules/recycling/sortingmachinery.dm`: `/obj/item/delivery/attackby()`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/game/objects/items/stacks/wrap.dm`: `/obj/item/stack/wrapping_paper/var/source`, `/obj/item/stack/package_wrap/var/source`
- `modular_psychonaut/master_files/code/modules/paperwork/paperplane.dm`: [`/obj/item/paperplane`: `var/eye_damage_lower`, `var/eye_damage_higher`, `var/scrap_on_impact`, `proc/turn_into_scrap()`]
- `modular_psychonaut/master_files/icons/mob/silicon/robots.dmi`: `cargo`, `cargo_l`, `cargo_e`, `cargo_e_r`
- `modular_psychonaut/master_files/icons/obj/devices/circuitry_n_data.dmi`: `cyborg_upgrade5`
- `modular_psychonaut/master_files/icons/obj/service/bureaucracy.dmi`: `paper_stamp-borg`, `stamp-borg`
- `modular_psychonaut/master_files/icons/stamp_icons/large_stamp-borg.png`
- `modular_psychonaut/modules/stamps/code/stamps.dm`: `GLOB.psychonaut_stamps`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/alerts.dm`: `ALERT_HIGHWEIGHT`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

RengaN, charlicko, Seefaaa
