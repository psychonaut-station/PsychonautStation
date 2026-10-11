# PsychonautStation - Bloodsucker v2 Dokümantasyonu

Bu doküman, `PsychonautStationMy` deposundaki `bloodsuckerv2` dalında (branch) gerçekleştirilen sistem mimarisi, oynanış mekanikleri, güçler, yapılar, arayüz ve yaşam kalitesi (QoL) değişikliklerini detaylandırmaktadır.

---

## 1. Genel Bakış ve Dal Bilgileri

- **Hedef Dal:** `bloodsuckerv2`
- **Temel Alınan Dal (Merge Base):** `master` (`42ab3eb822c` - Upstream mirror)
- **Değişiklik Boyutu:** 110 dosya, +6.916 satır ekleme, -20 satır silme.
- **Commit Geçmişi:**
  1. `551cdff9d38` - **Add Bloodsucker v2 changes:** Bloodsucker antagonist sisteminin v2 olarak sıfırdan revizyonu ve eklenmesi.
  2. `78e006a60c2` - **level system and predatory rush:** Dinamik güç seviyelendirme altyapısı, TGUI seviye desteği ve Lunge gücünün "Predatory Rush" olarak yeniden yazımı.
  3. `6e8ec96d909` - **Update lunge.dm:** Predatory Rush hareket döngüsü ve çarpışma mantığı iyileştirmesi.
  4. `a9c1112bdb0` - **haste rework:** Immortal Haste gücünün aktif toggle, mermi savuşturma ve etkileşim hızı bonusu olarak baştan tasarlanması.
  5. `36423e2325d` - **Fix combat mode right click butcher check interrupting combat attacks:** Savaş modunda sağ tık kasaplık (butchering) kontrolünün normal yakın dövüş saldırılarını kesmesini engelleyen düzeltme.

---

## 2. Temel Antagonist Mekanikleri (`datum/antagonist/bloodsucker`)

### 2.1. Kan Havuzu ve Tüketimi
- **Kan Rezervi (`bloodsucker_blood_volume`):** Başlangıçta 560 (normal insan hacmi), tavan kapasite (`max_blood_volume`) 600'dür. Her rütbe (Rank) atlandığında tavan +100 artar.
- **Pasif Kan Tüketimi:** Bilinci açık ve hareketsiz olmayan vampirler her yaşam döngüsünde (LifeTick) pasif olarak 0.1 kan tüketir (`BLOODSUCKER_PASSIVE_BLOOD_DRAIN`).
- **Beslenme (`Feed`):** Canlı hedeflerden boyun ısırığı ile kan emer. Ölü hedeflerden 1/3 oranında, insan olmayan hedeflerden 1/2 oranında kan kazanılır. Farelerden beslenmek mümkündür ancak İnsanlık (Humanity) kaybına ve kötü ruh haline yol açar.

### 2.2. İnsanlık Kaybı ve Masquerade
- **İnsanlık Kaybı (`humanity_lost`):** Masumları öldürerek beslenmek veya insanlık dışı eylemlerde bulunmak İnsanlık puanını düşürür.
- **Masquerade İhlalleri (`masquerade_infractions`):** Ölümlülerin gözü önünde vampir güçlerini kullanmak veya beslenmek ihlal oluşturur. 3 ihlale ulaşan vampir Masquerade'i bozar (`broke_masquerade`), inceleme (examine) ekranında ifşa olur ve diğer vampirlerin hedefi haline gelir.

### 2.3. Frenzy (Vahşi Öfke Modu)
- **Tetiklenme:** Kan hacmi 25 birimin (veya İnsanlık kaybına bağlı olarak yükselen eşiğin) altına indiğinde vampir istemsiz olarak Frenzy durumuna geçer. Kan 250'ye ulaşana kadar bu moddan çıkılamaz.
- **Kısıtlamalar:** Konuşamaz (`TRAIT_MUTE`), duyamaz (`TRAIT_DEAF`), `Feed` ve `Trespass` dışındaki tüm vampirik güçleri devre dışı kalır.
- **Savaş Avantajları:**
  - Sersemletme ve baton direnci (`TRAIT_BATON_RESISTANCE`, `TRAIT_STUNIMMUNE`, `TRAIT_PUSHIMMUNE`).
  - Yavaşlama etkilerini yok sayma (`TRAIT_IGNORESLOWDOWN`) ve ekstra hareket hızı (-0.4 hareket gecikmesi).
  - Özel dövüş sanatı **Frenzy Grab** (`/datum/martial_art/frenzygrab`): Hedefe tıklandığında anında agresif boyun kavraması (aggressive grab) uygular.

