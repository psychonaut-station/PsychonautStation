// This contains all boxes with edible stuffs or stuff related to edible stuffs.

/obj/item/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "Instructions: Heat in microwave. Product will stay perpetually warmed with cutting edge Donk Co. technology."
	icon_state = "donkpocketbox"
	illustration = null
	/// What type of donk pocket are we gonna cram into this box?
	var/donktype = /obj/item/food/donkpocket

/obj/item/storage/box/donkpockets/PopulateContents()
	return donktype

/obj/item/storage/box/donkpockets/donkpocketspicy
	name = "box of spicy-flavoured donk-pockets"
	icon_state = "donkpocketboxspicy"
	donktype = /obj/item/food/donkpocket/spicy

/obj/item/storage/box/donkpockets/donkpocketteriyaki
	name = "box of teriyaki-flavoured donk-pockets"
	icon_state = "donkpocketboxteriyaki"
	donktype = /obj/item/food/donkpocket/teriyaki

/obj/item/storage/box/donkpockets/donkpocketpizza
	name = "box of pizza-flavoured donk-pockets"
	icon_state = "donkpocketboxpizza"
	donktype = /obj/item/food/donkpocket/pizza

/obj/item/storage/box/donkpockets/donkpocketgondola
	name = "box of gondola-flavoured donk-pockets"
	icon_state = "donkpocketboxgondola"
	donktype = /obj/item/food/donkpocket/gondola

/obj/item/storage/box/donkpockets/donkpocketberry
	name = "box of berry-flavoured donk-pockets"
	icon_state = "donkpocketboxberry"
	donktype = /obj/item/food/donkpocket/berry

/obj/item/storage/box/donkpockets/donkpockethonk
	name = "box of banana-flavoured donk-pockets"
	icon_state = "donkpocketboxbanana"
	donktype = /obj/item/food/donkpocket/honk

/obj/item/storage/box/donkpockets/donkpocketshell
	name = "box of Donk Co. 'Donk Spike' flechette shells"
	desc = "Instructions: DO NOT heat in microwave. Product will remove all hostile threats with cutting edge Donk Co. technology."
	icon_state = "donkpocketboxshell"
	donktype = /obj/item/ammo_casing/shotgun/flechette/donk

/obj/item/storage/box/papersack
	name = "paper sack"
	desc = "A sack neatly crafted out of paper."
	icon = 'icons/obj/storage/paperbag.dmi'
	icon_state = "paperbag_None"
	inhand_icon_state = null
	illustration = null
	resistance_flags = FLAMMABLE
	foldable_result = null
	/// A list of all available papersack reskins
	var/list/papersack_designs = list()
	///What design from papersack_designs we are currently using.
	var/design_choice = "None"

/obj/item/storage/box/papersack/Initialize(mapload)
	. = ..()
	papersack_designs = sort_list(list(
		"None" = image(icon = src.icon, icon_state = "paperbag_None"),
		"NanotrasenStandard" = image(icon = src.icon, icon_state = "paperbag_NanotrasenStandard"),
		"SyndiSnacks" = image(icon = src.icon, icon_state = "paperbag_SyndiSnacks"),
		"Heart" = image(icon = src.icon, icon_state = "paperbag_Heart"),
		"SmileyFace" = image(icon = src.icon, icon_state = "paperbag_SmileyFace")
		))
	update_appearance()

/obj/item/storage/box/papersack/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, design_choice))
		update_appearance()

/obj/item/storage/box/papersack/update_icon_state()
	icon_state = "paperbag_[design_choice][(contents.len == 0) ? null : "_closed"]"
	return ..()

/obj/item/storage/box/papersack/update_desc(updates)
	switch(design_choice)
		if("None")
			desc = "A sack neatly crafted out of paper."
		if("NanotrasenStandard")
			desc = "A standard Nanotrasen paper lunch sack for loyal employees on the go."
		if("SyndiSnacks")
			desc = "The design on this paper sack is a remnant of the notorious 'SyndieSnacks' program."
		if("Heart")
			desc = "A paper sack with a heart etched onto the side."
		if("SmileyFace")
			desc = "A paper sack with a crude smile etched onto the side."
	return ..()

