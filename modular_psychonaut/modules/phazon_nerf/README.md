## Phazon Nerf

MODULE ID: PHAZON_NERF

### Açıklama

Phazon mechine phase ability icin cooldown ekler ve toxin chassis hasar tipini kaldirir

### TG Değişiklikleri

- `code/modules/vehicles/mecha/combat/phazon.dm`: `/datum/action/vehicle/sealed/mecha/mech_switch_damtype/Trigger()`, [`/datum/action/vehicle/sealed/mecha/mech_toggle_phasing`: `var/phase_time`, `var/phase_cooldown_time`], `/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/stop_phasing()`, `/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/Trigger()`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- `code/__DEFINES/~psychonaut_defines/cooldowns.dm`: `COOLDOWN_MECHA_PHASE`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

loanselot
