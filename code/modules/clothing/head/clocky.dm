#define CLOCKY_INACTIVE_FLAGS SNUG_FIT|STACKABLE_HELMET_EXEMPT|STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
#define CLOCKY_ACTIVE_FLAGS CLOCKY_INACTIVE_FLAGS|CASTING_CLOTHES

/obj/item/clothing/head/helmet/clocky
	name = "clock head"
	desc = "This piece of headgear harnesses the energies of a hallucinatory anomaly to create a safe audiovisual replica of -all- external stimuli directly into the cerebral cortex, \
		granting the user effective immunity to both psychic threats, and anything that would affect their perception - be it ear, eye, or even brain damage. \
		It can also violently discharge said energy, inducing hallucinations in others."
	icon_state = "clocky_head_inactive"
	icon = 'icons/psychonaut/mob/clothing/head/clocky.dmi'
	worn_icon = 'icons/psychonaut/mob/clothing/head/clocky.dmi'
	worn_icon_state = "clocky_head_inactive"
	base_icon_state = "clocky_head"
	force = 10
	dog_fashion = null
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 8 SECONDS
	clothing_flags = CLOCKY_ACTIVE_FLAGS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES
	animal_sounds = list("Tick Tock!","Tick Tick","Tick Tock?")
	flash_protect = FLASH_PROTECTION_WELDER_SENSITIVE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	armor_type = /datum/armor/head_helmet_clocky

	/// If we have a core or not
	var/core_installed = FALSE
	/// Active components to add onto the mob, deleted and created on core installation/removal
	var/list/active_components = list()
	/// List of additonal clothing traits to apply when the core is inserted
	var/list/additional_clothing_traits = list(
		TRAIT_NOFLASH,
		TRAIT_GOOD_HEARING,
	)

// weaker overall but better against energy
/datum/armor/head_helmet_clocky
	melee = 15
	bullet = 15
	laser = 45
	energy = 60
	bomb = 15
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/head/helmet/clocky/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)
	update_anomaly_state()

/obj/item/clothing/head/helmet/clocky/equipped(mob/living/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		user.update_sight()

/obj/item/clothing/head/helmet/clocky/dropped(mob/living/user, silent)
	UnregisterSignal(user, COMSIG_MOB_BEFORE_SPELL_CAST)
	user.update_sight()
	..()

/obj/item/clothing/head/helmet/clocky/proc/update_anomaly_state()

	// If the core isn't installed, or it's temporarily deactivated, disable special functions.
	if(!core_installed)
		clothing_flags = CLOCKY_INACTIVE_FLAGS
		detach_clothing_traits(additional_clothing_traits)
		QDEL_LIST(active_components)
		return

	clothing_flags = CLOCKY_ACTIVE_FLAGS
	attach_clothing_traits(additional_clothing_traits)

/obj/item/clothing/head/helmet/clocky/Destroy(force)
	QDEL_LIST(active_components)
	return ..()

/obj/item/clothing/head/helmet/clocky/examine(mob/user)
	. = ..()
	if (!core_installed)
		. += span_warning("It requires a bioscrambler anomaly core in order to function.")

/obj/item/clothing/head/helmet/clocky/update_icon_state()
	icon_state = base_icon_state + (core_installed ? "" : "_inactive")
	worn_icon_state = base_icon_state + (core_installed ? "" : "_inactive")
	return ..()

/obj/item/clothing/head/helmet/clocky/item_interaction(mob/user, obj/item/weapon, params)
	if (!istype(weapon, /obj/item/assembly/signaler/anomaly/bioscrambler))
		return NONE
	balloon_alert(user, "inserting...")
	if (!do_after(user, delay = 3 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING
	qdel(weapon)
	core_installed = TRUE
	update_anomaly_state()
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/machines/crate/crate_open.ogg', 50, FALSE)
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/helmet/clocky/functioning
	core_installed = TRUE

/obj/item/clothing/head/helmet/clocky/proc/make_cursed() //apply cursed effects.
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	clothing_flags = NONE //force animal sounds to always on.
	if(flags_inv == initial(flags_inv))
		flags_inv = HIDEFACIALHAIR
	var/update_speech_mod = !modifies_speech && LAZYLEN(animal_sounds)
	if(update_speech_mod)
		modifies_speech = TRUE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_HEAD) == src)
			if(update_speech_mod)
				RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
			to_chat(M, span_userdanger("[src] was cursed!"))
			M.update_worn_mask()

/obj/item/clothing/head/helmet/clocky/proc/clear_curse()
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	clothing_flags = initial(clothing_flags)
	flags_inv = initial(flags_inv)
	name = initial(name)
	desc = initial(desc)
	var/update_speech_mod = modifies_speech && !initial(modifies_speech)
	if(update_speech_mod)
		modifies_speech = FALSE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_HEAD) == src)
			to_chat(M, span_notice("[src]'s curse has been lifted!"))
			if(update_speech_mod)
				UnregisterSignal(M, COMSIG_MOB_SAY)
			M.update_worn_mask()

/obj/item/clothing/head/helmet/clocky/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(clothing_flags & VOICEBOX_DISABLED)
		return
	if(!modifies_speech || !LAZYLEN(animal_sounds))
		return
	speech_args[SPEECH_MESSAGE] = pick((prob(animal_sounds_alt_probability) && LAZYLEN(animal_sounds_alt)) ? animal_sounds_alt : animal_sounds)

/obj/item/clothing/head/helmet/clocky/equipped(mob/user, slot)
	if(!iscarbon(user))
		return ..()
	if((slot & ITEM_SLOT_HEAD) && HAS_TRAIT_FROM(src, TRAIT_NODROP, CURSED_MASK_TRAIT))
		to_chat(user, span_userdanger("[src] was cursed!"))
	return ..()

/obj/item/clothing/head/helmet/clocky
	cursed = TRUE


#undef CLOCKY_INACTIVE_FLAGS
#undef CLOCKY_ACTIVE_FLAGS
