/mob/living/silicon/robot/Initialize(mapload)
	RegisterSignal(src, COMSIG_COMBAT_MODE_TOGGLED, PROC_REF(toggle_combat_mode))
	return ..()

/mob/living/silicon/robot/proc/toggle_combat_mode()
	SIGNAL_HANDLER
	var/obj/item/robot_model/model = src.model
	if(model.cyborg_base_icon == "uWu_borg")
		icon_state = combat_mode ? "uWu_borg_rage" : "uWu_borg"
