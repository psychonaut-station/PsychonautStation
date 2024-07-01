## Worker

MODULE ID: WORKER

### Açıklama

Daha az sorumlulukları olan Station Engineer alternatifi.

### TG Değişiklikleri

- `code/__DEFINES/jobs.dm`: `JOB_GROUP_ENGINEERS`, `JOB_DISPLAY_ORDER_WORKER`
- `code/game/gamemodes/objective_items.dm`: `/datum/objective_item/steal/traitor/fireaxe/var/excludefromjob`, `/datum/objective_item/steal/blackbox/var/excludefromjob`, [`/datum/objective_item/steal/traitor/insuls`: `var/excludefromjob`, `var/item_owner`]
- `code/game/machinery/computer/crew.dm`: `/datum/crewmonitor/var/jobs`
- `code/modules/mob/living/basic/bots/cleanbot/cleanbot.dm`: `/mob/living/basic/bot/cleanbot/var/job_titles`
- `tgui/packages/tgui/interfaces/common/JobToIcon.ts`: `Worker`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/datums/id_trim/jobs.dm`: `/datum/id_trim/job/worker`
- `modular_psychonaut/master_files/icons/mob/huds/hud.dmi`: `hudworker`
- `modular_psychonaut/master_files/icons/obj/card.dmi`: `trim_worker`, `cardboard_worker`
- `modular_psychonaut/modules/spawn_point/code/spawn_point.dm`: `/datum/job/worker/var/roundstart_spawn_point`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/atom_hud.dm`: `SECHUD_WORKER`
- `code/__DEFINES/~psychonaut_defines/jobs.dm`: `JOB_WORKER`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

vicirdek, Seefaaa <!-- 😃 -->
