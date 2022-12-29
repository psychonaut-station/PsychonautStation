/obj/item/reagent_containers/knife
	//bıçak tarafı
	name = "Poisoned Knife"
	desc = "A special knife, injects the target with the contents of the internal container."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "knife"
	base_icon_state = "knife"
	force = 8
	throwforce = 15
	throw_speed = 5
	throw_range = 10
	sharpness = SHARP_EDGED
	flags_1 = CONDUCT_1
	demolition_mod = 0.75
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	wound_bonus = 5
	bare_wound_bonus = 15
	tool_behaviour = TOOL_KNIFE
	//reagent tarafı
	amount_per_transfer_from_this = 5
	fill_icon_state = "knife"
	fill_icon_thresholds = list(1, 10, 15, 20, 30, 40, 45, 50,)

/obj/item/reagent_containers/knife/Initialize(mapload)
	. = ..()
	create_reagents(50, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/toxin/chloralhydrate, 10)
	possible_transfer_amounts = list(5, 10)

/obj/item/reagent_containers/knife/attack_self(mob/user)
	if(possible_transfer_amounts.len)
		var/i=0
		for(var/A in possible_transfer_amounts)
			i++
			if(A == amount_per_transfer_from_this)
				if(i<possible_transfer_amounts.len)
					amount_per_transfer_from_this = possible_transfer_amounts[i+1]
				else
					amount_per_transfer_from_this = possible_transfer_amounts[1]
				balloon_alert(user, "[src]'s transfer amount is now [amount_per_transfer_from_this] units.")
				return

/obj/item/reagent_containers/knife/attack(mob/living/target, mob/living/user, params)
	if(!istype(target))
		return
	if(!user.combat_mode)
		return
	. = ..()
	if(!reagents.total_volume || !target.reagents)
		return
	var/amount_inject = amount_per_transfer_from_this
	if(!target.can_inject(user, 1))
		amount_inject = 1
	reagents.trans_to(target,amount_inject)
