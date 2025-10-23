/obj/item/organ/cyberimp/arm/toolkit/janitor
	name = "janitorial toolset implant"
	desc = "A set of janitorial tools hidden behind a concealed panel on the user's arm."
	icon = 'modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_janitor"
	items_to_create = list(
		/obj/item/lightreplacer,
		/obj/item/holosign_creator,
		/obj/item/soap/nanotrasen,
		/obj/item/reagent_containers/spray/cyborg_drying,
		/obj/item/mop/advanced,
		/obj/item/paint/paint_remover,
		/obj/item/reagent_containers/cup/beaker/large,
		/obj/item/reagent_containers/spray/cleaner
	)

/obj/item/organ/cyberimp/arm/toolkit/janitor/emag_act()
	if(obj_flags & EMAGGED)
		return FALSE
	to_chat(usr, span_notice("You unlock [src]'s integrated deluxe cleaning supplies!"))
	items_list += WEAKREF(new /obj/item/soap/syndie(src)) //We add not replace.
	items_list += WEAKREF(new /obj/item/reagent_containers/spray/cyborg_lube(src))
	var/obj/emagged_lightreplacer = new /obj/item/lightreplacer(src)
	emagged_lightreplacer.obj_flags |= EMAGGED
	items_list += WEAKREF(emagged_lightreplacer)
	obj_flags |= EMAGGED
	return TRUE

/obj/item/organ/cyberimp/arm/toolkit/paramedic
	name = "paramedic toolset implant"
	desc = "A set of rescue tools hidden behind a concealed panel on the user's arm."
	icon = 'modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_paramedic"
	items_to_create = list(
		/obj/item/emergency_bed/silicon,
		/obj/item/sensor_device,
		/obj/item/pinpointer/crew,
	)

/obj/item/organ/cyberimp/arm/toolkit/atmospherics
	name = "atmospherics toolset implant"
	desc = "A set of atmospheric tools hidden behind a concealed panel on the user's arm."
	icon = 'modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_atmosph"
	items_to_create = list(
		/obj/item/extinguisher,
		/obj/item/analyzer,
		/obj/item/crowbar/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/holosign_creator/atmos,
		/obj/item/pipe_dispenser,
	)

/obj/item/organ/cyberimp/arm/toolkit/botany
	name = "botany arm implant"
	desc = "A rather simple arm implant containing tools used in gardening and botanical research."
	icon = 'modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_hydro"
	items_to_create = list(
		/obj/item/cultivator,
		/obj/item/shovel/spade,
		/obj/item/hatchet,
		/obj/item/plant_analyzer,
		/obj/item/geneshears,
		/obj/item/secateurs,
		/obj/item/storage/bag/plants,
		/obj/item/storage/bag/plants/portaseeder
	)

/obj/item/organ/cyberimp/arm/toolkit/mantis
	name = "C.H.R.O.M.A.T.A. mantis blade implants"
	desc = "High tech mantis blade implants, easily portable weapon, that has a high wound potential."
	icon = 'modular_psychonaut/master_files/icons/obj/weapons/sword.dmi'
	icon_state = "mantis"
	items_to_create = list(/obj/item/mantis_blade)

/obj/item/organ/cyberimp/arm/toolkit/mantis/syndicate
	name = "A.R.A.S.A.K.A. mantis blade implants"
	desc = "Modernized mantis blade designed coined by Tiger operatives, much sharper blade with energy actuators makes it a much deadlier weapon."
	icon_state = "syndie_mantis"
	organ_flags = parent_type::organ_flags | ORGAN_HIDDEN
	items_to_create = list(/obj/item/mantis_blade/syndicate)

/obj/item/organ/cyberimp/arm/toolkit/mantis/shield
	name = "S.A.Y.A. arm defense system implants"
	desc = "Shield blade implants that allow user to block upcoming attacks at the cost of mobility and offense."
	icon_state = "shield_mantis"
	items_to_create = list(/obj/item/mantis_blade/shield)

/obj/item/organ/cyberimp/arm/ammo_counter
	name = "S.M.A.R.T. ammo logistics system"
	desc = "Special inhand implant that transmits the current ammo and energy data straight to the user's arm screen."
	icon = 'modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi'
	icon_state = "hand_implant"

	var/atom/movable/screen/cybernetics/ammo_counter/counter_ref
	var/obj/item/gun/our_gun

/obj/item/organ/cyberimp/arm/ammo_counter/Insert(mob/living/carbon/M, special = FALSE, movement_flags)
	. = ..()
	RegisterSignal(M, COMSIG_LIVING_PICKED_UP_ITEM, PROC_REF(add_to_hand))

/obj/item/organ/cyberimp/arm/ammo_counter/Remove(mob/living/carbon/M, special = FALSE, movement_flags)
	. = ..()
	UnregisterSignal(M, COMSIG_LIVING_PICKED_UP_ITEM)
	our_gun = null
	update_hud_elements()

/obj/item/organ/cyberimp/arm/ammo_counter/proc/update_hud_elements()
	SIGNAL_HANDLER
	if(!owner || !owner?.hud_used)
		return


	var/datum/hud/H = owner.hud_used

	if(!our_gun)
		if(!H.cybernetics_ammo[zone])
			return
		H.cybernetics_ammo[zone] = null

		H.infodisplay -= counter_ref
		H.mymob.client.screen -= counter_ref
		QDEL_NULL(counter_ref)
		return

	if(!H.cybernetics_ammo[zone])
		counter_ref = new(null, H)
		counter_ref.screen_loc =  zone == BODY_ZONE_L_ARM ? ui_hand_position_y(1,1,9) : ui_hand_position_y(2,1,9)
		H.cybernetics_ammo[zone] = counter_ref
		H.infodisplay += counter_ref
		H.mymob.client.screen += counter_ref

	var/display
	if(istype(our_gun,/obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/balgun = our_gun
		display = balgun.magazine ? balgun.magazine.ammo_count(FALSE) : 0
	else
		var/obj/item/gun/energy/egun = our_gun
		var/obj/item/ammo_casing/energy/shot = egun.ammo_type[egun.select]
		display = FLOOR(egun.cell.charge / shot.e_cost,1)
	counter_ref.maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='white'>[display]</font></div>")

/obj/item/organ/cyberimp/arm/ammo_counter/proc/add_to_hand(datum/source, obj/item/maybegun)
	SIGNAL_HANDLER

	var/obj/item/bodypart/bp = owner.get_active_hand()

	if(bp.body_zone != zone)
		return

	if(istype(maybegun,/obj/item/gun/ballistic) || istype(maybegun,/obj/item/gun/energy))
		our_gun = maybegun
		RegisterSignal(owner, COMSIG_MOB_FIRED_GUN, PROC_REF(update_hud_elements))
		RegisterSignal(our_gun, COMSIG_ATOM_UPDATE_APPEARANCE, PROC_REF(update_hud_elements))
		RegisterSignal(our_gun, COMSIG_ITEM_DROPPED, PROC_REF(remove_from_hand))

	update_hud_elements()

/obj/item/organ/cyberimp/arm/ammo_counter/proc/remove_from_hand(datum/source, mob/user)
	SIGNAL_HANDLER

	if(our_gun != source)
		return

	UnregisterSignal(owner, COMSIG_MOB_FIRED_GUN)
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_APPEARANCE)
	UnregisterSignal(source, COMSIG_ITEM_DROPPED)

	our_gun = null
	update_hud_elements()

/obj/item/organ/cyberimp/arm/ammo_counter/syndicate
	organ_flags = parent_type::organ_flags | ORGAN_HIDDEN
