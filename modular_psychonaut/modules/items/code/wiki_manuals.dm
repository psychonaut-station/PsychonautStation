/**
 * Title:
 * 	Space Law Manual
 * Description:
 * 	Replaces the default Space Law manual with a TGUI interface.
 * Related files:
 * 	`tgui/packages/tgui/interfaces/SpaceLaw/index.tsx`
 * 	`tgui/packages/tgui/interfaces/SpaceLaw/laws.ts`
 * Credits:
 * 	genkuqq
 * 	Seefaaa
 */
/obj/item/book/manual/wiki/security_space_law/display_content(mob/living/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceLaw")
		ui.open()
