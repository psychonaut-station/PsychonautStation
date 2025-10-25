/datum/memory/key/silicon_decrypt_key
	var/upload_key

/datum/memory/key/silicon_decrypt_key/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	upload_key,
)
	src.upload_key = upload_key
	return ..()

/datum/memory/key/silicon_decrypt_key/get_names()
	return list("The secret silicon decryption key is [upload_key]. Keep it a secret from the clown.")

/datum/memory/key/silicon_decrypt_key/get_starts()
	return list(
		"A sticky note attached to a locker with [upload_key] written on it.",
		"Lamarr the facehugger jumps to a AI upload console with [upload_key] written on it over and over again.",
		"[protagonist_name] spilling coffee over the AI upload console while typing [upload_key].",
	)
