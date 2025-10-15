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