/obj/item/storage/box/papersack/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(IS_WRITING_UTENSIL(tool))
		var/choice = show_radial_menu(user, src , papersack_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user, tool), radius = 36, require_near = TRUE)
		if(!choice || choice == design_choice)
			return ITEM_INTERACT_BLOCKING
		design_choice = choice
		balloon_alert(user, "modified")
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	if(tool.get_sharpness() && !contents.len)
		if(design_choice == "None")
			user.show_message(span_notice("You cut eyeholes into [src]."), MSG_VISUAL)
			new /obj/item/clothing/head/costume/papersack(drop_location())
			qdel(src)
			return ITEM_INTERACT_SUCCESS
		else if(design_choice == "SmileyFace")
			user.show_message(span_notice("You cut eyeholes into [src] and modify the design."), MSG_VISUAL)
			new /obj/item/clothing/head/costume/papersack/smiley(drop_location())
			qdel(src)
			return ITEM_INTERACT_SUCCESS
	return ..()

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 * * P The pen used to interact with a menu
 */
/obj/item/storage/box/papersack/proc/check_menu(mob/user, obj/item/pen/P)
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	if(contents.len)
		balloon_alert(user, "items inside!")
		return FALSE
	if(!P || !user.is_holding(P))
		balloon_alert(user, "needs pen!")
		return FALSE
	return TRUE

/obj/item/storage/box/papersack/meat
	desc = "It's slightly moist and smells like a slaughterhouse."

/obj/item/storage/box/papersack/meat/PopulateContents()
	. = list()
	for(var/_ in 1 to 7)
		. += /obj/item/food/meat/slab

/obj/item/storage/box/papersack/wheat
	desc = "It's a bit dusty, and smells like a barnyard."

/obj/item/storage/box/papersack/wheat/PopulateContents()
	. = list()
	for(var/_ in 1 to 7)
		. += /obj/item/food/grown/wheat

/obj/item/storage/box/ingredients //This box is for the randomly chosen version the chef used to spawn with, it shouldn't actually exist.
	name = "ingredients box"
	illustration = "fruit"
	storage_type = /datum/storage/box/ingredients

	///Used in describing the box
	var/theme_name

/obj/item/storage/box/ingredients/Initialize(mapload)
	. = ..()
	if(theme_name)
		name = "[name] ([theme_name])"
		desc = "A box containing supplementary ingredients for the aspiring chef. The box's theme is '[theme_name]'."
		inhand_icon_state = "syringe_kit"

/obj/item/storage/box/ingredients/wildcard
	theme_name = "wildcard"

/obj/item/storage/box/ingredients/wildcard/PopulateContents()
	var/static/list/obj/item/foods = list(
		/obj/item/food/chocolatebar,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/banana,
		/obj/item/food/grown/cabbage,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/cherries,
		/obj/item/food/grown/chili,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/cucumber,
		/obj/item/food/grown/mushroom/chanterelle,
		/obj/item/food/grown/mushroom/plumphelmet,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/potato/sweet,
		/obj/item/food/grown/soybeans,
		/obj/item/food/grown/tomato,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 7)
		insert += pick(foods)

	return insert

/obj/item/storage/box/ingredients/fiesta
	theme_name = "fiesta"

/obj/item/storage/box/ingredients/fiesta/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/grown/corn = 2,
		/obj/item/food/grown/soybeans = 2,
	))

/obj/item/storage/box/ingredients/italian
	theme_name = "italian"

/obj/item/storage/box/ingredients/italian/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/grown/tomato = 3,
		/obj/item/food/meatball = 3,
		/obj/item/reagent_containers/cup/glass/bottle/wine = 1,
	))

/obj/item/storage/box/ingredients/vegetarian
	theme_name = "vegetarian"

/obj/item/storage/box/ingredients/vegetarian/PopulateContents()
	return list(
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/eggplant,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/tomato,
	)

/obj/item/storage/box/ingredients/american
	theme_name = "american"

/obj/item/storage/box/ingredients/american/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/grown/corn = 2,
		/obj/item/food/grown/potato = 2,
		/obj/item/food/grown/tomato = 2,
		/obj/item/food/meatball = 1,
	))

