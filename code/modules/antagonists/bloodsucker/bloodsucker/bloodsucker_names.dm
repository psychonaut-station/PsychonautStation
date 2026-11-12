/datum/antagonist/bloodsucker/proc/return_full_name()
	var/fullname = bloodsucker_name ? bloodsucker_name : owner.current.name
	if(bloodsucker_title)
		fullname = "[bloodsucker_title] [fullname]"
	if(bloodsucker_reputation)
		fullname += " the [bloodsucker_reputation]"

	return fullname

///Returns a First name for the Bloodsucker.
/datum/antagonist/bloodsucker/proc/SelectFirstName()
	if(owner.current.gender == MALE)
		bloodsucker_name = pick(strings("names/bloodsucker_names.json", "first_names_male"))
	else
		bloodsucker_name = pick(strings("names/bloodsucker_names.json", "first_names_female"))

///Returns a Title for the Bloodsucker.
/datum/antagonist/bloodsucker/proc/SelectTitle(am_fledgling = 0, forced = FALSE)
	// Already have Title
	if(!forced && bloodsucker_title != null)
		return
	// Titles [Master]
	if(am_fledgling)
		bloodsucker_title = null
		return
	if(owner.current.gender == MALE)
		bloodsucker_title = pick(strings("names/bloodsucker_names.json", "titles_male"))
	else
		bloodsucker_title = pick(strings("names/bloodsucker_names.json", "titles_female"))
	to_chat(owner, span_announce("You have earned a title! You are now known as <i>[return_full_name()]</i>!"))

///Returns a Reputation for the Bloodsucker.
/datum/antagonist/bloodsucker/proc/SelectReputation(am_fledgling = FALSE, forced = FALSE)
	// Already have Reputation
	if(!forced && bloodsucker_reputation != null)
		return

	if(am_fledgling)
		bloodsucker_reputation = pick(strings("names/bloodsucker_names.json", "reputations_fledgling"))
	else if(owner.current.gender == MALE && prob(10))
		bloodsucker_reputation = pick(strings("names/bloodsucker_names.json", "reputations_rare_male"))
	else if(owner.current.gender == FEMALE && prob(10))
		bloodsucker_reputation = pick(strings("names/bloodsucker_names.json", "reputations_rare_female"))
	else
		bloodsucker_reputation = pick(strings("names/bloodsucker_names.json", "reputations_common"))

	to_chat(owner, span_announce("You have earned a reputation! You are now known as <i>[return_full_name()]</i>!"))
