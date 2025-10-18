## Schizo

MODULE ID: SCHIZO

### Açıklama

Daha iyi ve Türkçe halüsinasyonlar

### TG Değişiklikleri

- `code/__DEFINES/logging.dm`: `LOG_HALLUCINATION`, `INDIVIDUAL_HALLUCINATION_LOG`, `INDIVIDUAL_SHOW_ALL_LOG`, `LOG_CATEGORY_GAME_HALLUCINATION`
- `code/__HELPERS/logging/_logging.dm`: `/atom/proc/log_message()`
- `code/modules/admin/verbs/individual_logging.dm`: `/proc/show_individual_logging_panel()`
- `code/modules/hallucination/fake_chat.dm`: `/datum/hallucination/chat/start()`
- `config/logging.txt`: `LOG_HALLUCINATION`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/configuration/entries/general.dm`: `/datum/config_entry/flag/log_hallucination`
- `modular_psychonaut/master_files/code/controllers/subsystem/job.dm`: `/datum/controller/subsystem/job/proc/get_department_crew()`, `/datum/controller/subsystem/job/proc/is_occupation_of()`
- `modular_psychonaut/master_files/code/modules/logging/categories/log_category_game.dm`: `/datum/log_category/game_hallucination`
- `modular_psychonaut/master_files/strings/hallucination.json`

### Definelar ve Helperlar

- `code/__HELPERS/~psychonaut_helpers/logging.dm`: `/proc/log_hallucination()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot
