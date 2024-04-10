// Secretary id card

/obj/item/card/id/advanced/white
	name = "white identification card"
	desc = "impressive, very nice."
	icon = 'modular_psychonaut/master_files/icons/obj/card.dmi'
	icon_state = "card_white"
	assigned_icon_state = "assigned_white"
	wildcard_slots = WILDCARD_LIMIT_SILVER

/obj/item/card/id/advanced/white/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TASTEFULLY_THICK_ID_CARD, ROUNDSTART_TRAIT)

// Secretary door remote

/obj/item/door_remote/secretary
	name = "special door remote"
	desc = "Nanotrasen Research and Development Division recommends that you should stand away from the airlocks when using this."
	icon = 'modular_psychonaut/master_files/icons/obj/devices/remote.dmi'
	icon_state = "gangtool-secretary"
	base_icon_state = "gangtool-secretary"
	region_access = REGION_SECRETARY

/obj/item/door_remote/secretary/update_icon_state()
	. = ..()
	icon_state = base_icon_state

/obj/item/door_remote/secretary/attack_self(mob/user)
	return

/obj/item/door_remote/secretary/afterattack(atom/target, mob/user)
	if(!istype(user.mind?.assigned_role, /datum/job/nt_secretary))
		to_chat(user, span_warning("You don't know how to use this!"))
		return
	return ..()

// Secretary stamp

/obj/item/stamp/secretary
	name = "secretary's rubber stamp"
	icon = 'modular_psychonaut/master_files/icons/obj/service/bureaucracy.dmi'
	icon_state = "stamp-secretary"
	dye_color = DYE_CAPTAIN

/obj/item/paperwork/secretary
	icon = 'modular_psychonaut/master_files/icons/obj/service/bureaucracy.dmi'
	stamp_requested = /obj/item/stamp/secretary
	stamp_job = /datum/job/nt_secretary
	stamp_icon = "paper_stamp-secretary"

// Secretary pda

/obj/item/modular_computer/pda/nt_secretary
	name = "secretary PDA"
	desc = "A small experimental microcomputer."
	greyscale_config = /datum/greyscale_config/tablet/secretary
	greyscale_colors = "#fafafa#a52f29#034885"
	inserted_item = /obj/item/pen/fountain
	long_ranged = TRUE
	starting_programs = list(
		/datum/computer_file/program/emojipedia,
		/datum/computer_file/program/newscaster,
	)

// Office kit

/obj/item/storage/box/nt_secretary
	name = "Build your own office kit"
	desc = "a.k.a not so rapid office deployment system."
	icon = 'modular_psychonaut/master_files/icons/obj/storage/box.dmi'
	icon_state = "nt_secretary_kit"
	illustration = null

/obj/item/storage/box/nt_secretary/PopulateContents()
	new	/obj/item/stack/sheet/mineral/wood/fifty(src)
	new	/obj/item/stack/sheet/iron/twenty(src)
	new	/obj/item/stack/sheet/glass/twenty(src)
	new /obj/item/stack/tile/carpet/cyan/twenty(src)
	new /obj/item/circuitboard/computer/secretary_console(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)

/obj/item/stack/sheet/glass/twenty
	amount = 20

/obj/item/stack/tile/carpet/cyan/twenty
	amount = 20

/obj/item/storage/box/nt_secretary/coffee
	name = "Office coffee supplies"
	desc = "You shall need this."
	icon = 'modular_psychonaut/master_files/icons/obj/storage/box.dmi'
	icon_state = "nt_secretary_kit"
	illustration = null

/obj/item/storage/box/nt_secretary/coffee/PopulateContents()
	new /obj/item/storage/box/nt_secretary/coffeemakerkit(src)
	new /obj/item/reagent_containers/cup/coffeepot(src)
	new /obj/item/reagent_containers/cup/rag(src)
	new /obj/item/reagent_containers/cup/glass/coffee_cup(src)
	new /obj/item/reagent_containers/cup/glass/coffee_cup(src)
	new /obj/item/reagent_containers/condiment/pack/sugar(src)
	new /obj/item/reagent_containers/condiment/creamer(src)
	new /obj/item/reagent_containers/condiment/pack/astrotame(src)
	new /obj/item/coffee_cartridge(src)
	new /obj/item/coffee_cartridge/fancy(src)

/obj/item/storage/box/nt_secretary/coffeemakerkit
	name = "Coffee maker parts"
	desc = "Coffee maker maker kit for real makers!"
	icon = 'modular_psychonaut/master_files/icons/obj/storage/box.dmi'
	icon_state = "nanobox"
	illustration = null

/obj/item/storage/box/nt_secretary/coffeemakerkit/PopulateContents()
	new /obj/item/circuitboard/machine/coffeemaker(src)
	new /obj/item/reagent_containers/cup/beaker(src)
	new /obj/item/reagent_containers/cup/beaker(src)
	new /obj/item/stock_parts/water_recycler(src)
	new /obj/item/stock_parts/capacitor(src)
	new /obj/item/stock_parts/micro_laser(src)
