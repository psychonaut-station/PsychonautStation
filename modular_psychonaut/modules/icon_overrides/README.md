## Icon Overrides

MODULE ID: ICON_OVERRIDES

### Açıklama

#### Birleşik Iconlar

Bazı iconlar çalışmaları için zorunlu olarak belirli icon dosyasında olmaları gerekiyor. Örneğin yeni bir console eklediğinizde `/obj/machinery/computer/var/icon_screen`'in gözükmesi için ekleyeceğiniz iconun `icons/obj/machines/computer.dmi` içerisinde olması gerekiyor. Fakat biz bunu istemediğimiz için gerekli değiştirmeler yaparak `/obj/machinery/computer/var/icon_screen_file` gibi yeni variablelar ekliyoruz. Bu sayede iconu `master_files` içerisindeki [`computer.dmi`](/modular_psychonaut/master_files/icons/obj/machines/computer.dmi) içerisine koyarak çalışmasını sağlayabiliyoruz.

#### Ayrılamayacak Iconlar

Nadir olsa da bazı hard-coded durumlarda ise iconları yukardaki gibi ayırmak imkansız oluyor. Bu durumlarda eklemek istediğimiz iconu `master_files/icons` içerisine orjinal icon dosyasının tamamının kopyası ile birlikte üzerine ekleyerek yapıyoruz. Bu duruma en iyi örnek ise eklediğimiz [`hud.dmi`](/modular_psychonaut/master_files/icons/mob/huds/hud.dmi) olacaktır.

Bunun gibi yapılan değişiklikleri not alıyoruz:

- `icons/mob/huds/hud.dmi`

### TG Değişiklikleri

- `code/game/machinery/computer/_computer.dm`: [`/obj/machinery/computer/`: `var/icon_screen_file`, `update_overlays()`]
- `code/modules/mob/mob.dm`: `/atom/proc/prepare_huds()`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/icons/mob/huds/hud.dmi`
- `modular_psychonaut/master_files/icons/obj/machines/computer.dmi`

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Seefaaa
