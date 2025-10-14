## Spawn Point

MODULE ID: SPAWN_POINT

### Açıklama

Kendi eklediğimiz her meslek için haritalara landmark koyamayacağımızdan meslekleri halihazırda var olan landmarklarda başlatmamızı sağlar.

Mesleğin başlayacağı landmarkı belirtmek için mesleğin dosyasına aşağıdaki şekil gibi kod satırı eklenmesi gerekiyor.

```dm
/datum/job/brig_physician
	...
  roundstart_spawn_point = /obj/effect/landmark/start/security_officer
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
