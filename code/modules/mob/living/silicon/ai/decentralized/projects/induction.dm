/datum/ai_project/induction_basic
	name = "Bluespace Induction Basics"
	description = "Prerequisite theory for remote charging of connected hardware."
	research_cost = 1500
	ram_required = 0
	research_requirements_text = "None"
	can_be_run = FALSE
	category = AI_PROJECT_INDUCTION

/datum/ai_project/induction_cyborg
	name = "Bluespace Induction - Cyborgs"
	description = "Adds a rechargeable ability that restores roughly 33% charge to a visible cyborg."
	research_cost = 2500
	ram_required = 0
	research_requirements_text = "Bluespace Induction Basics"
	research_requirements = list(/datum/ai_project/induction_basic)
	category = AI_PROJECT_INDUCTION
	can_be_run = FALSE
	ability_path = /datum/action/innate/ai/ranged/charge_borg_or_apc
	ability_recharge_cost = 1500

/datum/ai_project/induction_cyborg/finish()
	var/datum/action/innate/ai/ranged/charge_borg_or_apc/ability = add_ability(ability_path)
	if(!ability)
		return
	ability.works_on_borgs = TRUE
	ability.name = ability.works_on_apcs ? "Charge Cyborg/APC" : "Charge Cyborg"
	ability.desc = ability.works_on_apcs ? "Click a cyborg or APC to charge it by roughly 33%." : "Click a cyborg to charge it by roughly 33%."

/datum/ai_project/induction_apc
	name = "Bluespace Induction - APCs"
	description = "Adds a rechargeable ability that restores roughly 33% charge to a visible APC."
	research_cost = 2500
	ram_required = 0
	research_requirements_text = "Bluespace Induction Basics"
	research_requirements = list(/datum/ai_project/induction_basic)
	category = AI_PROJECT_INDUCTION
	can_be_run = FALSE
	ability_path = /datum/action/innate/ai/ranged/charge_borg_or_apc
	ability_recharge_cost = 1500

/datum/ai_project/induction_apc/finish()
	var/datum/action/innate/ai/ranged/charge_borg_or_apc/ability = add_ability(ability_path)
	if(!ability)
		return
	ability.works_on_apcs = TRUE
	ability.name = ability.works_on_borgs ? "Charge Cyborg/APC" : "Charge APC"
	ability.desc = ability.works_on_borgs ? "Click a cyborg or APC to charge it by roughly 33%." : "Click an APC to charge it by roughly 33%."

/datum/action/innate/ai/ranged/charge_borg_or_apc
	name = "Charge Cyborg/APC"
	desc = "Depending on your upgrades, charges a visible cyborg or APC by roughly 33%."
	button_icon_state = "electrified"
	uses = 1
	delete_on_empty = FALSE
	var/works_on_borgs = FALSE
	var/works_on_apcs = FALSE
	enable_text = span_notice("You prime bluespace induction coils. Click a cyborg or APC to charge it.")
	disable_text = span_notice("You power down your induction coils.")

/datum/action/innate/ai/ranged/charge_borg_or_apc/do_ability(mob/living/clicker, atom/clicked_on)
	if(!isAI(clicker))
		return FALSE
	if(!iscyborg(clicked_on) && !istype(clicked_on, /obj/machinery/power/apc))
		to_chat(owner, span_warning("You can only charge cyborgs or APCs."))
		return FALSE
	if(iscyborg(clicked_on) && !works_on_borgs)
		to_chat(owner, span_warning("Your current induction package only supports APCs."))
		return FALSE
	if(istype(clicked_on, /obj/machinery/power/apc) && !works_on_apcs)
		to_chat(owner, span_warning("Your current induction package only supports cyborgs."))
		return FALSE

	if(!charge_target(clicked_on))
		return FALSE

	unset_ranged_ability(clicker)
	adjust_uses(-1)
	do_sparks(3, FALSE, clicked_on)
	to_chat(owner, span_notice("You charge [clicked_on]."))
	clicked_on.audible_message(span_notice("A gentle electrical hum emanates from [clicked_on]."))
	return TRUE

/datum/action/innate/ai/ranged/charge_borg_or_apc/proc/charge_target(atom/target)
	if(iscyborg(target))
		var/mob/living/silicon/robot/cyborg = target
		if(!cyborg.cell)
			to_chat(owner, span_warning("[cyborg] has no cell to charge."))
			return FALSE
		if(cyborg.cell.charge >= cyborg.cell.maxcharge)
			to_chat(owner, span_warning("[cyborg]'s cell is already full."))
			return FALSE
		cyborg.charge(null, cyborg.cell.maxcharge * 0.33)
		log_game("[key_name(owner)] charged cyborg [key_name(cyborg)] through Yog AI induction.")
		return TRUE

	var/obj/machinery/power/apc/apc = target
	if(!apc.cell)
		to_chat(owner, span_warning("[apc] has no installed power cell."))
		return FALSE
	if(apc.cell.charge >= apc.cell.maxcharge)
		to_chat(owner, span_warning("[apc] is already fully charged."))
		return FALSE
	apc.cell.give(apc.cell.maxcharge * 0.33)
	log_game("[key_name(owner)] charged APC [apc] through Yog AI induction.")
	return TRUE
