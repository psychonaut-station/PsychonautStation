/datum/unit_test/bodycam_watchers_cleanup/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/source = allocate(/datum)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	camera.on_start_watching(source)
	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert when bodycam watching starts.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher after watch start.")

	camera.on_stop_watching(source)
	TEST_ASSERT(!component.has_live_watchers(), "Component should have no live watchers after the last watcher stops.")
	TEST_ASSERT_EQUAL(LAZYLEN(component.sources_watching), 0, "Watcher list should be empty after removing the last watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Host alert should clear after the last watcher stops.")

/datum/unit_test/bodycam_watchers_alert_cleanup/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/source_one = allocate(/datum)
	var/datum/source_two = allocate(/datum)
	var/datum/stale_source = allocate(/datum)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	camera.on_start_watching(source_one)
	camera.on_start_watching(source_two)
	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while bodycam is being watched.")

	camera.on_stop_watching(source_one)
	TEST_ASSERT(component.has_live_watchers(), "A remaining live watcher should keep the component active.")
	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host alert should remain while at least one watcher is still live.")

	LAZYADD(component.sources_watching, WEAKREF(stale_source))
	qdel(stale_source)

	camera.on_stop_watching(source_two)
	TEST_ASSERT(!component.has_live_watchers(), "Dead weakrefs should not count as active watchers after the last real watcher stops.")
	TEST_ASSERT_EQUAL(LAZYLEN(component.sources_watching), 0, "Dead weakrefs should be pruned from the watcher list.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Host alert should clear when no live watchers remain.")

/datum/unit_test/bodycam_watchers_accessory_component/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	var/obj/item/clothing/under/color/grey/uniform = EASY_ALLOCATE()
	var/obj/item/clothing/accessory/bodycam/accessory = EASY_ALLOCATE()

	TEST_ASSERT(host.equip_to_slot_if_possible(uniform, ITEM_SLOT_ICLOTHING), "Failed to equip a uniform on the test host.")

	host.put_in_hands(accessory)
	TEST_ASSERT(uniform.attach_accessory(accessory, host), "Failed to attach the bodycam accessory to the worn uniform.")

	var/datum/component/pausable_bodycam/component = host.GetComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	TEST_ASSERT_NOTNULL(component, "Attaching an equipped bodycam accessory should add a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Attaching an equipped bodycam accessory should create a wearable bodycam camera.")

/datum/unit_test/bodycam_watchers_console_destroy/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()
	var/datum/tgui/ui = new(viewer, console, "CameraConsole", console.name)
	console.active_camera = camera
	console.open_uis = list(ui)
	camera.on_start_watching(console)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while a security console is watching.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher while the security console exists.")

	qdel(console)

	TEST_ASSERT(!component.has_live_watchers(), "Destroying the active security console should remove the live watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Destroying the active security console should clear the watched alert.")

/datum/unit_test/bodycam_watchers_console_close/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()
	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	viewer.mock_client = new /datum/client_interface()
	var/datum/tgui/ui = new(viewer, console, "CameraConsole", console.name)
	console.concurrent_users += REF(viewer)
	console.active_camera = camera
	console.open_uis = list(ui)
	camera.on_start_watching(console)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while a security console is watching.")

	console.ui_close(viewer)

	TEST_ASSERT(!component.has_live_watchers(), "Closing the security console should remove the live watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Closing the security console should clear the watched alert.")

/datum/unit_test/bodycam_watchers_console_stale_ui/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()
	var/datum/tgui/ui = new(viewer, console, "CameraConsole", console.name)
	console.active_camera = camera
	console.open_uis = list(ui)
	camera.on_start_watching(console)

	TEST_ASSERT(component.has_live_watchers(), "Component should treat a console with an open UI as a live watcher.")
	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while a valid console watcher exists.")

	console.open_uis = null

	TEST_ASSERT(!component.has_live_watchers(), "A console with no open UI should be pruned as a stale watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Pruning a stale console watcher should clear the viewed alert.")

/datum/unit_test/bodycam_watchers_console_ghost/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()
	var/mob/dead/observer/ghost = EASY_ALLOCATE()
	var/datum/tgui/ui = new(ghost, console, "CameraConsole", console.name)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	console.active_camera = camera
	console.open_uis = list(ui)
	camera.on_start_watching(console)

	console.update_active_camera_screen()

	TEST_ASSERT(!component.has_live_watchers(), "Ghost viewers should not keep bodycam watchers active.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Ghost viewers should clear the viewed alert.")

/datum/unit_test/bodycam_watchers_secureye_destroy/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()
	var/datum/tgui/ui = new(viewer, program, program.tgui_id, program.filedesc)
	program.open_uis = list(ui)
	program.camera_ref = WEAKREF(camera)
	camera.on_start_watching(program)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while secureye is watching.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher while secureye exists.")

	qdel(program)

	TEST_ASSERT(!component.has_live_watchers(), "Destroying the active secureye watcher should remove the live watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Destroying the active secureye watcher should clear the watched alert.")

