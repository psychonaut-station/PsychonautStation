/datum/antagonist
	/// The icon state for the credits major event icons
	var/credits_icon

/datum/antagonist/on_gain()
	. = ..()
	if(credits_icon && owner.current.client)
		SScredits.create_antagonist_icon(owner.current.client, owner.current, credits_icon)
