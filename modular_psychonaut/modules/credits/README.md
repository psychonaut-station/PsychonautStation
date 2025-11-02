## Round End Credits

MODULE ID: CREDITS

### Açıklama

Oyun sonu tur ile ilgili bilgiler gösterecek credits ekranı.

### TG Değişiklikleri

- `code/__HELPERS/roundend.dm`: `POPCOUNT_ESCAPEES_HUMANONLY`, `POPCOUNT_ESCAPEES_HUMANONLY_LIST`, `/datum/controller/subsystem/ticker/proc/gather_roundend_feedback()`, `/datum/controller/subsystem/ticker/proc/declare_completion()`
- `code/_onclick/hud/credits.dm`: `CREDIT_ROLL_SPEED`, `CREDIT_SPAWN_SPEED`, `CREDIT_ANIMATE_HEIGHT`, `CREDIT_EASE_DURATION`, `/client/proc/RollCredits()`, `/atom/movable/screen/credit`, `/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner, credited, client/P)`, `/atom/movable/screen/credit/Destroy()`
- `code/modules/loadout/loadout_preference.dm`: `/datum/preference/loadout/deserialize()`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/subsystem/ticker.dm`: `/datum/controller/subsystem/ticker/var/popcount`
- `modular_psychonaut/master_files/code/modules/antagonists/_common/antag_datum.dm`: `/datum/antagonist/var/credits_icon`, `/datum/antagonist/on_gain()`
- `modular_psychonaut/master_files/code/modules/antagonists/abductor/abductor.dm`: `/datum/antagonist/abductor/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/blob/blob_antag.dm`: `/datum/antagonist/blob/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/blob/blob_minion.dm`: `/datum/antagonist/blob_minion/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/blob/overmind.dm`: `/mob/eye/blob/get_mob_appearance()`
- `modular_psychonaut/master_files/code/modules/antagonists/changeling/changeling.dm`: `/datum/antagonist/changeling/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/cult/datums/cultist.dm`: `/datum/antagonist/cult/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/nukeop/datums/operative.dm`: `/datum/antagonist/nukeop/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/revolution/revolution.dm`: `/datum/antagonist/rev/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/traitor/datum_traitor.dm`: `/datum/antagonist/traitor/var/credits_icon`
- `modular_psychonaut/master_files/code/modules/antagonists/wizard/wizard.dm`: `/datum/antagonist/wizard/var/credits_icon`, `/datum/antagonist/wizard/rename_wizard()`
- `modular_psychonaut/master_files/code/modules/mob/living/carbon/inventory.dm`: `/mob/living/carbon/human/proc/is_wearing_item_of_type()`
- `modular_psychonaut/master_files/code/modules/mob/mob.dm`: `/mob/proc/get_mob_appearance()`
- `modular_psychonaut/master_files/code/modules/mob/living/brain/brain.dm`: `/mob/living/brain/get_mob_appearance()`
- `modular_psychonaut/master_files/code/modules/mob/living/silicon/ai/freelook/eye.dm`: `/mob/eye/camera/ai/get_mob_appearance()`
- `modular_psychonaut/modules/admin/code/verbs/admin.dm`: `set_credits_title`

### Definelar ve Helperlar

- `code/__HELPERS/~psychonaut_helpers/icons.dm`: `/proc/render_offline_appearance()`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- `modular_psychonaut/master_files/code/controllers/subsystem/credits.dm`
- `modular_psychonaut/master_files/code/modules/client/preferences/show_roundend_credits.dm`
- `modular_psychonaut/master_files/icons/effects/title_cards.dmi`
- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/show_roundend_credits.tsx`

### Katkıda Bulunanlar

Rengan
