/datum/ai_project/coolant_manager
	name = "Enhanced Coolant Management"
	description = "Improves thermal routing to raise the safe operating temperature of connected AI hardware by 10 kelvin."
	category = AI_PROJECT_EFFICIENCY
	research_cost = 2250
	can_be_run = FALSE

/datum/ai_project/coolant_manager/finish()
	if(ai.ai_network)
		ai.ai_network.temp_limit += 10

/datum/ai_project/coolant_manager/switch_network(datum/ai_network/old_net, datum/ai_network/new_net)
	if(old_net)
		old_net.temp_limit -= 10
	if(new_net)
		new_net.temp_limit += 10
	return ..()
