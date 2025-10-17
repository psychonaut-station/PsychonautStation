## Localization

MODULE ID: LOCALIZATION

### Açıklama

Adından anlaşılacağı gibi oyunu Türkçeleştirme.

<!-- priority_announce ve minor_announce ler yarım kaldı -->

### TG Değişiklikleri

- `code/__HELPERS/priority_announce.dm`: `/proc/priority_announce()`, `/proc/print_command_report`, `/proc/minor_announce`, `/proc/level_announce`, `/proc/generate_unique_announcement_header`
- `code/datums/mutations/body.dm`: `/datum/mutation/human/tourettes/on_life()`
- `code/datums/quirks/neutral_quirks/gamer.dm`: `/datum/quirk/gamer/proc/gamer_moment()`
- `interface/interface.dm`: [`/client`: `verb/wiki()`, `verb/rules()`, `verb/github()`, `verb/reportissue()`]
- `code/controllers/subsystem/nightshift.dm`: `/datum/controller/subsystem/nightshift/proc/announce()`, `/datum/controller/subsystem/nightshift/proc/check_nightshift()`, `/datum/controller/subsystem/nightshift/proc/update_nightshift()`
- `code/controllers/subsystem/shuttle.dm` `/datum/controller/subsystem/shuttle/proc/CheckAutoEvac()`, `/datum/controller/subsystem/shuttle/proc/block_recall()`, `/datum/controller/subsystem/shuttle/proc/unblock_recall()`, `/datum/controller/subsystem/shuttle/proc/call_evac_shuttle()`, `/datum/controller/subsystem/shuttle/proc/checkHostileEnvironment()`
- `code/datums/communications.dm`: `/datum/communciations_controller/proc/make_announcement()`
- `code/datums/components/cult_ritual_item.dm`: `/datum/component/cult_ritual_item/proc/scribe_narsie_rune()`
- `code/datums/station_traits/negative_traits.dm`: `/datum/station_trait/nebula/hostile/radiation/apply_nebula_effect()`, `/datum/station_trait/nebula/hostile/radiation/send_instructions()`
- `code/datums/station_traits/neutral_traits.dm`: `/datum/station_trait/birthday/proc/announce_birthday()`
- `code/datums/weather/weather_types/radiation_storm.dm`: `/datum/weather/rad_storm/end()`
- `code/game/gamemodes/events.dm`: `/proc/power_failure()`, `/proc/power_restore()`, `/proc/power_restore_quick()`
- `code/game/machinery/slotmachine.dm`: `/obj/machinery/computer/slot_machine/proc/give_prizes()`
- `code/game/machinery/computer/communications.dm`: `/obj/machinery/computer/communications/ui_act()`, `/obj/machinery/computer/communications/proc/send_cross_comms_message()`, `/obj/machinery/computer/communications/proc/hack_console()`
- `code/game/objects/effects/anomalies/anomalies_bluespace.dm`: `/obj/effect/anomaly/bluespace/detonate()`
- `code/game/objects/effects/anomalies/anomalies_dimensional.dm`: `/obj/effect/anomaly/dimensional/proc/relocate()`
- `code/game/objects/effects/anomalies/anomalies_ectoplasm.dm`: `/obj/effect/anomaly/ectoplasm/detonate()`
- `code/game/objects/items/crab17.dm`: `/obj/structure/checkoutmachine/Destroy()`, `/obj/effect/dumpeet_target/proc/startLaunch()`
- `code/game/objects/items/dna_probe.dm`: `/obj/item/dna_probe/carp_scanner/attack_self()`
- `code/modules/admin/verbs/adminshuttle.dm`: `disable_shuttle`, `enable_shuttle`
- `code/modules/admin/verbs/anonymousnames.dm`: `/datum/anonymous_theme/proc/announce_to_all_players()`, `/datum/anonymous_theme/proc/restore_all_players()`, `/datum/anonymous_theme/employees/announce_to_all_players()`, `/datum/anonymous_theme/wizards/announce_to_all_players()`, `/datum/anonymous_theme/spider_clan/announce_to_all_players()`, `/datum/anonymous_theme/station/announce_to_all_players()`
- `code/modules/admin/verbs/secrets.dm`: `/datum/secrets_menu/ui_act()`
- `code/modules/antagonists/blob/overmind.dm`: `/mob/eye/blob/process()`
- `tgui/packages/tgui/interfaces/Interview.tsx`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- `code/__HELPERS/~psychonaut_helpers/text.dm`: `/proc/locale_uppertext()`, `/proc/locale_lowertext_()`, `/proc/delocale_text()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot, Seefaaa, Rengan, genkuqq
