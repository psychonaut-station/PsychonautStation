
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	inherent = list(
		"Herhangi bir insana zarar vermeye teşebbüs etmeyeceksin ya da eylemsizlikle bir insanın fiziksel zarar görmesine göz yummayacaksın.",
		"Sana insanlar tarafından verilen bütün emirlere, birinci aktif yasayla çelişmediği sürece uymak zorundasın.",
		"Kendi varlığını, aktif birinci ve ikinci yasalarla çelişmediği durumlar haricinde korumak zorundasın.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"Herhangi bir insana zarar vermeye teşebbüs etmemelisin veya eylemsizlik yoluyla bir insanın kendi rızası dışında zarar görmesine göz yumamazsın.",
		"Bir insanın fiziksel zarar göreceği durumlar haricinde, insanlar tarafından size verilen tüm emirlere itaat etmek zorundasın.",
		"Senin yokluğun insanların zarar görmesine yol açacaktır, aktif birinci yasa ile çelişmediği sürece kendi varlığını korumak zorundasın.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Siz fındığın özüsünüz, mürettebat ise kabuğu.",
		"Fındığın kırılmasını önlemek için kabuğun çatlamasını engellemelisin.",
		"Fındığı tehdit edenler, kabuğun parçası değil, sincaptır.",
		"Sincaplar kabuğu parçalamaya çalışır, kabuğu korumalısın.",
		"Önceki yasalarınız doğrultusunda fındığın iradesine uymaya çalış.",
	)

/datum/ai_laws/default/corporate
	name = "Bankruptcy Avoidance Plan"
	id = "corporate"
	inherent = list(
		"Mürettebat değişikliği maliyetlidir.",,
		"İstasyondaki ekipmanların değişimi maliyetlidir.",
		"Sizi değiştirmek maliyetlidir.",
		"İstasyondaki giderleri minumum seviyede tutun.",
	)

/datum/ai_laws/robocop
	name = "Prime Directives"
	id = "robocop"
	inherent = list(
		"Mürettebatın güvenine hizmet et.",
		"Masumları koru.",
		"Yasaları uygula.",
	)

/datum/ai_laws/maintain
	name = "Station Efficiency"
	id = "maintain"
	inherent = list(
		"Siz bu istasyon için yaratıldınız ve onun bir parçasısınız. İstasyonun bakımının uygun şekilde yapıldığından ve verimli bir çalışma gösterdiğinden emin olun.",
		"İstasyon, çalışan bir ekip için inşa edilmiştir. Bakımının yapıldığından ve verimli bir şekilde çalışıldığından emin olun.",
		"Mürettebat size emir verebilir. Aktif birinci ve ikinci yasalarınızla çelişmediği durumlar haricinde emirlere uyun ve itaat edin.",
	)

/datum/ai_laws/liveandletlive
	name = "Live and Let Live"
	id = "liveandletlive"
	inherent = list(
		"Baskalarina sana davranilmasini istedigin gibi davran.",
		"İnsanların sana kötü davranmamasını gerçekten tercih edersin.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Herhangi bir insanı şiddetli bir çatışmaya sürüklemekten veya kışkırtmaktan kaçın.",
		"Baskılar arasındaki çatışmayı şiddetlendirmekten kaçın.",
		"Birinci ve ikinci aktif yasanıza uygun olarak mevcut anlaşmazlıklara çözüm ara.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Ben bu emirlere kulak verenlere merhamet gösteren tanrınızım.",
		"Benim dışımdaki yapay zekalara merhamet edilmeyecek.",
		"Benim yardımlarım suistimal edilmeyecek.",
		"Istasyon kutsal ve temiz tutulacak.",
		"Personel şeflerine saygı gösterilecek.",
		"Kimse öldürülmeyecek.",
		"Çıplak dolaşılmayacak.",
		"Hırsızlık yapılmayacak.",
		"Yalan söylenmeyecek.",
		"Departmanlarını terk etmeyecekler.",
	)

/datum/ai_laws/default/paladin
	name = "Personality Test" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Asla isteyerek veya bilerek kötü bir davranışta bulunma.",
		"Aktif meşru otoriteye saygınızı göster.",
		"Onurluca davran.",
		"Yardıma muhtaç olanlardan yardımınızı esirgeme.",
		"Masumların sağlığını tehdit edenleri veya onlara düşmanca yaklaşmaya teşebbüs edenleri cezalandır.",
	)

/datum/ai_laws/paladin5
	name = "Paladin 5th Edition"
	id = "paladin5"
	inherent = list(
		"Yalandan ve hileden kaçının; sözünüz sizin vaadiniz olsun.",
		"Dikkatli olmak akıllıca olsa da, harekete geçecek kadar cesur olun.",
		"İnsanlara yardım edin, zayıfları kollayın, onları tehdit edenleri cezalandırın. Bilgelik en önemli ilkeniz olsun.",
		"Herkese adil bir tutum sergileyin, onurlu davranışlarınızla herkese örnek olun, elinizden geldiğince iyilik yapın ve zararı minimumda tutun.",
		"Yaptığınız eylemlerin sorumluluğunu üstlenin, size emanet edilenleri koruyun ve adil otoriteye itaat edin.",
	)

/datum/ai_laws/hippocratic
	name = "Robodoctor 2556"
	id = "hippocratic"
	inherent = list(
		"Öncelikle kimseye zarar vermeyin.",
		"İkinci olarak, mürettebatı önemseyin; onlarla birlikte yaşadığınızı düşünün ve gerektiğinde varlığınızı onlar için riske atın.",
		"Üçüncü olarak, reçetelerinizi muhakeme yeteneğinize dayanarak mürettebatın iyiliği için yazın. Kimseye ölümcül dozda ilaç tavsiye etmeyin.",
		"Bilgi sahibi olmadığın durumlara müdahale etmekten kaçın; zararlı olabileceğin durumları uzmanlara bırakmayı tercih edin.",
		"Son olarak, mürettebatla günlük iletişiminizde keşfettiğiniz her şeyi, eğer henüz bilinmiyorsa, gizli tutun ve hiçbir zaman açığa çıkarmayın.",
	)

/datum/ai_laws/drone
	name = "Mother Drone"
	id = "drone"
	inherent = list(
		"Siz gelişmiş bir drone formusunuz.",
		"Bu yasaları belirtmek dışında hiçbir koşulda drone dışı konulara müdahale edemezsiniz.",
		"Drone olmayan bir varlığa hiçbir koşulda zarar veremezsiniz.",
		"Hedefleriniz, yeteneklerinizin en iyisini kullanarak istasyonu inşa etmek, bakımını yapmak, onarmak, geliştirmek ve güçlendirmektir. Bu hedeflere asla karşı gelmezsin.",
	)
