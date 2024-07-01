## Spawn Point

MODULE ID: SPAWN_POINT

### Açıklama

Kendi eklediğimiz her meslek için haritalara landmark koyamayacağımızdan meslekleri halihazırda var olan landmarklarda başlatmamızı sağlar.

Mesleğin başlayacağı landmarkı belirtmek için [`spawn_point.dm`](code/spawn_point.dm "modular_psychonaut/modules/spawn_point/code/spawn_point.dm") dosyasına aşağıdaki şekil gibi kod satırı eklenmesi gerekiyor.

```dm
/datum/job/nt_secretary
  roundstart_spawn_point = /obj/effect/landmark/start/assistant
```

### TG Değişiklikleri

- N/A

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/modules/jobs/job_types/_job.dm`: [`/datum/job`: `var/roundstart_spawn_point`, `get_default_roundstart_spawn_point()`]

### Definelar ve Helperlar

- N/A

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Seefaaa

<!-- Bir rol eklediysen adını buraya yazma, sadece eklediğin müdüle yazman yeterli. -->
