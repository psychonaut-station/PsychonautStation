/obj/item/paper/uploadkey
	name = "silicon decryption key"

/obj/item/paper/uploadkey/Initialize(mapload)
	..()

	add_raw_text("<center><h2>Top Secret Silicon Decryption Key</h2></center><br>Decryption key is <b>[GLOB.upload_key]</b>.<br>This key is used for upload console.")
	add_overlay("paper_words")
	update_appearance()

	return INITIALIZE_HINT_NORMAL
