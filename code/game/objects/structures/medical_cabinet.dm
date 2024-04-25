/obj/item/wallframe/medical_cabinet
	name = "medical cabinet frame"
	desc = "Used for building wall-mounted medical cabinets."
	icon = 'icons/psychonaut/obj/wallmounts.dmi'
	icon_state = "medical_cabinet"
	result_path = /obj/structure/medical_cabinet/empty
	pixel_shift = 32

/obj/structure/medical_cabinet
	name = "medical cabinet"
	desc = "A small wall mounted cabinet designed to hold some medicines."
	icon = 'icons/psychonaut/obj/wallmounts.dmi'
	icon_state = "medical_cabinet"
	anchored = TRUE
	density = FALSE
	max_integrity = 200
	integrity_failure = 0.25
	var/empty = FALSE
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/medical_cabinet, 32)

/obj/structure/medical_cabinet/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/medcabinet)
	populate_contents()

/obj/structure/medical_cabinet/proc/populate_contents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/storage/medkit/emergency = 2,
		/obj/item/storage/pill_bottle/epinephrine = 1,
	)
	generate_items_inside(items_inside, src)

/obj/structure/medical_cabinet/attackby(obj/item/used_item, mob/living/user, params)
	if(used_item.tool_behaviour == TOOL_WRENCH && !length(contents))
		user.balloon_alert(user, "deconstructing cabinet...")
		used_item.play_tool_sound(src)
		if(used_item.use_tool(src, user, 60))
			playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
			user.balloon_alert(user, "cabinet deconstructed")
			deconstruct(TRUE)
		return

/obj/structure/medical_cabinet/atom_break(damage_flag)
	. = ..()
	if(!broken && !(obj_flags & NO_DECONSTRUCTION))
		broken = 1
		atom_storage?.remove_all(get_turf(src))
		update_appearance(UPDATE_ICON)

/obj/structure/medical_cabinet/deconstruct(disassembled = TRUE)
	if(!(obj_flags & NO_DECONSTRUCTION))
		if(disassembled)
			new /obj/item/wallframe/medical_cabinet(loc)
		else
			new /obj/item/stack/sheet/iron (loc, 2)
	atom_storage?.remove_all(get_turf(src))
	qdel(src)

/obj/structure/medical_cabinet/empty
	empty = TRUE

/datum/storage/medcabinet
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 8

/datum/storage/medcabinet/New(
	atom/parent,
	max_slots,
	max_specific_storage,
	max_total_storage,
)
	. = ..()
	set_holdable(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/spray,
		/obj/item/lighter,
		/obj/item/storage/box/bandages,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/bonesetter,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/blood_filter,
		/obj/item/shears,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/holosign_creator/medical,
		/obj/item/stack/sticky_tape,
		/obj/item/storage/medkit,
	))
