/obj/machinery/vending/gunnervend
	name = "GunnerVend"
	desc = "A vending machine for guns."
	product_categories = list(
		list(
			"name" = "Automatic",
			"icon" = "gun",
			"products" = list(
				/obj/item/gun/ballistic/automatic/gyropistol/weak = 10,
				/obj/item/gun/ballistic/automatic/mini_uzi = 15,
				/obj/item/gun/ballistic/automatic/c20r/unrestricted = 15,
				/obj/item/gun/ballistic/automatic/m90/unrestricted = 15,
				/obj/item/gun/ballistic/automatic/battle_rifle = 15,
				/obj/item/gun/ballistic/automatic/ar = 15,
				/obj/item/gun/ballistic/automatic/l6_saw/unrestricted = 15,
				/obj/item/gun/ballistic/automatic/smartgun = 15,
				/obj/item/gun/ballistic/automatic/proto/unrestricted = 15,
				/obj/item/gun/ballistic/automatic/napad = 15,
				/obj/item/gun/ballistic/automatic/wt550 = 15,
			),
		),
		list(
			"name" = "Pistol",
			"icon" = "gun",
			"products" = list(
				/obj/item/gun/ballistic/automatic/pistol = 15,
				/obj/item/gun/ballistic/automatic/pistol/aps = 15,
				/obj/item/gun/ballistic/automatic/pistol/clandestine = 15,
				/obj/item/gun/ballistic/automatic/pistol/deagle = 15,
				/obj/item/gun/ballistic/automatic/pistol/m1911 = 15,
				/obj/item/gun/ballistic/automatic/pistol/riot = 15,
				/obj/item/gun/ballistic/revolver = 15,
				/obj/item/gun/ballistic/revolver/c38 = 15,
				/obj/item/gun/ballistic/revolver/cowboy = 15,
				/obj/item/gun/ballistic/revolver/mateba = 15,
				/obj/item/gun/ballistic/revolver/nagant = 15,
				/obj/item/gun/energy/laser/pistol = 15,
			),
		),
		list(
			"name" = "Rifle",
			"icon" = "gun",
			"products" = list(
				/obj/item/gun/ballistic/rifle = 15,
				/obj/item/gun/ballistic/rifle/boltaction/prime = 15,
				/obj/item/gun/ballistic/rifle/lionhunter = 15,
				/obj/item/gun/ballistic/rifle/rebarxbow = 15,
				/obj/item/gun/ballistic/rifle/sks/chekhov = 15,
				/obj/item/gun/ballistic/rifle/sniper_rifle/marine = 15,
			),
		),
		list(
			"name" = "Shotgun",
			"icon" = "gun",
			"products" = list(
				/obj/item/gun/ballistic/shotgun/lethal = 15,
				/obj/item/gun/ballistic/shotgun/bulldog/unrestricted = 15,
				/obj/item/gun/ballistic/shotgun/automatic/combat/deadly = 15,
				/obj/item/gun/ballistic/shotgun/automatic/dual_tube/deadly = 15,

			),
		),
		list(
			"name" = "Energy Guns",
			"icon" = "gun",
			"products" = list(
				/obj/item/gun/energy/e_gun/lethal = 15,
				/obj/item/gun/energy/laser = 15,
				/obj/item/gun/energy/laser/assault = 15,
				/obj/item/gun/energy/laser/carbine = 15,
				/obj/item/gun/energy/laser/cybersun/unrestricted = 15,
				/obj/item/gun/energy/laser/scatter = 15,
			),
		),
		list(
			"name" = "Ammos",
			"icon" = "gun",
			"products" = list(
				/obj/item/ammo_box/magazine/uzim9mm = 30,
				/obj/item/ammo_box/magazine/smgm45 = 30,
				/obj/item/ammo_box/magazine/m223 = 60,
				/obj/item/ammo_box/magazine/m38 = 30,
				/obj/item/ammo_box/magazine/m7mm = 30,
				/obj/item/ammo_box/magazine/smartgun = 30,
				/obj/item/ammo_box/magazine/smgm9mm = 30,
				/obj/item/ammo_box/magazine/napad = 30,
				/obj/item/ammo_box/magazine/wt550m9 = 30,
				/obj/item/ammo_box/magazine/m9mm = 60,
				/obj/item/ammo_box/magazine/m9mm_aps = 30,
				/obj/item/ammo_box/magazine/m10mm = 30,
				/obj/item/ammo_box/magazine/m50 = 30,
				/obj/item/ammo_box/magazine/m45 = 30,
				/obj/item/ammo_box/magazine/sniper_rounds/marine = 30,
				/obj/item/ammo_box/magazine/m75/weak = 50,
				/obj/item/ammo_box/magazine/m12g = 50,
				/obj/item/ammo_box/n762 = 50,
				/obj/item/ammo_box/speedloader/c357 = 150,
				/obj/item/ammo_box/speedloader/c38 = 50,
				/obj/item/ammo_box/speedloader/strilka310 = 100,
				/obj/item/ammo_box/speedloader/strilka310/phasic = 50,
				/obj/item/ammo_box/speedloader/strilka310/lionhunter = 50,
				/obj/item/ammo_casing/rebar = 100,
				/obj/item/storage/box/slugs = 150,
			)
		),
		list(
			"name" = "Armors",
			"icon" = "shield-halved",
			"products" = list(
				/obj/item/clothing/suit/armor/elder_atmosian = 30,
				/obj/item/clothing/suit/armor/bulletproof = 30,
				/obj/item/clothing/suit/armor/vest = 30,
				/obj/item/clothing/suit/armor/vest/alt = 30,
				/obj/item/clothing/suit/armor/heavy = 30,
				/obj/item/clothing/suit/armor/riot = 30,
				/obj/item/clothing/suit/armor/vest/alt/tactical_armor = 30,
			)
		),
		list(
			"name" = "Other",
			"icon" = "feather-pointed",
			"products" = list(
				/obj/item/storage/belt/holster/flarepouch = 100,
				/obj/item/flashlight/flare = 100,
			)
		)
	)

	default_price = PAYCHECK_COMMAND * 100 //Default of
	extra_price = PAYCHECK_COMMAND * 200
	payment_department = NO_FREEBIES


