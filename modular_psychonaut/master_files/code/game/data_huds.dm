/mob/living/carbon/human/proc/diag_hud_set_humancell()
	var/image/holder = hud_list?[DIAG_BATT_HUD]
	if (isnull(holder))
		return
	var/obj/item/organ/stomach/ipc/stomach = get_organ_slot(ORGAN_SLOT_STOMACH)
	if(stomach && istype(stomach) && stomach.cell)
		var/chargelvl = (stomach.cell.charge/stomach.cell.maxcharge)
		holder.icon_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		holder.icon_state = "hudnobatt"
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(holder.pixel_x != 23)
		holder.pixel_x = 23
