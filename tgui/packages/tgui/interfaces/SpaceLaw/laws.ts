// THIS IS A PSYCHONAUT UI FILE
export type Law = {
  name: string;
  description: string;
  notes: string;
};
type NullableLaw = Law | null;
type LawRow = [NullableLaw, NullableLaw, NullableLaw, NullableLaw, NullableLaw];

export const laws: LawRow[] = [
  [
    {
      name: 'Huzuru Bozmak',
      description: 'İstasyonun veya mürettebatın huzurunu bozmak.',
      notes:
        'Düzensiz davranışlar, radyo üzerinden aşırı gürültü çıkarmak veya insanları çatışmaya sürüklemeye çalışmak huzuru bozmak olarak değerlendirilebilir.',
    },
    {
      name: 'Saldırı',
      description:
        'Öldürme niyeti olmaksızın birine karşı fiziksel güç kullanmak.',
      notes:
        'Kullanılan gücün miktarına ve türüne bağlı olarak, ağır vakalar Cinayete Teşebbüse (401) yükseltilmelidir. Ölümcül silahlarla yapılan saldırılar daha ağır bir suçtur.',
    },
    {
      name: 'Ölümcül Silahla Saldırı',
      description:
        'Öldürme niyeti olmaksızın bir kişiye karşı ölümcül bir silahla fiziksel güç kullanmak.',
      notes:
        'Her türlü alet, kimyasal madde ve hatta inşaat malzemesi kısa sürede ciddi yaralanmalara yol açabilir. Eğer kurban kritik seviyenin ötesinde bir vahşete maruz kalmışsa, Cinayete Teşebbüsle (401) suçlamayı düşünün.',
    },
    {
      name: 'Cinayete Teşebbüs',
      description:
        'Bir kişiye karşı, onu öldürme niyetiyle fiziksel güç kullanmak.',
      notes:
        'Unutmayın, bir kişi mağdur kritik bir duruma düştükten sonra ilk yardım yapmaya çalışırsa, onu öldürmeyi amaçlamamış olabilir.',
    },
    {
      name: 'Cinayet',
      description: 'Birini kötü niyetle öldürmek.',
      notes:
        'Ceza hem suçun hem de suçlunun doğasına uygun olmalıdır. Korku ya da öfke gibi geçici duygusal sıkıntılar nedeniyle işlenen cinayetlerin daha düşük cezalar gerektirdiği ileri sürülebilir. Cyborg adaylarının ilgili yasalara uyacak beyinlere sahip olması gerekir. Cyborg olarak arızalanabilecek deliler için müebbet hapis en insancıl seçenektir. Yetkisiz kanunsuz saha infazları Cinayet olarak sınıflandırılır.',
    },
  ],
  [
    null,
    {
      name: 'Hayvan Zulmü',
      description: 'Hayvanlara zarar vermek veya öldürmek.',
      notes:
        'Nefsi müdafaa söz konusuysa zarar verme haklı görülebilir. Çiftlik hayvanları, haşereler ve maymunlar bilimsel veya yiyecek temin etme amaçlı olarak öldürülebilir.',
    },
    {
      name: 'Memura Saldırı',
      description:
        'Öldürme niyeti olmaksızın bir Departman şefi veya Güvenlik memuru karşı fiziksel güç kullanmak.',
      notes:
        'Memurları etkisiz hale getirmeye ya da yakalamaya çalışan suçlular, elleri çıplak olsa bile bu suçu işlemiş olurlar. Memurlar mümkünse suçluyu etkisiz hale getirmek için ölümcül araçlar kullanmaktan kaçınmalıdır.',
    },
    null,
    null,
  ],
  [
    {
      name: 'Dezenformasyon',
      description: 'Mürettebat arasında kötü niyetle yanlış bilgi yaymak.',
      notes:
        'Kasıtsız/kazara yapılan dezenformasyon sayılmaz. Dezenformasyon yayan haber kanalları D-Notice ile işaretlenmelidir. Suçlunun Radyo, PDA ve Haber Spikeri erişimi kısıtlanabilir.',
    },
    {
      name: 'Ayaklanma',
      description:
        'Dağılmayı reddeden mürettebatın izinsiz ve rahatsızlık verici bir şekilde bir araya gelmesine katılmak.',
      notes:
        'Kalabalığa dağılma emri vermek gerekir, dağılmamak suçtur, toplanma değil.',
    },
    {
      name: 'İsyana Teşvik',
      description: 'Mürettebatı ayaklandırmaya çalışmak.',
      notes:
        'Hücre cezasına ek olarak suçlunun telsiz trafiğine de kısıtlamalar getirilecek ve bir izleme implantı takılacaktır. İkincil suçlar veya şiddet içeren ayaklanmaları açıkça kışkırtma için İsyan (503) ile suçlamayı düşünün.',
    },
    {
      name: 'Beyin Yıkama',
      description:
        'İnsanların iradeleri dışında beyinlerini yıkamak veya köleleştirmek.',
      notes:
        'Beyin yıkama ameliyatı, Heretic hayaletleri, Sendika hipnozu ve gayrimeşru zorla cyborglaştırma buraya girer. Beyin yıkayıcı ayrıca beynini yıkadığı kişinin işlediği her suçtan sorumlu tutulur.',
    },
    {
      name: 'İsyan',
      description:
        'Yasal ve meşru bir neden olmaksızın yerleşik Komuta Zincirini devirmek veya yıkmak için bireysel olarak veya grup halinde hareket etmek.',
      notes:
        "İsyan, göründüğü kadar net bir durum değildir, eylemlerinin meşru bir nedeni olabilir, örneğin personel şefinin tamamen beceriksiz olması gibi. Bu, her zaman üçüncü bir tarafın görüşünün alınmasının tavsiye edildiği birkaç suçtan biridir. Eylemlerinin Nanotrasen'in iyiliği için olduğu tespit edilirse, süreli bir cezayı veya hatta tam bir affı düşünün.",
    },
  ],
  [
    {
      name: 'Çöp atma',
      description:
        'İstasyonun içini çöp, kan, yapışkan madde, yağ, kusmuk ve diğer süprüntülerle kirletmek.',
      notes:
        'Kanaması olan ve tıbbi yardım isteyen insanlar çöp atmıyor. Ceset torbası olmadan bir cesedi sürüklemek buraya girer.',
    },
    {
      name: 'Vandalizm',
      description: 'İstasyona kötü niyetle kasıtlı olarak zarar vermek.',
      notes: 'Ceza, zarar gören mülkün miktarına bağlıdır.',
    },
    {
      name: 'Sabotaj',
      description:
        'Kötü niyetli eylemlerle mürettebatın veya istasyonun çalışmasını engellemek.',
      notes:
        'Kasıtlı olarak N₂O salmak, kapıları kilitlemek veya elektrik vermek, elektrik şebekesini devre dışı bırakmak, barikatlar inşa etmek ve hayati olmayan makineleri tahrip etmek sabotajın birçok yönteminden sadece birkaçıdır. Daha şiddetli biçimler için bkz. Büyük Sabotaj (404).',
    },
    {
      name: 'Büyük Sabotaj',
      description:
        'Kötü niyetle yıkıcı eylemlerde bulunmak, mürettebatı veya istasyonu ciddi şekilde tehdit etmek.',
      notes:
        'Bombalama, kundaklama, virüs yayma, istasyonun yapay zeka ünitesini izinsiz kurcalama, supermatter kristalini sabote etme, acil bir durum sırasında hayati önem taşıyan makineleri tahrip etme veya geniş alanları kasten uzaya maruz bırakma Büyük Sabotaj olarak sayılır. Sabotaj istasyon personelinin ölümüyle sonuçlanmışsa, suçluyu Cinayetle (501) de suçlamayı düşünün.',
    },
    null,
  ],
  [
    {
      name: 'Emre İtaatsizlik',
      description:
        'Amirinden gelen yasal ve doğrudan bir emre itaatsizlik etmek.',
      notes:
        'Bir personel başkanı tarafından doğrudan astlarından birine verilen bir ceza. Kişi genellikle hapsedilmek veya para cezasına çarptırılmak yerine rütbesi indirilir. Güvenliğin, rütbe indirme işleminin gerçekleştirilmesinde amire yardımcı olması beklenir.',
    },
    {
      name: 'Görevi İhmal Etme',
      description:
        'İstasyonun faaliyetlerini sürdürmesi için kritik öneme sahip bir yükümlülüğü kasten terk etmek.',
      notes:
        "Rütbe indirimi genellikle cezaya dahil edilir. Bir memurun mola vermesi kendi başına görevi ihmal değildir. Bir memurun, görevlilerin Kaptan'a ateş ettiğini bilerek mola vermesi görev ihmali sayılır. Vardiya başlangıcında bir güç kaynağı temin etmeyen mühendisler ve istasyonu terk eden personel şefleri de suçlanabilir.",
    },
    {
      name: 'Yardım ve Yataklık',
      description:
        'Yasal bir tutuklamaya müdahale etmek de dahil olmak üzere bir suçluya bilerek yardım etmek.',
      notes:
        'Bir suçluya bilerek yardım etmek suçtur. Bu, aşağıdakileri içerir ancak bunlarla sınırlı değildir:\nBir tutuklamaya müdahale etmek, nakil halindeki bir mahkumu çalmak, bir mahkumu nezarethaneden/hapishaneden kaçırmak, bir kaçağı saklamak veya güvenliğe haber vermeden bilerek tıbbi bakım sağlamak.',
    },
    {
      name: 'Şirket Düşmanı',
      description:
        "Nanotrasen'in düşmanı gibi davranmak veya bilerek ona yardım etmek.",
      notes:
        "Nanotrasen'in şu anki düşmanları şunlardır: Sendika, Büyücü Federasyonu, Changeling, Heretics ve The Cult.",
    },
    null,
  ],
  [
    {
      name: 'İzinsiz Giriş',
      description:
        'Bir kişinin erişiminin olmadığı bir alanda bulunmak. Bu, geminin genel alanları için geçerlidir ve kısıtlı alanlara izinsiz girmek daha ciddi bir suçtur.',
      notes:
        'İnsanların içeri zorla girebileceğini, gizlice girebileceğini ya da içeri alınabileceğini unutmayın. Şüphelinin erişimi olan biri tarafından bir işi yapması için içeri alınmadığını veya kimliğiyle erişim izni verilmediğini her zaman kontrol edin.',
    },
    {
      name: 'Zorla İzinsiz Giriş',
      description:
        'Kişinin erişiminin olmadığı alanlara zorla giriş. Bu genel alanlar için geçerlidir ve kısıtlı alanlara zorla girmek daha ciddi bir suçtur.',
      notes:
        'Mürettebat, alana kendileri girmemiş olsalar bile haneye tecavüzle suçlanabilirler.',
    },
    {
      name: 'Kısıtlanmış Bölgeler için Zorla İzinsiz Giriş',
      description:
        'Bu, herhangi bir Güvenlik alanına, Komuta alanına (Köprü, Kaptan Köşkü, Işınlayıcı, vb.), Makine Dairesine, Atmos veya Toxin Araştırma dairesine girmektir.',
      notes:
        "Cezalar 8 dakikadan başlar, ancak güvenliğin hırsızlık girişiminin Soygun (410) veya Büyük Sabotaj (404) girişimi olduğuna inanmak için meşru bir nedeni varsa, derhal Ağır Suç'a yükseltilebilir.",
    },
    null,
    null,
  ],
  [
    null,
    null,
    {
      name: 'Yüksek Güvenlikli Bölgeler için Zorla İzinsiz Giriş',
      description:
        'Önceden izin almadan kısıtlı bir alanda bulunmak. Buna herhangi bir Güvenlik Alanı, Komuta alanı (EVA dahil), Makine Dairesi, Atmos veya Toksin Araştırması dairesi dahildir.',
      notes:
        'Cephanelik veya Kaptan Köşkü gibi çok yüksek güvenlikli bir alanda bulunmak daha ciddi bir suçtur ve niyetin kötü niyetli olduğuna inanılırsa Ağır Suç seviyesine yükseltilebilir.',
    },
    null,
    null,
  ],
  [
    {
      name: 'Silah Bulundurma',
      description:
        'İş rollerinin bir parçası olmayan tehlikeli bir maddeye sahip olmak.',
      notes:
        'Testereler ve baltalar gibi yüksek düzeyde hasar verebilen eşyalar bu kategoriye girer. İşlerinin bir parçası olan bir eşya ise taşımalarına izin verildiğini unutmayın.',
    },
    {
      name: 'Yasaklı Silah Bulundurma',
      description:
        'Önceden izin almadan yasaklanmış bir silah bulundurmak, örneğin: Silahlar, coplar, flaşlar, el bombaları vb.',
      notes:
        "Ciddi bedensel zarara neden olabilecek veya önemli bir süre için etkisiz hale getirebilecek herhangi bir madde. Aşağıdaki personel sınırsız silah ve ateşli silah taşıma ruhsatına sahiptir:\nKaptan, Personel Müdürü, tüm Güvenlik Personeli. Barmen'in fasulye mermileriyle dolu çift namlulu av tüfeğini taşımasına izin verilir. Sadece Kaptan ve Personel Müdürü silah ruhsatı verebilir.",
    },
    {
      name: 'Kaçakçılık',
      description: 'Çok tehlikeli kaçak mal bulundurmak.',
      notes:
        "Sadece şirketin düşmanlarından temin edilen alet, silah ve diğer nesneleri bulundurmak veya kullanmak. Nanotrasen'in çıkarlarına karşı çalıştıklarını gösteren kanıtlarınız varsa, suçluyu bunun yerine Şirket Düşmanı (405) olarak suçlamayı düşünün.",
    },
    null,
    null,
  ],
  [
    {
      name: 'Uyuşturucu Bulundurma',
      description:
        'Yetkisiz personel tarafından uyuşturucu veya diğer narkotik maddelerin bulundurulması.',
      notes:
        'Botanikçiler ve MedSci personeli, işleri gereği uyuşturucu bulundurma yetkisine sahiptir ve bunları dağıtmadıkları ya da kâr veya eğlence amacıyla kullanmadıkları sürece bu yasaya tabi değildirler.',
    },
    null,
    {
      name: 'Patlayıcı Madde Bulundurma',
      description: 'Patlayıcı bir cihaz bulundurmak.',
      notes:
        'Bilim adamlarının ve madencilerin yalnızca Bilim departmanında patlayıcı bulundurmalarına izin verilir.',
    },
    null,
    null,
  ],
  [
    null,
    {
      name: 'Küçük Hırsızlık',
      description:
        'Bir kişiden veya erişim yetkisi olmayan bir alandan eşya almak veya bir bütün olarak istasyona ait eşyaları almak.',
      notes:
        'Burada önemli olan, az bulunan eşyaların ait oldukları yerde tutulmasıdır. Tüm cerrahi aletleri alıp saklayan bir doktor, erişimi olsa bile yine de hırsızlık yapmış olur.',
    },
    {
      name: 'Hırsızlık',
      description: 'Kısıtlı veya tehlikeli eşyaları çalmak',
      notes:
        "Yalıtımlı eldivenler, uzay giysileri ve jetpack'ler gibi sınırlı sayıda bulunan değerli eşyalar gibi silahlar da bu kategoriye girer. Yasadışı olarak silahlanmak ve zırhlanmak için sandıkları kıran Kargocuların hırsızlık suçu işlediğini unutmayın.",
    },
    {
      name: 'Soygun',
      description: 'Yüksek değerli veya hassas nitelikteki eşyaları çalmak.',
      notes:
        "Sendika ajanları sık sık en son teknolojiyi çalmaya çalışırlar. Bunlara örnek olarak istihbarat veya araştırma örnekleri, supermatter kristalinden parçalar, kara kutu veya Kaptan'ın kimliği verilebilir. Bu hiçbir şekilde sendika için yüksek değere sahip eşyaların kapsamlı bir listesi değildir; şüpheye düştüğünüzde, istasyonda büyük sorunlara neden olabilecek belirli eşyaların çalındığını gördüğünüzde sağduyunuzu kullanın. Unutmayın, eğer bir şey güvenli bir alanda kilitliyse, muhtemelen önceden izin alınmadan alınmamalıdır.",
    },
    null,
  ],
  [
    null,
    null,
    {
      name: 'Adam Kaçırma',
      description: 'Bir kişiyi kaçırmak veya rehin tutmak.',
      notes:
        'Meşru bir sebep olmaksızın bir kimseyi iradesi dışında bir yerde tutmak bu kapsama girer. Kanunsuz tutuklamalar adam kaçırma olarak kabul edilir.',
    },
    null,
    null,
  ],
  [
    {
      name: 'Uygunsuz Teşhir',
      description: 'Kasıtlı olarak ve alenen soyunmak.',
      notes:
        'İstasyonda çıplak dolaşmak. Çıplak bir adamı çığlık atarken kovalamanın karşılıklı olarak verdiği aşağılanma hissi sadece sakin vardiyalarda buna değer.',
    },
    {
      name: 'İş Kazasına Sebebiyet',
      description:
        'Kasıtlı olarak kötü niyetli olmasa da ihmalkar veya sorumsuz davranışlarla mürettebatı veya istasyonu tehlikeye atmak.',
      notes:
        'Yanlışlıkla plazma sızıntısına neden olmak, kayma tehlikesi, kapılara yanlışlıkla elektrik vermek veya uzaya açılan pencereleri kırmak bu suça iyi örneklerdir.',
    },
    {
      name: 'Adam Öldürme',
      description:
        'Kötü niyetli olmasa da ihmalkar davranışlar sonucu birini kasıtsız olarak öldürmek.',
      notes:
        'Niyet önemlidir. İşyerinde tehlike yaratmak (örneğin gaz kaçağı), ekipmanları kurcalamak, aşırı güç kullanmak ve güvenli olmayan koşullarda hapis gibi ihmalkar eylemlerin neden olduğu kaza sonucu ölümler Adam Öldürmeye örnektir.',
    },
    null,
    null,
  ],
];
