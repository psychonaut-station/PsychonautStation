/datum/vote/storyteller_vote
	name = "Map"
	default_message = "Vote for next round's map!"
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE
	display_statistics = FALSE

/datum/vote/storyteller_vote/New()
	. = ..()
	default_choices = SSstoryteller.get_valid_storytellers()

/datum/vote/storyteller_vote/create_vote()
	var/list/new_choices = SSstoryteller.get_valid_storytellers()
	if (new_choices)
		default_choices = new_choices
	. = ..()
	if(!.)
		return FALSE

	if(length(choices) == 1) // Only one choice, no need to vote. Let's just auto-rotate it to the only remaining map because it would just happen anyways.
		var/datum/storyteller/storyteller = SSstoryteller.storyteller_namelist[choices[1]]
		finalize_vote(choices[1])// voted by not voting, very sad.
		to_chat(world, span_boldannounce("The storyteller vote has been skipped because there is only one storyteller left to vote for. \
			The storyteller has been changed to [storyteller.name]."))
		return FALSE
	if(length(choices) == 0)
		to_chat(world, span_boldannounce("A storyteller vote was called, but there are no storyteller to vote for! \
			Players, complain to the admins. Admins, complain to the coders."))
		return FALSE

	return TRUE

/datum/vote/storyteller_vote/toggle_votable()
	CONFIG_SET(flag/storyteller_votable, !CONFIG_GET(flag/storyteller_votable))

/datum/vote/storyteller_vote/is_config_enabled()
	return CONFIG_GET(flag/storyteller_votable)

/datum/vote/storyteller_vote/finalize_vote(winning_option)
	text2file(winning_option, "data/next_round_storyteller.txt")

/datum/vote/storyteller_vote/proc/get_vote_choices()
	. = list()
	for(var/datum/storyteller/storyteller_type as anything in subtypesof(/datum/storyteller))
		var/datum/storyteller/storyteller = new storyteller_type()
		. += storyteller.name
