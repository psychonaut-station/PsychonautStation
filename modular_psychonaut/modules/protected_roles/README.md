## Protected Roles

MODULE ID: PROTECTED_ROLES

### Açıklama

Bazı rollerin antag olmaması veya olamaması gerekiyor. Bu modül ile bu rollere antag gelmesini yasaklıyoruz.

Yeni bir role antag kısıtlaması getirmek için [`protected_roles.dm`](code/protected_roles.dm "modular_psychonaut/modules/protected_roles/code/protected_roles.dm") dosyasına aşağıdaki şekil gibi kod satırı eklenmesi gerekiyor.

```dm
/datum/job/nt_secretary
  antagonist_protected = TRUE
```

`antagonist_protected` o rolün antag olmaması gerektiğini `antagonist_restricted` ise o rolün antag olamayacağını belirtiyor. Örneğin Cyborg antag olmaması gerekiyor değil antag olamaz.

`protected_antagonists` ve `restricted_antagonists` ise belirtildiklerinde o rolü sadece belirtilen antaglardan kısıtlıyor, eğer belirtilmezse tüm antaglardan kısıtlıyor.

### TG Değişiklikleri

- N/A

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/controllers/subsystem/dynamic/dynamic.dm`: `/datum/controller/subsystem/dynamic/configure_ruleset()`
- `modular_psychonaut/master_files/code/modules/jobs/job_types/_job.dm`: [`/datum/job/`: `var/antagonist_protected`, `var/antagonist_restricted`, `var/protected_antagonists`, `var/restricted_antagonists`]

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Seefaaa

<!-- Bir rol eklediysen adını buraya yazma, sadece eklediğin müdüle yazman yeterli. -->
