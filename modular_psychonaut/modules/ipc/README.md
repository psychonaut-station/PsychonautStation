## IPC

MODULE ID: IPC

### Açıklama

IPC ırkını oyuna ekler

### TG Değişiklikleri

- `code/__DEFINES/DNA.dm`: `ORGAN_SLOT_VOLTPROTECT`, `organ_process_order`
- `code/__DEFINES/mobs.dm`: `BODYTYPE_IPC`
- `code/_globalvars/bitfields.dm`: `bodytype`, `acceptable_bodytype`
- `code/_globalvars/phobias.dm`: `GLOB.phobia_species`
- `code/_onclick/hud/radial.dm`: `/datum/radial_menu/proc/SetElement()`
- `code/datums/components/surgery_initiator.dm`: `/datum/component/surgery_initiator/proc/get_available_surgeries()`
- `code/datums/elements/tool_flash.dm`: `/datum/element/tool_flash/proc/flash()`
- `code/modules/antagonists/heretic/knowledge/starting_lore.dm`: `/datum/heretic_knowledge/living_heart/proc/is_valid_heart()`
- `code/modules/client/preferences_savefile.dm`: `/datum/preferences/proc/save_preferences()`, `/datum/preferences/proc/save_character()`
- `code/modules/client/preferences/_preference.dm`: `/datum/preference/proc/write()`, `/datum/preferences/proc/write_preference()`, `/datum/preferences/proc/update_preference()`, `/datum/preference/proc/compile_ui_data()`, `/datum/preference/choiced/proc/get_choices_serialized()`
- `code/modules/client/preferences/names.dm`: `/datum/preference/name/real_name/deserialize()`
- `code/modules/client/preferences/species.dm`: `/datum/preference/choiced/species/deserialize()`
- `code/modules/deathmatch/deathmatch_maps.dm`: `/datum/lazy_template/deathmatch/species_warfare`
- `code/modules/mob/living/brain/brain_item.dm`: `/obj/item/organ/brain/attack()`
- `code/modules/mob/living/carbon/human/dummy.dm`: `/proc/create_consistent_human_dna()`
- `code/modules/mob/living/carbon/human/human_defines.dm`: `/mob/living/carbon/human/var/hud_possible`
- `code/modules/power/power_store.dm`: `/obj/item/stock_parts/power_store/attack_self()`
- `code/modules/surgery/organ_manipulation.dm`: `/datum/surgery_step/manipulate_organs/preop()`
- `code/modules/surgery/organs/internal/cyberimp/augments_arms.dm`: `/obj/item/organ/cyberimp/arm/toolkit/on_limb_detached()`
- `code/modules/unit_tests/preferences.dm`: `/datum/unit_test/preferences_implement_everything/Run()`
- `code/modules/unit_tests/screenshots/screenshot_humanoids__datum_species_ipc.png`
- `config/game_options.txt`: `ROUNDSTART_RACES`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/_onclick/hud/radial.dm`: `/datum/radial_menu_choice/var/warning`
- `modular_psychonaut/master_files/code/controllers/subsystem/sprite_accessories.dm`: `/datum/controller/subsystem/accessories/var/ipc_chassis_list`, `/datum/controller/subsystem/accessories/setup_lists()`
- `modular_psychonaut/master_files/code/datums/sprite_accessories.dm`: `/datum/sprite_accessory/ipc_chassis`, `/datum/sprite_accessory/ipc_chassis/black`, `/datum/sprite_accessory/ipc_chassis/bishopcyberkinetics`, `/datum/sprite_accessory/ipc_chassis/bishopcyberkinetics2`, `/datum/sprite_accessory/ipc_chassis/hephaestussindustries`, `/datum/sprite_accessory/ipc_chassis/shellguardmunitions`, `/datum/sprite_accessory/ipc_chassis/zenghupharmaceuticals`, `/datum/sprite_accessory/ipc_chassis/star_industrial`, `/datum/sprite_accessory/ipc_chassis/mcgreyscale`
- `modular_psychonaut/master_files/code/datums/bodypart_overlays/markings_bodypart_overlay.dm`: `/datum/bodypart_overlay/simple/body_marking/proc/get_aux_image()`, `/datum/bodypart_overlay/simple/body_marking/ipc`
- `modular_psychonaut/master_files/code/game/data_huds.dm`: `/mob/living/carbon/human/proc/diag_hud_set_humancell()`
- `modular_psychonaut/master_files/code/game/objects/effects/warning.dm`: `/obj/effect/abstract/warning`
- `modular_psychonaut/master_files/code/game/objects/items/storage/boxes/job_boxes.dm`: `/obj/item/storage/box/survival/wardrobe_removal()`
- `modular_psychonaut/master_files/code/modules/client/preferences/clothing.dm`: `/datum/preference/choiced/socks/is_accessible()`, `/datum/preference/choiced/undershirt/is_accessible()`
- `modular_psychonaut/master_files/code/modules/client/preferences/names.dm`: `/datum/preference/name/real_name/serialize()`, `/datum/preference/name/real_name/is_valid()`, `/datum/preference/name/backup_human/deserialize()`
- `modular_psychonaut/master_files/code/modules/client/preferences/species_features/ipc.dm`: `/datum/preference/choiced/ipc_chassis`
- `modular_psychonaut/master_files/code/modules/deathmatch/deathmatch_loadouts.dm`: `/datum/outfit/deathmatch_loadout/ipc`
- `modular_psychonaut/master_files/code/modules/mob/living/brain/brain_cybernetic.dm`: `/obj/item/organ/brain/cybernetic/ipc`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/carbon.dm`: `/mob/living/carbon/get_cell()`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/human/_species.dm`: `/datum/species/var/allow_numbers_in_name`, `/datum/species/proc/wash()`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/human/human.dm`: `/mob/living/carbon/human/prepare_data_huds()`, `/mob/living/carbon/human/wash()`, `/mob/living/carbon/human/species/ipc`
- `modular_psychonaut/master_files/code/modules/power/power_store.dm`: `/obj/item/stock_parts/power_store/proc/ipc_drain()`
- `modular_psychonaut/master_files/code/modules/power/apc/apc_attack.dm`: `/obj/machinery/power/apc/proc/ipc_interact()`
- `modular_psychonaut/master_files/code/modules/reagents/reagent_containers/blood_pack.dm`: `/obj/item/reagent_containers/blood/oil`
- `modular_psychonaut/master_files/code/modules/research/designs/mechfabricator_designs.dm`: `/datum/design/ipc_chest`, `/datum/design/ipc_head`, `/datum/design/ipc_l_arm`, `/datum/design/ipc_r_arm`, `/datum/design/ipc_l_leg`, `/datum/design/ipc_r_leg`, `/datum/design/ipc_stomach`, `/datum/design/ipc_voltprotector`, `/datum/design/ipc_power_cord`
- `modular_psychonaut/master_files/code/modules/research/techweb/nodes/robo_nodes.dm`: `/datum/techweb_node/ipc`
- `modular_psychonaut/master_files/code/modules/surgery/organs/internal/cyberimp/augments_arms.dm`: `/obj/item/organ/cyberimp/arm/on_limb_attached()`, `/obj/item/organ/cyberimp/arm/on_limb_detached()`, `/obj/item/organ/cyberimp/arm/proc/on_limb_qdel()`, `/obj/item/organ/cyberimp/arm/toolkit/on_limb_qdel()`
- `modular_psychonaut/master_files/code/modules/surgery/organs/internal/heart/_heart.dm`: `/obj/item/organ/heart/cybernetic/tier2/ipc`
- `modular_psychonaut/master_files/code/modules/surgery/organs/internal/stomach/stomach_ipc.dm`: `/obj/item/organ/stomach/ipc`
- `modular_psychonaut/master_files/icons/effects/effects.dmi`: `warning`, `warning_hovered`
- `modular_psychonaut/master_files/icons/hud/screen_alert.dmi`: `ipc_nopower`
- `modular_psychonaut/master_files/icons/mob/actions/actions_silicon.dmi`: `ipc_monitor`
- `modular_psychonaut/master_files/icons/mob/human/species/ipc/bodyparts.dmi`
- `modular_psychonaut/master_files/icons/mob/human/species/ipc/ipc_screens.dmi`
- `modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi`: `stomach-ipc`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/DNA.dm`: `FEATURE_IPC_CHASSIS`
- `code/__DEFINES/~psychonaut_defines/mobs.dm`: `SPECIES_IPC`, `IPC_DISCHARGE_FACTOR`
- `code/__DEFINES/~psychonaut_defines/research/research_categories.dm`: `RND_CATEGORY_MECHFAB_IPC`, `RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS`, `RND_SUBCATEGORY_MECHFAB_IPC_ORGANS`
- `code/__DEFINES/~psychonaut_defines/research/techweb_nodes.dm`: `TECHWEB_NODE_IPC`
- `code/__DEFINES/~psychonaut_defines/traits/declarations.dm`: `TRAIT_NOTOOLFLASH`
- `code/__HELPERS/~psychonaut_helpers/is_helpers.dm`: `isipc`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Rengan
