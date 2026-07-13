#define INTERNAL_VOLUME 50
#define MAX_FUEL 30
#define FUEL_PER_COAL 30
#define FUEL_CONSUME_INTERVAL 30 SECONDS

#define SMOKE_CONSUME_INTERVAL 1 SECONDS
#define SMOKE_CONSUME_AMOUNT 0.1

#define INHALE_COOLDOWN 5 SECONDS
#define BASE_COUGH_STAMINA_LOSS 5

#define BASE_INHALE_VOLUME 3
#define BASE_INHALE_LIMIT 3

#define MAX_FOOD_ITEMS 5

#define OPTION_CLEAR "Clear the bowl"
#define OPTION_EXTINGUISH "Extinguish coals"
#define OPTION_BLOW "Light up"

/obj/item/hookah
	name = "hookah"
	desc = "A simple glass water hookah. Perfect for a relaxing break in the dorms."
	icon = 'icons/psychonaut/obj/hookah.dmi'
	icon_state = "hookah"
	max_integrity = 50
	inhand_icon_state = "beaker"
	w_class = WEIGHT_CLASS_HUGE

	/// Mouthpiece that belongs to this hookah
	var/obj/item/hookah_mouthpiece/mouthpiece
	var/fuel = 0
	var/lit = FALSE
	COOLDOWN_DECLARE(fuel_consume_cooldown)
	COOLDOWN_DECLARE(smoke_decrease_cooldown)
	/// Food ingredients inside the bowl
	var/list/food_items = list()
	/// How well smoked is this hookah?
	var/smoke_amount = 0
	var/particle_type

/obj/item/hookah/add_context(atom/source, list/context, atom/target, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_RMB] = "Take mouthpiece"
	context[SCREENTIP_CONTEXT_ALT_RMB] = "More actions"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/hookah/examine()
	. = ..()
	. += span_notice("Bowl's contents: [english_list(food_items, nothing_text = "empty")].")
	if(lit)
		. += span_notice("[src] is lit.")

/obj/item/hookah/Initialize(mapload)
	. = ..()
	mouthpiece = new(src)
	update_appearance(UPDATE_OVERLAYS)
	create_reagents(INTERNAL_VOLUME, TRANSPARENT)
	register_context()

/obj/item/hookah/update_overlays()
	. = ..()
	if(mouthpiece in contents)
		. += "pipe"
	if(fuel > 0)
		. += "coal"
	if(lit)
		. += "coal_lit"
		. += emissive_appearance(icon, "lit_overlay", src, alpha = src.alpha)

/obj/item/hookah/proc/return_mouthpiece()
	if(isnull(mouthpiece) || (mouthpiece in contents))
		return
	mouthpiece.disconnect()
	mouthpiece.forceMove(src)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/hookah/attack_hand_secondary(mob/user, list/modifiers)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(ismob(loc))
		return
	if(isnull(mouthpiece))
		balloon_alert(user, "mouthpiece gone!")
		return
	if(!(mouthpiece in contents))
		balloon_alert(user, "already taken!")
		return
	if(!user.put_in_hands(mouthpiece))
		balloon_alert(user, "hands full!")
		return
	mouthpiece.connect_to(user)
	to_chat(user, span_notice("You take the mouthpiece in hand."))
	update_appearance(UPDATE_OVERLAYS)

/obj/item/hookah/proc/try_light(obj/item/lighter_object, mob/user)
	var/msg = lighter_object.ignition_effect(src, user)
	if(!msg)
		return FALSE
	if(lit)
		to_chat(user, span_warning("[src] is already lit!"))
		return FALSE
	if(!fuel)
		to_chat(user, span_warning("There are no coals in [src]!"))
		return FALSE
	visible_message(msg)
	ignite()
	return TRUE

/obj/item/hookah/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!isnull(mouthpiece) && tool == mouthpiece)
		return_mouthpiece()
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/hookah_coals))
		add_coals(user, tool)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/food))
		add_food(user, tool)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/reagent_containers))
		add_reagents(user, tool)
		return ITEM_INTERACT_SUCCESS
	if(try_light(tool, user))
		return
	return NONE

/obj/item/hookah/proc/add_coals(mob/user, obj/item/hookah_coals/coal)
	if(fuel + FUEL_PER_COAL > MAX_FUEL)
		to_chat(user, span_warning("There are already enough coals in [src]!"))
		return
	fuel += FUEL_PER_COAL
	qdel(coal)
	to_chat(user, span_notice("You add coals to [src]."))

