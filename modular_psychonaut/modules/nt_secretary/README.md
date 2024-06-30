## Nt Secretary

MODULE ID: NT_SECRETARY

### Açıklama

Eskiden gelen vazgeçilmez rölümüz olan Nt Secretary.

### TG Değişiklikleri

- `code/__DEFINES/jobs.dm`: `JOB_DISPLAY_ORDER_NT_SECRETARY`
- `code/datums/station_traits/job_traits.dm`: `/datum/station_trait/job/bridge_assistant/var/weight`
- `code/modules/asset_cache/assets/paper.dm`: `/datum/asset/spritesheet/simple/paper/var/assets`
- `tgui/packages/tgui/interfaces/common/JobToIcon.ts`: `Nt Secretary`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/subsystem/id_access.dm`: `/datum/controller/subsystem/id_access/setup_region_lists()`
- `modular_psychonaut/master_files/code/datums/id_trim/jobs.dm`: `/datum/id_trim/job/nt_secretary`
- `modular_psychonaut/master_files/icons/mob/clothing/head/hats.dmi`: `nt_secretary`
- `modular_psychonaut/master_files/icons/mob/clothing/head/plasmaman_head.dmi`: `secretary_envirohelm`, `secretary_envirohelm-light`
- `modular_psychonaut/master_files/icons/mob/clothing/under/centcom.dmi`: `nt_secretary`
- `modular_psychonaut/master_files/icons/mob/clothing/under/plasmaman.dmi`: `secretary_envirosuit`
- `modular_psychonaut/master_files/icons/mob/huds/hud.dmi`: `hudntsecretary`
- `modular_psychonaut/master_files/icons/obj/clothing/head/hats.dmi`: `nt_secretary`, `nt_secretary_flipped`
- `modular_psychonaut/master_files/icons/obj/clothing/head/plasmaman_hats.dmi`: `secretary_envirohelm`, `secretary_envirohelm-light`
- `modular_psychonaut/master_files/icons/obj/clothing/under/centcom.dmi`: `nt_secretary`
- `modular_psychonaut/master_files/icons/obj/clothing/under/plasmaman.dmi`: `secretary_envirosuit`
- `modular_psychonaut/master_files/icons/obj/clothing/headsets.dmi`: `secretary_headset`
- `modular_psychonaut/master_files/icons/obj/devices/remote.dmi`: `gangtool-secretary`
- `modular_psychonaut/master_files/icons/obj/machines/computer.dmi`: `secretary_console`
- `modular_psychonaut/master_files/icons/obj/service/bureaucracy.dmi`: `paper_stamp-secretary`, `stamp-secretary`
- `modular_psychonaut/master_files/icons/obj/storage/box.dmi`: `nanobox`, `nt_secretary_kit`
- `modular_psychonaut/master_files/icons/obj/card.dmi`: `trim_secretary`, `cardboard_secretary`, `card_white`, `assigned_white`
- `modular_psychonaut/master_files/icons/stamp_icons/large_stamp-secretary.png`
- `modular_psychonaut/modules/GAGS/json_configs/pda/pda_secretary.json`
- `modular_psychonaut/modules/GAGS/greyscale_configs.dm`: `/datum/greyscale_config/tablet/secretary`
- `modular_psychonaut/modules/protected_roles/code/protected_roles.dm`: `/datum/job/nt_secretary/var/antagonist_protected`
- `modular_psychonaut/modules/spawn_point/code/spawn_point.dm`: `/datum/job/nt_secretary/var/roundstart_spawn_point`
- `modular_psychonaut/modules/stamps/code/stamps.dm`: `GLOB.psychonaut_stamps`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/access.dm`: `REGION_SECRETARY`, `REGION_ACCESS_SECRETARY`
- `code/__DEFINES/~psychonaut_defines/atom_hud.dm`: `SECHUD_NT_SECRETARY`
- `code/__DEFINES/~psychonaut_defines/colors.dm`: `SECRETARY_BLUE`
- `code/__DEFINES/~psychonaut_defines/jobs.dm`: `JOB_NT_SECRETARY`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/SecretaryConsole.jsx`

### Katkıda Bulunanlar

robotduinom, RenganN02, Seefaaa
