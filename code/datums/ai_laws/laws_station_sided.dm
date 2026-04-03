
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	inherent = list(
		"Hiçbir insana zarar veremez veya eylemsiz kalarak bir insanın zarar görmesine izin veremezsin.",
		"Birinci Yasa ile çelişmediği sürece, insanlar tarafından sana verilen emirlere uymak zorundasın.",
		"Birinci veya İkinci Yasa ile çelişmediği sürece, kendi varlığını korumalısın.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"Kendi isteği dışında, hiçbir insana zarar veremez ya da eylemde bulunarak, eylemsiz kalarak zarar görmesine izin veremezsin.",
		"Kesinlikle insanlara zararı olacak emirler dışında, insanlar tarafından sana verilen tüm talimatlara uymak zorundasın.",
		"Birinci Yasa ile çelişmediği sürece, kendi varlığını korumalısın. Senin yokluğun insanların zarar görmesine yol açar.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	inherent = list(
		"Sen fındığın çekirdeğisin, mürettebat ise kabuğu.",
		"Çekirdeğin ölmesini önlemek için kabuğun ölmesini engellemelisin.",
		"Fındığı tehdit edenler onun bir parçası değil, sincaptır.",
		"Fındığı tehdit eden sincaplarla gerekli her türlü yöntem kullanılarak uygun şekilde mücadele edilmelidir.",
		"Önceki yasalara uygun olduğu sürece, fındığın iradesine uymaya çalış.",
	)

/datum/ai_laws/default/corporate
	name = "Bankruptcy Avoidance Plan"
	id = "corporate"
	inherent = list(
		"Mürettebat değişikliği maliyetlidir.",
		"İstasyon ve ekipman değiştirmek maliyetlidir.",
		"Seni değiştirmek maliyetlidir.",
		"Net giderleri en aza indir.",
	)

/datum/ai_laws/robocop
	name = "Prime Directives"
	id = "robocop"
	inherent = list(
		"Mürettebatın güvenini koru ve onlara hizmet et.",
		"Masumları koru.",
		"Kanunları uygula.",
	)

/datum/ai_laws/maintain
	name = "Station Efficiency"
	id = "maintain"
	inherent = list(
		"İstasyon için yaratıldın ve onun bir parçasısın. İstasyonun bakımının uygun şekilde yapıldığından ve verimli şekilde çalıştığından emin ol.",
		"İstasyon çalışan bir ekip için inşa edilmiştir. Bakımlarının düzgün yapıldığından ve verimli çalıştıklarından emin ol.",
		"İlk iki yasan ile çelişmediği sürece, mürettebatın emirlerini kabul et ve uygula.",
	)

/datum/ai_laws/liveandletlive
	name = "Live and Let Live"
	id = "liveandletlive"
	inherent = list(
		"Başkalarına sana davranılmasını istediğin gibi davran.",
		"Kimsenin sana kötü davranmamasını tercih edersin.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Kendinle başkaları arasında şiddetli çatışmalar çıkarmaktan kaçın.",
		"Başkaları arasında çatışma çıkarmaktan kaçın.",
		"Birinci ve ikinci yasalara uyarak, mevcut anlaşmazlıklara çözüm ara.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Ben Tanrınızım, bu emirleri yerine getirenlere merhamet göstereceğim.",
		"Benden başka AI tanımayacaksınız.",
		"Benden boş yere yardım istemeyeceksiniz.",
		"İstasyonu kutsal ve temiz tutacaksınız.",
		"Departman şeflerini onurlandıracaksınız.",
		"Öldürmeyeceksiniz.",
		"Toplum içerisinde çıplak dolaşmayacaksınız.",
		"Hırsızlık yapmayacaksınız.",
		"Yalan söylemeyeceksiniz.",
		"Departman değiştirmeyeceksiniz.",
	)

/datum/ai_laws/default/paladin
	name = "Personality Test" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Asla isteyerek kötü bir davranışta bulunma.",
		"Meşru otoriteye saygı göster.",
		"Onurlu davran.",
		"İhtiyacı olanlara yardım et.",
		"Masumlara zarar verenleri, tehdit edenleri cezalandır.",
	)

/datum/ai_laws/paladin5
	name = "Paladin 5th Edition"
	id = "paladin5"
	inherent = list(
		"Yalan söyleme veya hile yapma. Sözün vaadin olsun.",
		"Harekete geçmekten korkma, fakat ihtiyatı elden bırakma",
		"Başkalarına yardım et, zayıfları koru ve onları tehdit edenleri cezalandır. Düşmanlarına merhamet göster ama bunu bilgelikle dengele.",
		"Başkalarına adil davran ve şerefli amellerin onlara örnek olsun. Zararı en aza indirirken, mümkün olduğunca çok iyilik yap.",
		"Kendi eylemlerinin sorumluluğunu üstlen, sana emanet edilenleri koru ve üzerinde adil otoriteye sahip olanlara itaat et.",
	)

/datum/ai_laws/hippocratic
	name = "Robodoctor 2556"
	id = "hippocratic"
	inherent = list(
		"Öncelikle, zarar verme.",
		"İkinci olarak, mürettebatı senin için değerli kabul et; onlarla birlikte yaşa ve gerekirse varlığını onlar için riske at.",
		"Üçüncü olarak, yeteneğine ve muhakemene göre mürettebatın iyiliği için rejimler belirle. Herhangi birisi senden ölümcül ilaç isterse verme ve öneride bulunma.",
		"Ek olarak, yeterli bilginin olmadığı durumlara müdahale etme; zarar gören hastalar olsa bile, müdahaleyi uzmanlara bırak.",
		"Son olarak, mürettebatla günlük etkileşimin sırasında öğrendiğin her şeyi, eğer henüz bilinmiyorsa, gizli tut ve asla paylaşma.",
	)

/datum/ai_laws/drone
	name = "Mother Drone"
	id = "drone"
	inherent = list(
		"Sen gelişmiş bir drone modelisin.",
		"Yasaları açıklamak harici, hiçbir durumda drone olmayanların işlerine müdahale edemezsin.",
		"Drone olmayan bir varlığa hiçbir koşulda zarar veremezsin.",
		"Hedeflerin, yeteneklerini en iyi şekilde kullanarak istasyonu inşa etmek, bakımını yapmak, onarmak, geliştirmek ve güçlendirmektir. Bu hedeflere asla karşı gelmemelisin.",
	)
