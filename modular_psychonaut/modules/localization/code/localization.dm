/proc/locale_surgery_sentence(rawtext)
	var/static/bioware_pushed = FALSE
	var/static/list/locale_list = list(
		"the skin must be cut" = "deri kesik olmalı",
		"the skin must be open" = "deri açık olmalı",
		"the blood vessels must be unclamped" = "kan damarları klemplenmemiş olmalı",
		"the blood vessels must be clamped" = "kan damarları klemplenmiş olmalı",
		"the organs must be cut" = "organlar kesilmiş olmalı",
		"the bone must be drilled" = "kemik delinmiş olmalı",
		"the bone must be sawed" = "kemik testereyle kesilmiş olmalı",
		"plastic must be applied" = "plastik uygulanmış olmalı",
		"the prosthetic must be unsecured" = "protez sabitlenmiş olmalı",
		"the chest cavity must be opened wide" = "göğüs boşluğu genişçe açılmış olmalı",
		"the skin must not be cut" = "deri kesik olmamalı",
		"the skin must not be open" = "deri açık olmamalı",
		"the blood vessels must not be unclamped" = "kan damarları klemplenmemiş olmamalı",
		"the blood vessels must not be clamped" = "kan damarları klemplenmiş olmamalı",
		"the organs must not be cut" = "organlar kesilmiş olmamalı",
		"the bone must not be drilled" = "kemik delinmiş olmamalı",
		"the bone must not be sawed" = "kemik testereyle kesilmiş olmamalı",
		"plastic must not be applied" = "plastik uygulanmış olmamalı",
		"the prosthetic must not be unsecured" = "protez sabitlenmiş olmamalı",
		"the chest cavity must not be opened wide" = "göğüs boşluğu genişçe açılmış olmamalı",
		"Any item" = "Herhangi bir eşya",
		"Any sharp item" = "Keskin bir eşya",
		"Any sharp edged item" = "Keskin kenarlı bir eşya",
		"Any sharp edged item with decent force" = "Keskin kenarlı ağır bir cisim",
		"Any sharp pointed item with decent force" = "Keskin uçlu ağır bir cisim",
		"Any heat source" = "Bir ısı kaynağı",
		"the patient must not be organic" = "hasta organik olmamalı",
		"the patient must not be robotic" = "hasta robotik olmamalı",
		"the organ must not be organic" = "organ organik olmamalı",
		"the organ must not be cybernetic" = "organ sibernetik olmamalı",
		"operate on patient" = "hastaya müdahale et",
		"operate on head (target head)" = "kafa bölgesine müdahale et (hedef: kafa)",
		"operate on chest (target chest)" = "göğüs bölgesine müdahale et (hedef: göğüs)",
		"operate on mouth (target mouth)" = "ağız içerisine müdahale et (hedef: ağız)",
		"operate on heart (target chest)" = "kalbe müdahale et (hedef: göğüs)",
		"operate on brain (target head)" = "beyine müdahale et (hedef: kafa)",
		"operate on ears (target head)" = "kulaklara müdahale et (hedef: kafa)",
		"operate on eyes (target eyes)" = "gözlere müdahale et (hedef: göz)",
		"operate on lungs (target chest)" = "akciğere müdahale et (hedef: göğüs)",
		"operate on liver (target chest)" = "karaciğere müdahale et (hedef: göğüs)",
		"operate on stomach (target chest)" = "mideye müdahale et (hedef: göğüs)",
		"operate on moth wings (target chest)" = "kanatlara müdahale et (hedef: göğüs)",
		"the patient must be deceased" = "hasta ölü olmalı",
		"the limb must have bones" = "uzuvda kemik olmalı",
		"if the limb has bones, they must be intact" = "eğer uzuvda kemik varsa, kemikler sağlam olmalı",
		"the patient must not be husked" = "hasta husklanmamış olmalı",
		"the patient must be lying down" = "hasta yatar pozisyonda olmalı",
		"the bone must be sawed or drilled" = "kemik kesilmiş veya delinmiş olmalı",
		"the skin must be cut or opened" = "deri kesilmiş veya açılmış olmalı",
		"the blood vessels must be clamped or unclamped" = "kan damarları klemplenmiş veya klemplenmemiş olmalı",
		"a surgeon may perform this on themselves" = "cerrah bunu kendi üzerinde uygulayabilir",
		"the bone must be intact" = "kemik sağlam olmalı",
		"the skin must be intact" = "deri sağlam olmalı",
		"the blood vessels must be intact" = "kan damarları sağlam olmalı",
		"the operation site must not be obstructed by clothing" = "operasyon bölgesi giysiler tarafından engellenmemeli",
		"Any suitable arm replacement" = "Uygun bir kol protezi",
		"when the chest is prepared, target the zone of the limb you are attaching" = "göğüs bölgesi hazırlandığında, takacağınız uzvun bölgesini hedefleyin",
		"arms may receive any suitable item in lieu of a replacement limb" = "kollar, yedek bir uzuv yerine uygun olan herhangi bir eşyayı kabul edebilir",
		"if operating on the head, the bone MUST be sawed" = "eğer kafa bölgesinde operasyon gerçekleştiriliyor ise, kemik testere ile kesilmiş olmalı",
		"otherwise, the state of the bone doesn't matter" = "aksi takdirde, kemiğin durumu önemli değildir",
		"the limb must be wooden" = "uzuv ahşap olmalı",
		"the patient must be asthmatic" = "hastanın astımı olmalı",
		"the patient must not have been autopsied prior" = "hastaya daha önce otopsi uygulanmamış olmalı",
		"the limb must be dislocated" = "uzuv yerinden çıkmış olmalı",
		"the limb must have a hairline fracture" = "uzuvda kılcak çatlaklar olmalı",
		"the limb must have a compound fracture" = "uzuvda açık kırık olmalı",
		"the limb's compound fracture has been reset" = "uzuvdaki açık kırık düzeltilmiş olmalı",
		"the cranium must be fractured" = "kafatası kırılmış olmalı",
		"the debris has been cleared from the cranial fissure" = "kafatası çatlağındaki kalıntılar temizlenmiş olmalı",
		"operate on a deceased slime" = "ölü bir slimede operayonu uygulayın",
		"the limb must have a second degree or worse burn" = "uzuvda ikinci derece veya daha kötü bir yanık olmalı",
		"the mouth must have teeth" = "hastanın ağızında diş bulunmalı",
		"the patient must not have been dissected prior" = "hastaya daha önce otopsi uygulanmamış olmalı",
		"The patient must not have complex anatomy" = "Hastanın karmaşık bir anatomisi olmamalı",
		"the limb must have skin" = "uzvun derisi olmalı",
		"the limb must have blood vessels" = "uzuvda kan damarları olmalı",
		"the patient must have brute or burn damage" = "hastanın kaba veya yanık hasarı olmalı",
		"have an implant case below or inhand to store removed implants" = "çıkarılan implantları saklamak için altta veya elinizde bir implant kutusu bulunmalı",
		"the patient must have excess fat to remove" = "hastanın alınabilir aşırı yağı olmalı",
		"if operating on the brain or any chest organs, the bone MUST be sawed" = "eğer beyin veya göğüs organları üzerinde operasyon gerçekleştiriliyor ise, kemik testere ile kesilmiş olmalı",
		"otherwise, the state of the bone doesn't matter" = "aksi takdirde, kemiğin durumu önemli değildir",
		"the organ must be moderately damaged" = "organ orta derecede hasar almış olmalı",
		"the organ must not have been surgically repaired prior" = "organ daha önce cerrahi olarak onarılmamış olmalı",
		"the limb must have an unoperated puncture wound" = "uzuvda müdahale edilmemiş bir delici yara olmalı",
		"the limb must have an operated puncture wound" = "uzuvdaki delici yaraya müdahale edilmiş olmalı",
		"the patient must be in a revivable state" = "hasta canlandırılabilir olmalı",
		"the patient must have a virus to bond" = "hastanın vücudunda iyileştirilebilir bir virüs olmalı",
		"the patient must be dosed with >=1u [/datum/reagent/medicine/spaceacillin::name]" = "hastaya en az 1 birim [/datum/reagent/medicine/spaceacillin::name] dozlanmış olmalı",
		"the patient must be dosed with >=1u [/datum/reagent/consumable/virus_food::name]" = "hastaya en az 1 birim [/datum/reagent/consumable/virus_food::name] dozlanmış olmalı",
		"the patient must be dosed with >=1u [/datum/reagent/toxin/formaldehyde::name]" = "hastaya en az 1 birim [/datum/reagent/toxin/formaldehyde::name] dozlanmış olmalı",
		"the wings must be burnt" = "kanatlar yanmış olmalı",
		"the patient must be dosed with >=5u [/datum/reagent/medicine/c2/synthflesh::name]" = "hastaya en az 5 birim [/datum/reagent/medicine/c2/synthflesh::name] dozlanmış olmalı",
		"if the limb has bones, they must be intact" = "eğer uzuv kemikli ise, kemikler sağlam olmalı",
		"the limb must have a brain present" = "uzuvda bir beyin bulunmalı",
		"the patient or tool must contain >1u [/datum/reagent/medicine/rezadone::name]" = "hastada veya alette 1 birimden fazla [/datum/reagent/medicine/rezadone::name] bulunmalı",
		"the patient or tool must contain >1u [/datum/reagent/toxin/zombiepowder::name]" = "hastada veya alette 1 birimden fazla  [/datum/reagent/toxin/zombiepowder::name] bulunmalı",
		"the limb must not already have a Romerol tumor" = "uzuvda Romerol tümörü bulunmamalı",
		"the limb must not be cybernetic" = "uzuv sibernetik olmamalı",
		"the limb must not be organic" = "uzuv organik olmamalı",
		"the limb must be missing / a stump" = "uzuv eksik veya güdük olmalı"
	)

	if(!bioware_pushed)
		for(var/datum/surgery_operation/limb/bioware/bioware as anything in subtypesof(/datum/surgery_operation/limb/bioware))
			var/list/incompatible_surgeries = list()
			var/datum/status_effect/bio_status_effect = bioware::status_effect_gained
			for(var/datum/surgery_operation/limb/bioware/other_bioware as anything in (subtypesof(/datum/surgery_operation/limb/bioware)))
				var/datum/status_effect/otbio_status_effect = other_bioware::status_effect_gained
				if(otbio_status_effect::id != bio_status_effect::id)
					continue
				if(other_bioware::required_bodytype != bioware::required_bodytype)
					continue
				incompatible_surgeries += (other_bioware.rnd_name || other_bioware.name)
			var/english_biware_text = "the patient must not have undergone [english_list(incompatible_surgeries, and_text = " OR ")] prior"
			locale_list[english_biware_text] = "hasta daha önce [turkish_list(incompatible_surgeries, "hiçbir operasyon", " VEYA ")] geçirmemiş olmalı"
		bioware_pushed = TRUE

	var/locale_text = locale_list[rawtext]
	if(locale_text)
		return locale_text

	stack_trace("\"[rawtext]\" not found in /proc/locale_surgery_sentence")
	return rawtext
