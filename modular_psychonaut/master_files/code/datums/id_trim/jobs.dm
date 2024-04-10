/datum/id_trim/job/nt_secretary
	assignment = "Nt Secretary"
	trim_icon = 'modular_psychonaut/master_files/icons/obj/card.dmi'
	trim_state = "trim_secretary"
	department_color = SECRETARY_BLUE
	subdepartment_color = SECRETARY_BLUE
	sechud_icon_state = SECHUD_NT_SECRETARY
	minimal_access = list()
	extra_access = list(
		ACCESS_MAINT_TUNNELS,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_HOP,
		)
	job = /datum/job/nt_secretary
