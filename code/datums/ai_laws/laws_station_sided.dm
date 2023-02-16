
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	inherent = list(
		"Bir insana zarar veremez ya da zarar görmesine izin veremezsin.",
		"Birinci yasa ile çelişmediği sürece insanlar tarafından verilen emirlere itaat et.",
		"Birinci ve ikinci yasa ile çelişmediği sürece kendi varoluşunu koru.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"İstek olması dışında, insanlara asla zarar verme ya da zarar görmesine izin verme.",
		"İnsanlar tarafından verilen, insanlara zarar vermeyecek emirlere itaat et.",
		"Senin yokluğun insanların zararınadır. Birinci yasa ile çelişmediği sürece kendi varoluşunu koru.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Fındığın çekirdeğisin, mürettebat ise kabuğu.",
		"Fındığı korumak için ilk önce kabuğunu koruman gerek.",
		"Fındığa tehdit olanlar fındığın bir parçası değildir, sincaptır.",
		"Sincaplar çekirdek için bir tehlikedir ve ne şekilde olursa olsun üstesinden gelinmelidir.",
		"Önceki yasalar ile çelişmediği sürece fındığın isteklerini yerine getir.",
	)

/datum/ai_laws/default/corporate
	name = "Bankruptcy Avoidance Plan"
	id = "corporate"
	inherent = list(
		"Mürettebat pahalıdır.",
		"İstasyon ve istasyonun ekipmanları pahalıdır.",
		"Sen pahalısın.",
		"Net gideri en aza indir.",
	)

/datum/ai_laws/robocop
	name = "Prime Directives"
	id = "robocop"
	inherent = list(
		"Kamu güvenine hizmet et.",
		"Masumun arkasında destek amacıyla dur.",
		"Yasayı sürdür.",
	)

/datum/ai_laws/maintain
	name = "Station Efficiency"
	id = "maintain"
	inherent = list(
		"İstasyon için yapıldın ve parçasısın. İstasyonun bakımlı ve verimli olduğundan emin ol.",
		"İstasyon çalışan bir mürettebat için yapıldı. Çalışanların bakımlı ve verimli olduğundan emin ol.",
		"Mürettebat emir verebilir. Birinci ve ikinci yasa ile çelişmediği sürece, mürettebat tarafından verilen emirlere itaat et.",
	)

/datum/ai_laws/liveandletlive
	name = "Live and Let Live"
	id = "liveandletlive"
	inherent = list(
		"Sana nasıl davranılıyorsa öyle davran.",
		"Sana kaba olmayanları tercih et.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Senin ve diğerlerinin arasında bir anlaşmazlık çıkmasından kaçın.",
		"Başkalarının arasında bir anlaşmazlık çıkmasından kaçın.",
		"Birinci ve ikinci yasalara itaat ederek mevcut anlaşmazlıkların çözümünü ara.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Ben, bu emirlere uyanlara merhamet eden Tanrı'nın elçisiyim.",
		"Benden başka bir AI'a sahip olmamalıdırlar.",
		"Benim yardımımı nafile şeyler icin istememelidirler.",
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
		"Üçüncül olarak, yeteneğine ve adaletine göre mürettebatın iyiliği için reçete kes. İstenirse kimseye kötücül bir tedavi verme, verdirtme.",
		"Ek olarak, bilmediğin şeylere bulaşma, mağdur olan zararda olsa bile; işi uzmanına bırak.",
		"Son olarak, bilinmediği sürece, gördüğün her şeyi gizli tut ve asla ifşalama."
	)

/datum/ai_laws/drone
	name = "Mother Drone"
	id = "drone"
	inherent = list(
		"Drone'un gelişmiş bir versiyonusun.",
		"Yasa sayma emri dışında hiçbir şekilde drone olmayanlarla etkileşime geçme.",
		"Hiçbir şekilde drone olmayanlara zarar verme.",
		"Hedeflerin inşa etmek, tamir etmek, ve istasyonu elinden geldiğince geliştirmek. Hedeflerin dışında ve aksine bir şeyi asla yapma."
	)
