/datum/computer_file/program/supermatter_monitor
	/// List of supermatters that we are going to send the data of.
	var/list/obj/anomalies = list()

/datum/computer_file/program/supermatter_monitor/kill_program(mob/user)
	for(var/anomaly in anomalies)
		clear_anomaly(anomaly)
	return ..()

/datum/computer_file/program/supermatter_monitor/refresh()
	for(var/anomaly in anomalies)
		clear_anomaly(anomaly)
	var/turf/user_turf = get_turf(computer.ui_host())
	if(!user_turf)
		return ..()
	for (var/obj/singularity/singularity as anything in GLOB.all_singularities)
		anomalies += singularity
		RegisterSignal(singularity, COMSIG_QDELETING, PROC_REF(clear_anomaly))
	for (var/obj/energy_ball/eball as anything in GLOB.all_energy_balls)
		anomalies += eball
		RegisterSignal(eball, COMSIG_QDELETING, PROC_REF(clear_anomaly))
	return ..()

/datum/computer_file/program/supermatter_monitor/ui_static_data(mob/user)
	. = ..()
	.["eball_gas_metadata"] = eball_gas_data()

/datum/computer_file/program/supermatter_monitor/ui_data(mob/user)
	. = ..()
	for (var/obj/singularity/singularity as anything in anomalies)
		.["anomaly_data"] += list(singularity.ntcims_ui_data())
		.["all_data"] += list(singularity.ntcims_ui_data())

/datum/computer_file/program/supermatter_monitor/proc/clear_anomaly(obj/singularity/singulo)
	SIGNAL_HANDLER
	anomalies -= singulo
	UnregisterSignal(singulo, COMSIG_QDELETING)
