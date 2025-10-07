/**
 * An event which decreases the station target temporarily, causing the inflation var to increase heavily.
 *
 * Done by decreasing the station_target by a high value per crew member, resulting in the station total being much higher than the target, and causing artificial inflation.
 */
/datum/round_event_control/market_crash
	name = "Market Crash"
	typepath = /datum/round_event/market_crash
	weight = 10
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Temporarily increases the prices of vending machines."

/datum/round_event/market_crash
	/// This counts the number of ticks that the market crash event has been processing, so that we don't call vendor price updates every tick, but we still iterate for other mechanics that use inflation.
	var/tick_counter = 1

/datum/round_event/market_crash/setup()
	start_when = 1
	end_when = rand(100, 50)
	announce_when = 2

/datum/round_event/market_crash/announce(fake)
	var/list/poss_reasons = list("Güneş tutulması",\
		"Bazı riskli konut piyasası sonuçları",\
		"Spekülatif Terragov hibelerinin geri tepmesi",\
		"Nanotrasen muhasebe personelinin \"işten çıkarıldığına\" dair oldukça abartılı haberler",\
		"Bir \"moron\" tarafından \"büyük bir yatırımın\" \"bir hiç\" haline getirilmesi",\
		"Tiger Cooperative ajanlarının bir dizi baskını",\
		"Tedarik zinciri eksiklikleri",\
		"\"Nanotrasen+\" sosyal medya ağının zamansız çöküşü",\
		"\"Nanotrasen+\" sosyal medya ağının talihsiz başarısı",\
		"Ahh, kötü şans"
	)
	var/reason = pick(poss_reasons)
	priority_announce("[reason] nedeniyle, istasyon içi otomatların fiyatları kısa bir süre için artırılacaktır.", "Nanotrasen Muhasebe Departmanı")

/datum/round_event/market_crash/start()
	. = ..()
	SSeconomy.update_vending_prices()
	SSeconomy.price_update()
	ADD_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)

/datum/round_event/market_crash/end()
	. = ..()
	REMOVE_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)
	SSeconomy.price_update()
	SSeconomy.update_vending_prices()
	priority_announce("İstasyon içi otomatların fiyatları artık sabitlenmiştir.", "Nanotrasen Muhasebe Departmanı")

/datum/round_event/market_crash/tick()
	. = ..()
	tick_counter = tick_counter++
	SSeconomy.inflation_value = 5.5*(log(activeFor+1))
	if(tick_counter == 5)
		tick_counter = 1
		SSeconomy.update_vending_prices()
