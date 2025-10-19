## Alternative Job Titles

MODULE ID: ALTERNATIVE_JOB_TITLES

### Açıklama

Tarafımızca eklenen yiyecekler, yemek makinaları, yiyecek ve içecek tarifleri.

### TG Değişiklikleri

- `code/controllers/subsystem/job.dm`: `/datum/controller/subsystem/job/proc/equip_rank()`
- `code/datums/records/manifest.dm`: `/datum/manifest/proc/inject()`
- `code/modules/admin/verbs/admingame.dm`: `respawn_character`
- `code/modules/client/preferences_savefile.dm`: `/datum/preferences/proc/load_character()`, `/datum/preferences/proc/save_character()`
- `code/modules/client/preferences/middleware/jobs.dm`: `/datum/preference_middleware/jobs`, `/datum/preference_middleware/jobs/get_constant_data()`, `/datum/preference_middleware/jobs/get_ui_data()`
- `code/modules/jobs/job_types/_job.dm`: `/datum/job/proc/announce_job()`, `/datum/job/proc/announce_head()`
- `code/modules/jobs/job_types/security_officer.dm`: `/datum/job/security_officer/proc/setup_department()`
- `code/modules/mob/dead/new_player/new_player.dm`: `/mob/dead/new_player/proc/AttemptLateSpawn()`
- `code/modules/modular_computers/file_system/programs/messenger/messenger_program.dm`: `/datum/computer_file/program/messenger/proc/get_messengers()`
- `tgui/packages/tgui/interfaces/CrewManifest.jsx`: `CrewManifest`
- `tgui/packages/tgui/interfaces/JobSelection.tsx`: `Data`, `JobEntry`
- `tgui/packages/tgui/interfaces/NtosCrewManifest.jsx`: `NtosCrewManifest`
- `tgui/packages/tgui/interfaces/NtosMessenger/index.tsx`: `ContactsScreen`
- `tgui/packages/tgui/interfaces/NtosMessenger/types.tsx`: `NtMessenger`
- `tgui/packages/tgui/interfaces/PreferencesMenu/types.ts`: `Job`, `PreferencesMenuData`
- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/JobsPage.tsx`: `PriorityButtons`, `JobRow`
- `tgui/packages/tgui/styles/interfaces/PreferencesMenu.scss`: `.PreferencesMenu`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/subsystem/job.dm`: `/datum/controller/subsystem/job/var/all_alt_titles`
- `modular_psychonaut/master_files/code/modules/client/preferences.dm`: `/datum/preferences/var/alt_job_titles`
- `modular_psychonaut/master_files/code/modules/client/preferences/middleware/jobs.dm`: `/datum/preference_middleware/jobs/proc/set_job_title()`
- `modular_psychonaut/master_files/code/modules/jobs/job_types/_job.dm`: `/datum/job/var/alt_titles`, `/datum/job/New()`, `/datum/job/proc/set_alt_title()`, `/mob/living/carbon/human/dress_up_as_job()`
- `modular_psychonaut/master_files/code/modules/mob/dead/new_player/latejoin_menu.dm`: `/datum/latejoin_menu/ui_data()`
- `modular_psychonaut/modules/brig_physician/code/job.dm`: `/datum/job/brig_physician/var/alt_titles`
- `modular_psychonaut/modules/worker/code/job.dm`: `/datum/job/worker/var/alt_titles`

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Rengan
