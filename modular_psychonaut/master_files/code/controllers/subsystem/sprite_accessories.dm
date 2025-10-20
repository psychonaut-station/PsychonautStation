/// The non gender specific list that we get from init_sprite_accessory_subtypes()
#define DEFAULT_SPRITE_LIST "default_sprites"
/// The male specific list that we get from init_sprite_accessory_subtypes()
#define MALE_SPRITE_LIST "male_sprites"
/// The female specific list that we get from init_sprite_accessory_subtypes()
#define FEMALE_SPRITE_LIST "female_sprites"

/datum/controller/subsystem/accessories
	//Mutant Human bits
	var/list/arachnid_appendages_list
	var/list/ipc_chassis_list

/datum/controller/subsystem/accessories/setup_lists()
	. = ..()
	arachnid_appendages_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/arachnid_appendages)[DEFAULT_SPRITE_LIST]
	ipc_chassis_list = init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_chassis)[DEFAULT_SPRITE_LIST]

#undef DEFAULT_SPRITE_LIST
#undef MALE_SPRITE_LIST
#undef FEMALE_SPRITE_LIST
