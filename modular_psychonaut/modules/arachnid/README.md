## Arachnid

MODULE ID: ARACHNID

### Açıklama

Arachnid ırkını oyuna ekler

### TG Değişiklikleri

- `code/_globalvars/phobias.dm`: `GLOB.phobia_species`
- `code/modules/surgery/organs/internal/eyes/_eyes.dm`: `/obj/item/organ/eyes/Initialize()`, `/obj/item/organ/eyes/on_mob_remove()`, `/obj/item/organ/eyes/proc/generate_body_overlay()`
- `code/modules/unit_tests/screenshot_humanoids.dm`: `/datum/unit_test/screenshot_humanoids/Run()`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/subsystem/sprite_accessories.dm`: `/datum/controller/subsystem/accessories/var/arachnid_appendages_list`, `/datum/controller/subsystem/accessories/setup_lists()`
- `modular_psychonaut/master_files/code/datums/sprite_accessories.dm`: `/datum/sprite_accessory/arachnid_appendages`, `/datum/sprite_accessory/arachnid_appendages/long`, `/datum/sprite_accessory/arachnid_appendages/short`, `/datum/sprite_accessory/arachnid_appendages/sharp`, `/datum/sprite_accessory/arachnid_appendages/zigzag`, `/datum/sprite_accessory/arachnid_appendages/chipped`, `/datum/sprite_accessory/arachnid_appendages/curled`
- `modular_psychonaut/master_files/code/modules/client/preferences/species_features/arachnid.dm`: `/datum/preference/choiced/arachnid_appendages`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/human/human.dm`: `/mob/living/carbon/human/species/arachnid`
- `modular_psychonaut/master_files/code/modules/surgery/organs/internal/eyes/_eyes.dm`: `/obj/item/organ/eyes/var/eye_icon`, `/obj/item/organ/eyes/on_mob_insert()`, `/obj/effect/abstract/eyelid_effect/Initialize()`, `/obj/item/organ/eyes/arachnid`, `/obj/item/organ/eyes/night_vision/arachnid`
- `modular_psychonaut/master_files/code/modules/surgery/organs/internal/tongue/_tongue.dm`: `/obj/item/organ/tongue/arachnid`
- `modular_psychonaut/master_files/icons/mob/human/species/arachnid/arachnid_appendages.dmi`: `m_arachnid_appendages_long_FRONT`, `m_arachnid_appendages_long_BEHIND`, `m_arachnid_appendages_short_FRONT`, `m_arachnid_appendages_short_BEHIND`, `m_arachnid_appendages_sharp_FRONT`, `m_arachnid_appendages_sharp_BEHIND`, `m_arachnid_appendages_zigzag_FRONT`, `m_arachnid_appendages_zigzag_BEHIND`, `m_arachnid_appendages_chipped_FRONT`, `m_arachnid_appendages_chipped_BEHIND`, `m_arachnid_appendages_curled_FRONT`, `m_arachnid_appendages_curled_BEHIND`
- `modular_psychonaut/master_files/icons/mob/human/species/arachnid/bodyparts.dmi`: `arachnid_head`, `arachnid_chest`, `arachnid_l_arm`, `arachnid_r_arm`, `arachnid_l_leg`, `arachnid_r_leg`, `arachnid_l_hand`, `arachnid_r_hand`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/DNA.dm`: `FEATURE_ARACHNID_APPENDAGES`, `ORGAN_SLOT_EXTERNAL_APPENDAGES`
- `code/__DEFINES/~psychonaut_defines/mobs.dm`: `SPECIES_ARACHNID`, `SPECIES_CAVESPIDER`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `code/modules/unit_tests/screenshots/screenshot_humanoids__datum_species_arachnid_cavespider.png`
- `code/modules/unit_tests/screenshots/screenshot_humanoids__datum_species_arachnid.png`

### Katkıda Bulunanlar

Rengan
