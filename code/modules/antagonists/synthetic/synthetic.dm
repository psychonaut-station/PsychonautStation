/datum/antagonist/synthetic
	name = "\improper Synthetic"
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE
	show_to_ghosts = FALSE
	show_name_in_check_antagonists = FALSE
	silent = TRUE

/datum/antagonist/synthetic/on_gain()
	. = ..()
	give_objective()

/datum/antagonist/synthetic/greet()
	. = ..()
	to_chat(owner, span_boldannounce("Whitelist'e alınmış bir mesleği seçtin, bunun ne demek olduğunu zaten biliyorsun. En ufak hatada bu meslekten kalıcı yasaklanabilirsin. Lütfen görevlerini iyice oku ve anla. (Sol üstteki menüden bilgi alabilirsin)"))

/datum/antagonist/synthetic/proc/give_objective()
	var/datum/objective/obj_1 = new()
	obj_1.explanation_text = "Centcom'dan gelen emirler senin için her şeyden üstündür. Centcom ne diyorsa yapmak zorundasın."
	obj_1.owner = owner
	obj_1.completed = TRUE

	var/datum/objective/obj_2 = new()
	obj_2.explanation_text = "İnsanları ve İnsansı yaşam formlarını koru, onlara zarar gelmesine izin verme. Mürettebatın hayatı her zaman dışarıdan gelenlerden önceliklidir."
	obj_2.owner = owner
	obj_2.completed = TRUE

	var/datum/objective/obj_3 = new()
	obj_3.explanation_text = "İstasyonun devamlılığını sağla."
	obj_3.owner = owner
	obj_3.completed = TRUE

	objectives |= obj_1
	objectives |= obj_2
	objectives |= obj_3
