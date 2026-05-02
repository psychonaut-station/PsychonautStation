/datum/ai_project/shock_defense
	name = "Shock Defense"
	description = "Adds a rechargeable discharge that shocks anyone standing near your data cores."
	research_cost = 3000
	ram_required = 0
	research_requirements_text = "Bluespace Induction Basics"
	research_requirements = list(/datum/ai_project/induction_basic)
	can_be_run = FALSE
	category = AI_PROJECT_INDUCTION
	ability_path = /datum/action/innate/ai/shock_defense
	ability_recharge_cost = 2000

/datum/ai_project/shock_defense/finish()
	add_ability(ability_path)

/datum/action/innate/ai/shock_defense
	name = "Shock Defense"
	desc = "Discharges nearby data cores, shocking anyone within two tiles."
	button_icon_state = "emergency_lights"
	uses = 2
	delete_on_empty = FALSE

/datum/action/innate/ai/shock_defense/Activate()
	if(!istype(owner.loc, /obj/machinery/ai/data_core))
		to_chat(owner, span_warning("You must be routed through an active data core to do this."))
		return

	var/mob/living/silicon/ai/ai_owner = owner
	var/list/network_nodes = ai_owner.ai_network?.get_all_nodes()
	for(var/obj/machinery/ai/data_core/core in network_nodes)
		tesla_zap(core, 2, 15000, ZAP_MOB_DAMAGE | ZAP_MOB_STUN)
		core.use_energy(5000)

	adjust_uses(-1)
