/datum/id_trim/job/brig_physician
	assignment = "Brig Physician"
	trim_icon = 'modular_psychonaut/master_files/icons/obj/card.dmi'
	trim_state = "trim_brig_physician"
	department_color = COLOR_SECURITY_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_BRIG_PHYSICIAN
	extra_access = list(ACCESS_DETECTIVE, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(
		ACCESS_BRIG,
		ACCESS_COURT,
		ACCESS_SECURITY,
		ACCESS_BRIG_ENTRANCE,
		ACCESS_MECH_SECURITY,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_WEAPONS,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL,
	)
	/// List of bonus departmental accesses that departmental sec officers get.
	var/department_access = list()
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/brig_physician

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
		ACCESS_TECH_STORAGE
	)
	extra_access = list(
		ACCESS_ATMOSPHERICS,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CE,
		ACCESS_CHANGE_IDS
	)
	job = /datum/job/worker