/datum/unit_test/bodycam_watchers_secureye_ghost/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)
	var/mob/dead/observer/ghost = EASY_ALLOCATE()
	var/datum/tgui/ui = new(ghost, program, program.tgui_id, program.filedesc)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	program.camera_ref = WEAKREF(camera)
	program.open_uis = list(ui)
	camera.on_start_watching(program)

	program.update_active_camera_screen()

	TEST_ASSERT(!component.has_live_watchers(), "Ghost viewers should not keep secureye bodycam watchers active.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Ghost viewers should clear the viewed alert.")

/datum/unit_test/bodycam_watchers_secureye_close/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)
	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()
	var/datum/tgui/ui = new(viewer, program, program.tgui_id, program.filedesc)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	program.camera_ref = WEAKREF(camera)
	program.open_uis = list(ui)
	program.concurrent_users += REF(viewer)
	camera.on_start_watching(program)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while secureye has a living viewer.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher while a living viewer is present.")

	program.ui_close(viewer)

	TEST_ASSERT(!component.has_live_watchers(), "Closing secureye should remove the live watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Closing secureye should clear the watched alert.")

/datum/unit_test/bodycam_watchers_secureye_stale_open_uis/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()
	var/datum/tgui/ui = new(viewer, program, program.tgui_id, program.filedesc)
	program.camera_ref = WEAKREF(camera)
	program.open_uis = list(ui)
	camera.on_start_watching(program)

	TEST_ASSERT(component.has_live_watchers(), "Component should treat a secureye with an open UI as a live watcher.")
	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while a valid secureye watcher exists.")

	program.open_uis = null
	program.update_active_camera_screen()

	TEST_ASSERT(!component.has_live_watchers(), "A secureye with no open UI should be pruned as a stale watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Pruning a stale secureye watcher should clear the viewed alert.")

/datum/unit_test/bodycam_watchers_console_multiple_viewers/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()
	var/mob/living/carbon/human/consistent/viewer_one = EASY_ALLOCATE()
	viewer_one.mock_client = new /datum/client_interface()
	var/mob/living/carbon/human/consistent/viewer_two = EASY_ALLOCATE()
	viewer_two.mock_client = new /datum/client_interface()
	var/datum/tgui/ui_one = new(viewer_one, console, "CameraConsole", console.name)
	var/datum/tgui/ui_two = new(viewer_two, console, "CameraConsole", console.name)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	console.concurrent_users += REF(viewer_one)
	console.concurrent_users += REF(viewer_two)
	console.active_camera = camera
	console.open_uis = list(ui_one, ui_two)
	camera.on_start_watching(console)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert with two console viewers.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report live watchers with two console viewers.")

	console.open_uis -= ui_one
	console.ui_close(viewer_one)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should persist while viewer_two is still watching the console.")
	TEST_ASSERT(component.has_live_watchers(), "Component should still have a live watcher after one of two console viewers closes.")

	console.open_uis -= ui_two
	console.ui_close(viewer_two)

	TEST_ASSERT(!component.has_live_watchers(), "Component should have no live watchers after both console viewers close.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should clear after the last console viewer closes.")

/datum/unit_test/bodycam_watchers_secureye_multiple_viewers/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)
	var/mob/living/carbon/human/consistent/viewer_one = EASY_ALLOCATE()
	viewer_one.mock_client = new /datum/client_interface()
	var/mob/living/carbon/human/consistent/viewer_two = EASY_ALLOCATE()
	viewer_two.mock_client = new /datum/client_interface()
	var/datum/tgui/ui_one = new(viewer_one, program, program.tgui_id, program.filedesc)
	var/datum/tgui/ui_two = new(viewer_two, program, program.tgui_id, program.filedesc)

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	program.concurrent_users += REF(viewer_one)
	program.concurrent_users += REF(viewer_two)
	program.camera_ref = WEAKREF(camera)
	program.open_uis = list(ui_one, ui_two)
	camera.on_start_watching(program)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert with two secureye viewers.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report live watchers with two secureye viewers.")

	program.open_uis -= ui_one
	program.ui_close(viewer_one)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should persist while viewer_two is still watching via secureye.")
	TEST_ASSERT(component.has_live_watchers(), "Component should still have a live watcher after one of two secureye viewers closes.")

	program.open_uis -= ui_two
	program.ui_close(viewer_two)

	TEST_ASSERT(!component.has_live_watchers(), "Component should have no live watchers after both secureye viewers close.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should clear after the last secureye viewer closes.")

