// @Genku

// Türkçeleştirmeye açıktır.
// Title kısmındaki isimler ile Table dosyasındaki
// isimlerin aynı olmasına dikkat edin.

// [0] Suç başlığı
// [1] Suç hakkında çıkacak tooltip

export const spaceLawTable = [
  {
    code: 'X01',
    Mischief: [
      'Huzuru Bozmak',
      'İstasyonun veya mürettebatın huzurunu bozmak.',
    ],
    Misdemeanor: [
      'Darp',
      'Öldürme niyeti olmaksızın birine karşı fiziksel güç kullanmak.',
    ],
    Felony: [
      'Ölümcül Silahla Saldırı',
      'Öldürme niyeti olmaksızın bir kişiye karşı ölümcül bir silahla fiziksel güç kullanmak.',
    ],
    GrandFelony: [
      'Cinayete Teşebbüs',
      'Bir kişiye karşı, onu öldürme niyetiyle fiziksel güç kullanmak.',
    ],
    CapitalCrime: ['Cinayet', 'Birini kötü niyetle öldürmek.'],
  },
  {
    code: 'X02',
    Mischief: ' ',
    Misdemeanor: ['Hayvan Zulmü', 'Hayvanlara zarar vermek veya öldürmek.'],
    Felony: [
      'Memura Saldırı',
      'Öldürme niyeti olmaksızın bir Daire Başkanı veya Güvenlik mensubuna karşı fiziksel güç kullanmak.',
    ],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
  {
    code: 'X03',
    Mischief: [
      'Dezenformasyon',
      'Mürettebat arasında kötü niyetle yanlış bilgi yaymak.',
    ],
    Misdemeanor: [
      'Ayaklanma',
      'Dağılmayı reddeden mürettebatın izinsiz ve rahatsızlık verici bir şekilde bir araya gelmesine katılmak.',
    ],
    Felony: ['İsyana Teşvik', 'Mürettebatı ayaklandırmaya çalışmak.'],
    GrandFelony: [
      'Beyin Yıkama',
      'İnsanların iradeleri dışında beyinlerini yıkamak veya köleleştirmek.',
    ],
    CapitalCrime: [
      'İsyan',
      'Yasal ve meşru bir neden olmaksızın yerleşik Komuta Zincirini devirmek veya yıkmak için bireysel olarak veya grup halinde hareket etmek.',
    ],
  },
  {
    code: 'X04',
    Mischief: [
      'Çöp atma',
      'İstasyonun içini çöp, kan, yapışkan madde, yağ, kusmuk ve diğer süprüntülerle kirletmek.',
    ],
    Misdemeanor: [
      'Vandalizm',
      'İstasyona kötü niyetle kasıtlı olarak zarar vermek.',
    ],
    Felony: [
      'Sabotaj',
      'Kötü niyetli eylemlerle mürettebatın veya istasyonun çalışmasını engellemek.',
    ],
    GrandFelony: [
      'Büyük Sabotaj',
      'Kötü niyetle yıkıcı eylemlerde bulunmak, mürettebatı veya istasyonu ciddi şekilde tehdit etmek.',
    ],
    CapitalCrime: ' ',
  },
  {
    code: 'X05',
    Mischief: [
      'Emre İtaatsizlik',
      'Amirinden gelen yasal ve doğrudan bir emre itaatsizlik etmek.',
    ],
    Misdemeanor: [
      'Görevi İhmal Etme',
      'İstasyonun faaliyetlerini sürdürmesi için kritik öneme sahip bir yükümlülüğü kasten terk etmek.',
    ],
    Felony: [
      'Yardım ve Yataklık',
      'Yasal bir tutuklamaya müdahale etmek de dahil olmak üzere bir suçluya bilerek yardım etmek.',
    ],
    GrandFelony: [
      'Şirket Düşmanı',
      "Nanotrasen'in düşmanı gibi davranmak veya bilerek ona yardım etmek.",
    ],
    CapitalCrime: ' ',
  },
  {
    code: 'X06',
    Mischief: [
      'İzinsiz Giriş',
      'Bir kişinin erişiminin olmadığı bir alanda bulunmak. Bu, geminin genel alanları için geçerlidir ve kısıtlı alanlara izinsiz girmek daha ciddi bir suçtur.',
    ],
    Misdemeanor: [
      'Zorla İzinsiz Giriş',
      'Kişinin erişiminin olmadığı alanlara zorla giriş. Bu genel alanlar için geçerlidir ve kısıtlı alanlara zorla girmek daha ciddi bir suçtur.',
    ],
    Felony: [
      'Kısıtlanmış Bölgeler için Zorla İzinsiz Giriş',
      'Bu, herhangi bir Güvenlik alanına, Komuta alanına (Köprü, Kaptan Köşkü, Işınlayıcı, vb.), Makine Dairesine, Atmos&apos;a veya Toxin Araştırma dairesine girmektir.',
    ],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
  {
    code: 'X07',
    Mischief: ' ',
    Misdemeanor: ' ',
    Felony: [
      'Yüksek Güvenlikli Bölgeler için Zorla İzinsiz Giriş',
      'Önceden izin almadan kısıtlı bir alanda bulunmak. Buna herhangi bir Güvenlik Alanı, Komuta alanı (EVA dahil), Makine Dairesi, Atmos veya Toksin Araştırması dairesi dahildir.',
    ],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
  {
    code: 'X08',
    Mischief: [
      'Silah Bulundurma',
      'İş rollerinin bir parçası olmayan tehlikeli bir maddeye sahip olmak.',
    ],
    Misdemeanor: [
      'Yasaklı Silah Bulundurma',
      'Önceden izin almadan yasaklanmış bir silah bulundurmak, örneğin: Silahlar, coplar, flaşlar, el bombaları vb.',
    ],
    Felony: ['Kaçakçılık', 'Çok tehlikeli kaçak mal bulundurmak.'],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
  {
    code: 'X09',
    Mischief: [
      'Uyuşturucu Bulundurma',
      'Yetkisiz personel tarafından uyuşturucu veya diğer narkotik maddelerin bulundurulması.',
    ],
    Misdemeanor: ' ',
    Felony: ['Patlayıcı Madde Bulundurma', 'Patlayıcı bir cihaz bulundurmak.'],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
  {
    code: 'X10',
    Mischief: ' ',
    Misdemeanor: [
      'Yan Kesicilik',
      'Bir kişiden veya erişim yetkisi olmayan bir alandan eşya almak veya bir bütün olarak istasyona ait eşyaları almak.',
    ],
    Felony: ['Hırsızlık', 'Kısıtlı veya tehlikeli eşyaları çalmak'],
    GrandFelony: [
      'Soygun',
      'Yüksek değerli veya hassas nitelikteki eşyaları çalmak.',
    ],
    CapitalCrime: ' ',
  },
  {
    code: 'X11',
    Mischief: ' ',
    Misdemeanor: ' ',
    Felony: ['Adam Kaçırma', 'Bir kişiyi kaçırmak veya rehin tutmak.'],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
  {
    code: 'X12',
    Mischief: ['Uygunsuz Teşhir', 'Kasıtlı olarak ve alenen soyunmak.'],
    Misdemeanor: [
      'İş Kazasına Sebebiyet',
      'Kasıtlı olarak kötü niyetli olmasa da ihmalkar veya sorumsuz davranışlarla mürettebatı veya istasyonu tehlikeye atmak.',
    ],
    Felony: [
      'Adam Öldürme',
      'Kötü niyetli olmasa da ihmalkar davranışlar sonucu birini kasıtsız olarak öldürmek.',
    ],
    GrandFelony: ' ',
    CapitalCrime: ' ',
  },
];
