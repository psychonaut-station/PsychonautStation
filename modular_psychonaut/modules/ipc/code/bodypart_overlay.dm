/datum/bodypart_overlay/simple/body_marking/ipc
	dna_feature_key = FEATURE_IPC_CHASSIS

/datum/bodypart_overlay/simple/body_marking/ipc/get_accessory(name)
	return SSaccessories.ipc_chassis_list[name]

/datum/bodypart_overlay/simple/body_marking/ipc/get_overlay(layer, obj/item/bodypart/limb)
	layer = bitflag_to_layer(layer)
	var/image/main_image = get_image(layer, limb)
	color_image(main_image, layer, limb)
	var/image/aux_image = get_aux_image(layer, limb)
	color_image(aux_image, layer, limb)
	if(blocks_emissive == EMISSIVE_BLOCK_NONE || !limb)
		return list(
			main_image,
			aux_image
		)

	var/list/all_images = list(
		main_image,
		emissive_blocker(main_image.icon, main_image.icon_state, limb, layer = main_image.layer, alpha = main_image.alpha),
		aux_image,
		emissive_blocker(aux_image.icon, aux_image.icon_state, limb, layer = aux_image.layer, alpha = aux_image.alpha),
	)
	return all_images
