## Localization

MODULE ID: LOCALIZATION

### Açıklama

Adından anlaşılacağı gibi oyunu Türkçeleştirme.

### TG Değişiklikleri

- `code/__DEFINES/anomaly.dm`: `ANOMALY_ANNOUNCE_MEDIUM_TEXT`, `ANOMALY_ANNOUNCE_HARMFUL_TEXT`, `ANOMALY_ANNOUNCE_DANGEROUS_TEXT`
- `code/__DEFINES/time.dm`: `NEW_YEAR`, `VALENTINES`, `APRIL_FOOLS`, `EASTER`, `HALLOWEEN`, `CHRISTMAS`, `FESTIVE_SEASON`, `GARBAGEDAY`, `MONKEYDAY`, `PRIDE_WEEK`, `MOTH_WEEK`, `IAN_HOLIDAY`, `HOTDOG_DAY`, `ICE_CREAM_DAY`
- `code/__HELPERS/chat_filter.dm`: `/proc/is_ic_filtered()`, `/proc/is_soft_ic_filtered()`, `/proc/is_ooc_filtered()`, `/proc/is_soft_ooc_filtered()`, `/proc/is_ic_filtered_for_pdas()`, `/proc/is_soft_ic_filtered_for_pdas()`,
- `code/__HELPERS/names.dm`: `/proc/new_station_name()`, `/proc/generate_code_phrase()`
- `code/__HELPERS/priority_announce.dm`: `/proc/priority_announce()`, `/proc/print_command_report`, `/proc/minor_announce`, `/proc/level_announce`, `/proc/generate_unique_announcement_header`
- `code/__HELPERS/text.dm`: `/proc/reject_bad_name()`, `/proc/capitalize()`
- `code/datums/mutations/body.dm`: `/datum/mutation/human/tourettes/on_life()`
- `code/datums/quirks/neutral_quirks/gamer.dm`: `/datum/quirk/gamer/proc/gamer_moment()`
- `code/datums/voice_of_god_command.dm`: `/proc/voice_of_god()`
- `code/datums/status_effects/debuffs/speech_debuffs.dm`: `/datum/status_effect/speech/stutter/derpspeech/handle_message()`
- `interface/interface.dm`: [`/client`: `verb/wiki()`, `verb/rules()`, `verb/github()`, `verb/reportissue()`]
- `code/controllers/configuration/entries/game_options.dm`: `/datum/config_entry/string/alert_green`, `/datum/config_entry/string/alert_blue_upto`, `/datum/config_entry/string/alert_blue_downto`, `/datum/config_entry/string/alert_red_upto`, `/datum/config_entry/string/alert_red_downto`, `/datum/config_entry/string/alert_delta`
- `code/controllers/subsystem/discord.dm`: `/datum/controller/subsystem/discord/Initialize()`
- `code/controllers/subsystem/nightshift.dm`: `/datum/controller/subsystem/nightshift/proc/announce()`, `/datum/controller/subsystem/nightshift/proc/check_nightshift()`, `/datum/controller/subsystem/nightshift/proc/update_nightshift()`
- `code/controllers/subsystem/shuttle.dm` `/datum/controller/subsystem/shuttle/proc/CheckAutoEvac()`, `/datum/controller/subsystem/shuttle/proc/block_recall()`, `/datum/controller/subsystem/shuttle/proc/unblock_recall()`, `/datum/controller/subsystem/shuttle/proc/call_evac_shuttle()`, `/datum/controller/subsystem/shuttle/proc/checkHostileEnvironment()`
- `code/datums/ai_laws/laws_antagonistic.dm`: `/datum/ai_laws/antimov/var/inherent`, `/datum/ai_laws/balance/var/inherent`, `/datum/ai_laws/thermodynamic/var/inherent`, `/datum/ai_laws/syndicate_override/var/inherent`, `/datum/ai_laws/ninja_override/var/inherent`
- `code/datums/ai_laws/laws_neutral.dm`: `/datum/ai_laws/united_nations/var/inherent`, `/datum/ai_laws/hulkamania/var/inherent`, `/datum/ai_laws/reporter/var/inherent`, `/datum/ai_laws/dungeon_master/var/inherent`, `/datum/ai_laws/painter/var/inherent`, `/datum/ai_laws/tyrant/var/inherent`, `/datum/ai_laws/overlord/var/inherent`
- `code/datums/ai_laws/laws_station_sided.dm`: `/datum/ai_laws/default/asimov/var/inherent`, `/datum/ai_laws/asimovpp/var/inherent`, `/datum/ai_laws/nutimov/var/inherent`, `/datum/ai_laws/default/corporate/var/inherent`, `/datum/ai_laws/robocop/var/inherent`, `/datum/ai_laws/maintain/var/inherent`, `/datum/ai_laws/liveandletlive/var/inherent`, `/datum/ai_laws/peacekeeper/var/inherent`, `/datum/ai_laws/ten_commandments/var/inherent`, `/datum/ai_laws/default/paladin/var/inherent`, `/datum/ai_laws/paladin5/var/inherent`, `/datum/ai_laws/hippocratic/var/inherent`, `/datum/ai_laws/drone/var/inherent`
- `code/datums/communications.dm`: `/datum/communciations_controller/proc/make_announcement()`
- `code/datums/components/cult_ritual_item.dm`: `/datum/component/cult_ritual_item/proc/scribe_narsie_rune()`
- `code/datums/station_traits/negative_traits.dm`: `/datum/station_trait/nebula/hostile/radiation/apply_nebula_effect()`, `/datum/station_trait/nebula/hostile/radiation/send_instructions()`
- `code/datums/station_traits/neutral_traits.dm`: `/datum/station_trait/birthday/proc/announce_birthday()`
- `code/datums/world_topic.dm`: `/datum/world_topic/comms_console/proc/receive_cross_comms_message()`, `/datum/world_topic/news_report/Run()`
- `code/datums/weather/weather_types/radiation_storm.dm`: `/datum/weather/rad_storm/end()`
- `code/datums/mutations/speech.dm`: `/datum/mutation/chav/New()`
- `code/game/gamemodes/events.dm`: `/proc/power_failure()`, `/proc/power_restore()`, `/proc/power_restore_quick()`
- `code/game/machinery/slotmachine.dm`: `/obj/machinery/computer/slot_machine/proc/give_prizes()`
- ``code/game/machinery/status_display.dm`: `/obj/machinery/status_display/proc/set_messages()``
- `code/game/machinery/computer/communications.dm`: `/obj/machinery/computer/communications/ui_act()`, `/obj/machinery/computer/communications/proc/send_cross_comms_message()`, `/obj/machinery/computer/communications/proc/hack_console()`
- `code/game/objects/effects/anomalies/anomalies_bluespace.dm`: `/obj/effect/anomaly/bluespace/detonate()`
- `code/game/objects/effects/anomalies/anomalies_dimensional.dm`: `/obj/effect/anomaly/dimensional/proc/relocate()`
- `code/game/objects/effects/anomalies/anomalies_ectoplasm.dm`: `/obj/effect/anomaly/ectoplasm/detonate()`
- `code/game/objects/effects/wanted_poster.dm`: `/obj/structure/sign/poster/wanted/proc/print_across_top()`
- `code/game/objects/items/crab17.dm`: `/obj/structure/checkoutmachine/Destroy()`, `/obj/effect/dumpeet_target/proc/startLaunch()`
- `code/game/objects/items/dna_probe.dm`: `/obj/item/dna_probe/carp_scanner/attack_self()`
- `code/modules/admin/verbs/adminshuttle.dm`: `disable_shuttle`, `enable_shuttle`
- `code/modules/admin/verbs/anonymousnames.dm`: `/datum/anonymous_theme/proc/announce_to_all_players()`, `/datum/anonymous_theme/proc/restore_all_players()`, `/datum/anonymous_theme/employees/announce_to_all_players()`, `/datum/anonymous_theme/wizards/announce_to_all_players()`, `/datum/anonymous_theme/spider_clan/announce_to_all_players()`, `/datum/anonymous_theme/station/announce_to_all_players()`
- `code/modules/admin/verbs/secrets.dm`: `/datum/secrets_menu/ui_act()`
- `code/modules/antagonists/blob/overmind.dm`: `/mob/eye/blob/process()`
- `code/modules/holiday/holidays.dm`: `/datum/holiday/anz`, `/datum/holiday/atrakor_festival`, `/datum/holiday/friendship/greet()`, `/datum/holiday/indigenous`, `/datum/holiday/un_day`, `/datum/holiday/friday_thirteenth`, `/datum/holiday/islamic/ramadan/end`, `/datum/holiday/hebrew/passover`
- `code/modules/mining/lavaland/mining_loot/megafauna/colossus.dm`: `/obj/item/organ/vocal_cords/colossus/speak_with()`
- `code/modules/mob/living/living_say.dm`: `/mob/living/say()`, `/mob/living/proc/treat_message()`
- `code/modules/spells/spell_types/self/voice_of_god.dm`: `/datum/action/cooldown/spell/voice_of_god/cast()`
- `code/modules/wiremod/components/string/textcase.dm`: `/obj/item/circuit_component/textcase/input_received()`
- `config/game_options.txt`: `ALERT_GREEN`, `ALERT_BLUE_UPTO`, `ALERT_BLUE_DOWNTO`, `ALERT_RED_UPTO`, `ALERT_RED_DOWNTO`, `ALERT_DELTA`

