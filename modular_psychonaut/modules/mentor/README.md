## MENTOR

MODULE ID: MENTOR

### Açıklama

Mentor ticket ve rankını oyuna ekler

### TG Değişiklikleri

`code/_globalvars/bitfields.dm`: `admin_flags`
`code/datums/keybinding/client.dm`: `/datum/keybinding/client/admin_help/down()`
`code/modules/admin/admin_ranks.dm`: `/datum/admin_rank/proc//process_keyword()`
`code/modules/admin/topic.dm`: `/datum/admins/Topic()`
`code/modules/admin/verbs/admin.dm`
`code/modules/admin/verbs/adminhelp.dm`
`code/modules/admin/verbs/adminpm.dm`
`code/modules/admin/verbs/commandreport.dm`: `change_command_name`, `create_command_report`, `/datum/command_report_menu`
`code/modules/admin/verbs/individual_logging.dm`: `/proc/show_individual_logging_panel()`
`code/modules/requests/request_manager.dm`: `/datum/request_manager`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

`code/__DEFINES/admin.dm`: `R_EVERYTHING`, `R_MENTOR`
`code/__DEFINES/span.dm`: `span_mentorsay`, `span_mentorsaytext`
`code/__DEFINES/~psychonaut_defines/admin.dm`: `TICKET_TYPE_ADMIN`, `TICKET_TYPE_MENTOR`
`code/__HELPERS/type2type.dm`: `/proc/rights2text()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/Mentorhelp.tsx`
- `tgui/packages/tgui/interfaces/TicketSelectHelper.tsx`

### Katkıda Bulunanlar

loanselot, Seefaaa, Rengan
