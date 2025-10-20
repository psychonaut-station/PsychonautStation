/obj/item/reagent_containers/blood/oil
	blood_type = BLOOD_TYPE_OIL

/obj/item/reagent_containers/blood/oil/examine()
	. = ..()
	. += span_notice("There is a flammable warning on the label.")