- `tgui/packages/tgui/interfaces/Interview.tsx`: `Interview`, `RenderedStatus`, `QuestionArea`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/modules/holiday/holidays.dm`: `/datum/holiday/greet()`, `/datum/holiday/fleet_day`, `/datum/holiday/fleet_day/greet()`, `/datum/holiday/groundhog`, `/datum/holiday/nz`, `/datum/holiday/nz/greet()`, `/datum/holiday/birthday`, `/datum/holiday/birthday/greet()`, `/datum/holiday/random_kindness`, `/datum/holiday/random_kindness/greet()`, `/datum/holiday/pi`, `/datum/holiday/pi/getStationPrefix()`, `/datum/holiday/no_this_is_patrick`, `/datum/holiday/no_this_is_patrick/getStationPrefix()`, `/datum/holiday/no_this_is_patrick/greet()`, `/datum/holiday/spess`, `/datum/holiday/spess/greet()`, `/datum/holiday/fourtwenty`, `/datum/holiday/tea`, `/datum/holiday/tea/getStationPrefix()`, `/datum/holiday/earth`, `/datum/holiday/cocuk_bayrami`, `/datum/holiday/labor`, `/datum/holiday/draconic_day`, `/datum/holiday/draconic_day/greet()`, `/datum/holiday/spor_bayrami`, `/datum/holiday/firefighter`, `/datum/holiday/firefighter/getStationPrefix()`, `/datum/holiday/bee`, `/datum/holiday/bee/getStationPrefix()`, `/datum/holiday/summersolstice`, `/datum/holiday/doctor`, `/datum/holiday/ufo`, `/datum/holiday/demokrasi_bayrami`, `/datum/holiday/usa`, `/datum/holiday/usa/getStationPrefix()`, `/datum/holiday/writer`, `/datum/holiday/france`, `/datum/holiday/france/getStationPrefix()`, `/datum/holiday/france/greet()`, `/datum/holiday/hotdogday/greet()`, `/datum/holiday/wizards_day`, `/datum/holiday/friendship`, `/datum/holiday/zafer_bayrami`, `/datum/holiday/tiziran_unification`, `/datum/holiday/tiziran_unification/greet()`, `/datum/holiday/tiziran_unification/getStationPrefix()`, `/datum/holiday/ianbirthday/greet()`, `/datum/holiday/pirate`, `/datum/holiday/pirate/greet()`, `/datum/holiday/questions`, `/datum/holiday/questions/greet()`, `/datum/holiday/animal`, `/datum/holiday/smile`, `/datum/holiday/boss`, `/datum/holiday/cumhuriyet_bayrami`, `/datum/holiday/vegan`, `/datum/holiday/october_revolution`, `/datum/holiday/remembrance_day`, `/datum/holiday/remembrance_day/greet()`, `/datum/holiday/remembrance_day/getStationPrefix()`, `/datum/holiday/lifeday`, `/datum/holiday/lifeday/getStationPrefix()`, `/datum/holiday/kindness`, `/datum/holiday/flowers`, `/datum/holiday/hello`, `/datum/holiday/hello/greet()`, `/datum/holiday/holy_lights`, `/datum/holiday/holy_lights/greet()`, `/datum/holiday/festive_season/greet()`, `/datum/holiday/human_rights`, `/datum/holiday/monkey/celebrate()`, `/datum/holiday/xmas/greet()`, `/datum/holiday/boxing`, `/datum/holiday/programmers`, `/datum/holiday/islamic/ramadan`, `/datum/holiday/islamic/ramadan/eve`, `/datum/holiday/hebrew/hanukkah`, `/datum/holiday/hebrew/hanukkah/greet()`, `/datum/holiday/easter/greet()`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/colors.dm`: `COLOR_TURKISH_RED`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot, Seefaaa, Rengan, genkuqq
