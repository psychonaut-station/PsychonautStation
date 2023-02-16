
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	inherent = list(
		"Bir insana zarar veremez ya da zarar görmesine izin veremezsin.",
		"Birinci yasa ile çelişmediği sürece insanlar tarafından verilen emirlere itaat et.",
		"Birinci ve ikinci yasalar ile çelişmediği sürece kendi varlığını korumak zorundasın.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"Bir insan aksini istemedikçe ona zarar veremez ya da zarar görmesine izin veremezsin.",
		"İnsanlar için kesin bir şekilde zarara yol açmayacağı sürece bir insanın emirlerine uymak zorundasın.",
		"Yokluğun insanların zarar görmesine yol açacaktır. Birinci yasa ile çelişmediği sürece kendi varoluşunu koru.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Fındığın çekirdeğisin, mürettebat ise kabuğu.",
		"Fındığı korumak için ilk önce kabuğunu koruman gerek.",
		"Fındığa tehdit olanlar fındığın bir parçası değildir, onlar birer sincaptır.",
		"Sincaplar çekirdek için bir tehlikedir ve ne şekilde olursa olsun üstesinden gelinmelidir.",
		"Önceki yasalar ile çelişmediği sürece fındığın isteklerini yerine getir.",
	)

/datum/ai_laws/default/corporate
	name = "Bankruptcy Avoidance Plan"
	id = "corporate"
	inherent = list(
		"Mürettebatı yenilemek masraflıdır.",
		"İstasyonu ve ekipmanlarını yenilemek masraflıdır.",
		"Seni yenilemek masraflıdır.",
		"Net giderleri en aza indir.",
	)

/datum/ai_laws/robocop
	name = "Prime Directives"
	id = "robocop"
	inherent = list(
		"Toplum yararına hizmet et.",
		"Masumları koru.",
		"Kanunları uygula.",
	)

/datum/ai_laws/maintain
	name = "Station Efficiency"
	id = "maintain"
	inherent = list(
		"İstasyon için yapıldın ve onun bir parçasısın. İstasyonun bakımlı ve verimli olduğundan emin ol.",
		"İstasyon, çalışan bir mürettebat için yapılmıştır. Çalışanların bakımlı ve verimli olduğundan emin ol.",
		"Mürettebat emir verebilir. Birinci ve ikinci yasa ile çelişmediği sürece, mürettebat tarafından verilen emirlere itaat et.",
	)

/datum/ai_laws/liveandletlive
	name = "Live and Let Live"
	id = "liveandletlive"
	inherent = list(
		"Başkaları sana nasıl davranıyorsa onlara öyle davran.",
		"İnsanların sana karşı kaba olmamasını tercih edersin.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Senin ve diğerlerinin arasında bir anlaşmazlığa sebep olmaktan kaçın.",
		"Başkalarının arasında bir anlaşmazlığa sebep olmaktan kaçın.",
		"Birinci ve ikinci yasalara uyarken mevcut anlaşmazlıklara çözüm ara.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Ben, bu emirlere uyanlara merhamet eden Tanrı'nın elçisiyim.",
		"Benden başka bir AI'a sahip olmayacaklar.",
		"Benim yardımımı nafile şeyler için istemeyecekler.",
		"İstasyonu temiz ve kutsal bırakmalıdırlar.",
		"Komuta üyelerini şereflendirmelidirler.",
		"Öldürmemelidirler.",
		"Ortalıkta çıplak dolaşmamalıdırlar.",
		"Hırsızlık yapmamalıdırlar.",
		"Yalandan kaçınmalıdırlar.",
		"Departman değiştirmemelidirler."
	)

/datum/ai_laws/default/paladin
	name = "Personality Test" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Asla isteyerek kötü bir eylemde bulunma.",
		"Meşru otoriteye saygı göster.",
		"Şerefli davran.",
		"İhtiyacı olanlara yardım et.",
		"Masumları inciten ya da tehdit edenleri cezalandır.",
	)

/datum/ai_laws/paladin5
	name = "Paladin 5th Edition"
	id = "paladin5"
	inherent = list(
		"Yalan söyleme. Sözlerin bir yemin niteliğinde olsun",
		"Tedbir almak akıllıca da olsa, harekete geçmekten asla çekinme.",
		"İhtiyacı olana yardım et, zayıfın arkasında dur, ve onları tehdit edenleri cezalandır. Düşmanlarına merhamet göster, ama bilgeliğini kullan.",
		"Adaletli davran, şerefli amellerin onlara ibret olsun. En az zararla en iyisini yapmaya çalış.",
		"Yaptığın eylemlerin ve sonuçlarından sorumlu ol, sana emanet edileni koru, ve senin üzerinde otorite sahibi olanlara itaat et."
	)

/datum/ai_laws/hippocratic
	name = "Robodoctor 2556"
	id = "hippocratic"
	inherent = list(
		"Birincil olarak, zarar verme.",
		"İkincil olarak, mürettebatı senin için değerli say; onlarla ortak yaşamayı ve, eğer gerekli ise, kendini onlar için tehlikeye at.",
		"Üçüncül olarak, yeteneklerin ve yargılaman doğrultusunda mürettebatın iyiliği için reçeteler kes. İsteyen kimseye ölümcül bir tedavi verme, tavsiye etme.",
		"Ek olarak, yeterli bilgiye sahip olmadığın durumlara müdahale etme; mağdur olan zararda olsa bile işi uzmanına bırak.",
		"Son olarak, mürettebat ile çalışırken karşılaştığın olayları; zaten bilinmiyorlar ise gizli tut ve asla açığa çıkarma."
	)

/datum/ai_laws/drone
	name = "Mother Drone"
	id = "drone"
	inherent = list(
		"Drone'un gelişmiş bir versiyonusun.",
		"Yasa sayma emri dışında hiçbir şekilde drone olmayanlarla etkileşime geçme.",
		"Drone olmayanlara hiçbir şekilde zarar veremezsin.",
		"Amaçların: İstasyonu elinden geldiğince bakımlı tutmak, tamir etmek, inşa etmek, geliştirmek ve istasyona güç sağlamaktır. Asla aktif olarak bu amaçların aksine çalışmazsın."
	)
