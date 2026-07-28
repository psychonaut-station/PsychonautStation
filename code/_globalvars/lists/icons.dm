/// Cache of the width and height of icon files, to avoid repeating the same expensive operation
GLOBAL_LIST_EMPTY(icon_dimensions)
/// Cache of the states of icon files
GLOBAL_LIST_EMPTY(icon_states_cache)
/// Cache of the states of icon files, stored associatively with TRUE for lookup
GLOBAL_LIST_EMPTY(icon_states_cache_lookup)
/// Female Uniforms
GLOBAL_LIST_EMPTY(female_clothing_icons)
/// Icon overrides for sechuds
GLOBAL_LIST_INIT(hud_icon_overrides, alist(
	SECHUD_BRIG_PHYSICIAN = 'icons/psychonaut/mob/huds/hud.dmi',
	SECHUD_WORKER = 'icons/psychonaut/mob/huds/hud.dmi'
))
