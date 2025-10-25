## MENTOR

MODULE ID: MENTOR

### Açıklama

Mentor ticket ve rankını oyuna ekler

### TG Değişiklikleri

- `code/__DEFINES/admin.dm`: `R_EVERYTHING`, `R_MENTOR`
- `code/__DEFINES/span.dm`: `span_mentorsay`, `span_mentorsaytext`
- `code/__HELPERS/type2type.dm`: `/proc/rights2text()`
- `code/_globalvars/bitfields.dm`: `admin_flags`
- `code/datums/components/admin_popup.dm`: `/proc/give_admin_popup()`
- `code/datums/keybinding/client.dm`: `/datum/keybinding/client/admin_help/down()`
- `code/modules/admin/admin_ranks.dm`: `/datum/admin_rank/proc//process_keyword()`
- `code/modules/admin/topic.dm`: `/datum/admins/Topic()`
- `code/modules/admin/verbs/admin.dm`: `show_tip`, `/client/proc/trigger_centcom_recall()`
- `code/modules/admin/verbs/adminhelp.dm`: `/datum/admin_help_tickets/proc/BrowseTickets()`, `REPLACE_SENDER`, `/datum/admin_help/var/ticket_type`, `/datum/admin_help/New()`, `/datum/admin_help/proc/TimeoutVerb()`, `/datum/admin_help/proc/MessageNoRecipient()`, `/datum/admin_help/proc/reply_to_admins_notification()`, `/datum/admin_help/proc/Reject()`, `/datum/admin_help/proc/TicketPanel()`, `/client/proc/giveadminhelpverb()`
- `code/modules/admin/verbs/adminpm.dm`: `cmd_admin_pm_context`, `cmd_admin_pm_panel`, `/client/proc/cmd_ahelp_reply()`, `/client/proc/cmd_admin_pm()`, `/client/proc/sends_adminpm_message()`, `/client/proc/receive_ahelp()`
- `code/modules/admin/verbs/commandreport.dm`: `change_command_name`, `create_command_report`, `/datum/command_report_menu`
- `code/modules/admin/verbs/diagnostics.dm`: `reload_admins`
- `code/modules/admin/verbs/individual_logging.dm`: `/proc/show_individual_logging_panel()`
- `code/modules/admin/verbs/reestablish_db_connection.dm`: `reestablish_db_connection`
- `code/modules/admin/verbs/secrets.dm`: `secrets`
- `code/modules/admin/view_variables/view_variables.dm`: `debug_variables`
- `code/modules/admin/admin_investigate.dm`: `investigate_show`
- `code/modules/client/client_procs.dm`: `/client/Topic()`
- `code/modules/interview/interview.dm`: `/datum/interview/ui_act()`
- `code/modules/requests/request_manager.dm`: `/datum/request_manager`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/admin.dm`: `TICKET_TYPE_ADMIN`, `TICKET_TYPE_MENTOR`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `tgui/packages/tgui/interfaces/Mentorhelp.tsx`
- `tgui/packages/tgui/interfaces/TicketSelectHelper.tsx`

### Katkıda Bulunanlar

loanselot, Seefaaa, Rengan
