## Job Slots

MODULE ID: JOB_SLOTS

### Açıklama

Character Setup ekranındaki tüm meslekler için, oynayacağımız karakterleri önceden belirlememize olanak sağlayan yeni seçenek ekler.

### TG Değişiklikleri

- `code/modules/client/preferences_savefile.dm`: `/datum/preferences/load_preferences()`, `/datum/preferences/save_preferences()`, `/datum/preferences/load_character()`, `/datum/preferences/save_character()`
- `code/modules/jobs/job_types/_job.dm`: `/mob/living/carbon/human/apply_prefs_job()`
- `tgui/packages/tgui/interfaces/PreferencesMenu/index.tsx`: `PreferencesMenu`
- `tgui/packages/tgui/interfaces/PreferencesMenu/types.ts`: `PreferencesMenuData`
- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/JobsPage.tsx`: `JobSlotDropdown`, `PriorityButtons`, `JobRow`
- `tgui/packages/tgui/styles/interfaces/PreferencesMenu.scss`: `.PreferencesMenu`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/jobs.dm`: `JOB_SLOT_RANDOMISED_SLOT`, `JOB_SLOT_CURRENT_SLOT`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/JobSlotDropdown.tsx`
- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/job_slot_pref_select.tsx`

### Katkıda Bulunanlar

Homek
