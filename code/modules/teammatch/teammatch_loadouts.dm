/datum/outfit/teammatch_loadout //remember that fun > balance
	name = ""
	ears = /obj/item/radio/headset/teammatch
	shoes = /obj/item/clothing/shoes/sneakers/black // im not doing this on all of them
	/// Name shown in the UI
	var/display_name = ""
	/// Description shown in the UI
	var/desc = ":KILL:"
	/// If defined, using this outfits sets the targets mobtype of it
	var/mob/living/mob_override

	var/has_radio = TRUE
	var/team_radio_freq = FREQ_COMMON

	var/minimap_implant_type = /obj/item/implant/tacmap/teammatch

/datum/outfit/teammatch_loadout/post_equip(mob/living/carbon/human/human_to_equip, visuals_only=FALSE)
	if(visuals_only)
		return
	if(has_radio)
		var/obj/item/radio/headset = human_to_equip.ears
		headset.set_frequency(team_radio_freq)
		headset.freqlock = RADIO_FREQENCY_LOCKED
		headset.special_channels |= RADIO_SPECIAL_CENTCOM

/datum/outfit/teammatch_loadout/xenomorph
	name = "Teammatch: Xenomorph"
	display_name = "Xenomorph"
	ears = null
	mob_override = /mob/living/carbon/alien/larva
	has_radio = FALSE

/datum/outfit/teammatch_loadout/marine
	name = "Teammatch: Marine"
	display_name = "Marine"

	uniform = /obj/item/clothing/under/color/black
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/helmet
	id = /obj/item/card/id/away/dogtag
	back = /obj/item/storage/backpack
	backpack_contents = list()
	team_radio_freq = FREQ_XM_MARINE

/datum/outfit/teammatch_loadout/marine/engineer
	name = "Teammatch: Marine Engineer"
	display_name = "Engineer"

	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	gloves = /obj/item/clothing/gloves/color/yellow
	shoes = /obj/item/clothing/shoes/workboots
	id_trim = /datum/id_trim/away/teammatch/marine/engineer

/datum/outfit/teammatch_loadout/marine/medic
	name = "Teammatch: Marine Medic"
	display_name = "Medic"

	uniform = /obj/item/clothing/under/rank/medical/doctor
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	id_trim = /datum/id_trim/away/teammatch/marine/medic

/datum/outfit/teammatch_loadout/marine/fc
	name = "Teammatch: Field Commander"
	display_name = "Field Commander"

	uniform = /obj/item/clothing/under/syndicate
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	id_trim = /datum/id_trim/away/teammatch/marine/fc
	minimap_implant_type = /obj/item/implant/tacmap/teammatch/leader

