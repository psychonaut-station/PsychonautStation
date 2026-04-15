/obj/item/server_rack
	name = "server rack"
	desc = "A self-contained rack built for decentralized AI hardware."
	icon = 'icons/obj/module.dmi'
	icon_state = "server_rack"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	force = 5
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2.5)
	var/list/contained_cpus = list()
	var/contained_ram = 0

/obj/item/server_rack/examine(mob/user)
	. = ..()
	var/total = get_cpu()
	for(var/obj/item/ai_cpu/cpu in contained_cpus)
		. += span_notice("It has [cpu] installed. Running at [cpu.speed]THz and consuming [cpu.get_power_usage()]W.")
	. += span_notice("For a total CPU speed of [total]THz")
	. += span_notice("----------------------")
	. += span_notice("It currently has [get_ram()]TB of RAM installed.")
	. += span_notice("It consumes [get_power_usage()]W of electricity.")

/obj/item/server_rack/proc/get_cpu()
	. = 0
	for(var/obj/item/ai_cpu/cpu in contained_cpus)
		. += cpu.speed

/obj/item/server_rack/proc/get_ram()
	return contained_ram

/obj/item/server_rack/proc/get_power_usage()
	. = 0
	for(var/obj/item/ai_cpu/cpu in contained_cpus)
		. += cpu.get_power_usage()
	. += contained_ram * AI_RAM_POWER_USAGE

/obj/item/server_rack/roundstart/Initialize(mapload)
	. = ..()
	var/obj/item/ai_cpu/cpu = new(src)
	contained_cpus += cpu
	contained_ram = 1
