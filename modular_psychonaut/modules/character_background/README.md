## Character Background

MODULE ID: CHARACTER_BACKGROUND_INFORMATION

### Açıklama

Oyuna karakter geçmişi ekler.

### TG Değişiklikleri

- `code/datums/records/manifest.dm`: `/datum/manifest/proc/inject()`
- `code/datums/records/record.dm`: `/datum/record/crew/New()`, `/datum/record/crew/proc/get_rapsheet()`
- `code/game/machinery/computer/records/medical.dm`: `/obj/machinery/computer/records/medical/ui_data()`, `/obj/machinery/computer/records/medical/expunge_record_info()`
- `code/game/machinery/computer/records/medical.dm`: `/obj/machinery/computer/records/security/ui_data()`, `/obj/machinery/computer/records/security/expunge_record_info()`
- `code/game/objects/effects/spawners/random/techstorage.dm`: `/obj/effect/spawner/random/techstorage/command_all/var/loot`
- `code/modules/client/preferences/_preference.dm`: `PREFERENCE_PRIORITY_BACKGROUND_INFORMATION`, `MAX_PREFERENCE_PRIORITY`
- `code/modules/paperwork/filingcabinet.dm`: `/obj/structure/filingcabinet/medical/proc/populate()`
- `code/modules/research/techweb/nodes/service_nodes.dm`: `/datum/techweb_node/consoles/var/design_ids`
- `tgui/packages/tgui/interfaces/MedicalRecords/RecordView.tsx`: `MedicalRecordView`
- `tgui/packages/tgui/interfaces/MedicalRecords/types.ts`: `MedicalRecord`
- `tgui/packages/tgui/interfaces/PreferencesMenu/types.ts`: `PreferencesMenuData`
- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/index.tsx`: `BackgroundPage`, `Page`, `CharacterPreferenceWindow`
- `tgui/packages/tgui/interfaces/MedicalRecords/RecordView.tsx`: `RecordInfo`
- `tgui/packages/tgui/interfaces/MedicalRecords/types.ts`: `SecurityRecord`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/game_options.dm`: `/datum/config_entry/number/maximum_background_charlength`
- `modular_psychonaut/master_files/code/controllers/subsystem/minor_mapping.dm`: `/datum/controller/subsystem/minor_mapping/Initialize()`, `/datum/controller/subsystem/minor_mapping/proc/place_crewrecords()`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/human/examine.dm`: `/mob/living/carbon/human/examine_more(mob/user)`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/human/human_defines.dm`: `/mob/living/carbon/human/var/flavor_text`
- `modular_psychonaut/master_files/icons/obj/machines/computer.dmi`: `crewlaptop`

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/CrewRecords/helpers.ts`
- `tgui/packages/tgui/interfaces/CrewRecords/index.tsx`
- `tgui/packages/tgui/interfaces/CrewRecords/RecordTabs.tsx`
- `tgui/packages/tgui/interfaces/CrewRecords/RecordView.tsx`
- `tgui/packages/tgui/interfaces/CrewRecords/types.ts`
- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/BackgroundPage.tsx`

### Katkıda Bulunanlar

Rengan
