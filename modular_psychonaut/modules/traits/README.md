## Traits

MODULE ID: TRAITS

### Açıklama

Yeni bir trait ekleyeceğin zaman traitleri [`declarations.dm`](/code/__DEFINES/~psychonaut_defines/traits/declarations.dm)'a eklemelisin ama ayrıca [`_traits.dm`](/modular_psychonaut/master_files/code/_globalvars/traits/_traits.dm) ve [`admin_tooling.dm`](/modular_psychonaut/master_files/code/_globalvars/traits/admin_tooling.dm) de bulunan listelere eklemen gerekiyor. Eklediğin yeni traitleri burada değil eklediğim modülde belirtmelisin.

### TG Değişiklikleri

- `code/_globalvars/traits/_traits.dm`: `/proc/generate_global_trait_name_map()`
- `code/_globalvars/traits/admin_tooling.dm`: `/proc/generate_admin_trait_name_map()`
- `code/modules/admin/verbs/admin.dm`: `/datum/admins/proc/modify_traits()`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Seefaaa
