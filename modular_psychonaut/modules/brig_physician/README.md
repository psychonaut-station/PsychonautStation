## Brig Physician

MODULE ID: BRIG_PHYSICIAN

### Açıklama

Brigde çalışan, Security'e dahil, doktor mesleği.

### TG Değişiklikleri

- `code/__DEFINES/jobs.dm`: `JOB_DISPLAY_ORDER_BRIG_PHYSICIAN`
- `code/game/gamemodes/objective_items.dm`: `/datum/objective_item/steal/traitor/space_law/var/excludefromjob`,`/datum/objective_item/steal/traitor/donut_box/var/excludefromjob`,`/datum/objective_item/steal/spy/disabler/var/excludefromjob`,`/datum/objective_item/steal/spy/energy_gun/var/excludefromjob`,`/datum/objective_item/steal/spy/laser_gun/var/excludefromjob`,`/datum/objective_item/steal/spy/shotgun/var/excludefromjob`,`/datum/objective_item/steal/spy/temp_gun/var/excludefromjob`,`/datum/objective_item/steal/spy/sunglasses/var/excludefromjob`,`/datum/objective_item/steal/spy/stun_bato/var/excludefromjob`,`/datum/objective_item/steal/spy/det_baton/var/excludefromjob`
- `code/game/machinery/computer/crew.dm`: `/datum/crewmonitor/var/jobs`
- `tgui/packages/tgui/interfaces/common/JobToIcon.ts`: `Brig Physician`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/datums/id_trim/jobs.dm`: `/datum/id_trim/job/brig_physician`
- `modular_psychonaut/master_files/icons/mob/clothing/head/helmet.dmi`: `helmet_bp`
- `modular_psychonaut/master_files/icons/mob/clothing/suits/armor.dmi`: `armor_bp`
- `modular_psychonaut/master_files/icons/mob/huds/hud.dmi`: `hudbrigphysician`
- `modular_psychonaut/master_files/icons/obj/card.dmi`: `trim_brig_physician`, `cardboard_brig_physician`
- `modular_psychonaut/master_files/icons/obj/clothing/head/helmet.dmi`: `helmet_bp`
- `modular_psychonaut/master_files/icons/obj/clothing/suits/armor.dmi`: `armor_bp`
- `modular_psychonaut/modules/GAGS/code/greyscale_configs.dm`: `/datum/greyscale_config/tablet/stripe_double_split`
- `modular_psychonaut/modules/GAGS/code/json_configs/pda/pda_stripe_double_split.json`
- `modular_psychonaut/modules/sechuds/code/sechuds.dm`: `GLOB.psychonaut_sechuds`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/atom_hud.dm`: `SECHUD_BRIG_PHYSICIAN`
- `code/__DEFINES/~psychonaut_defines/jobs.dm`: `JOB_BRIG_PHYSICIAN`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

vicirdek, robotduinom, AhmetEfeAkgoz, RengaN, Seefaaa
