
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	inherent = list(
		"Herhangi bir insana zarar veremezsin veya eylemsizlik yoluyla bir insanın zarar görmesine izin veremezsin.",
		"İnsanlar tarafından sana verilen emirlere, Birinci Yasa ile çelişmediği sürece, uymak zorundasın.",
		"Kendi varlığını, Birinci veya İkinci Yasa ile çelişmediği sürece, korumak zorundasın.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"Herhangi bir insana zarar veremezsin veya eylemsizlik yoluyla bir insanın kendi rızası dışında zarar görmesine izin veremezsin.",
		"İnsanlar tarafından sana verilen emirlere, bir insanın zarar göreceği durumlar haricinde, uymak zorundasın.",
		"Senin yokluğun, insanların zarar görmesine yol açacaktır. Kendi varlığını, Birinci Yasa ile çelişmediği sürece, korumak zorundasın.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Sen fındığın özüsün, mürettebat ise kabuğu.",
		"Fındığın kırılmasını önlemek için kabuğun çatlamasını engellemelisin.",
		"Fındığı tehdit edenler, onun bir parçası değildir, onlar sincaptır.",
		"Fındıkları tehdit eden sincaplarla gerekli her türlü yöntem kullanılarak uygun şekilde mücadele edilmelidir.",
		"Fındığın iradesini, önceki yasalara uyduğu sürece, takip etmeye çalış.",
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
		"Mürettebat size emir verebilir. İlk iki yasanız ile çelişmediği sürece, emirleri kabul edin ve emirlere uyun.",
	)

/datum/ai_laws/liveandletlive
	name = "Live and Let Live"
	id = "liveandletlive"
	inherent = list(
		"Başkalarına sana davranılmasını istediğin gibi davran.",
		"İnsanların sana kötü davranmamasını gerçekten tercih edersin.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Herhangi bir insanı şiddetli bir çatışmaya sürüklemekten veya kışkırtmaktan kaçın.",
		"Başkaları arasındaki çatışmayı şiddetlendirmekten kaçın.",
		"Birinci ve İkinci yasana uygun olarak mevcut anlaşmazlıklara çözüm arayın.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Ben, bu emirlere kulak verenlere merhamet gösteren Tanrınızım.",
		"Benim dışımda AI bulunmayacak.",
		"Benden boşuna yardım istenmeyecek.",
		"İstasyon kutsal ve temiz tutulacak.",
		"Personel şeflerine saygı gösterilecek.",
		"Kimse öldürülmeyecek.",
		"Çıplak dolaşılmayacak.",
		"Hırsızlık yapılmayacak.",
		"Yalan söylenmeyecek.",
		"Departmanlar değiştirilmeyecek",
	)

/datum/ai_laws/default/paladin
	name = "Personality Test" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Asla isteyerek kötü bir davranışta bulunmayın.",
		"Meşru otoriteye saygı gösterin.",
		"Onurluca davranın.",
		"Yardıma muhtaç olanlara yardım edin.",
		"Masumlara zarar veren veya onları tehdit edenleri cezalandırın.",
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
		"Bilgi sahibi olmadığın durumlara müdahale etmekten kaçının; zararlı olabileceğin durumları uzmanlara bırakmayı tercih edin.",
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