/obj/item/storage/box/ingredients/fruity
	theme_name = "fruity"

/obj/item/storage/box/ingredients/fruity/PopulateContents(datum/storage_config/config)
	config.compute_max_total_weight = TRUE

	return flatten_quantified_list(list(
		/obj/item/food/grown/apple = 2,
		/obj/item/food/grown/citrus/orange = 2,
		/obj/item/food/grown/citrus/lemon = 1,
		/obj/item/food/grown/citrus/lime = 1,
		/obj/item/food/grown/watermelon = 1,
	))

/obj/item/storage/box/ingredients/sweets
	theme_name = "sweets"

/obj/item/storage/box/ingredients/sweets/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/grown/cherries = 2,
		/obj/item/food/grown/banana = 2,
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/cocoapod = 1,
	))

/obj/item/storage/box/ingredients/delights
	theme_name = "delights"

/obj/item/storage/box/ingredients/delights/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/grown/bluecherries = 2,
		/obj/item/food/grown/potato/sweet = 2,
		/obj/item/food/grown/berries = 1,
		/obj/item/food/grown/cocoapod = 1,
		/obj/item/food/grown/vanillapod = 1,
	))

/obj/item/storage/box/ingredients/grains
	theme_name = "grains"

/obj/item/storage/box/ingredients/grains/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/grown/oat = 3,
		/obj/item/food/grown/cocoapod = 1,
		/obj/item/food/grown/wheat = 1,
		/obj/item/food/honeycomb = 1,
		/obj/item/seeds/poppy = 1,
	))

/obj/item/storage/box/ingredients/carnivore
	theme_name = "carnivore"

/obj/item/storage/box/ingredients/carnivore/PopulateContents()
	return list(
		/obj/item/food/meat/slab/bear,
		/obj/item/food/meat/slab/corgi,
		/obj/item/food/meat/slab/penguin,
		/obj/item/food/meat/slab/spider,
		/obj/item/food/meat/slab/xeno,
		/obj/item/food/meatball,
		/obj/item/food/spidereggs,
	)

/obj/item/storage/box/ingredients/exotic
	theme_name = "exotic"

/obj/item/storage/box/ingredients/exotic/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/fishmeat/carp = 2,
		/obj/item/food/grown/cabbage = 2,
		/obj/item/food/grown/soybeans = 2,
		/obj/item/food/grown/chili = 1,
	))

/obj/item/storage/box/ingredients/seafood
	theme_name = "seafood"

/obj/item/storage/box/ingredients/seafood/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/fishmeat/armorfish = 2,
		/obj/item/food/fishmeat/carp = 2,
		/obj/item/food/fishmeat/moonfish = 2,
		/obj/item/food/fishmeat/gunner_jellyfish/supply = 1,
	))

/obj/item/storage/box/ingredients/salads
	theme_name = "salads"

/obj/item/storage/box/ingredients/salads/PopulateContents()
	return list(
		/obj/item/food/grown/cabbage,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/olive,
		/obj/item/food/grown/onion/red,
		/obj/item/food/grown/onion/red,
		/obj/item/food/grown/tomato,
		/obj/item/reagent_containers/condiment/olive_oil,
	)

/obj/item/storage/box/ingredients/random
	theme_name = "random"
	desc = "This box should not exist, contact the proper authorities."

