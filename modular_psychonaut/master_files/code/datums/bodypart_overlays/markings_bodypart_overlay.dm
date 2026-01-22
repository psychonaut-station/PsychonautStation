/datum/bodypart_overlay/simple/body_marking/proc/get_aux_image(layer, obj/item/bodypart/limb)
	return mutable_appearance(icon, "[icon_state]_[limb.aux_zone]", -limb.aux_layer)