/obj/item/hookah/proc/add_food(mob/user, obj/item/food/food)
	if(length(food_items) >= MAX_FOOD_ITEMS)
		to_chat(user, span_warning("There are already enough ingredients in [src]!"))
		return
	food_items += food
	food.forceMove(src)
	to_chat(user, span_notice("You add [food] to [src]."))

/obj/item/hookah/proc/add_reagents(mob/user, obj/item/reagent_containers/container)
	if(istype(container, /obj/item/reagent_containers/applicator/pill))
		return
	if(!container.reagents.total_volume)
		to_chat(user, span_warning("There is nothing inside [container]!"))
		return
	var/transferred = container.reagents.trans_to(src, container.amount_per_transfer_from_this)
	if(!transferred)
		to_chat(user, span_warning("There is no space in [src]!"))
		return
	user.visible_message(span_notice("[user] pours something into [src]."), span_notice("You pour [transferred] units of liquid into [src]."))

/obj/item/hookah/process()
	if(!lit || !fuel)
		return PROCESS_KILL
	if(COOLDOWN_FINISHED(src, fuel_consume_cooldown))
		fuel = max(fuel - 1, 0)
		if(fuel > 0)
			COOLDOWN_START(src, fuel_consume_cooldown, FUEL_CONSUME_INTERVAL)
		else
			put_out()
			return PROCESS_KILL
	if(COOLDOWN_FINISHED(src, smoke_decrease_cooldown))
		smoke_amount = max(smoke_amount - SMOKE_CONSUME_AMOUNT, 0)
		if(smoke_amount > 0)
			COOLDOWN_START(src, smoke_decrease_cooldown, SMOKE_CONSUME_INTERVAL)

/obj/item/hookah/click_alt_secondary(mob/user)
	if(!ishuman(user))
		return CLICK_ACTION_BLOCKING
	var/list/choices = list()

	if(lit)
		choices[OPTION_EXTINGUISH] = image(icon = 'icons/psychonaut/obj/radial.dmi', icon_state = "extinguish")
	if(length(food_items) || reagents.total_volume)
		if(lit)
			choices[OPTION_BLOW] = image(icon = 'icons/psychonaut/obj/radial.dmi', icon_state = "blow")
		choices[OPTION_CLEAR] = image(icon = 'icons/psychonaut/obj/radial.dmi', icon_state = "eject")

	var/choice = show_radial_menu(user, src, choices, require_near = TRUE)

	if(!choice)
		return CLICK_ACTION_BLOCKING

	switch(choice)
		if(OPTION_EXTINGUISH)
			if(!lit)
				balloon_alert(user, "not lit!")
				return CLICK_ACTION_BLOCKING
			to_chat(user, span_notice("You start extinguishing [src]..."))
			if(!do_after(user, 2 SECONDS, src))
				return CLICK_ACTION_BLOCKING
			put_out()
			return CLICK_ACTION_SUCCESS
		if(OPTION_BLOW)
			if(!lit)
				balloon_alert(user, "not lit!")
				return CLICK_ACTION_BLOCKING
			if(!length(food_items) && !reagents.total_volume)
				to_chat(user, span_warning("There are no ingredients in [src]!"))
				return CLICK_ACTION_BLOCKING
			if(!(mouthpiece in user.held_items))
				to_chat(user, span_warning("You need to hold the mouthpiece to inhale from [src]!"))
				return CLICK_ACTION_BLOCKING
			user.visible_message(span_notice("[user] takes a deep drag..."), span_notice("You take a deep drag..."))
			playsound(src, 'sound/_psychonaut/hookah_bubble.ogg', 40)
			if(!do_after(user, 5 SECONDS, src))
				return CLICK_ACTION_BLOCKING
			mouthpiece?.inhale_smoke(user, BASE_INHALE_VOLUME * 2, TRUE)
			return CLICK_ACTION_SUCCESS
		if(OPTION_CLEAR)
			if(!length(food_items) && !reagents.total_volume)
				to_chat(user, span_warning("There is nothing to clear in [src]!"))
				return CLICK_ACTION_BLOCKING
			if(!do_after(user, 2 SECONDS, src))
				return CLICK_ACTION_BLOCKING
			reagents.clear_reagents()
			QDEL_LIST(food_items)
			to_chat(user, span_notice("You clear the bowl of [src]."))
			return CLICK_ACTION_SUCCESS

