/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: admin_state
 *
 * Checks that the user is an admin, end-of-story.
 */

GLOBAL_DATUM_INIT(admin_state, /datum/ui_state/admin_state, new)

/datum/ui_state/admin_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_ADMIN))
		return UI_INTERACTIVE
	return UI_CLOSE

/**
 * tgui state: mentor_state
 *
 * Checks that the user is a mentor BUT ALSO an admin.
 */

GLOBAL_DATUM_INIT(mentor_state, /datum/ui_state/mentor_state, new)

/datum/ui_state/mentor_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_MENTOR | R_ADMIN))
		return UI_INTERACTIVE
	return UI_CLOSE