/obj/item/storage/box/ingredients/random/Initialize(mapload)
	. = ..()
	var/chosen_box = pick(subtypesof(/obj/item/storage/box/ingredients) - /obj/item/storage/box/ingredients/random)
	new chosen_box(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/storage/box/gum
	name = "bubblegum packet"
	desc = "The packaging is entirely in Japanese, apparently. You can't make out a single word of it."
	icon = 'icons/obj/storage/gum.dmi'
	icon_state = "bubblegum_generic"
	w_class = WEIGHT_CLASS_TINY
	illustration = null
	foldable_result = null
	custom_price = PAYCHECK_CREW
	storage_type = /datum/storage/box/bubble_gum

/obj/item/storage/box/gum/PopulateContents()
	. = list()
	for(var/_ in 1 to 4)
		. += /obj/item/food/bubblegum

/obj/item/storage/box/gum/nicotine
	name = "nicotine gum packet"
	desc = "Designed to help with nicotine addiction and oral fixation all at once without destroying your lungs in the process. Mint flavored!"
	icon_state = "bubblegum_nicotine"
	custom_premium_price = PAYCHECK_CREW * 1.5

/obj/item/storage/box/gum/nicotine/PopulateContents()
	. = list()
	for(var/_ in 1 to 4)
		. += /obj/item/food/bubblegum/nicotine

/obj/item/storage/box/gum/happiness
	name = "HP+ gum packet"
	desc = "A seemingly homemade packaging with an odd smell. It has a weird drawing of a smiling face sticking out its tongue."
	icon_state = "bubblegum_happiness"
	custom_price = PAYCHECK_COMMAND * 3
	custom_premium_price = PAYCHECK_COMMAND * 3

/obj/item/storage/box/gum/happiness/Initialize(mapload)
	. = ..()
	if (prob(25))
		desc += " You can faintly make out the word 'Hemopagopril' was once scribbled on it."

/obj/item/storage/box/gum/happiness/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/bubblegum/happiness = 4,
	))

/obj/item/storage/box/gum/bubblegum
	name = "bubblegum gum packet"
	desc = "The packaging is entirely in Demonic, apparently. You feel like even opening this would be a sin."
	icon_state = "bubblegum_bubblegum"

/obj/item/storage/box/gum/bubblegum/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/food/bubblegum/bubblegum = 4,
	))

/obj/item/storage/box/mothic_rations
	name = "Mothic Rations Pack"
	desc = "A box containing a few rations and some Activin gum, for keeping a starving moth going."
	icon_state = "moth_package"
	illustration = null

/obj/item/storage/box/mothic_rations/PopulateContents()
	var/static/list/obj/item/food = list(
		/obj/item/food/sustenance_bar = 10,
		/obj/item/food/sustenance_bar/cheese = 5,
		/obj/item/food/sustenance_bar/mint = 5,
		/obj/item/food/sustenance_bar/neapolitan = 5,
		/obj/item/food/sustenance_bar/wonka = 1,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 3)
		insert += pick_weight(food)
	insert += /obj/item/storage/box/gum/wake_up

	return insert

/obj/item/storage/box/tiziran_goods
	name = "Tiziran Farm-Fresh Pack"
	desc = "A box containing an assortment of fresh Tiziran goods- perfect for making the foods of the Lizard Empire."
	icon_state = "lizard_package"
	illustration = null

/obj/item/storage/box/tiziran_goods/PopulateContents()
	var/static/list/obj/item/food = list(
		/obj/item/food/bread/root = 2,
		/obj/item/food/grown/ash_flora/seraka = 2,
		/obj/item/food/grown/korta_nut = 10,
		/obj/item/food/grown/korta_nut/sweet = 2,
		/obj/item/food/liver_pate = 5,
		/obj/item/food/lizard_dumplings = 5,
		/obj/item/food/moonfish_caviar = 5,
		/obj/item/food/root_flatbread = 5,
		/obj/item/food/rootroll = 5,
		/obj/item/food/spaghetti/nizaya = 5,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 3)
		insert += pick_weight(food)

	return insert

/obj/item/storage/box/tiziran_cans
	name = "Tiziran Canned Goods Pack"
	desc = "A box containing an assortment of canned Tiziran goods- to be eaten as is, or used in cooking."
	icon_state = "lizard_package"
	illustration = null
	storage_type = /datum/storage/box/tiziran_cans

/obj/item/storage/box/tiziran_cans/PopulateContents()
	var/static/list/obj/item/food = list(
		/obj/item/food/bread/root = 2,
		/obj/item/food/grown/ash_flora/seraka = 2,
		/obj/item/food/grown/korta_nut = 10,
		/obj/item/food/grown/korta_nut/sweet = 2,
		/obj/item/food/liver_pate = 5,
		/obj/item/food/lizard_dumplings = 5,
		/obj/item/food/moonfish_caviar = 5,
		/obj/item/food/root_flatbread = 5,
		/obj/item/food/rootroll = 5,
		/obj/item/food/spaghetti/nizaya = 5,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 8)
		insert += pick_weight(food)

	return insert

