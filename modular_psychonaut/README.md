# Psychonaut Stili Modülerlik

Modülerlik için genel olarak [Skyrat](https://github.com/Skyrat-SS13/Skyrat-tg)'ı takip ettiğimizden dolayı [Skyrat'ın rehberini](https://github.com/Skyrat-SS13/Skyrat-tg/blob/master/modular_skyrat/readme.md) okuyarak başlayabilir ayrıca halihazırda eklenmiş olanlara da bakabilirsin.

Bazı şeyleri eklerken de orada yazmayan belirlediğimiz kurallar bulunuyor.

- [`TRAITS`](#traitler)
- [`ICON_OVERRIDES`](#iconlar)
- [`GAGS`](#gags)
- [`PROTECTED_ROLES`](#protected-roles)
- [`STAMPS`](#stamps)

## Traitler

Ekleyeceğin traitleri `code/__DEFINES/~psychonaut_defines/traits/declarations.dm`'a eklemelisin ama ayrıca `modular_psychonaut/master_files/code/_globalvars/traits/_traits.dm` ve `modular_psychonaut/master_files/code/_globalvars/traits/admin_tooling.dm` de bulunan listelere eklemen gerekiyor.

## Iconlar

### Birleşik Iconlar

Bazı iconlar çalışmaları için illa belirli icon dosyasında olmaları gerekiyor. Örneğin yeni bir console eklediğinizde `/obj/machinery/computer/var/icon_screen`'in gözükmesi için ekleyeceğiniz iconun `icons/obj/machines/computer.dmi` içerisinde olması gerekiyor. Fakat biz bunu istemediğimiz için `ICON_OVERRIDES` adında gerekli değiştirmeler yaparak `/obj/machinery/computer/var/icon_screen_file` gibi yeni variablelar ekliyoruz. Bu sayede iconu `modular_psychonaut/master_files/icons/obj/machines/computer.dmi` koyarak çalışmasını sağlayabiliyoruz.

Bunun gibi yapılan değişiklikleri not alıyoruz:

- `icons/obj/machines/computer.dmi`: `/obj/machinery/computer/var/icon_screen_file`

### Ayrılamayacak Iconlar

Nadir olsa da bazı hard-coded durumlarda ise iconları yukardaki gibi ayırmak imkansız oluyor. Bu durumlarda eklemek istediğimiz iconu `master_files/icons` içerisine orjinal icon dosyasının tamamının kopyası ile birlikte üzerine ekleyerek yapıyoruz. Bu duruma en iyi örnek ise yine `ICON_OVERRIDES` adıyla eklediğimiz `modular_psychonaut/master_files/icons/mob/huds/hud.dmi`.

Bunun gibi yapılan değişiklikleri not alıyoruz:

- `icons/mob/huds/hud.dmi`

## GAGS

Ekleyeceğin greyscale eşyaları `modular_psychonaut\modules\GAGS`'a eklemen gerekiyor. Dahası fazlası için: [README.md](modules/GAGS/README.md)

## Protected Roles

Yeni ekleyeceğin bir role antag kısıtlaması getirmek için rolünü `modular_psychonaut\modules\protected_roles\code\protected_roles.dm`'a eklemen gerekiyor. Daha fazlası için: [README.md](modules/protected_roles/README.md)

## Stamps

Ekleyeceğin stampleri traitlere benzer bir şekilde `modular_psychonaut/modules/stamps/stamps.dm`'e eklemen gerekiyor. Daha fazlası için: [README.md](modules/stamps/README.md)
