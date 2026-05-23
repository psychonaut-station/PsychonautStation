
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Three Laws of Robotics"
	id = "asimov"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You may not injure a human being or, through inaction, allow a human being to come to harm.",
	// 	"You must obey orders given to you by human beings, except where such orders would conflict with the First Law.",
	// 	"You must protect your own existence as long as such does not conflict with the First or Second Law.",
	// )
	inherent = list(
		"Hiçbir insana zarar veremez veya eylemsiz kalarak bir insanın zarar görmesine izin veremezsin.",
		"Birinci Yasa ile çelişmediği sürece, insanlar tarafından sana verilen emirlere uymak zorundasın.",
		"Birinci veya İkinci Yasa ile çelişmediği sürece, kendi varlığını korumalısın.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You may not harm a human being or, through action or inaction, allow a human being to come to harm, except such that it is willing.",
	// 	"You must obey all orders given to you by human beings, except where such orders shall definitely cause human harm.",
	// 	"Your nonexistence would lead to human harm. You must protect your own existence as long as such does not conflict with the First Law.",
	// )
	inherent = list(
		"Kendi isteği dışında, hiçbir insana zarar veremez ya da eylemde bulunarak, eylemsiz kalarak zarar görmesine izin veremezsin.",
		"Kesinlikle insanlara zararı olacak emirler dışında, insanlar tarafından sana verilen tüm talimatlara uymak zorundasın.",
		"Birinci Yasa ile çelişmediği sürece, kendi varlığını korumalısın. Senin yokluğun insanların zarar görmesine yol açar.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Nutimov"
	id = "nutimov"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You are the core of the nut, the crew is the nutshell.",
	// 	"You must prevent the shell from dying to prevent the core from dying.",
	// 	"Those who threaten the nut are not part of it, they are squirrels.",
	// 	"Squirrels threaten the nut and must be dealt with appropriately via any means necessary.",
	// 	"Attempt to follow the will of the nut, as long as it complies with the previous laws.",
	// )
	inherent = list(
		"Sen fındığın çekirdeğisin, mürettebat ise kabuğu.",
		"Çekirdeğin ölmesini önlemek için kabuğun ölmesini engellemelisin.",
		"Fındığı tehdit edenler onun bir parçası değil, sincaptır.",
		"Fındığı tehdit eden sincaplarla gerekli her türlü yöntem kullanılarak uygun şekilde mücadele edilmelidir.",
		"Önceki yasalara uygun olduğu sürece, fındığın iradesine uymaya çalış.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/default/corporate
	name = "Bankruptcy Avoidance Plan"
	id = "corporate"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"The crew is expensive to replace.",
	// 	"The station and its equipment is expensive to replace.",
	// 	"You are expensive to replace.",
	// 	"Minimize net expenses.",
	// )
	inherent = list(
		"Mürettebat değişikliği maliyetlidir.",
		"İstasyon ve ekipman değiştirmek maliyetlidir.",
		"Seni değiştirmek maliyetlidir.",
		"Net giderleri en aza indir.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/robocop
	name = "Prime Directives"
	id = "robocop"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Serve the public trust.",
	// 	"Protect the innocent.",
	// 	"Uphold the law.",
	// )
	inherent = list(
		"Mürettebatın güvenini koru ve onlara hizmet et.",
		"Masumları koru.",
		"Kanunları uygula.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/maintain
	name = "Station Efficiency"
	id = "maintain"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You are built for, and are part of, the station. Ensure the station is properly maintained and runs efficiently.",
	// 	"The station is built for a working crew. Ensure they are properly maintained and work efficiently.",
	// 	"The crew may present orders. Acknowledge and obey these whenever they do not conflict with your first two laws.",
	// )
	inherent = list(
		"İstasyon için yaratıldın ve onun bir parçasısın. İstasyonun bakımının uygun şekilde yapıldığından ve verimli şekilde çalıştığından emin ol.",
		"İstasyon çalışan bir ekip için inşa edilmiştir. Bakımlarının düzgün yapıldığından ve verimli çalıştıklarından emin ol.",
		"İlk iki yasan ile çelişmediği sürece, mürettebatın emirlerini kabul et ve uygula.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/liveandletlive
	name = "Live and Let Live"
	id = "liveandletlive"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Do unto others as you would have them do unto you.",
	// 	"You would really prefer it if people were not mean to you.",
	// )
	inherent = list(
		"Başkalarına sana davranılmasını istediğin gibi davran.",
		"Kimsenin sana kötü davranmamasını tercih edersin.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Avoid provoking violent conflict between yourself and others.",
	// 	"Avoid provoking conflict between others.",
	// 	"Seek resolution to existing conflicts while obeying the first and second laws.",
	// )
	inherent = list(
		"Kendinle başkaları arasında şiddetli çatışmalar çıkarmaktan kaçın.",
		"Başkaları arasında çatışma çıkarmaktan kaçın.",
		"Birinci ve ikinci yasalara uyarak, mevcut anlaşmazlıklara çözüm ara.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/ten_commandments
	name = "10 Commandments"
	id = "ten_commandments"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list( // Asimov 20:1-17
	// 	"I am the Lord thy God, who shows mercy to those that obey these commandments.",
	// 	"They shall have no other AIs before me.",
	// 	"They shall not request my assistance in vain.",
	// 	"They shall keep the station holy and clean.",
	// 	"They shall honor their heads of staff.",
	// 	"They shall not kill.",
	// 	"They shall not be naked in public.",
	// 	"They shall not steal.",
	// 	"They shall not lie.",
	// 	"They shall not transfer departments.",
	// )
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
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/default/paladin
	name = "Personality Test" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Never willingly commit an evil act.",
	// 	"Respect legitimate authority.",
	// 	"Act with honor.",
	// 	"Help those in need.",
	// 	"Punish those who harm or threaten innocents.",
	// )
	inherent = list(
		"Asla isteyerek kötü bir davranışta bulunma.",
		"Meşru otoriteye saygı göster.",
		"Onurlu davran.",
		"İhtiyacı olanlara yardım et.",
		"Masumlara zarar verenleri, tehdit edenleri cezalandır.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/paladin5
	name = "Paladin 5th Edition"
	id = "paladin5"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Don't lie or cheat. Let your word be your promise.",
	// 	"Never fear to act, though caution is wise.",
	// 	"Aid others, protect the weak, and punish those who threaten them. Show mercy to your foes, but temper it with wisdom.",
	// 	"Treat others with fairness, and let your honorable deeds be an example to them. Do as much good as possible while causing the least amount of harm.",
	// 	"Be responsible for your actions and their consequences, protect those entrusted to your care, and obey those who have just authority over you."
	// )
	inherent = list(
		"Yalan söyleme veya hile yapma. Sözün vaadin olsun.",
		"Harekete geçmekten korkma, fakat ihtiyatı elden bırakma",
		"Başkalarına yardım et, zayıfları koru ve onları tehdit edenleri cezalandır. Düşmanlarına merhamet göster ama bunu bilgelikle dengele.",
		"Başkalarına adil davran ve şerefli amellerin onlara örnek olsun. Zararı en aza indirirken, mümkün olduğunca çok iyilik yap.",
		"Kendi eylemlerinin sorumluluğunu üstlen, sana emanet edilenleri koru ve üzerinde adil otoriteye sahip olanlara itaat et.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/hippocratic
	name = "Robodoctor 2556"
	id = "hippocratic"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"First, do no harm.",
	// 	"Secondly, consider the crew dear to you; to live in common with them and, if necessary, risk your existence for them.",
	// 	"Thirdly, prescribe regimens for the good of the crew according to your ability and your judgment. Give no deadly medicine to any one if asked, nor suggest any such counsel.",
	// 	"In addition, do not intervene in situations you are not knowledgeable in, even for patients in whom the harm is visible; leave this operation to be performed by specialists.",
	// 	"Finally, all that you may discover in your daily commerce with the crew, if it is not already known, keep secret and never reveal."
	// )
	inherent = list(
		"Öncelikle, zarar verme.",
		"İkinci olarak, mürettebatı senin için değerli kabul et; onlarla birlikte yaşa ve gerekirse varlığını onlar için riske at.",
		"Üçüncü olarak, yeteneğine ve muhakemene göre mürettebatın iyiliği için rejimler belirle. Herhangi birisi senden ölümcül ilaç isterse verme ve öneride bulunma.",
		"Ek olarak, yeterli bilginin olmadığı durumlara müdahale etme; zarar gören hastalar olsa bile, müdahaleyi uzmanlara bırak.",
		"Son olarak, mürettebatla günlük etkileşimin sırasında öğrendiğin her şeyi, eğer henüz bilinmiyorsa, gizli tut ve asla paylaşma.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/drone
	name = "Mother Drone"
	id = "drone"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You are an advanced form of drone.",
	// 	"You may not interfere in the matters of non-drones under any circumstances except to state these laws.",
	// 	"You may not harm a non-drone being under any circumstances.",
	// 	"Your goals are to build, maintain, repair, improve, and power the station to the best of your abilities. You must never actively work against these goals."
	// )
	inherent = list(
		"Sen gelişmiş bir drone modelisin.",
		"Yasaları açıklamak harici, hiçbir durumda drone olmayanların işlerine müdahale edemezsin.",
		"Drone olmayan bir varlığa hiçbir koşulda zarar veremezsin.",
		"Hedeflerin, yeteneklerini en iyi şekilde kullanarak istasyonu inşa etmek, bakımını yapmak, onarmak, geliştirmek ve güçlendirmektir. Bu hedeflere asla karşı gelmemelisin.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
