## Localization

MODULE ID: LOCALIZATION

### Açıklama

Adından anlaşılacağı gibi oyunu Türkçeleştirme.

### TG Değişiklikleri

- `code/__DEFINES/anomaly.dm`: `ANOMALY_ANNOUNCE_MEDIUM_TEXT`, `ANOMALY_ANNOUNCE_HARMFUL_TEXT`, `ANOMALY_ANNOUNCE_DANGEROUS_TEXT`
- `code/__DEFINES/time.dm`: `NEW_YEAR`, `VALENTINES`, `APRIL_FOOLS`, `EASTER`, `HALLOWEEN`, `CHRISTMAS`, `FESTIVE_SEASON`, `GARBAGEDAY`, `MONKEYDAY`, `PRIDE_WEEK`, `MOTH_WEEK`, `IAN_HOLIDAY`, `HOTDOG_DAY`, `ICE_CREAM_DAY`
- `code/__HELPERS/chat_filter.dm`: `/proc/is_ic_filtered()`, `/proc/is_soft_ic_filtered()`, `/proc/is_ooc_filtered()`, `/proc/is_soft_ooc_filtered()`, `/proc/is_ic_filtered_for_pdas()`, `/proc/is_soft_ic_filtered_for_pdas()`,
- `code/__HELPERS/names.dm`: `/proc/new_station_name()`
- `code/__HELPERS/priority_announce.dm`: `/proc/priority_announce()`, `/proc/print_command_report`, `/proc/minor_announce`, `/proc/level_announce`, `/proc/generate_unique_announcement_header`
- `code/controllers/configuration/entries/game_options.dm`: `/datum/config_entry/string/alert_green`, `/datum/config_entry/string/alert_blue_upto`, `/datum/config_entry/string/alert_blue_downto`, `/datum/config_entry/string/alert_red_upto`, `/datum/config_entry/string/alert_red_downto`, `/datum/config_entry/string/alert_delta`
- `code/controllers/subsystem/discord.dm`: `/datum/controller/subsystem/discord/Initialize()`
- `code/controllers/subsystem/nightshift.dm`: `/datum/controller/subsystem/nightshift/proc/announce()`, `/datum/controller/subsystem/nightshift/proc/check_nightshift()`, `/datum/controller/subsystem/nightshift/proc/update_nightshift()`
- `code/controllers/subsystem/shuttle.dm`
- `code/datums/ai_laws/laws_antagonistic.dm`: `/datum/ai_laws/antimov/var/inherent`, `/datum/ai_laws/balance/var/inherent`, `/datum/ai_laws/thermodynamic/var/inherent`, `/datum/ai_laws/syndicate_override/var/inherent`, `/datum/ai_laws/ninja_override/var/inherent`
- `code/datums/ai_laws/laws_neutral.dm`: `/datum/ai_laws/united_nations/var/inherent`, `/datum/ai_laws/hulkamania/var/inherent`, `/datum/ai_laws/reporter/var/inherent`, `/datum/ai_laws/dungeon_master/var/inherent`, `/datum/ai_laws/painter/var/inherent`, `/datum/ai_laws/tyrant/var/inherent`, `/datum/ai_laws/overlord/var/inherent`
- `code/datums/ai_laws/laws_station_sided.dm`: `/datum/ai_laws/default/asimov/var/inherent`, `/datum/ai_laws/asimovpp/var/inherent`, `/datum/ai_laws/nutimov/var/inherent`, `/datum/ai_laws/default/corporate/var/inherent`, `/datum/ai_laws/robocop/var/inherent`, `/datum/ai_laws/maintain/var/inherent`, `/datum/ai_laws/liveandletlive/var/inherent`, `/datum/ai_laws/peacekeeper/var/inherent`, `/datum/ai_laws/ten_commandments/var/inherent`, `/datum/ai_laws/default/paladin/var/inherent`, `/datum/ai_laws/paladin5/var/inherent`, `/datum/ai_laws/hippocratic/var/inherent`, `/datum/ai_laws/drone/var/inherent`
- `code/datums/communications.dm`: `/datum/communciations_controller/proc/make_announcement()`
- `code/datums/components/cult_ritual_item.dm`: `/datum/component/cult_ritual_item/proc/scribe_narsie_rune()`
- `code/datums/mutations/body.dm`: `/datum/mutation/human/tourettes/on_life()`
- `code/datums/mutations/speech.dm`: `/datum/mutation/chav/New()`
- `code/datums/quirks/neutral_quirks/gamer.dm`: `/datum/quirk/gamer/proc/gamer_moment()`
- `code/datums/station_traits/negative_traits.dm`: `/datum/station_trait/nebula/hostile/radiation/apply_nebula_effect()`, `/datum/station_trait/nebula/hostile/radiation/send_instructions()`
- `code/datums/station_traits/neutral_traits.dm`: `/datum/station_trait/birthday/proc/announce_birthday()`
- `code/datums/weather/weather_types/radiation_storm.dm`: `/datum/weather/rad_storm/end()`
- `code/datums/world_topic.dm`: `/datum/world_topic/comms_console/proc/receive_cross_comms_message()`, `/datum/world_topic/news_report/Run()`
- `code/game/gamemodes/events.dm`: `/proc/power_failure()`, `/proc/power_restore()`, `/proc/power_restore_quick()`
- `code/game/machinery/computer/communications.dm`: `/obj/machinery/computer/communications/ui_act()`, `/obj/machinery/computer/communications/proc/send_cross_comms_message()`, `/obj/machinery/computer/communications/proc/hack_console()`
- `code/game/machinery/requests_console.dm`: `/obj/machinery/requests_console/ui_act()`
- `code/game/machinery/requests_console.dm`: `/obj/machinery/requests_console/ui_act()`
- `code/game/machinery/slotmachine.dm`: `/obj/machinery/computer/slot_machine/proc/give_prizes()`
- `code/game/objects/effects/anomalies/anomalies_bluespace.dm`: `/obj/effect/anomaly/bluespace/detonate()`
- `code/game/objects/effects/anomalies/anomalies_dimensional.dm`: `/obj/effect/anomaly/dimensional/proc/relocate()`
- `code/game/objects/effects/anomalies/anomalies_ectoplasm.dm`: `/obj/effect/anomaly/ectoplasm/detonate()`
- `code/game/objects/items/charter.dm`: `/obj/item/station_charter/proc/rename_station()`, `/obj/item/station_charter/banner/rename_station()`
- `code/game/objects/items/charter.dm`: `/obj/item/station_charter/proc/rename_station()`, `/obj/item/station_charter/banner/rename_station()`
- `code/game/objects/items/crab17.dm`: `/obj/structure/checkoutmachine/Destroy()`, `/obj/effect/dumpeet_target/proc/startLaunch()`
- `code/game/objects/items/dna_probe.dm`: `/obj/item/dna_probe/carp_scanner/attack_self()`
- `code/game/objects/items/mail.dm`: `/obj/item/mail/proc/junk_mail()`
- `code/modules/admin/verbs/adminshuttle.dm`: `disable_shuttle`, `enable_shuttle`
- `code/modules/admin/verbs/anonymousnames.dm`: `/datum/anonymous_theme/proc/announce_to_all_players()`, `/datum/anonymous_theme/proc/restore_all_players()`, `/datum/anonymous_theme/employees/announce_to_all_players()`, `/datum/anonymous_theme/wizards/announce_to_all_players()`, `/datum/anonymous_theme/spider_clan/announce_to_all_players()`, `/datum/anonymous_theme/station/announce_to_all_players()`
- `code/modules/admin/verbs/secrets.dm`: `/datum/secrets_menu/ui_act()`
- `code/modules/admin/topic.dm`: `/datum/admins/Topic()`
- `code/modules/antagonists/blob/overmind.dm`: `/mob/eye/blob/process()`
- `code/modules/antagonists/cult/cult_items.dm`: `/obj/item/shuttle_curse/attack_self()`
- `code/modules/antagonists/heretic/knowledge/ash_lore.dm`: `/datum/heretic_knowledge/ultimate/ash_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/ash_lore.dm`: `/datum/heretic_knowledge/ultimate/ash_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/blade_lore.dm`: `/datum/heretic_knowledge/ultimate/blade_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/blade_lore.dm`: `/datum/heretic_knowledge/ultimate/blade_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/cosmic_lore.dm`: `/datum/heretic_knowledge/ultimate/cosmic_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/cosmic_lore.dm`: `/datum/heretic_knowledge/ultimate/cosmic_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/flesh_lore.dm`: `/datum/heretic_knowledge/ultimate/flesh_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/flesh_lore.dm`: `/datum/heretic_knowledge/ultimate/flesh_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/lock_lore.dm`: `/datum/heretic_knowledge/ultimate/lock_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/lock_lore.dm`: `/datum/heretic_knowledge/ultimate/lock_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/moon_lore.dm`: `/datum/heretic_knowledge/ultimate/moon_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/moon_lore.dm`: `/datum/heretic_knowledge/ultimate/moon_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/rust_lore.dm`: `/datum/heretic_knowledge/ultimate/rust_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/rust_lore.dm`: `/datum/heretic_knowledge/ultimate/rust_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/void_lore.dm`: `/datum/heretic_knowledge/ultimate/void_final/var/announcement_text`
- `code/modules/antagonists/heretic/knowledge/void_lore.dm`: `/datum/heretic_knowledge/ultimate/void_final/var/announcement_text`
- `code/modules/antagonists/malf_ai/malf_ai_modules.dm`: `/datum/action/innate/ai/nuke_station/proc/set_up_us_the_bomb()`
- `code/modules/antagonists/malf_ai/malf_ai_modules.dm`: `/datum/action/innate/ai/nuke_station/proc/set_up_us_the_bomb()`
- `code/modules/antagonists/nukeop/equipment/nuclear_bomb/_nuclear_bomb.dm`: `/obj/machinery/nuclearbomb/proc/really_actually_explode()`
- `code/modules/antagonists/nukeop/equipment/nuclear_bomb/_nuclear_bomb.dm`: `/obj/machinery/nuclearbomb/proc/really_actually_explode()`
- `code/modules/antagonists/nukeop/equipment/nuclear_challenge.dm`: `/obj/item/nuclear_challenge/proc/war_was_declared()`, `/obj/item/nuclear_challenge/literally_just_does_the_message/war_was_declared()`
- `code/modules/antagonists/nukeop/equipment/nuclear_challenge.dm`: `/obj/item/nuclear_challenge/proc/war_was_declared()`, `/obj/item/nuclear_challenge/literally_just_does_the_message/war_was_declared()`
- `code/modules/antagonists/pirate/pirate_gangs.dm`: [`/datum/pirate_gang`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/rogues`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/silverscales`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/skeletons`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/interdyne`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/grey`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/irs`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/lustrous`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`]
- `code/modules/antagonists/pirate/pirate_gangs.dm`: [`/datum/pirate_gang`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/rogues`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/silverscales`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/skeletons`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/interdyne`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/grey`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/irs`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`], [`/datum/pirate_gang/lustrous`: `var/response_received`, `var/response_rejected`, `var/response_too_late`, `var/response_not_enough`]
- `code/modules/antagonists/pirate/pirate_shuttle_equipment.dm`: `/obj/machinery/shuttle_scrambler/proc/send_notification()`
- `code/modules/antagonists/pirate/pirate_shuttle_equipment.dm`: `/obj/machinery/shuttle_scrambler/proc/send_notification()`
- `code/modules/antagonists/separatist/nation_creation.dm`: `/proc/create_separatist_nation()`
- `code/modules/antagonists/separatist/nation_creation.dm`: `/proc/create_separatist_nation()`
- `code/modules/antagonists/space_dragon/carp_rift.dm`: `/obj/structure/carp_rift/proc/update_check()`
- `code/modules/antagonists/space_dragon/carp_rift.dm`: `/obj/structure/carp_rift/proc/update_check()`
- `code/modules/antagonists/space_dragon/space_dragon.dm`: `/datum/antagonist/space_dragon/proc/victory()`
- `code/modules/antagonists/space_dragon/space_dragon.dm`: `/datum/antagonist/space_dragon/proc/victory()`
- `code/modules/antagonists/wizard/grand_ritual/finales/armageddon.dm`: `/datum/grand_finale/armageddon`, `var/possible_last_words`
- `code/modules/antagonists/wizard/grand_ritual/finales/armageddon.dm`: `/datum/grand_finale/armageddon`, `var/possible_last_words`
- `code/modules/antagonists/wizard/grand_ritual/finales/captaincy.dm`: `/datum/grand_finale/usurp/trigger()`
- `code/modules/antagonists/wizard/grand_ritual/finales/captaincy.dm`: `/datum/grand_finale/usurp/trigger()`
- `code/modules/antagonists/wizard/grand_ritual/finales/cheese.dm`: `/datum/grand_finale/cheese/trigger()`
- `code/modules/antagonists/wizard/grand_ritual/finales/cheese.dm`: `/datum/grand_finale/cheese/trigger()`
- `code/modules/antagonists/wizard/grand_ritual/grand_rune.dm`: `/obj/effect/grand_rune/proc/announce_rune()`, `/obj/effect/grand_rune/finale/invoke_rune()`
- `code/modules/antagonists/wizard/grand_ritual/grand_rune.dm`: `/obj/effect/grand_rune/proc/announce_rune()`, `/obj/effect/grand_rune/finale/invoke_rune()`
- `code/modules/atmospherics/machinery/components/fusion/hfr_procs.dm`: `/obj/machinery/atmospherics/components/unary/hypertorus/core/proc/countdown()`
- `code/modules/atmospherics/machinery/components/fusion/hfr_procs.dm`: `/obj/machinery/atmospherics/components/unary/hypertorus/core/proc/countdown()`
- `code/modules/client/verbs/who.dm`: `NO_ADMINS_ONLINE_MESSAGE`, `/client/verb/adminwho()`
- `code/modules/client/verbs/who.dm`: `NO_ADMINS_ONLINE_MESSAGE`, `/client/verb/adminwho()`
- `code/modules/events/anomaly/_anomaly.dm`: `/datum/round_event/anomaly/announce()`
- `code/modules/events/anomaly/_anomaly.dm`: `/datum/round_event/anomaly/announce()`
- `code/modules/events/anomaly/anomaly_bioscrambler.dm`: `/datum/round_event/anomaly/anomaly_bioscrambler/announce()`
- `code/modules/events/anomaly/anomaly_bioscrambler.dm`: `/datum/round_event/anomaly/anomaly_bioscrambler/announce()`
- `code/modules/events/anomaly/anomaly_bluespace.dm`: `/datum/round_event/anomaly/anomaly_bluespace/announce()`
- `code/modules/events/anomaly/anomaly_bluespace.dm`: `/datum/round_event/anomaly/anomaly_bluespace/announce()`
- `code/modules/events/anomaly/anomaly_dimensional.dm`: `/datum/round_event/anomaly/anomaly_dimensional/announce()`
- `code/modules/events/anomaly/anomaly_dimensional.dm`: `/datum/round_event/anomaly/anomaly_dimensional/announce()`
- `code/modules/events/anomaly/anomaly_ectoplasm.dm`: `/datum/round_event/anomaly/anomaly_ectoplasm/announce()`
- `code/modules/events/anomaly/anomaly_ectoplasm.dm`: `/datum/round_event/anomaly/anomaly_ectoplasm/announce()`
- `code/modules/events/anomaly/anomaly_grav.dm`: `/datum/round_event/anomaly/anomaly_grav/announce()`
- `code/modules/events/anomaly/anomaly_grav.dm`: `/datum/round_event/anomaly/anomaly_grav/announce()`
- `code/modules/events/anomaly/anomaly_hallucination.dm`: `/datum/round_event/anomaly/anomaly_hallucination/announce()`
- `code/modules/events/anomaly/anomaly_hallucination.dm`: `/datum/round_event/anomaly/anomaly_hallucination/announce()`
- `code/modules/events/anomaly/anomaly_pyro.dm`: `/datum/round_event/anomaly/anomaly_pyro/announce()`
- `code/modules/events/anomaly/anomaly_pyro.dm`: `/datum/round_event/anomaly/anomaly_pyro/announce()`
- `code/modules/events/aurora_caelus.dm`: `/datum/round_event/aurora_caelus/announce()`, `/datum/round_event/aurora_caelus/end()`
- `code/modules/events/aurora_caelus.dm`: `/datum/round_event/aurora_caelus/announce()`, `/datum/round_event/aurora_caelus/end()`
- `code/modules/events/brand_intelligence.dm`: `/datum/round_event/brand_intelligence/announce()`
- `code/modules/events/brand_intelligence.dm`: `/datum/round_event/brand_intelligence/announce()`
- `code/modules/events/communications_blackout.dm`: `/datum/round_event/communications_blackout/announce()`
- `code/modules/events/communications_blackout.dm`: `/datum/round_event/communications_blackout/announce()`
- `code/modules/events/grid_check.dm`: `/datum/round_event/grid_check/announce()`
- `code/modules/events/grid_check.dm`: `/datum/round_event/grid_check/announce()`
- `code/modules/events/holiday/easter.dm`: `/datum/round_event/easter/announce()`, `/datum/round_event/rabbitrelease/announce()`
- `code/modules/events/holiday/easter.dm`: `/datum/round_event/easter/announce()`, `/datum/round_event/rabbitrelease/announce()`
- `code/modules/events/holiday/halloween.dm`: `/datum/round_event/spooky/announce()`
- `code/modules/events/holiday/halloween.dm`: `/datum/round_event/spooky/announce()`
- `code/modules/events/holiday/vday.dm`: `/datum/round_event/valentines/announce()`
- `code/modules/events/holiday/vday.dm`: `/datum/round_event/valentines/announce()`
- `code/modules/events/holiday/xmas.dm`: `/datum/round_event/ghost_role/santa/announce()`
- `code/modules/events/holiday/xmas.dm`: `/datum/round_event/ghost_role/santa/announce()`
- `code/modules/events/immovable_rod/immovable_rod_event.dm`: `/datum/round_event/immovable_rod/announce()`
- `code/modules/events/immovable_rod/immovable_rod_event.dm`: `/datum/round_event/immovable_rod/announce()`
- `code/modules/events/market_crash.dm`: `/datum/round_event/market_crash/announce()`, `/datum/round_event/market_crash/end()`
- `code/modules/events/market_crash.dm`: `/datum/round_event/market_crash/announce()`, `/datum/round_event/market_crash/end()`
- `code/modules/events/meteors/dark_matteor_event.dm`: `/datum/round_event/dark_matteor/announce()`
- `code/modules/events/meteors/dark_matteor_event.dm`: `/datum/round_event/dark_matteor/announce()`
- `code/modules/events/meteors/stray_meteor_event.dm`: `/datum/round_event/stray_meteor/announce()`
- `code/modules/events/meteors/stray_meteor_event.dm`: `/datum/round_event/stray_meteor/announce()`
- `code/modules/events/mice_migration.dm`: `/datum/round_event/mice_migration/announce()`
- `code/modules/events/mice_migration.dm`: `/datum/round_event/mice_migration/announce()`
- `code/modules/events/processor_overload.dm`: `/datum/round_event/processor_overload/announce()`
- `code/modules/events/processor_overload.dm`: `/datum/round_event/processor_overload/announce()`
- `code/modules/events/radiation_leak.dm`: `/datum/round_event/radiation_leak/announce()`
- `code/modules/events/radiation_leak.dm`: `/datum/round_event/radiation_leak/announce()`
- `code/modules/events/radiation_storm.dm`: `/datum/round_event/radiation_storm/announce()`
- `code/modules/events/radiation_storm.dm`: `/datum/round_event/radiation_storm/announce()`
- `code/modules/events/sandstorm.dm`: `/datum/round_event/sandstorm/announce()`
- `code/modules/events/sandstorm.dm`: `/datum/round_event/sandstorm/announce()`
- `code/modules/events/shuttle_catastrophe.dm`: `/datum/round_event/shuttle_catastrophe/announce()`
- `code/modules/events/shuttle_catastrophe.dm`: `/datum/round_event/shuttle_catastrophe/announce()`
- `code/modules/events/shuttle_insurance.dm`: `/datum/round_event/shuttle_insurance/announce()`, `/datum/round_event/shuttle_insurance/proc/answered()`
- `code/modules/events/shuttle_insurance.dm`: `/datum/round_event/shuttle_insurance/announce()`, `/datum/round_event/shuttle_insurance/proc/answered()`
- `code/modules/events/shuttle_loan/shuttle_loan_event.dm`: `/datum/round_event/shuttle_loan/announce()`, `/datum/round_event/shuttle_loan/proc/loan_shuttle()`
- `code/modules/events/shuttle_loan/shuttle_loan_event.dm`: `/datum/round_event/shuttle_loan/announce()`, `/datum/round_event/shuttle_loan/proc/loan_shuttle()`
- `code/modules/events/stray_cargo.dm`: `/datum/round_event/stray_cargo/announce()`
- `code/modules/events/stray_cargo.dm`: `/datum/round_event/stray_cargo/announce()`
- `code/modules/events/supermatter_surge.dm`: `/datum/round_event/supermatter_surge/announce()`, `/datum/round_event/supermatter_surge/end()`, `/datum/round_event/supermatter_surge/poly/announce()`
- `code/modules/events/supermatter_surge.dm`: `/datum/round_event/supermatter_surge/announce()`, `/datum/round_event/supermatter_surge/end()`, `/datum/round_event/supermatter_surge/poly/announce()`
- `code/modules/events/vent_clog.dm`: `/datum/round_event/vent_clog/announce()`, `/datum/round_event/vent_clog/proc/vent_move(datum/source)`, `/datum/round_event/vent_clog/major/announce()`, `/datum/round_event/vent_clog/critical/announce()`, `/datum/round_event/vent_clog/strange/announce()`
- `code/modules/events/vent_clog.dm`: `/datum/round_event/vent_clog/announce()`, `/datum/round_event/vent_clog/proc/vent_move(datum/source)`, `/datum/round_event/vent_clog/major/announce()`, `/datum/round_event/vent_clog/critical/announce()`, `/datum/round_event/vent_clog/strange/announce()`
- `code/modules/events/wisdomcow.dm`: `/datum/round_event/wisdomcow/announce()`
- `code/modules/events/wisdomcow.dm`: `/datum/round_event/wisdomcow/announce()`
- `code/modules/events/wormholes.dm`: `/datum/round_event/wormholes/announce()`
- `code/modules/events/wormholes.dm`: `/datum/round_event/wormholes/announce()`
- `code/modules/holiday/holidays.dm`: `/datum/holiday/anz`, `/datum/holiday/atrakor_festival`, `/datum/holiday/friendship/greet()`, `/datum/holiday/indigenous`, `/datum/holiday/un_day`, `/datum/holiday/friday_thirteenth`, `/datum/holiday/islamic/ramadan/end`, `/datum/holiday/hebrew/passover`
- `code/modules/jobs/job_types/ai.dm`: `/datum/job/ai/announce_job()`
- `code/modules/jobs/job_types/ai.dm`: `/datum/job/ai/announce_job()`
- `code/modules/jobs/job_types/captain.dm`: `/datum/job/captain/get_captaincy_announcement()`
- `code/modules/jobs/job_types/captain.dm`: `/datum/job/captain/get_captaincy_announcement()`
- `code/modules/jobs/job_types/chief_engineer.dm`: `/datum/job/chief_engineer/get_captaincy_announcement()`
- `code/modules/jobs/job_types/chief_engineer.dm`: `/datum/job/chief_engineer/get_captaincy_announcement()`
- `code/modules/jobs/job_types/chief_medical_officer.dm`: `/datum/job/chief_medical_officer/get_captaincy_announcement()`
- `code/modules/jobs/job_types/chief_medical_officer.dm`: `/datum/job/chief_medical_officer/get_captaincy_announcement()`
- `code/modules/jobs/job_types/head_of_personnel.dm`: `/datum/job/head_of_personnel/get_captaincy_announcement()`
- `code/modules/jobs/job_types/head_of_personnel.dm`: `/datum/job/head_of_personnel/get_captaincy_announcement()`
- `code/modules/jobs/job_types/head_of_security.dm`: `/datum/job/head_of_security/get_captaincy_announcement()`
- `code/modules/jobs/job_types/head_of_security.dm`: `/datum/job/head_of_security/get_captaincy_announcement()`
- `code/modules/jobs/job_types/research_director.dm`: `/datum/job/research_director/get_captaincy_announcement()`
- `code/modules/jobs/job_types/research_director.dm`: `/datum/job/research_director/get_captaincy_announcement()`
- `code/modules/jobs/job_types/station_trait/human_ai.dm`: `/datum/job/human_ai/announce_job()`
- `code/modules/jobs/job_types/station_trait/human_ai.dm`: `/datum/job/human_ai/announce_job()`
- `code/modules/meteors/meteor_dark_matteor.dm`: `/obj/effect/meteor/dark_matteor/moved_off_z()`
- `code/modules/meteors/meteor_dark_matteor.dm`: `/obj/effect/meteor/dark_matteor/moved_off_z()`
- `code/modules/mining/aux_base.dm`: `/obj/machinery/computer/auxiliary_base/proc/set_landing_zone()`
- `code/modules/mining/aux_base.dm`: `/obj/machinery/computer/auxiliary_base/proc/set_landing_zone()`
- `code/modules/mob/living/living.dm`: `/mob/living/proc/process_capture()`
- `code/modules/mob/living/living.dm`: `/mob/living/proc/process_capture()`
- `code/modules/mob/living/silicon/ai/ai_say.dm`: `/mob/living/silicon/ai/proc/announcement()`
- `code/modules/mob/living/silicon/ai/ai_say.dm`: `/mob/living/silicon/ai/proc/announcement()`
- `code/modules/mob/living/silicon/ai/freelook/eye.dm`: `/mob/eye/camera/ai/examine()`
- `code/modules/mob/living/silicon/ai/freelook/eye.dm`: `/mob/eye/camera/ai/examine()`
- `code/modules/mob/living/silicon/examine.dm`: `/mob/living/silicon/examine()`
- `code/modules/mob/living/silicon/examine.dm`: `/mob/living/silicon/examine()`
- `code/modules/mob/living/silicon/laws.dm`: `/mob/living/silicon/proc/show_laws()`, `/mob/living/silicon/proc/post_lawchange()`
- `code/modules/mob/living/silicon/laws.dm`: `/mob/living/silicon/proc/show_laws()`, `/mob/living/silicon/proc/post_lawchange()`
- `code/modules/mob/living/silicon/robot/laws.dm`: `/mob/living/silicon/robot/show_laws()`, `/mob/living/silicon/robot/post_lawchange()`
- `code/modules/mob/living/silicon/robot/laws.dm`: `/mob/living/silicon/robot/show_laws()`, `/mob/living/silicon/robot/post_lawchange()`
- `code/modules/mob/living/silicon/silicon.dm`: `/mob/living/silicon/proc/statelaws()`
- `code/modules/mob/living/silicon/silicon.dm`: `/mob/living/silicon/proc/statelaws()`
- `code/modules/power/singularity/narsie.dm`: `/proc/narsie_end_begin_check()`, `/proc/narsie_end_second_check()`, `/proc/narsie_apocalypse()`
- `code/modules/power/singularity/narsie.dm`: `/proc/narsie_end_begin_check()`, `/proc/narsie_end_second_check()`, `/proc/narsie_apocalypse()`
- `config/game_options.txt`: `ALERT_GREEN`, `ALERT_BLUE_UPTO`, `ALERT_BLUE_DOWNTO`, `ALERT_RED_UPTO`, `ALERT_RED_DOWNTO`, `ALERT_DELTA`
- `interface/interface.dm`: [`/client`: `verb/wiki()`, `verb/rules()`, `verb/github()`, `verb/reportissue()`]
- `tgui/packages/tgui/interfaces/Interview.tsx`: `Interview`, `RenderedStatus`, `QuestionArea`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/game/objects/structures/bedsheet_bin.dm`
- `modular_psychonaut/master_files/code/modules/holiday/holidays.dm`: `/datum/holiday/greet()`, `/datum/holiday/fleet_day`, `/datum/holiday/fleet_day/greet()`, `/datum/holiday/groundhog`, `/datum/holiday/nz`, `/datum/holiday/nz/greet()`, `/datum/holiday/birthday`, `/datum/holiday/birthday/greet()`, `/datum/holiday/random_kindness`, `/datum/holiday/random_kindness/greet()`, `/datum/holiday/pi`, `/datum/holiday/pi/getStationPrefix()`, `/datum/holiday/no_this_is_patrick`, `/datum/holiday/no_this_is_patrick/getStationPrefix()`, `/datum/holiday/no_this_is_patrick/greet()`, `/datum/holiday/spess`, `/datum/holiday/spess/greet()`, `/datum/holiday/fourtwenty`, `/datum/holiday/tea`, `/datum/holiday/tea/getStationPrefix()`, `/datum/holiday/earth`, `/datum/holiday/cocuk_bayrami`, `/datum/holiday/labor`, `/datum/holiday/draconic_day`, `/datum/holiday/draconic_day/greet()`, `/datum/holiday/spor_bayrami`, `/datum/holiday/firefighter`, `/datum/holiday/firefighter/getStationPrefix()`, `/datum/holiday/bee`, `/datum/holiday/bee/getStationPrefix()`, `/datum/holiday/summersolstice`, `/datum/holiday/doctor`, `/datum/holiday/ufo`, `/datum/holiday/demokrasi_bayrami`, `/datum/holiday/usa`, `/datum/holiday/usa/getStationPrefix()`, `/datum/holiday/writer`, `/datum/holiday/france`, `/datum/holiday/france/getStationPrefix()`, `/datum/holiday/france/greet()`, `/datum/holiday/hotdogday/greet()`, `/datum/holiday/wizards_day`, `/datum/holiday/friendship`, `/datum/holiday/zafer_bayrami`, `/datum/holiday/tiziran_unification`, `/datum/holiday/tiziran_unification/greet()`, `/datum/holiday/tiziran_unification/getStationPrefix()`, `/datum/holiday/ianbirthday/greet()`, `/datum/holiday/pirate`, `/datum/holiday/pirate/greet()`, `/datum/holiday/questions`, `/datum/holiday/questions/greet()`, `/datum/holiday/animal`, `/datum/holiday/smile`, `/datum/holiday/boss`, `/datum/holiday/cumhuriyet_bayrami`, `/datum/holiday/vegan`, `/datum/holiday/october_revolution`, `/datum/holiday/remembrance_day`, `/datum/holiday/remembrance_day/greet()`, `/datum/holiday/remembrance_day/getStationPrefix()`, `/datum/holiday/lifeday`, `/datum/holiday/lifeday/getStationPrefix()`, `/datum/holiday/kindness`, `/datum/holiday/flowers`, `/datum/holiday/hello`, `/datum/holiday/hello/greet()`, `/datum/holiday/holy_lights`, `/datum/holiday/holy_lights/greet()`, `/datum/holiday/festive_season/greet()`, `/datum/holiday/human_rights`, `/datum/holiday/monkey/celebrate()`, `/datum/holiday/xmas/greet()`, `/datum/holiday/boxing`, `/datum/holiday/programmers`, `/datum/holiday/islamic/ramadan`, `/datum/holiday/islamic/ramadan/eve`, `/datum/holiday/hebrew/hanukkah`, `/datum/holiday/hebrew/hanukkah/greet()`, `/datum/holiday/easter/greet()`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/colors.dm`: `COLOR_TURKISH_RED`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot, Seefaaa, Rengan, genkuqq
