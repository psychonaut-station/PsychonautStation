/datum/vote/storyteller_vote
	name = "Storyteller"
	default_message = "Vote for next round's storyteller!"
	count_method = VOTE_COUNT_METHOD_SINGLE
	winner_method = VOTE_WINNER_METHOD_SIMPLE
	display_statistics = FALSE
	var/forced = FALSE

/datum/vote/storyteller_vote/New()
	. = ..()
	default_choices = SSstoryteller.get_valid_storytellers()

/datum/vote/storyteller_vote/reset()
	. = ..()
	forced = FALSE

/datum/vote/storyteller_vote/create_vote(mob/vote_creator)
	var/list/new_choices = SSstoryteller.get_valid_storytellers()
	if (new_choices)
		default_choices = new_choices
	. = ..()
	if(!.)
		return FALSE

	if(!isnull(vote_creator))
		src.forced = TRUE

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
	CONFIG_SET(flag/allow_storyteller_vote, !CONFIG_GET(flag/allow_storyteller_vote))

/datum/vote/storyteller_vote/is_config_enabled()
	return CONFIG_GET(flag/allow_storyteller_vote)

/datum/vote/storyteller_vote/finalize_vote(winning_option)
	SSstoryteller.set_storyteller(winning_option, FALSE, forced)

/datum/vote/storyteller_vote/get_result_text(list/all_winners, real_winner, list/non_voters)
	if(CONFIG_GET(flag/public_storyteller))
		return ..()
	else
		return null

/datum/vote/storyteller_vote/get_winner_text(list/all_winners, real_winner, list/non_voters)
	. = ..()
	. += "\n"
	. += SSstoryteller.storyteller_desc(real_winner)
