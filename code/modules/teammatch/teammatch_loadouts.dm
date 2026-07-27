/datum/outfit/teammatch_loadout //remember that fun > balance
	name = ""
	ears = /obj/item/radio/headset
	shoes = /obj/item/clothing/shoes/combat // im not doing this on all of them
	implants = list(/obj/item/implant/tacmap/teammatch)
	/// Name shown in the UI
	var/display_name = ""
	/// Description shown in the UI
	var/desc = ":KILL:"
	/// If defined, using this outfits sets the targets mobtype of it
	var/mob/living/mob_override

	var/has_radio = TRUE
	var/team_radio_freq = FREQ_COMMON

	/// Organs to insert
	var/list/organs = list()

/datum/outfit/teammatch_loadout/post_equip(mob/living/carbon/user, visuals_only=FALSE)
	if(visuals_only)
		return
	if(has_radio)
		var/obj/item/radio/headset = user.ears
		headset.set_frequency(team_radio_freq)
		headset.freqlock = RADIO_FREQENCY_LOCKED
		headset.special_channels |= RADIO_SPECIAL_CENTCOM

	if(organs)
		for(var/organ_type in organs)
			var/obj/item/organ/organ = SSwardrobe.provide_type(organ_type, user)
			organ.Insert(user)

/datum/outfit/teammatch_loadout/xenomorph
	name = "Teammatch: Xenomorph"
	display_name = "Xenomorph"
	ears = null
	mob_override = /mob/living/carbon/alien/larva
	has_radio = FALSE
	implants = list(/obj/item/implant/tacmap/teammatch/xenomorph)

/datum/outfit/teammatch_loadout/marine
	name = "Teammatch: Squad Marine"
	display_name = "Squad Marine"

	uniform = /obj/item/clothing/under/color/black
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/helmet
	id = /obj/item/card/id/away/dogtag
	back = /obj/item/storage/backpack
	box = /obj/item/storage/box/survival
	glasses = /obj/item/clothing/glasses/hud/security
	backpack_contents = list()
	team_radio_freq = FREQ_XM_MARINE
	implants = list(/obj/item/implant/tacmap/teammatch/marine)
	organs = list(/obj/item/organ/cyberimp/arm/ammo_counter, /obj/item/organ/cyberimp/arm/ammo_counter/left_handed)

/datum/outfit/teammatch_loadout/marine/engineer
	name = "Teammatch: Squad Engineer"
	display_name = "Squad Engineer"

	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	gloves = /obj/item/clothing/gloves/color/yellow
	shoes = /obj/item/clothing/shoes/workboots
	id_trim = /datum/id_trim/away/teammatch/marine/engineer

/datum/outfit/teammatch_loadout/marine/medic
	name = "Teammatch: Squad Corpsman"
	display_name = "Squad Corpsman"

	uniform = /obj/item/clothing/under/rank/medical/doctor
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	id_trim = /datum/id_trim/away/teammatch/marine/medic

/datum/outfit/teammatch_loadout/marine/fc
	name = "Teammatch: Field Commander"
	display_name = "Field Commander"

	uniform = /obj/item/clothing/under/syndicate
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	id_trim = /datum/id_trim/away/teammatch/marine/fc
	implants = list(/obj/item/implant/tacmap/teammatch/marine/leader)