/obj/item/hookah/proc/ignite()
	if(lit)
		return
	lit = TRUE
	particle_type = /particles/smoke/cig/big
	add_shared_particles(particle_type)
	START_PROCESSING(SSmachines, src)
	visible_message(span_notice("The coals inside [src] slowly begin to glow red."))
	update_appearance()
	set_light(2, 1, LIGHT_COLOR_ORANGE)
	smoke_amount = 30
	COOLDOWN_START(src, fuel_consume_cooldown, FUEL_CONSUME_INTERVAL)
	COOLDOWN_START(src, smoke_decrease_cooldown, SMOKE_CONSUME_INTERVAL)

/obj/item/hookah/proc/put_out()
	if(!lit)
		return
	lit = FALSE
	visible_message(span_notice("The coals inside [src] return to their usual color."))
	update_appearance()
	STOP_PROCESSING(SSmachines, src)
	stop_smoke()
	set_light(0)
	smoke_amount = 0

/obj/item/hookah/proc/stop_smoke()
	if(particle_type)
		remove_shared_particles(particle_type)
		particle_type = null

/obj/item/hookah/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.)
		atom_destruction()

/obj/item/hookah/atom_destruction(damage_flag)
	new /obj/item/shard(get_turf(src))

	if(reagents.total_volume)
		reagents.expose(get_turf(src), TOUCH)

	for(var/obj/item/food/food as anything in food_items)
		if(food.reagents.total_volume)
			food.reagents.expose(get_turf(src), TOUCH)
		qdel(food)

	visible_message(span_warning("[src] shatters into pieces with a crack!"))
	playsound(src, SFX_SHATTER, 50)
	return ..()

/obj/item/hookah/pickup(mob/user)
	. = ..()
	if(!isnull(mouthpiece) && !(mouthpiece in contents))
		return_mouthpiece()
		to_chat(user, span_notice("The mouthpiece returns to [src]."))

/obj/item/hookah/Destroy()
	STOP_PROCESSING(SSmachines, src)
	stop_smoke()
	QDEL_LIST(food_items)
	if(!isnull(mouthpiece))
		mouthpiece.hookah = null
		mouthpiece.disconnect()
		QDEL_NULL(mouthpiece)
	set_light(0)
	return ..()

/obj/item/hookah_mouthpiece
	name = "mouthpiece"
	desc = "A mouthpiece made of some light metal. Something is engraved on its handle."
	icon = 'icons/psychonaut/obj/hookah.dmi'
	icon_state = "mouthpiece"
	w_class = WEIGHT_CLASS_BULKY
	var/obj/item/hookah/hookah
	var/datum/beam/beam
	var/atom/attached_to
	COOLDOWN_DECLARE(inhale_cooldown)
	var/currently_inhaling = FALSE

/obj/item/hookah_mouthpiece/Initialize(mapload)
	. = ..()
	if(!istype(loc, /obj/item/hookah))
		return INITIALIZE_HINT_QDEL
	hookah = loc

/obj/item/hookah_mouthpiece/proc/connect_to(mob/user)
	if(!hookah || !user)
		return

	attached_to = user
	beam = hookah.Beam(
		user,
		icon = 'icons/effects/beam.dmi',
		icon_state = "1-full",
		beam_color = COLOR_BLACK,
		layer = BELOW_MOB_LAYER,
		override_origin_pixel_y = 0,
	)

	RegisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED), PROC_REF(check_distance))
	RegisterSignal(hookah, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED), PROC_REF(check_distance))
	return TRUE

/obj/item/hookah_mouthpiece/proc/disconnect()
	if(attached_to)
		UnregisterSignal(attached_to, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED))
		attached_to = null
	if(hookah)
		UnregisterSignal(hookah, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED))
	QDEL_NULL(beam)

/obj/item/hookah_mouthpiece/proc/check_distance()
	SIGNAL_HANDLER
	if(!hookah || !attached_to)
		return

	if((get_dist(hookah, attached_to) <= 1))
		return

	if(ismob(attached_to))
		var/mob/user = attached_to
		user.dropItemToGround(src)
		to_chat(user, span_warning("You let go of [hookah]."))
	disconnect()

/obj/item/hookah_mouthpiece/Destroy()
	if(hookah)
		hookah.stop_smoke()
		hookah.mouthpiece = null
	disconnect()
	return ..()

/obj/item/hookah_mouthpiece/dropped(mob/user)
	. = ..()
	currently_inhaling = FALSE
	if(hookah)
		hookah.return_mouthpiece()

/obj/item/hookah_mouthpiece/attack_self(mob/user)
	if(!hookah?.lit || !ishuman(user))
		return ..()
	start_inhale(user)

