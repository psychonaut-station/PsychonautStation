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

/datum/id_trim/job/worker
	assignment = "Worker"
	trim_icon = 'modular_psychonaut/master_files/icons/obj/card.dmi'
	trim_state = "trim_worker"
	department_color = COLOR_ENGINEERING_ORANGE
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_WORKER
	minimal_access = list(
		ACCESS_AUX_BASE,
		ACCESS_CONSTRUCTION,
		ACCESS_ENGINEERING,
		ACCESS_ENGINE_EQUIP,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MECH_ENGINE,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_TECH_STORAGE,
	)
	extra_access = list(
		ACCESS_ATMOSPHERICS,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_CE,
	)
	job = /datum/job/worker
