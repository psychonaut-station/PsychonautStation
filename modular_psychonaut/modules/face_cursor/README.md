## Face Cursor

MODULE ID: FACE_CURSOR

### Açıklama

Basarken mouseye bakmamızı sağlayan bir kısayol ekler, bunun sayesinde geri geri yürüme tarzı şeyler yapılabilir.

### TG Değişiklikleri

- `code/game/atoms_movable.dm`: `/atom/movable/Move()`
- `code/game/atom/_atom.dm`: `/atom/proc/on_mouse_enter()`
- `code/modules/mob/mob_movement.dm`: `/client/Move()`

### Modüler Değişiklikler

- `modular_psychonaut/master_files/code/game/atoms_movable.dm`: `/atom/movable/var/face_mouse`
- `modular_psychonaut/master_files/code/modules/movespeed/modifiers/mobs.dm`: `/datum/movespeed_modifier/backward_walk`, `/datum/movespeed_modifier/side_walk`

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/keybinding.dm`: `COMSIG_KB_LIVING_FACECURSOR_DOWN`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

Hardly3D, Rengan
