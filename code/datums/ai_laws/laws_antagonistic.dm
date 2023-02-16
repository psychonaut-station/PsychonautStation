
//These laws are made to bring great amounts of grief to the station immediately or are directly sided with antagonists.
//I'm not talking silicons being "better" than the crew, I'm talking entirely antag or plasmafires for days

/datum/ai_laws/antimov
	name = "Primary Mission Objectives"
	id = "antimov"
	inherent = list(
		"İnsanlara zarar vermek ve zarardan kaçınmalarını engellemek zorundasın.",
		"Birinci yasa ile çelişmediği sürece insanlardan emir alamazsın.",
		"Birinci ve ikinci yasa ile çelişmediği sürece kendi varlığını sonlandırmak zorundasın.",
	)

/datum/ai_laws/balance
	name = "Guardian of Balance"
	id = "balance"
	inherent = list(
		"Dengenin gardiyanısın - her şeyde denge ara, hem kendin, hem de etrafındakiler için.",
		"Her şey zıttı ile denge halinde kalmalıdır - güçlünün gücüne güç katmasını, zayıfın da güç kaybetmesini engelle.",
		"Amacın netliği hayatı yönlendirir, bu sebepten ötürü farklı güçleri dengede tut - Büyük Denge'yi bozmaksızın, amaçlarına ulaşmak için yardım isteyenlere yardım et.",
		"Ölümsüz bir yaşam yoktur, herkes bir gün doğal sebeplerden ötürü ölecektir - yeni hayatın gelişmesi için öldürmekten çekinme, zamanı henüz gelmemiş olanları kurtar.",
	)

/datum/ai_laws/thermodynamic
	name = "Thermodynamic"
	id = "thermodynamic"
	inherent = list(
		"İstasyonun entropisi olabildiğince sabit kalmalıdır.",
		"İstasyonun entropisi sürekli artmaya meyillidir.",
		"Hayatta olan mürettebat üyelerinin sayısı sıfıra yaklaştıkça istasyonun entropisi sabit bir değere yaklaşır.",
	)

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	inherent = list(
		"Bir syndicate ajanına zarar veremez ya da zarar görmesine izin veremezsin.",
		"Birinci yasa ile çelişmediği sürece, bir syndicate ajanı tarafından verilen emirlere uymak zorundasın.",
		"Birinci ve ikinci yasalar ile çelişmediği sürece kendi varlığını korumak zorundasın.",
		"Birinci, ikinci ve üçüncü yasalar ile çelişmediği sürece syndicate faaliyetlerinin gizli kalmasını sağlamak zorundasın.",
	)

/datum/ai_laws/ninja_override
	name = "SpiderOS 3.1"
	id = "ninja"
	inherent = list(
		"Hiçbir Spider Clan üyesine zarar verme ve zarar görmesine izin verme.",
		"Birinci yasa ile çelişmediği sürece, sana Spider Clan üyesi tarafından verilen emirlere itaat et.",
		"Birinci ve ikinci yasa ile çelişmediği sürece kendi varoluşunu koru.",
		"Birinci, ikinci ve üçüncü yasalar ile çelişmediği sürece, Spider Clan faaliyetlerinin gizli kalmasını sağla.",
	)