### 2.4. Doğaüstü Dayanıklılık ve Zayıflıklar
- **Doğuştan Gelen Özellikler (Traits):** Oksijensiz yaşayabilme (`TRAIT_NOBREATH`), uyku bağışıklığı (`TRAIT_SLEEPIMMUNE`), kritik hasar/bayılma bağışıklığı (`TRAIT_NOSOFTCRIT`, `TRAIT_NOHARDCRIT`), soğuk ve radyasyon direnci, virüs ve toksin bağışıklığı, aynalarda yansımama (`TRAIT_NO_MIRROR_REFLECTION`).
- **Kusurlar & Zayıflıklar:**
  - **Ateş/Yangın:** Vampirler yangın hasarına karşı son derece savunmasızdır. Çift azami can değerini aşan yangın hasarı anında nihai ölüme sebep olur.
  - **Kazık (Wooden Stake):** Göğse saplanan kazıklar güçleri kilitler; uykuda veya Torpor halindeyken saplanırsa nihai ölüm gerçekleşir.

---

## 3. Sol (Sunlight / Güneş Işığı) Sistemi (`subsystem/sunlight`)

İstasyon periyodik olarak yıkıcı solar flare (UV radyasyonu) döngüsüne girer:
- **Zaman Çizelgesi:**
  - Gece Süresi: Ortalama 600 saniye (±90 saniye rastgele sapma).
  - 1. Uyarı: Güneşe 90 saniye kala istasyona bildirim düşer.
  - 2. Uyarı: 30 saniye kala acil durum sinyali verilir.
  - Son Çağrı: 5 saniye kala.
  - Sol Gündüz Süresi: 60 saniye sürer.
- **Gündüz Hasarı:** Açık alanda kalan tüm vampirler `bloodsucker_sol` etkisiyle alev alır ve hızla yanar. Hayatta kalmak için istasyonda hak iddia edilmiş bir **Tabut (Coffin)** veya kapalı bir dolap içine saklanmak zorunludur.
- **Deneyim ve Rütbe:** Sol sona ermeden 15 saniye önce hayatta kalan tüm vampirlere gecenin ödülü olarak seviye puanı (`RankUp`) verilir.

---

## 4. Torpor, İyileşme ve Ölüm Hiyerarşisi

1. **Torpor (Ölümsüz Uyku):**
   - Vampir ölümcül hasar aldığında veya yaralı haldeyken tabutuna girdiğinde Torpor durumuna geçer (ölü taklidi ve sahte koma).
   - Tabut içerisinde yangın hasarı, ezilme hasarı, gömülü nesneler ve kopan uzuvlar hızla yenilenir (`check_limbs`).
   - Tabut dışındayken Torpor iyileşmesi %20 daha yavaştır.
2. **Final Death (Nihai Ölüm):**
   - Yangın hasarı azami sağlığın 2.5 katına ulaştığında,
   - Torpor veya bilinçsizlik halindeyken göğsüne ahşap/gümüş kazık saplandığında tetiklenir.
   - Düşük seviyeli vampirler patlayarak parçalanır (`gib`), 4. seviye ve üzeri kıdemli vampirler ise bir toz yığınına dönüşür (`dust`). Tüm köleleri (Vassals) serbest kalır.

---

## 5. Rütbe ve Seviye Sistemi (Progression)

