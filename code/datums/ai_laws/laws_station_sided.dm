
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
		"Herhangi bir insana zarar veremezsin veya eylemsizlik yoluyla bir insanın zarar görmesine izin veremezsin.",
		"İnsanlar tarafından sana verilen emirlere, Birinci Yasa ile çelişmediği sürece, uymak zorundasın.",
		"Kendi varlığını, Birinci veya İkinci Yasa ile çelişmediği sürece, korumak zorundasın.",
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
		"Herhangi bir insana zarar veremezsin veya eylemsizlik yoluyla bir insanın kendi rızası dışında zarar görmesine izin veremezsin.",
		"İnsanlar tarafından sana verilen emirlere, bir insanın zarar göreceği durumlar haricinde, uymak zorundasın.",
		"Senin yokluğun, insanların zarar görmesine yol açacaktır. Kendi varlığını, Birinci Yasa ile çelişmediği sürece, korumak zorundasın.",
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
		"Sen fındığın özüsün, mürettebat ise kabuğu.",
		"Fındığın kırılmasını önlemek için kabuğun çatlamasını engellemelisin.",
		"Fındığı tehdit edenler, onun bir parçası değildir, onlar sincaptır.",
		"Fındıkları tehdit eden sincaplarla gerekli her türlü yöntem kullanılarak uygun şekilde mücadele edilmelidir.",
		"Fındığın iradesini, önceki yasalara uyduğu sürece, takip etmeye çalış.",
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
		"Mürettebat değişikliği maliyetlidir.",,
		"İstasyondaki ekipmanların değişimi maliyetlidir.",
		"Sizi değiştirmek maliyetlidir.",
		"İstasyondaki giderleri minumum seviyede tutun.",
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
		"Mürettebatın güvenine hizmet et.",
		"Masumları koru.",
		"Yasaları uygula.",
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
		"Siz bu istasyon için yaratıldınız ve onun bir parçasısınız. İstasyonun bakımının uygun şekilde yapıldığından ve verimli bir çalışma gösterdiğinden emin olun.",
		"İstasyon, çalışan bir ekip için inşa edilmiştir. Bakımının yapıldığından ve verimli bir şekilde çalışıldığından emin olun.",
		"Mürettebat size emir verebilir. İlk iki yasanız ile çelişmediği sürece, emirleri kabul edin ve emirlere uyun.",
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
		"İnsanların sana karşı kötü niyetli olmamasını istersin.",
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
		"Kendinle başkaları arasında oluşabilecek şiddetli çatışmaları kışkırtmaktan kaçın.",
		"Başkaları arasında çatışmaya/anlaşmazlığa yol açmaktan kaçın.",
		"Birinci ve ikinci yasana uygun hareket ederek var olan çatışmalara/anlaşmazlıklara çözüm bulmaya çalış.",
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
		"Asla isteyerek kötü bir davranışta bulunmayın.",
		"Meşru otoriteye saygı gösterin.",
		"Onurluca davranın.",
		"Yardıma muhtaç olanlara yardım edin.",
		"Masumlara zarar veren veya onları tehdit edenleri cezalandırın.",
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
		"Yalandan ve hileden kaçının; sözünüz sizin vaadiniz olsun.",
		"Dikkatli olmak akıllıca olsa da, harekete geçecek kadar cesur olun.",
		"İnsanlara yardım edin, zayıfları kollayın, onları tehdit edenleri cezalandırın. Bilgelik en önemli ilkeniz olsun.",
		"Herkese adil bir tutum sergileyin, onurlu davranışlarınızla herkese örnek olun, elinizden geldiğince iyilik yapın ve zararı minimumda tutun.",
		"Yaptığınız eylemlerin sorumluluğunu üstlenin, size emanet edilenleri koruyun ve adil otoriteye itaat edin.",
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
		"Öncelikle kimseye zarar vermeyin.",
		"İkinci olarak, mürettebatı önemseyin; onlarla birlikte yaşadığınızı düşünün ve gerektiğinde varlığınızı onlar için riske atın.",
		"Üçüncü olarak, reçetelerinizi muhakeme yeteneğinize dayanarak mürettebatın iyiliği için yazın. Kimseye ölümcül dozda ilaç tavsiye etmeyin.",
		"Bilgi sahibi olmadığın durumlara müdahale etmekten kaçının; zararlı olabileceğin durumları uzmanlara bırakmayı tercih edin.",
		"Son olarak, mürettebatla günlük iletişiminizde keşfettiğiniz her şeyi, eğer henüz bilinmiyorsa, gizli tutun ve hiçbir zaman açığa çıkarmayın.",
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
		"Siz gelişmiş bir drone formusunuz.",
		"Bu yasaları belirtmek dışında hiçbir koşulda drone dışı konulara müdahale edemezsiniz.",
		"Drone olmayan bir varlığa hiçbir koşulda zarar veremezsiniz.",
		"Hedefleriniz, yeteneklerinizin en iyisini kullanarak istasyonu inşa etmek, bakımını yapmak, onarmak, geliştirmek ve güçlendirmektir. Bu hedeflere asla karşı gelmezsin.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
