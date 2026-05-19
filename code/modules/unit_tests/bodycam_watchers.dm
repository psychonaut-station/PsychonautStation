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

	console.active_camera = camera
	console.open_uis = list(allocate(/datum))
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

	console.concurrent_users += REF(viewer)
	console.active_camera = camera
	console.open_uis = list(allocate(/datum))
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

	console.active_camera = camera
	console.open_uis = list(allocate(/datum))
	camera.on_start_watching(console)

	TEST_ASSERT(component.has_live_watchers(), "Component should treat a console with an open UI as a live watcher.")
	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while a valid console watcher exists.")

	console.open_uis = null

	TEST_ASSERT(!component.has_live_watchers(), "A console with no open UI should be pruned as a stale watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Pruning a stale console watcher should clear the viewed alert.")

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

	program.camera_ref = WEAKREF(camera)
	camera.on_start_watching(program)

	TEST_ASSERT(host.has_alert(ALERT_BODYCAM_VIEWED), "Host should gain the viewed alert while secureye is watching.")
	TEST_ASSERT(component.has_live_watchers(), "Component should report a live watcher while secureye exists.")

	qdel(program)

	TEST_ASSERT(!component.has_live_watchers(), "Destroying the active secureye watcher should remove the live watcher.")
	TEST_ASSERT(!host.has_alert(ALERT_BODYCAM_VIEWED), "Destroying the active secureye watcher should clear the watched alert.")
