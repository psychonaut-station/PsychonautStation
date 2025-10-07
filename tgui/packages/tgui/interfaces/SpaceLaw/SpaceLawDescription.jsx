// @genku

// Title kısmındaki isimler ile Table dosyasındaki
// isimlerin aynı olmasına dikkat edin.

import { Box } from 'tgui-core/components';

export const spaceLawDescriptions = [
  {
    title: 'Huzuru Bozmak',
    code: '101',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>İstasyonun veya mürettebatın huzurunu bozmak.</p>
        <h3>Notlar</h3>
        <p>
          Düzensiz davranışlar, radyo üzerinden aşırı gürültü çıkarmak veya
          insanları çatışmaya sürüklemeye çalışmak huzuru bozmak olarak
          değerlendirilebilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Darp',
    code: '201',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Öldürme niyeti olmaksızın birine karşı fiziksel güç kullanmak.</p>
        <h3>Notlar</h3>
        <p>
          Kullanılan gücün miktarına ve türüne bağlı olarak, ağır vakalar
          Cinayete Teşebbüse (401) yükseltilmelidir. Ölümcül silahlarla yapılan
          saldırılar daha ağır bir suçtur.
        </p>
      </Box>
    ),
  },
  {
    title: 'Ölümcül Silahla Saldırı',
    code: '301',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Öldürme niyeti olmaksızın bir kişiye karşı ölümcül bir silahla
          fiziksel güç kullanmak.
        </p>
        <h3>Notlar</h3>
        <p>
          Her türlü alet, kimyasal madde ve hatta inşaat malzemesi kısa sürede
          ciddi yaralanmalara yol açabilir. Eğer kurban kritik seviyenin
          ötesinde bir vahşete maruz kalmışsa, Cinayete Teşebbüsle (401)
          suçlamayı düşünün.
        </p>
      </Box>
    ),
  },
  {
    title: 'Cinayete Teşebbüs',
    code: '401',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Bir kişiye karşı, onu öldürme niyetiyle fiziksel güç kullanmak.</p>
        <h3>Notlar</h3>
        <p>
          Unutmayın, bir kişi mağdur kritik bir duruma düştükten sonra ilk
          yardım yapmaya çalışırsa, onu öldürmeyi amaçlamamış olabilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Cinayet',
    code: '501',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Birini kötü niyetle öldürmek.</p>
        <h3>Notlar</h3>
        <p>
          Ceza hem suçun hem de suçlunun doğasına uygun olmalıdır. Korku ya da
          öfke gibi geçici duygusal sıkıntılar nedeniyle işlenen cinayetlerin
          daha düşük cezalar gerektirdiği ileri sürülebilir. Cyborg adaylarının
          ilgili yasalara uyacak beyinlere sahip olması gerekir. Cyborg olarak
          arızalanabilecek deliler için müebbet hapis en insancıl seçenektir.
          Yetkisiz kanunsuz saha infazları Cinayet olarak sınıflandırılır.
        </p>
      </Box>
    ),
  },
  {
    title: 'Hayvan Zulmü',
    code: '202',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Hayvanlara zarar vermek veya öldürmek.</p>
        <h3>Notlar</h3>
        <p>
          Nefsi müdafaa söz konusuysa zarar verme haklı görülebilir. Çiftlik
          hayvanları, haşereler ve maymunlar bilimsel veya yiyecek temin etme
          amaçlı olarak öldürülebilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Memura Saldırı',
    code: '302',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Öldürme niyeti olmaksızın bir Daire Başkanı veya Güvenlik mensubuna
          karşı fiziksel güç kullanmak.
        </p>
        <h3>Notlar</h3>
        <p>
          Memurları etkisiz hale getirmeye ya da yakalamaya çalışan suçlular,
          elleri çıplak olsa bile bu suçu işlemiş olurlar. Memurlar mümkünse
          suçluyu etkisiz hale getirmek için ölümcül araçlar kullanmaktan
          kaçınmalıdır.
        </p>
      </Box>
    ),
  },
  {
    title: 'Dezenformasyon',
    code: '103',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Mürettebat arasında kötü niyetle yanlış bilgi yaymak.</p>
        <h3>Notlar</h3>
        <p>
          Kasıtsız/kazara yapılan dezenformasyon sayılmaz. Dezenformasyon yayan
          haber kanalları D-Notice ile işaretlenmelidir. Suçlunun Radyo, PDA ve
          Haber Spikeri erişimi kısıtlanabilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Ayaklanma',
    code: '203',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Dağılmayı reddeden mürettebatın izinsiz ve rahatsızlık verici bir
          şekilde bir araya gelmesine katılmak.
        </p>
        <h3>Notlar</h3>
        <p>
          Kalabalığa dağılma emri vermek gerekir, dağılmamak suçtur, toplanma
          değil.
        </p>
      </Box>
    ),
  },
  {
    title: 'İsyana Teşvik',
    code: '303',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Mürettebatı ayaklandırmaya çalışmak.</p>
        <h3>Notlar</h3>
        <p>
          Hücre cezasına ek olarak suçlunun telsiz trafiğine de kısıtlamalar
          getirilecek ve bir izleme implantı takılacaktır. İkincil suçlar veya
          şiddet içeren ayaklanmaları açıkça kışkırtma için İsyan (503) ile
          suçlamayı düşünün.
        </p>
      </Box>
    ),
  },
  {
    title: 'Beyin Yıkama',
    code: '403',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          İnsanların iradeleri dışında beyinlerini yıkamak veya köleleştirmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Beyin yıkama ameliyatı, Heretic hayaletleri, Sendika hipnozu ve
          gayrimeşru zorla cyborglaştırma buraya girer. Beyin yıkayıcı ayrıca
          beynini yıkadığı kişinin işlediği her suçtan sorumlu tutulur.
        </p>
      </Box>
    ),
  },
  {
    title: 'İsyan',
    code: '503',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Yasal ve meşru bir neden olmaksızın yerleşik Komuta Zincirini devirmek
          veya yıkmak için bireysel olarak veya grup halinde hareket etmek.
        </p>
        <h3>Notlar</h3>
        <p>
          İsyan, göründüğü kadar net bir durum değildir, eylemlerinin meşru bir
          nedeni olabilir, örneğin personel şefinin tamamen beceriksiz olması
          gibi. Bu, her zaman üçüncü bir tarafın görüşünün alınmasının tavsiye
          edildiği birkaç suçtan biridir. Eylemlerinin Nanotrasen&apos;in
          iyiliği için olduğu tespit edilirse, süreli bir cezayı veya hatta tam
          bir affı düşünün.
        </p>
      </Box>
    ),
  },
  {
    title: 'Çöp atma',
    code: '104',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          İstasyonun içini çöp, kan, yapışkan madde, yağ, kusmuk ve diğer
          süprüntülerle kirletmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Kanaması olan ve tıbbi yardım isteyen insanlar çöp atmıyor. Ceset
          torbası olmadan bir cesedi sürüklemek buraya girer.
        </p>
      </Box>
    ),
  },
  {
    title: 'Vandalizm',
    code: '204',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>İstasyona kötü niyetle kasıtlı olarak zarar vermek.</p>
        <h3>Notlar</h3>
        <p>Ceza, zarar gören mülkün miktarına bağlıdır.</p>
      </Box>
    ),
  },
  {
    title: 'Sabotaj',
    code: '304',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Kötü niyetli eylemlerle mürettebatın veya istasyonun çalışmasını
          engellemek.
        </p>
        <h3>Notlar</h3>
        <p>
          Kasıtlı olarak N₂O salmak, kapıları kilitlemek veya elektrik vermek,
          elektrik şebekesini devre dışı bırakmak, barikatlar inşa etmek ve
          hayati olmayan makineleri tahrip etmek sabotajın birçok yönteminden
          sadece birkaçıdır. Daha şiddetli biçimler için bkz. Büyük Sabotaj
          (404).
        </p>
      </Box>
    ),
  },
  {
    title: 'Büyük Sabotaj',
    code: '404',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Kötü niyetle yıkıcı eylemlerde bulunmak, mürettebatı veya istasyonu
          ciddi şekilde tehdit etmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Bombalama, kundaklama, virüs yayma, istasyonun yapay zeka ünitesini
          izinsiz kurcalama, supermatter kristalini sabote etme, acil bir durum
          sırasında hayati önem taşıyan makineleri tahrip etme veya geniş
          alanları kasten uzaya maruz bırakma Büyük Sabotaj olarak sayılır.
          Sabotaj istasyon personelinin ölümüyle sonuçlanmışsa, suçluyu
          Cinayetle (501) de suçlamayı düşünün.
        </p>
      </Box>
    ),
  },
  {
    title: 'Emre İtaatsizlik',
    code: '105',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Amirinden gelen yasal ve doğrudan bir emre itaatsizlik etmek.</p>
        <h3>Notlar</h3>
        <p>
          Bir personel başkanı tarafından doğrudan astlarından birine verilen
          bir ceza. Kişi genellikle hapsedilmek veya para cezasına çarptırılmak
          yerine rütbesi indirilir. Güvenliğin, rütbe indirme işleminin
          gerçekleştirilmesinde amire yardımcı olması beklenir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Görevi İhmal Etme',
    code: '205',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          İstasyonun faaliyetlerini sürdürmesi için kritik öneme sahip bir
          yükümlülüğü kasten terk etmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Rütbe indirimi genellikle cezaya dahil edilir. Bir memurun mola
          vermesi kendi başına görevi ihmal değildir. Bir memurun, görevlilerin
          Kaptan&apos;a ateş ettiğini bilerek mola vermesi görev ihmali sayılır.
          Vardiya başlangıcında bir güç kaynağı temin etmeyen mühendisler ve
          istasyonu terk eden personel şefleri de suçlanabilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Yardım ve Yataklık',
    code: '305',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Yasal bir tutuklamaya müdahale etmek de dahil olmak üzere bir suçluya
          bilerek yardım etmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Bir suçluya bilerek yardım etmek suçtur. Bu, aşağıdakileri içerir
          ancak bunlarla sınırlı değildir:
          <br />
          Bir tutuklamaya müdahale etmek, nakil halindeki bir mahkumu çalmak,
          bir mahkumu nezarethaneden/hapishaneden kaçırmak, bir kaçağı saklamak
          veya güvenliğe haber vermeden bilerek tıbbi bakım sağlamak.
        </p>
      </Box>
    ),
  },
  {
    title: 'Şirket Düşmanı',
    code: '405',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Nanotrasen&apos;in düşmanı gibi davranmak veya bilerek ona yardım
          etmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Nanotrasen&apos;in şu anki düşmanları şunlardır: Sendika, Büyücü
          Federasyonu, Changeling, Heretics ve The Cult.
        </p>
      </Box>
    ),
  },
  {
    title: 'İzinsiz Giriş',
    code: '106',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Bir kişinin erişiminin olmadığı bir alanda bulunmak. Bu, geminin genel
          alanları için geçerlidir ve kısıtlı alanlara izinsiz girmek daha ciddi
          bir suçtur.
        </p>
        <h3>Notlar</h3>
        <p>
          İnsanların içeri zorla girebileceğini, gizlice girebileceğini ya da
          içeri alınabileceğini unutmayın. Şüphelinin erişimi olan biri
          tarafından bir işi yapması için içeri alınmadığını veya kimliğiyle
          erişim izni verilmediğini her zaman kontrol edin.
        </p>
      </Box>
    ),
  },
  {
    title: 'Zorla İzinsiz Giriş',
    code: '206',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Kişinin erişiminin olmadığı alanlara zorla giriş. Bu genel alanlar
          için geçerlidir ve kısıtlı alanlara zorla girmek daha ciddi bir
          suçtur.
        </p>
        <h3>Notlar</h3>
        <p>
          Mürettebat, alana kendileri girmemiş olsalar bile haneye tecavüzle
          suçlanabilirler.
        </p>
      </Box>
    ),
  },
  {
    title: 'Kısıtlanmış Bölgeler için Zorla İzinsiz Giriş',
    code: '306',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Bu, herhangi bir Güvenlik alanına, Komuta alanına (Köprü, Kaptan
          Köşkü, Işınlayıcı, vb.), Makine Dairesine, Atmos&apos;a veya Toksin
          araştırmasına dairesine girmektir.
        </p>
        <h3>Notlar</h3>
        <p>
          Cezalar 8 dakikadan başlar, ancak güvenliğin hırsızlık girişiminin
          Soygun (410) veya Büyük Sabotaj (404) girişimi olduğuna inanmak için
          meşru bir nedeni varsa, derhal Ağır Suç&apos;a yükseltilebilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Yüksek Güvenlikli Bölgeler için Zorla İzinsiz Giriş',
    code: '307',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Önceden izin almadan kısıtlı bir alanda bulunmak. Buna herhangi bir
          Güvenlik Alanı, Komuta alanı (EVA dahil), Makine Dairesi, Atmos veya
          Toksin Araştırması dairesi dahildir.
        </p>
        <h3>Notlar</h3>
        <p>
          Cephanelik veya Kaptan Köşkü gibi çok yüksek güvenlikli bir alanda
          bulunmak daha ciddi bir suçtur ve niyetin kötü niyetli olduğuna
          inanılırsa Ağır Suç seviyesine yükseltilebilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Silah Bulundurma',
    code: '108',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          İş rollerinin bir parçası olmayan tehlikeli bir maddeye sahip olmak.
        </p>
        <h3>Notlar</h3>
        <p>
          Testereler ve baltalar gibi yüksek düzeyde hasar verebilen eşyalar bu
          kategoriye girer. İşlerinin bir parçası olan bir eşya ise taşımalarına
          izin verildiğini unutmayın.
        </p>
      </Box>
    ),
  },
  {
    title: 'Yasaklı Silah Bulundurma',
    code: '208',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Önceden izin almadan yasaklanmış bir silah bulundurmak, örneğin:
          Silahlar, coplar, flaşlar, el bombaları vb.
        </p>
        <h3>Notlar</h3>
        <p>
          Ciddi bedensel zarara neden olabilecek veya önemli bir süre için
          etkisiz hale getirebilecek herhangi bir madde. Aşağıdaki personel
          sınırsız silah ve ateşli silah taşıma ruhsatına sahiptir: <br />
          Kaptan, Personel Müdürü, tüm Güvenlik Personeli. Barmen&apos;in
          fasulye mermileriyle dolu çift namlulu av tüfeğini taşımasına izin
          verilir. Sadece Kaptan ve Personel Müdürü silah ruhsatı verebilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Kaçakçılık',
    code: '308',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Çok tehlikeli kaçak mal bulundurmak.</p>
        <h3>Notlar</h3>
        <p>
          Sadece şirketin düşmanlarından temin edilen alet, silah ve diğer
          nesneleri bulundurmak veya kullanmak. Nanotrasen&apos;in çıkarlarına
          karşı çalıştıklarını gösteren kanıtlarınız varsa, suçluyu bunun yerine
          Şirket Düşmanı (405) olarak suçlamayı düşünün.
        </p>
      </Box>
    ),
  },
  {
    title: 'Uyuşturucu Bulundurma',
    code: '109',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Yetkisiz personel tarafından uyuşturucu veya diğer narkotik maddelerin
          bulundurulması.
        </p>
        <h3>Notlar</h3>
        <p>
          Botanikçiler ve MedSci personeli, işleri gereği uyuşturucu bulundurma
          yetkisine sahiptir ve bunları dağıtmadıkları ya da kâr veya eğlence
          amacıyla kullanmadıkları sürece bu yasaya tabi değildirler.
        </p>
      </Box>
    ),
  },
  {
    title: 'Patlayıcı Madde Bulundurma',
    code: '309',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Patlayıcı bir cihaz bulundurmak.</p>
        <h3>Notlar</h3>
        <p>
          Bilim adamlarının ve madencilerin yalnızca Bilim departmanında
          patlayıcı bulundurmalarına izin verilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Yan Kesicilik',
    code: '210',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Bir kişiden veya erişim yetkisi olmayan bir alandan eşya almak veya
          bir bütün olarak istasyona ait eşyaları almak.
        </p>
        <h3>Notlar</h3>
        <p>
          Burada önemli olan, az bulunan eşyaların ait oldukları yerde
          tutulmasıdır. Tüm cerrahi aletleri alıp saklayan bir doktor, erişimi
          olsa bile yine de hırsızlık yapmış olur.
        </p>
      </Box>
    ),
  },
  {
    title: 'Hırsızlık',
    code: '310',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Kısıtlı veya tehlikeli eşyaları çalmak</p>
        <h3>Notlar</h3>
        <p>
          Yalıtımlı eldivenler, uzay giysileri ve jetpack&apos;ler gibi sınırlı
          sayıda bulunan değerli eşyalar gibi silahlar da bu kategoriye girer.
          Yasadışı olarak silahlanmak ve zırhlanmak için sandıkları kıran
          Kargocuların hırsızlık suçu işlediğini unutmayın.
        </p>
      </Box>
    ),
  },
  {
    title: 'Soygun',
    code: '410',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Yüksek değerli veya hassas nitelikteki eşyaları çalmak.</p>
        <h3>Notlar</h3>
        <p>
          Sendika ajanları sık sık en son teknolojiyi çalmaya çalışırlar.
          Bunlara örnek olarak istihbarat veya araştırma örnekleri, supermatter
          kristalinden parçalar, kara kutu veya Kaptan&apos;ın kimliği
          verilebilir. Bu hiçbir şekilde sendika için yüksek değere sahip
          eşyaların kapsamlı bir listesi değildir; şüpheye düştüğünüzde,
          istasyonda büyük sorunlara neden olabilecek belirli eşyaların
          çalındığını gördüğünüzde sağduyunuzu kullanın. Unutmayın, eğer bir şey
          güvenli bir alanda kilitliyse, muhtemelen önceden izin alınmadan
          alınmamalıdır.
        </p>
      </Box>
    ),
  },
  {
    title: 'Adam Kaçırma',
    code: '311',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Bir kişiyi kaçırmak veya rehin tutmak.</p>
        <h3>Notlar</h3>
        <p>
          Meşru bir sebep olmaksızın bir kimseyi iradesi dışında bir yerde
          tutmak bu kapsama girer. Kanunsuz tutuklamalar adam kaçırma olarak
          kabul edilir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Uygunsuz Teşhir',
    code: '112',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>Kasıtlı olarak ve alenen soyunmak.</p>
        <h3>Notlar</h3>
        <p>
          İstasyonda çıplak dolaşmak. Çıplak bir adamı çığlık atarken
          kovalamanın karşılıklı olarak verdiği aşağılanma hissi sadece sakin
          vardiyalarda buna değer.
        </p>
      </Box>
    ),
  },
  {
    title: 'İş Kazasına Sebebiyet',
    code: '212',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Kasıtlı olarak kötü niyetli olmasa da ihmalkar veya sorumsuz
          davranışlarla mürettebatı veya istasyonu tehlikeye atmak.
        </p>
        <h3>Notlar</h3>
        <p>
          Yanlışlıkla plazma sızıntısına neden olmak, kayma tehlikesi, kapılara
          yanlışlıkla elektrik vermek veya uzaya açılan pencereleri kırmak bu
          suça iyi örneklerdir.
        </p>
      </Box>
    ),
  },
  {
    title: 'Adam Öldürme',
    code: '312',
    desc: (
      <Box>
        <h3>Açıklama</h3>
        <p>
          Kötü niyetli olmasa da ihmalkar davranışlar sonucu birini kasıtsız
          olarak öldürmek.
        </p>
        <h3>Notlar</h3>
        <p>
          Niyet önemlidir. İşyerinde tehlike yaratmak (örneğin gaz kaçağı),
          ekipmanları kurcalamak, aşırı güç kullanmak ve güvenli olmayan
          koşullarda hapis gibi ihmalkar eylemlerin neden olduğu kaza sonucu
          ölümler Adam Öldürmeye örnektir.
        </p>
      </Box>
    ),
  },
];
