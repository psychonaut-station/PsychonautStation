/obj/item/modular_computer/pda/security/brig_physician
	name = "warden PDA"
	icon_state = "/obj/item/modular_computer/pda/security/brig_physician"
	greyscale_config = /datum/greyscale_config/tablet/stripe_double_split
	greyscale_colors = "#EA3232#0000CC#363636#3F96CC"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
	)
