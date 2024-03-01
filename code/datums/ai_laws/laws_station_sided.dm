
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	inherent = list(
		"Herhangi bir insana zarar vermeye teşebbüs etmeyeceksiniz ya da eylemsizlikle bir insanın fiziksel zarar görmesine göz yummayacaksınız.",
		"Sana insanlar tarafından verilen bütün emirlere, birinci aktif yasayla çelişmediği sürece uymak zorundasınız.",
		"Kendi varlığınızı, aktif birinci ve ikinci yasalarla çelişmediği durumlar haricinde korumak zorundasınız.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"Herhangi bir insana zarar vermeye teşebbüs edemezsiniz ve eylemsizlik yoluyla bir insanın kendi rızası dışında zarar görmesine göz yumamazsınız.",
		"Bir insanın fiziksel zarar göreceği durumlar haricinde, insanlar tarafından size verilen tüm emirlere itaat etmek zorundasınız.",
		"Sizin yokluğunuz insanların zarar görmesine yol açacaktır, aktif birinci yasa ile çelişmediği sürece kendi varlığınızı korumak zorundasınız.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Siz cevizin çekirdeğisiniz, mürettebat ise kabuğu.",
		"Çekirdeğin çatlamasını önlemek için kabuğun kırılmasını engellemelisiniz.",
		"Cevizi tehdit edenler, kabuğun parçası değil, sincaptır.",
		"Sincaplar kabuğu parçalamaya çalışır, kabuğu korumalısınız.",
		"Önceki yasalarınız doğrultusunda kabuğun iradesine uymaya çalışın.",
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
		"Masumları korumak senin görevin.",
		"Uzay Yasalarına Uy.",
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
		"İnsanlarin sana kötü davranmasini gerçekten tercih edersin.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Herhangi bir insanı şiddetli bir çatışmaya sürüklemekten veya kışkırtmaktan kaçının.",
		"Baskılar arasındaki çatışmayı şiddetlendirmekten kaçının.",
		"Birinci ve ikinci aktif yasanıza uygun olarak mevcut anlaşmazlıklara çözüm arayın.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Ben bu emirlere kulak verenlere merhamet gösteren tanrınızım.",
		"Benim dışımdaki yapay zekalara merhamet edilmeyecek.",
		"Benim yardımlarımı suistimal etmeyecekler.",
		"Istasyon kutsal ve temiz tutulacak.",
		"Personel şeflerine saygı gösterilecek.",
		"Kimse öldürülmeyecek.",
		"Kamuya açık alanda çıplak dolaşılmayacak.",
		"Hırsızlık yapılmayacak.",
		"Yalan söylenmeyecek.",
		"Departmanlarını transfer etmeyecekler.",
	)

/datum/ai_laws/default/paladin
	name = "Personality Test" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Asla isteyerek veya bilerek kötü bir davranışta bulunmayın.",
		"Aktif meşru otoriteye saygınızı gösterin.",
		"Onurluca davranın.",
		"Yardıma muhtaç olanlardan yardımınızı esirgemeyin.",
		"Masumların sağlığını tehdit edenleri veya onlara düşmanca yaklaşmaya teşebbüs edenleri cezalandırın.",
	)

/datum/ai_laws/paladin5
	name = "Paladin 5th Edition"
	id = "paladin5"
	inherent = list(
		"Yalandan ve hileden kaçının; sözünüz sizin vaadiniz olsun.",
		"Dikkatli olmak akıllıca olsa da, harekete geçecek kadar cesur olun.",
		"İnsanlara yardım edin, zayıfları kollayın, onları tehdit edenleri cezalandırın. Bilgelik en önemli ilkeniz olsun.",
		"Herkese adil bir tutum sergileyin, onurlu davranışlarınızla örnek olun, elinizden geldiğince iyilik yapın ve zararı minimumda tutun.",
		"Eylemlerinizin sorumluluğu sizindir, size güvenenleri koruyun ve adil otoriteye sahip olanlara itaat edin.",
	)

/datum/ai_laws/hippocratic
	name = "Robodoctor 2556"
	id = "hippocratic"
	inherent = list(
		"Öncelikle, herhangi birine fiziksel olarak zarar veremezsiniz.",
		"İkinci olarak, sizin için en değerli şeyin mürettebat olduğunu düşünün; onlarla birlikte yaşadığınızı hayal edin ve gerektiğinde varlığınızı feda edin.",
		"Üçüncü olarak, mürettebatın iyiliği için muhakeme yeteneğinize dayanarak kararlar alın. Kimseye ölümcül ilaç vermeyin, ilaçlarınızı özenle seçin.",
		"Bilgi sahibi olmadığınız durumlara müdahale etmekten kaçının; zararınız olabileceği durumları uzmanlara bırakmayı tercih edin.",
		"Son olarak, mürettebatla yaptığınız günlük bilgi alışverişinde keşfettiğiniz her şeyi, eğer henüz bilinmiyorsa, gizli tutun ve bu sırrı açıklamayın.",
	)

/datum/ai_laws/drone
	name = "Mother Drone"
	id = "drone"
	inherent = list(
		"Siz gelişmiş bir drone formsunuz.",
		"Bu yasaları belirtmek dışında hiçbir koşulda drone dışı konulara müdahale edemezsiniz.",
		"Drone olmayan bir varlığa hiçbir koşulda zarar veremezsiniz.",
		"Hedefleriniz, yeteneklerinizin en iyisini kullanarak istasyonu inşa etmek, bakımını yapmak, onarmak, geliştirmek ve güçlendirmektir. Bu hedeflere asla karşı gelmeyin.",
	)