/datum/unit_test/bodycam_watchers_console_ghost_and_living/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()
	var/mob/living/carbon/human/consistent/living_viewer = EASY_ALLOCATE()
	living_viewer.mock_client = new /datum/client_interface()
	var/mob/dead/observer/ghost = EASY_ALLOCATE()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	var/datum/tgui/ui_living = new(living_viewer, console, "CameraConsole", console.name)
	var/datum/tgui/ui_ghost = new(ghost, console, "CameraConsole", console.name)
	console.concurrent_users += REF(living_viewer)
	console.active_camera = camera
	console.open_uis = list(ui_living, ui_ghost)
	camera.on_start_watching(console)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should be active with a living viewer and a ghost on the console.")

	console.open_uis -= ui_ghost
	console.ui_close(ghost)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should persist after ghost closes while a living viewer remains.")
	TEST_ASSERT(component.has_live_watchers(), "Component should still have a live watcher after the ghost closes.")

	console.open_uis -= ui_living
	console.ui_close(living_viewer)

	TEST_ASSERT(!component.has_live_watchers(), "Component should have no live watchers after the living viewer also closes.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should clear after the last living viewer closes.")

/datum/unit_test/bodycam_watchers_secureye_ghost_and_living/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)
	var/mob/living/carbon/human/consistent/living_viewer = EASY_ALLOCATE()
	living_viewer.mock_client = new /datum/client_interface()
	var/mob/dead/observer/ghost = EASY_ALLOCATE()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	var/datum/tgui/ui_living = new(living_viewer, program, program.tgui_id, program.filedesc)
	var/datum/tgui/ui_ghost = new(ghost, program, program.tgui_id, program.filedesc)
	program.concurrent_users += REF(living_viewer)
	program.camera_ref = WEAKREF(camera)
	// open_uis must be set before on_start_watching so has_living_viewers() can find the living viewer
	program.open_uis = list(ui_living, ui_ghost)
	camera.on_start_watching(program)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should be active with a living viewer and a ghost on secureye.")

	// Ghost closes — living viewer remains, alert must stay
	program.open_uis -= ui_ghost
	program.ui_close(ghost)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should persist after ghost closes while a living viewer remains on secureye.")
	TEST_ASSERT(component.has_live_watchers(), "Component should still have a live watcher after the ghost closes on secureye.")

	// Living viewer closes — alert must clear
	program.open_uis -= ui_living
	program.ui_close(living_viewer)

	TEST_ASSERT(!component.has_live_watchers(), "Component should have no live watchers after the living viewer also closes on secureye.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Alert should clear after the last living viewer closes on secureye.")

/datum/unit_test/bodycam_watchers_console_camera_disabled/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/obj/machinery/computer/security/console = EASY_ALLOCATE()
	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")

	var/datum/tgui/ui = new(viewer, console, "CameraConsole", console.name)
	console.concurrent_users += REF(viewer)
	console.active_camera = camera
	console.open_uis = list(ui)
	camera.on_start_watching(console)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should have the viewed alert while a console is watching.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher while the console is watching.")

	// Simulate bodycam being disabled (e.g. EMP, cover removed)
	console.on_camera_disabled(camera)

	TEST_ASSERT(!component.has_live_watchers(), "Disabling the bodycam should remove the live watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Disabling the bodycam should clear the watched alert.")

/datum/unit_test/bodycam_watchers_secureye_camera_disabled/Run()
	var/mob/living/carbon/human/consistent/host = EASY_ALLOCATE()
	host.mock_client = new /datum/client_interface()
	var/datum/component/pausable_bodycam/component = host.AddComponent(/datum/component/pausable_bodycam)
	var/obj/machinery/camera/bodycam/camera = locate(/obj/machinery/camera/bodycam) in host.contents
	var/datum/computer_file/program/secureye/program = allocate(/datum/computer_file/program/secureye)
	var/mob/living/carbon/human/consistent/viewer = EASY_ALLOCATE()
	viewer.mock_client = new /datum/client_interface()

	TEST_ASSERT_NOTNULL(component, "Expected the host to receive a pausable bodycam component.")
	TEST_ASSERT_NOTNULL(camera, "Expected the host to receive a bodycam camera.")
	TEST_ASSERT_NOTNULL(program, "Expected to allocate a secureye program watcher.")

	var/map_name = "camera_console_[REF(program)]_map"
	program.cam_screen = new
	program.cam_screen.generate_view(map_name)

	var/datum/tgui/ui = new(viewer, program, program.tgui_id, program.filedesc)
	program.concurrent_users += REF(viewer)
	program.camera_ref = WEAKREF(camera)
	program.open_uis = list(ui)
	camera.on_start_watching(program)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should have the viewed alert while secureye is watching.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher while secureye is watching.")

	program.on_camera_disabled(camera)

	TEST_ASSERT(!component.has_live_watchers(), "Disabling the bodycam should remove the live watcher from secureye.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Disabling the bodycam should clear the watched alert on secureye.")

