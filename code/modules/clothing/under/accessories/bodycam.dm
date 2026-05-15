/datum/action/item_action/bodycam_toggle
	name = "Toggle Bodycam"
	button_icon = 'icons/psychonaut/obj/clothing/bodycam_accessories.dmi'
	button_icon_state = "bodycamera"
	desc = "Turn your bodycam on or off."

/// Wearable accessory that broadcasts the wearer's perspective when viewed remotely.
/obj/item/clothing/accessory/bodycam
	name = "bodycam"
	desc = "A compact body camera linked to the station security network. It only transmits while someone is actively viewing it."
	icon = 'icons/psychonaut/obj/clothing/bodycam_accessories.dmi'
	worn_icon = 'icons/psychonaut/mob/clothing/bodycam_accessories.dmi'
	icon_state = "bodycamera"
	attachment_slot = CHEST
	var/broken = FALSE
	/// If FALSE, the camera monitor will show no feed for this bodycam.
	var/camera_on = TRUE
	var/datum/action/item_action/bodycam_toggle/toggle_action

/obj/item/clothing/accessory/bodycam/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	for(var/obj/item/clothing/accessory/bodycam/other_bodycam in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "already has a bodycam!")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/bodycam/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	. = ..()
	if(!isliving(user))
		return
	user.AddComponent(/datum/component/pausable_bodycam, "bodycam", "[user.real_name] (Bodycam)", CAMERANET_NETWORK_SS13, FALSE, 0.5 SECONDS, camera_on && !broken)
	toggle_action = new(src)
	toggle_action.Grant(user)
	RegisterSignal(clothes, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp))

/obj/item/clothing/accessory/bodycam/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(clothes, COMSIG_ATOM_EMP_ACT)
	if(toggle_action)
		toggle_action.Remove(user)
		toggle_action = null
	. = ..()
	if(!isliving(user))
		return
	var/datum/component/pausable_bodycam/component = user.GetComponent(/datum/component/pausable_bodycam)
	if(component)
		qdel(component)

/obj/item/clothing/accessory/bodycam/ui_action_click(mob/user, datum/action/source)
	if(broken)
		balloon_alert(user, "is broken!")
		return
	camera_on = !camera_on
	var/datum/component/pausable_bodycam/component = user?.GetComponent(/datum/component/pausable_bodycam)
	if(component)
		component.set_camera_enabled(camera_on)
	balloon_alert(user, camera_on ? "camera on" : "camera off")

/obj/item/clothing/accessory/bodycam/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || broken)
		return
	emp_break()
	update_component()

/obj/item/clothing/accessory/bodycam/proc/on_emp(datum/source, severity, protection)
	SIGNAL_HANDLER
	if(protection & EMP_PROTECT_SELF || broken)
		return
	emp_break()
	update_component()

/obj/item/clothing/accessory/bodycam/proc/emp_break()
	broken = TRUE
	icon_state = "bodycamera_broken"
	update_appearance(UPDATE_ICON_STATE)
	astype(loc, /obj/item/clothing/under)?.update_accessory_overlay()
	visible_message(span_warning("[src] sparks and powers down!"))

/obj/item/clothing/accessory/bodycam/proc/update_component()
	var/obj/item/clothing/under/uniform = astype(loc)
	var/mob/living/wearer = uniform?.loc
	if(!istype(wearer))
		return
	var/datum/component/pausable_bodycam/component = wearer.GetComponent(/datum/component/pausable_bodycam)
	if(component)
		component.set_broken(broken, camera_on)

/obj/item/clothing/accessory/bodycam/proc/repair_with_cable(mob/user, obj/item/stack/cable_coil/cabling)
	if(!broken)
		if(user)
			balloon_alert(user, "isn't broken!")
		return FALSE
	if(!cabling.use(1))
		if(user)
			balloon_alert(user, "need cable!")
		return FALSE
	broken = FALSE
	icon_state = "bodycamera"
	update_appearance(UPDATE_ICON_STATE)
	astype(loc, /obj/item/clothing/under)?.update_accessory_overlay()
	update_component()
	if(user)
		balloon_alert(user, "repaired")
	return TRUE

/obj/item/clothing/accessory/bodycam/attackby(obj/item/item, mob/user, list/modifiers)
	if(broken && istype(item, /obj/item/stack/cable_coil))
		repair_with_cable(user, item)
		return TRUE
	return ..()

/obj/item/clothing/accessory/bodycam/examine(mob/user)
	. = ..()
	if(broken)
		. += span_warning("It is broken and can be repaired with cable.")
	else if(!camera_on)
		. += span_notice("It is currently switched off.")
