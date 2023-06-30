/**
 * ## VIM!!!!!!!
 *
 * It's a teenie minature mecha... for critters!
 * For the critters that cannot be understood, there is a sound creator in the mecha. It also has headlights.
 */
/obj/vehicle/sealed/car/vim
	name = "\improper Vim"
	desc = "An minature exosuit from Nanotrasen, developed to let the irreplacable station pets live a little longer."
	icon_state = "vim"
	max_integrity = 50
	armor_type = /datum/armor/car_vim
	enter_delay = 20
	movedelay = 0.6
	engine_sound_length = 0.3 SECONDS
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 2
	light_on = FALSE
	engine_sound = 'sound/effects/servostep.ogg'
	///Maximum size of a mob trying to enter the mech
	var/maximum_mob_size = MOB_SIZE_SMALL
	COOLDOWN_DECLARE(sound_cooldown)

	var/obj/item/modular_computer/pda/vim/modularInterface
	var/mob/living/driver

/datum/armor/car_vim
	melee = 70
	bullet = 40
	laser = 40
	bomb = 30
	fire = 80
	acid = 80

/obj/vehicle/sealed/car/vim/Initialize(mapload)
	. = ..()
	create_modularInterface()
	AddComponent( \
		/datum/component/shell, \
		unremovable_circuit_components = list(new /obj/item/circuit_component/vim), \
		capacity = SHELL_CAPACITY_SMALL, \
	)

/obj/vehicle/sealed/car/vim/Destroy()
	if(modularInterface)
		QDEL_NULL(modularInterface)
	if(driver)
		driver = null

/obj/vehicle/sealed/car/vim/examine(mob/user)
	. = ..()
	. += span_notice("[src] can be repaired with a welder.")

/obj/vehicle/sealed/car/vim/atom_destruction(damage_flag)
	new /obj/effect/decal/cleanable/oil(get_turf(src))
	do_sparks(5, TRUE, src)
	visible_message(span_boldannounce("[src] blows apart!"))
	return ..()

/obj/vehicle/sealed/car/vim/mob_try_enter(mob/entering)
	if(!isanimal_or_basicmob(entering))
		return FALSE
	var/mob/living/animal_or_basic = entering
	if(animal_or_basic.mob_size > maximum_mob_size)
		entering.balloon_alert(entering, "can't fit inside!")
		return FALSE
	return ..()

/obj/vehicle/sealed/car/vim/welder_act(mob/living/user, obj/item/W)
	if(user.combat_mode)
		return
	. = TRUE
	if(DOING_INTERACTION(user, src))
		balloon_alert(user, "you're already repairing it!")
		return
	if(atom_integrity >= max_integrity)
		balloon_alert(user, "it's not damaged!")
		return
	if(!W.tool_start_check(user, amount=1))
		return
	user.balloon_alert_to_viewers("started welding [src]", "started repairing [src]")
	audible_message(span_hear("You hear welding."))
	var/did_the_thing
	while(atom_integrity < max_integrity)
		if(W.use_tool(src, user, 2.5 SECONDS, volume=50, amount=1))
			did_the_thing = TRUE
			atom_integrity += min(VIM_HEAL_AMOUNT, (max_integrity - atom_integrity))
			audible_message(span_hear("You hear welding."))
		else
			break
	if(did_the_thing)
		user.balloon_alert_to_viewers("[(atom_integrity >= max_integrity) ? "fully" : "partially"] repaired [src]")
	else
		user.balloon_alert_to_viewers("stopped welding [src]", "interrupted the repair!")

/obj/vehicle/sealed/car/vim/mob_enter(mob/newoccupant, silent = FALSE)
	. = ..()
	update_appearance()
	playsound(src, 'sound/machines/windowdoor.ogg', 50, TRUE)
	if(atom_integrity == max_integrity)
		SEND_SOUND(newoccupant, sound('sound/mecha/nominal.ogg',volume=50))
	driver = newoccupant

/obj/vehicle/sealed/car/vim/mob_try_exit(mob/pilot, mob/user, silent = FALSE, randomstep = FALSE)
	. = ..()
	driver = null
	update_appearance()

/obj/vehicle/sealed/car/vim/generate_actions()
	initialize_controller_action_type(/datum/action/vehicle/sealed/climb_out/vim, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/pda/vim, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/noise/chime, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/noise/buzz, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/headlights/vim, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/car/vim/update_overlays()
	. = ..()
	var/static/piloted_overlay
	var/static/headlights_overlay
	if(isnull(piloted_overlay))
		piloted_overlay = iconstate2appearance(icon, "vim_piloted")
		headlights_overlay = iconstate2appearance(icon, "vim_headlights")

	var/list/drivers = return_drivers()
	if(drivers.len)
		. += piloted_overlay
	if(headlights_toggle)
		. += headlights_overlay

/obj/vehicle/sealed/car/vim/proc/create_modularInterface()
	if(!modularInterface)
		modularInterface = new /obj/item/modular_computer/pda/vim(src)
	modularInterface.saved_job = "Vim"
	modularInterface.layer = ABOVE_HUD_PLANE
	SET_PLANE_EXPLICIT(modularInterface, ABOVE_HUD_PLANE, src)
	modularInterface.saved_identification = name

/obj/item/circuit_component/vim
	display_name = "Vim"
	desc = "An minature exosuit from Nanotrasen, developed to let the irreplacable station pets live a little longer."

	/// Sent when the mech chimes.
	var/datum/port/output/chime
	/// Sent when the mech buzzes.
	var/datum/port/output/buzz
	/// Whether the mech headlights are currently on.
	var/datum/port/output/are_headlights_on

/obj/item/circuit_component/vim/populate_ports()
	are_headlights_on = add_output_port("Are Headlights On", PORT_TYPE_NUMBER)
	chime = add_output_port("On Chime Used", PORT_TYPE_SIGNAL)
	buzz = add_output_port("On Buzz Used", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/vim/register_shell(atom/movable/shell)
	. = ..()
	RegisterSignal(shell, COMSIG_VIM_HEADLIGHTS_TOGGLED, PROC_REF(on_headlights_toggle))
	RegisterSignal(shell, COMSIG_VIM_CHIME_USED, PROC_REF(on_chime_used))
	RegisterSignal(shell, COMSIG_VIM_BUZZ_USED, PROC_REF(on_buzz_used))

/obj/item/circuit_component/vim/unregister_shell(atom/movable/shell)
	. = ..()
	UnregisterSignal(shell, COMSIG_VIM_HEADLIGHTS_TOGGLED)
	UnregisterSignal(shell, COMSIG_VIM_CHIME_USED)
	UnregisterSignal(shell, COMSIG_VIM_BUZZ_USED)

/obj/item/circuit_component/vim/proc/on_headlights_toggle(datum/source, headlights_on)
	SIGNAL_HANDLER
	are_headlights_on.set_output(headlights_on)

/obj/item/circuit_component/vim/proc/on_chime_used()
	SIGNAL_HANDLER
	chime.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/vim/proc/on_buzz_used()
	SIGNAL_HANDLER
	buzz.set_output(COMPONENT_SIGNAL)