/obj/item/hookah_mouthpiece/attack(mob/living/target_mob, mob/living/user)
	if(target_mob == user && hookah.lit)
		start_inhale(target_mob)
		return
	return ..()

/obj/item/hookah_mouthpiece/proc/start_inhale(mob/living/carbon/human/user)
	if(currently_inhaling)
		return

	if(!hookah || !hookah.reagents.total_volume)
		to_chat(user, span_warning("There is no liquid inside [hookah]!"))
		return

	currently_inhaling = TRUE
	user.visible_message(span_notice("[user] inhales from [src]."), span_notice("You inhale..."))
	playsound(src, 'sound/_psychonaut/hookah_bubble.ogg', 40)
	if(!do_after(user, 2 SECONDS, src))
		currently_inhaling = FALSE
		return
	inhale_smoke(user, BASE_INHALE_VOLUME)
	currently_inhaling = FALSE

/obj/item/hookah_mouthpiece/proc/inhale_smoke(mob/living/user, amount, skip_calculations = FALSE)
	if(HAS_TRAIT(user, TRAIT_NOBREATH))
		to_chat(user, span_warning("You cannot take a breath!"))
		return

	if(!hookah || !length(hookah.food_items) && !hookah.reagents.total_volume)
		return
	if(!(src in user.held_items))
		return

	for(var/obj/item/food/food as anything in hookah.food_items)
		food.reagents?.trans_to(hookah.reagents, amount / length(hookah.food_items))
		if(!food.reagents?.total_volume)
			hookah.food_items -= food
			qdel(food)

	var/smoke_efficiency = min(hookah.smoke_amount, 100)
	var/amount_to_transfer = skip_calculations ? amount : (amount * smoke_efficiency / 100)
	var/amount_to_waste = amount - amount_to_transfer
	var/transferred = hookah.reagents.trans_to(user, amount_to_transfer, methods = INHALE)

	if(transferred)
		to_chat(user, span_notice("You inhale smoke from [src]."))
		user.add_mood_event("smoked", /datum/mood_event/smoked)

		if(!COOLDOWN_FINISHED(src, inhale_cooldown) || transferred > BASE_INHALE_LIMIT)
			user.visible_message(span_warning(pick("[user] starts coughing!", "[user] winces while coughing.", "[user] chokes!")), span_warning(pick("Your head is spinning...", "You cough, wincing from a sharp tingling in your throat.", "You choke!")))
			user.emote("cough")
			user.adjust_stamina_loss(BASE_COUGH_STAMINA_LOSS * (transferred / BASE_INHALE_LIMIT))

		switch(smoke_efficiency)
			if(0 to 20)
				to_chat(user, span_warning("Your throat feels like it's burning..."))
				user.emote("cough")
			if(20 to 40)
				to_chat(user, span_notice("Slightly bitter."))
			if(40 to 80)
				to_chat(user, span_notice("Quite a pleasant taste..."))
			else
				to_chat(user, span_notice("Not bad smoke."))

		COOLDOWN_START(src, inhale_cooldown, INHALE_COOLDOWN)
		hookah.smoke_amount = min(hookah.smoke_amount + rand(amount * 2, amount), 100)
		addtimer(CALLBACK(src, PROC_REF(delayed_puff), user, amount_to_waste), 1 SECONDS)

/obj/item/hookah_mouthpiece/proc/delayed_puff(mob/user, amount)
	if(QDELETED(hookah))
		return
	do_chem_smoke(amount / 5, null, user.loc, carry = hookah.reagents, amount = amount * 0.2, smoke_type = /obj/effect/particle_effect/fluid/smoke/chem/quick)

/obj/item/hookah_coals
	name = "hookah coals"
	desc = "Dense coals, finely shaped into cubes."
	icon = 'icons/psychonaut/obj/hookah.dmi'
	icon_state = "coals"
	custom_premium_price = PAYCHECK_CREW * 1.5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/hookah_coals/examine()
	. = ..()
	. += span_info("There are three cubes in the pile.")

#undef INTERNAL_VOLUME
#undef MAX_FUEL
#undef FUEL_PER_COAL
#undef FUEL_CONSUME_INTERVAL
#undef SMOKE_CONSUME_INTERVAL
#undef SMOKE_CONSUME_AMOUNT
#undef INHALE_COOLDOWN
#undef BASE_COUGH_STAMINA_LOSS
#undef BASE_INHALE_VOLUME
#undef BASE_INHALE_LIMIT
#undef MAX_FOOD_ITEMS
#undef OPTION_CLEAR
#undef OPTION_EXTINGUISH
#undef OPTION_BLOW
