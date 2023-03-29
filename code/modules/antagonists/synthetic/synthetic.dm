/datum/antagonist/synthetic
	name = "\improper Synthetic"
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE
	show_to_ghosts = FALSE
	show_name_in_check_antagonists = FALSE
	silent = FALSE

/datum/antagonist/synthetic/greet()
	. = ..()
	to_chat(owner, span_boldannounce("Unutulmamalıdır ki, Sentetikler Asimov yasalarına bağlı değildirler ve mürettebata karşı saldırgan tavırlar göstermemeleri beklenir. Ancak bazı ekstrem durumlarda bu kural yok sayılabilir. Sentetik böyle durumlarda etrafta yaralı veya tehlike altında biri varsa ona öncelik vermelidir. Etrafta böyle biri yoksa bahsi geçen tehdite saldırabilirler."))

/datum/antagonist/synthetic/on_gain()
	. = ..()
	give_objective()

/datum/antagonist/synthetic/proc/give_objective()
	var/datum/objective/obj_1 = new()
	obj_1.explanation_text = "Eğer kararsız kaldıysanız herhangi bir şey yapmadan veya bir eşyayı almadan önce birine sor."
	obj_1.owner = owner
	obj_1.completed = FALSE

	var/datum/objective/obj_2 = new()
	obj_2.explanation_text = "Mürettebat üyelerine zarar verme. (Bazı özel durumlarda bu kural göz ardı edilebilir.)"
	obj_2.owner = owner
	obj_2.completed = FALSE

	var/datum/objective/obj_3 = new()
	obj_3.explanation_text = "Command üyeleri tarafından verilen emir Nanotrasen'e ve çıkarlarına zarar vermeyeceği sürece verilen emri yerine getirmek zorundasın. Nanotrasen'e ve Nanotrasen'in mutlak otoritesine karşı gelecek emirleri uygulaman kesinlikle yasak."
	obj_3.owner = owner
	obj_3.completed = FALSE

	var/datum/objective/obj_4 = new()
	obj_4.explanation_text = "Herhangi bir mürettebat üyesini kanıtın olmadığı veya kendi gözlerinle görmediğin sürece suçlama. Dalga geçme amaçlı böyle şeyleri yapmanda bir sakınca yok ancak çok abartma."
	obj_4.owner = owner
	obj_4.completed = FALSE

	var/datum/objective/obj_5 = new()
	obj_5.explanation_text = "Kendi varlığını korumak ve devam ettirmek en büyük önceliklerinden, amaçsız bir şekilde kendi varlığını sonlandıracak şeyler yapma..."
	obj_5.owner = owner
	obj_5.completed = FALSE

	var/datum/objective/obj_6 = new()
	obj_6.explanation_text = "Eğer biriyle dövüşüyorsan, tehditi etkisiz hale getirdikten sonra bırakmalısın. Eğer senden kaçarsa/uzaklaşmaya çalışırsa onu kovalama. (Delta, Red alert ve diğer spesifik durumlar için bu kural göz ardı edilebilir, bahsedilen spesifik durumlar aşağıda belirtiliyor.)"
	obj_6.owner = owner
	obj_6.completed = FALSE

	objectives |= obj_1
	objectives |= obj_2
	objectives |= obj_3
	objectives |= obj_4
	objectives |= obj_5
	objectives |= obj_6

/datum/antagonist/synthetic/ui_data(mob/user)
	var/list/data = list()
	data["antag_name"] = name
	data["objectives"] = get_objectives()
	return data
