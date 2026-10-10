/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//			TG OVERWRITES

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/blood/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(exposed_mob)
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_blood_volume = min(bloodsuckerdatum.bloodsucker_blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)

/mob/living/transfer_blood_to(atom/movable/receiver, amount, ignore_low_blood = FALSE, ignore_incompatibility = FALSE, transfer_viruses = TRUE)
	. = ..()
	if(. > 0 && mind)
		var/datum/antagonist/bloodsucker/bloodsuckerdatum = mind.has_antag_datum(/datum/antagonist/bloodsucker)
		bloodsuckerdatum?.bloodsucker_blood_volume -= .


// Used when analyzing a Bloodsucker, Masquerade will hide brain traumas (Unless you're a Beefman)
/mob/living/carbon/get_traumas()
	if(QDELETED(mind))
		return ..()
	if(IS_BLOODSUCKER(src) && HAS_TRAIT(src, TRAIT_MASQUERADE))
		return
	return ..()

/datum/outfit/bloodsucker_outfit
	name = "Bloodsucker outfit (Preview only)"
	uniform = /obj/item/clothing/under/suit/black
	suit = /obj/item/clothing/suit/costume/dracula
	shoes = /obj/item/clothing/shoes/laceup

/datum/outfit/bloodsucker_outfit/post_equip(mob/living/carbon/human/enrico, visuals_only = FALSE)
	enrico.set_hairstyle("Undercut", update = FALSE)
	enrico.set_haircolor("#FFFFFF", override = FALSE, update = FALSE)
	enrico.skin_tone = "albino"
	enrico.set_eye_color("#AA1010")
	enrico.update_body()
