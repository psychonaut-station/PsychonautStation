## Singularity Engine

MODULE ID: SINGULARITY_ENGINE

### Açıklama

İstasyona supermatter engineye alternatif olan singularity engine'yi ekler.

Baseturfu olan istasyonlarda kullanılmamalıdır. Bknz [`/turf/singularity_act()`](/code/game/turfs/turf.dm#L542)

### TG Değişiklikleri

- `code/__DEFINES/_flags.dm`: `ZAP_EBALL_FLAGS`
- `code/__HELPERS/areas.dm`: `GLOB.typecache_powerfailure_safe_areas`
- `code/__HELPERS/radiation.dm`: `/proc/radiation_pulse()`, `/datum/radiation_pulse_information/var/intensity`
- `code/datums/components/singularity.dm`: `/datum/component/singularity/process()`, `/datum/component/singularity/proc/digest()`, `/datum/component/singularity/proc/move()`, `/datum/component/singularity/bloodthirsty/move()`
- `code/game/machinery/incident_display.dm`: `DISPLAY_SINGULARITY_DEATH`, `sign_features`, `/obj/machinery/incident_display/add_context()`, `/obj/machinery/incident_display/emp_act()`, `/obj/machinery/incident_display/examine()`
- `code/game/objects/effects/anomalies/anomalies_bioscrambler.dm`: `/obj/effect/anomaly/bioscrambler/move_anomaly()`
- `code/modules/admin/verbs/debug.dm`: `cmd_admin_areatest`
- `code/modules/antagonists/wizard/grand_ritual/grand_ritual.dm`: `/datum/action/cooldown/grand_ritual/var/area_blacklist`
- `code/modules/events/supermatter_surge.dm`: `/datum/round_event_control/supermatter_surge/can_spawn_event()`
- `code/modules/modular_computers/file_system/programs/sm_monitor.dm`: `/datum/computer_file/program/supermatter_monitor/ui_data()`
- `code/modules/power/singularity/singularity.dm`: `/obj/singularity/var/dissipate_delay`, `/obj/singularity/process()`, `/obj/singularity/proc/expand()`
- `code/modules/power/tesla/energy_ball.dm`: `TESLA_DEFAULT_ENERGY`, [`/obj/energy_ball`: `var/pixel_x`, `var/pixel_y`], `/obj/energy_ball/process()`, `/obj/energy_ball/proc/can_move()`, `/obj/energy_ball/proc/new_mini_ball()`, `/proc/tesla_zap()`
- `code/modules/projectiles/gun.dm`: `/obj/item/gun/proc/fire_gun()`
- `code/modules/research/techweb/nodes/engi_nodes.dm`: `/datum/techweb_node/energy_manipulation`
- `tgui/packages/tgui/interfaces/NtosSupermatter.tsx`: `NtosSupermatterData`, `NtosSupermatter`, `MonitorContent`
- `tgui/packages/tgui/interfaces/Supermatter.tsx`: `SupermatterProps`, `SupermatterContent`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/subsystem/persistence/_persistence.dm`: [`/datum/controller/subsystem/persistence`: `var/rounds_since_singularity_death`, `var/singularity_death_record`], `/datum/controller/subsystem/persistence/Initialize()`, `/datum/controller/subsystem/persistence/collect_data()`
- `modular_psychonaut/master_files/code/controllers/subsystem/persistence/counter_singularity_deaths.dm`: `/datum/controller/subsystem/persistence/load_singularity_death_counter()`, `/datum/controller/subsystem/persistence/save_singularity_death_counter()`
- `modular_psychonaut/master_files/code/datums/storage/subtypes/toolboxes.dm`: `/datum/storage/toolbox/guncase/anomalycatcher`
- `modular_psychonaut/master_files/code/game/area/areas/station/engineering.dm`: `/area/station/engineering/singularity`, `/area/station/engineering/singularity/room`
- `modular_psychonaut/master_files/code/game/atom/atom_act.dm` `/atom/proc/rad_act()`
- `modular_psychonaut/master_files/code/game/machinery/incident_display.dm`
- `modular_psychonaut/master_files/code/game/objects/items/anomaly_kinesis.dm`: `/obj/item/gun/energy/kinesis`
- `modular_psychonaut/master_files/code/game/objects/items/devices/anomaly_catcher.dm`: `/obj/item/anomaly_catcher`
- `modular_psychonaut/master_files/code/game/objects/items/storage/toolboxes/weapons.dm`: `/obj/item/storage/toolbox/guncase/anomaly_catcher`
- `modular_psychonaut/master_files/code/game/objects/structures/crates_lockers/closets/secure/engineering.dm`: `/obj/structure/closet/secure_closet/engineering_chief/PopulateContents()`
- `modular_psychonaut/master_files/code/modules/cargo/bounties/engineering.dm`: `/datum/bounty/item/engineering/energy_ball`
- `modular_psychonaut/master_files/code/modules/cargo/exports/tools.dm`: `/datum/export/singulo`, `/datum/export/singulo/tesla`
- `modular_psychonaut/master_files/code/modules/cargo/packs/engineering.dm`: `/datum/supply_pack/engine/particle_accelerator`, `/datum/supply_pack/engine/singulo_gen`, `/datum/supply_pack/engine/tesla_gen`
- `modular_psychonaut/master_files/code/modules/modular_computers/file_system/programs/sm_monitor.dm`
- `modular_psychonaut/master_files/code/modules/paperwork/paper_premade.dm`: `/obj/item/paper/guides/jobs/engineering/pa`, `/obj/item/paper/guides/jobs/engineering/singularity`
- `modular_psychonaut/master_files/code/modules/power/singularity/field_generator.dm`: `/obj/machinery/field/generator/singularity`
- `modular_psychonaut/master_files/code/modules/power/singularity/singularity.dm`
- `modular_psychonaut/master_files/code/modules/power/tesla/eball_gas.dm`
- `modular_psychonaut/master_files/code/modules/power/tesla/energy_ball.dm`
- `modular_psychonaut/master_files/code/modules/projectiles/gun.dm`: `/obj/item/gun/var/fire_in`
- `modular_psychonaut/master_files/code/modules/projectiles/ammunition/ballistic/rocket.dm`: `/obj/item/ammo_casing/rocket/anomaly_catcher`
- `modular_psychonaut/master_files/code/modules/projectiles/boxes_magazines/internal/grenade.dm`: `/obj/item/ammo_box/magazine/internal/rocketlauncher/anomaly_catcher`, `/obj/item/ammo_box/magazine/internal/rocketlauncher/anomaly_catcher/empty`
- `modular_psychonaut/master_files/code/modules/projectiles/guns/ballistic/launchers.dm`: `/obj/item/gun/ballistic/rocketlauncher/anomaly_catcher`
- `modular_psychonaut/master_files/code/modules/projectiles/projectile/special/rocket.dm`: `/obj/projectile/bullet/anomaly_catcher`
- `modular_psychonaut/master_files/icons/area/areas_station.dmi`: `engine_singularity`, `engine_singularity_room`
- `modular_psychonaut/master_files/icons/obj/device.dmi`: `anomaly_catcher`
- `modular_psychonaut/master_files/icons/obj/machines/field_generator.dmi`
- `modular_psychonaut/master_files/icons/obj/machines/incident_display.dmi`
- `modular_psychonaut/master_files/icons/obj/machines/engine/128x128.dmi`
- `modular_psychonaut/master_files/icons/obj/machines/engine/particle_accelerator.dmi`
- `modular_psychonaut/master_files/icons/obj/machines/engine/singularity.dmi`
- `modular_psychonaut/master_files/icons/obj/storage/case.dmi`: `antisingularity_case`
- `modular_psychonaut/master_files/icons/obj/weapons/guns/ammo.dmi`: `anom-catcher`
- `modular_psychonaut/master_files/icons/obj/weapons/guns/energy.dmi`: `kinesis_gun`, `super_kinesis_gun`
- `modular_psychonaut/master_files/icons/obj/weapons/guns/projectiles.dmi`: `anom-catcher`
- `modular_psychonaut/master_files/icons/obj/weapons/guns/wide_guns.dmi`: `rocketlauncher`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/traits/declarations.dm`: `TRAIT_GRABBED_BY_KINESIS`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

`modular_psychonaut/modules/modular_rooms/code/engine.dm`: `/datum/map_template/modular_room/random_engine`, `/datum/map_template/modular_room/random_engine/meta_supermatter`, `/datum/map_template/modular_room/random_engine/meta_singularity`, `/datum/map_template/modular_room/random_engine/delta_supermatter`, `/datum/map_template/modular_room/random_engine/delta_singularity`
`_maps/ModularRooms/Deltastation/singularity.dmm`
`_maps/ModularRooms/MetaStation/singularity.dmm`
`tgui/packages/tgui/interfaces/SingularityTesla.tsx`
`tgui/packages/tgui/interfaces/ParticleAccelerator.tsx`

### Katkıda Bulunanlar

Rengan