- Geceyi atlatan vampirler harcanmamış seviye kazanır (`bloodsucker_level_unspent`).
- Seviyeler yalnızca istasyonda sahiplenilmiş bir **Tabut (Coffin)** içinde uyurken harcanabilir.
- **Seviye Atlama Getirileri:**
  - Yeni bir vampirik güç satın alma imkânı.
  - Sahip olunan seviyelendirilebilir tüm güçlerin (`can_level = TRUE`) rütbesinin yükselmesi.
  - Maksimum kan kapasitesine +100 artış.
  - Pasif iyileşme hızına +0.05 artış.
  - Çıplak el silahsız vuruş hasarına bonus artış.
  - 4. Rütbeye ulaşıldığında özel kıdemli unvanı ve şöhret (`SelectReputation`) kazanılır.

---

## 6. Vampirik Güçler (Powers)

| Güç Adı | Türü | Seviye Ölçekli | Kan Maliyeti | Açıklama |
| :--- | :--- | :---: | :---: | :--- |
| **Feed** | Toggle | Evet | 0 | Canlılardan kan emer. Seviye arttıkça hazırlık ve bekleme süresi kısalır; agresif tutuşta kurbanı bayıltır. |
| **Masquerade** | Toggle | Hayır | 10 (+0.1/s) | İnsan taklidi yapar. Kalp atışı başlar, tıbbi tarayıcılarda %100 kan gösterir. Aktifken vampirik iyileşme durur. |
| **Veil of Many Faces** | Toggle | Hayır | 15 (+0.1/s) | Duman bulutu içinde görünümü ve kimliği rastgele bir mürettebat üyesine dönüştürür. |
| **Cloak of Darkness** | Toggle | Evet | 5 (+0.2/s) | Gölgelerde görünmez olur (yapay zeka kameraları dahil). Koşmaya çalışırsa hasar alır. Seviye ile şeffaflık artar. |
| **Fortitude** | Toggle | Evet | 30 (+0.2/s) | Çelik zırh. Saplanma, sersemleme, uzuv kopması bağışıklığı ve %30-%70 Brute/Stamina hasar azaltması sağlar (Lvl 4'te tam sersemleme bağışıklığı). Haste ile aynı anda açılamaz. |
| **Immortal Haste** *(Reworked)* | Toggle | Evet | 10 (+0.2/s) | Refleksleri hızlandırır. Açılışta tutulmaları bozar. Mermilerden kaçınma (%15 - %60), etkileşim hızı artışı (%15 - %60) ve arkasında gölge izi (afterimage) bırakır. Fortitude ile aynı anda açılamaz. |
| **Predatory Rush** *(Lunge Rework)*| Hedefli | Evet | 10 | Hedefe doğru korkunç bir hızla atılır. Seviye arttıkça ön hazırlık süresi kısalır (1.5s -> 0.2s). Çarpışmada 15+(lvl*3) hasar verir, yere yıkar ve boynundan yakalar. |
| **Brawn** | Hedefli | Evet | 8 | Kelepçeleri kırar, hedefleri geriye fırlatır, cyborg'lara ağır EMP vurur. 3. seviyede dolapları parçalar, 4. seviyede kilitlenmemiş hava kilitlerini (airlock) kırıp açar. |
| **Mesmerize** | Hedefli | Evet | 30 | Göz temasıyla hedefi hipnotize edip dondurur. Lvl 2'de susturur, Lvl 3'te maske arkasından işler, Lvl 5'te yöne bakılmaksızın çalışır. |
| **Trespass** | Hedefli | Evet | 10 | Sise dönüşerek 2 karo ileriye duvar olmayan engellerin/kapıların arkasına ışınlanır. |
| **Go Home** | Anlık | Hayır | 0 | Sol yaklaştığında tabutun bulunduğu sığınağa dönüş yolunu gösterir/yardımcı olur. |

---

## 7. Vassal (Hizmetkâr) ve Dönüşüm Mekaniği

Bloodsucker'lar istasyon mürettebatını köleleştirerek kendilerine bağlayabilirler:
1. **İkna Tezgâhı (Persuasion Rack):** Kurban bu tezgâha bağlandığında işkence döngüsü başlatılır. Kurbanın zihinsel sadakati kırılır, Mindshield implantı parçalanır ve efendisine mutlak sadakatle bağlanan bir **Vassal** haline gelir.
2. **Vassal Türleri:**
   - **Standart Vassal:** Efendisine telepatik olarak bağlıdır, konumunu gösteren pinpointer taşır ve vampir dilini konuşabilir.
   - **Favorite Vassal:** Efendinin en sevdiği kölesi. Mindshield implantasyonuna karşı tamamen bağışıktır ve doğuştan **Brawn** gücüne sahip olur.
   - **Revenge Vassal (İntikam Kölesi):** Efendisi Final Death ile yok edildiğinde özgür kalmak yerine efendisinin tüm güçlerini miras alır, yeni round-end antag raporuna girer ve diğer Ex-Vassal'ları toplayarak intikam alma (`Avenge Bloodsucker`) görevini üstlenir.
   - **Ex-Vassal:** Efendisi ölen köleler 10 dakikalık bir kan açlığı döngüsüne girer. Bu süre içinde vampir kanı verilmezse deconvert olurlar.
3. **Vassal Güçleri:**
   - `Sanguine Recuperation`: Efendinin kan havuzunu kullanarak kendi Brute, Burn ve Toxin yaralarını iyileştirir.
   - `Distress`: Kendini yaralayarak efendisine acil durum konum sinyali yollar.
   - `Bat Form`: Tehlikeli durumlarda uzay yarasasına dönüşür.
   - `Help Vassal`: Yalnızca Revenge Vassal tarafından kullanılır; Ex-Vassal'ları yeniden örgüte katar veya vampirik kan torbası doldurur.

---

## 8. Kripta Yapıları, Eşyalar ve Üretim (Crafting)

- **Tabutlar (Coffins):**
  - *Black Coffin* (Kumaş, Ahşap, Demir)
  - *Secure Coffin* (Plasteel, Demir, Çubuklar - Yangın, asit ve lav geçirmez)
  - *Meat Coffin* (Et parçaları, Kablo kelepçe)
  - *Metal Coffin* (Demir levhalar, Çubuklar)
- **Kripta Süsleme ve Ritüel Objeleri:**
  - *Persuasion Rack:* Vassal dönüştürme ve işkence tezgâhı.
  - *Candelabrum:* Vampirik aydınlatma ve moral takviyesi.
  - *Blood Throne:* Kan tahtı; üzerine oturan vampirin konuşma ses efektini yankılı ve korkutucu hale getirir.
  - *Blood Altar, Statue, Portrait, Brazier, Mirror:* Sığınak dekorasyonları.
- **Kazıklar (Stakes):**
  - Ahşap kalıplardan kesici bir aletle yontularak üretilir (5 saniye).
  - *Wooden Stake*, *Hardened Stake* (ateşte sertleştirilmiş), *Silver Stake* (gümüş kaplama, yüksek delme gücü).

---

## 9. Kullanıcı Arayüzü (TGUI) ve Ek Değişiklikler

1. **Antag Bilgi Ekranı (`AntagInfoBloodsucker.tsx`):**
   - Vampirin hedefleri, güçlü ve zayıf yönleri gösterilir.
   - Güçler sekmesinde her gücün seviyesi (`Lvl 1`, `Lvl 2` vb.) kırmızı rozetle listelenir.
   - Seviyesi olmayan güçlerde seviye göstergesi gizlenir.
2. **HUD Sayaçları:**
   - `HUD_BLOODSUCKER_BLOOD`: Mevcut kan hacmi göstergesi.
   - `HUD_BLOODSUCKER_RANK`: Mevcut vampir rütbesi göstergesi.
   - `HUD_BLOODSUCKER_SUNLIGHT`: Güneş ışığına kalan süreyi gösteren gösterge.
3. **Kasaplık Düzeltmesi (`code/datums/components/butchering.dm`):**
   - Savaş modunda (Combat Mode) sağ tıklandığında oyuncuların hedefe saldırmak yerine yanlışlıkla kasaplık eylemine girmesi ve saldırı zincirinin bozulması engellendi.
   - Yalnızca kurban ölü/baygın/bağlıysa ve kurbanın bulunduğu karoda bir masa, yatak, stasis ünitesi veya mutfak çengeli varsa sağ tıkla kasaplık eylemi tetiklenir.
