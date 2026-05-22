/atom/movable/screen/cybernetics/ammo_counter
	name = "digital ammo counter"
	icon = 'modular_psychonaut/master_files/icons/hud/screen_cybernetics.dmi'
	icon_state = "basic_interface"

/atom/movable/screen/cybernetics/ammo_counter/proc/update_counter(obj/item/gun/our_gun)
	var/display
	if(istype(our_gun,/obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/balgun = our_gun
		display = balgun.magazine ? balgun.magazine.ammo_count(FALSE) : 0
	else
		var/obj/item/gun/energy/egun = our_gun
		var/obj/item/ammo_casing/energy/shot = egun.ammo_type[egun.select]
		display = FLOOR(egun.cell.charge / shot.e_cost,1)
	maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='white'>[display]</font></div>")