/obj/item/storage/box/tiziran_meats
	name = "Tiziran Meatmarket Pack"
	desc = "A box containing an assortment of fresh-frozen Tiziran meats and fish- the keys to lizard cooking."
	icon_state = "lizard_package"
	illustration = null
	storage_type = /datum/storage/box/tiziran_meats

/obj/item/storage/box/tiziran_meats/PopulateContents()
	var/static/list/obj/item/food = list(
		/obj/item/food/fishmeat/armorfish = 5,
		/obj/item/food/fishmeat/gunner_jellyfish = 5,
		/obj/item/food/fishmeat/moonfish = 5,
		/obj/item/food/meat/slab = 5,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 10)
		insert += pick_weight(food)

	return insert

/obj/item/storage/box/mothic_goods
	name = "Mothic Farm-Fresh Pack"
	desc = "A box containing an assortment of Mothic cooking supplies."
	icon_state = "moth_package"
	illustration = null
	storage_type = /datum/storage/box/mothic_goods

/obj/item/storage/box/mothic_goods/PopulateContents(datum/storage_config/config)
	config.compute_max_total_weight = TRUE

	var/static/list/obj/item/food = list(
		/obj/item/food/cheese/cheese_curds = 5,
		/obj/item/food/cheese/curd_cheese = 5,
		/obj/item/food/cheese/firm_cheese = 5,
		/obj/item/food/cheese/mozzarella = 5,
		/obj/item/food/cheese/wheel = 5,
		/obj/item/food/grown/toechtauese = 10,
		/obj/item/reagent_containers/condiment/cornmeal = 5,
		/obj/item/reagent_containers/condiment/olive_oil = 5,
		/obj/item/reagent_containers/condiment/yoghurt = 5,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 12)
		insert += pick_weight(food)

	return insert

/obj/item/storage/box/mothic_cans_sauces
	name = "Mothic Pantry Pack"
	desc = "A box containing an assortment of Mothic canned goods and premade sauces."
	icon_state = "moth_package"
	illustration = null
	storage_type = /datum/storage/box/mothic_cans_sauces

/obj/item/storage/box/mothic_cans_sauces/PopulateContents()
	var/static/list/obj/item/food = list(
		/obj/item/food/bechamel_sauce = 5,
		/obj/item/food/canned/pine_nuts = 5,
		/obj/item/food/canned/tomatoes = 5,
		/obj/item/food/pesto = 5,
		/obj/item/food/tomato_sauce = 5,
	)

	var/list/obj/item/insert = list()
	for(var/i in 1 to 8)
		insert += pick_weight(food)

	return insert

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	illustration = "condiment"

/obj/item/storage/box/condimentbottles/PopulateContents()
	return flatten_quantified_list(list(
		/obj/item/reagent_containers/condiment = 6,
	))


/obj/item/storage/box/coffeepack
	icon_state = "arabica_beans"
	name = "arabica beans"
	desc = "A bag containing fresh, dry coffee arabica beans. Ethically sourced and packaged by Waffle Corp."
	illustration = null
	icon = 'icons/obj/food/containers.dmi'
	storage_type = /datum/storage/box/coffee

	/// Bean type to initialize the box with
	var/beantype = /obj/item/food/grown/coffee

/obj/item/storage/box/coffeepack/PopulateContents()

	var/list/obj/item/food = list()
	for(var/i in 1 to 5)
		var/obj/item/food/grown/coffee/bean = new beantype(null)
		ADD_TRAIT(bean, TRAIT_DRIED, ELEMENT_TRAIT(type))
		bean.add_atom_colour(COLOR_DRIED_TAN, FIXED_COLOUR_PRIORITY) //give them the tan just like from the drying rack
		food += bean

	return food

/obj/item/storage/box/coffeepack/robusta
	icon_state = "robusta_beans"
	name = "robusta beans"
	desc = "A bag containing fresh, dry coffee robusta beans. Ethically sourced and packaged by Waffle Corp."
	beantype = /obj/item/food/grown/coffee/robusta
