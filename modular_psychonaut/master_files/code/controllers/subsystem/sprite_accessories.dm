/// The non gender specific list that we get from init_sprite_accessory_subtypes()
#define DEFAULT_SPRITE_LIST "default_sprites"
/// The male specific list that we get from init_sprite_accessory_subtypes()
#define MALE_SPRITE_LIST "male_sprites"
/// The female specific list that we get from init_sprite_accessory_subtypes()
#define FEMALE_SPRITE_LIST "female_sprites"

/// Use this to init a sprite accessory list for a feature where mobs are required to have one selected
#define INIT_ACCESSORY(sprite_accessory) init_sprite_accessory_subtypes(sprite_accessory, add_blank = FALSE)[DEFAULT_SPRITE_LIST]
/// Use this to init a sprite accessory list for a feature where mobs can opt to not have one selected
#define INIT_OPTIONAL_ACCESSORY(sprite_accessory) init_sprite_accessory_subtypes(sprite_accessory, add_blank = TRUE)[DEFAULT_SPRITE_LIST]

/datum/controller/subsystem/accessories/setup_lists()
	. = ..()
	feature_list[FEATURE_ARACHNID_APPENDAGES] = INIT_ACCESSORY(/datum/sprite_accessory/arachnid_appendages)
	feature_list[FEATURE_IPC_CHASSIS] = INIT_ACCESSORY(/datum/sprite_accessory/ipc_chassis)

#undef INIT_ACCESSORY
#undef INIT_OPTIONAL_ACCESSORY

#undef DEFAULT_SPRITE_LIST
#undef MALE_SPRITE_LIST
#undef FEMALE_SPRITE_LIST
