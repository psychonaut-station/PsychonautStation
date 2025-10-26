## Language

MODULE ID: LANGUAGE

### Açıklama

Oyun içerisinde Türkçe kullanılmasından dolayı çıkan sorunları çözmek amacıyla yapılan değişiklikler.

### TG Değişiklikleri

- `code/__DEFINES/text.dm`: `LOWER_TEXT`
- `code/__HELPERS/names.dm`: `/proc/generate_code_phrase()`
- `code/__HELPERS/text.dm`: `/proc/reject_bad_name()`, `/proc/capitalize()`
- `code/datums/voice_of_god_command.dm`: `/proc/voice_of_god()`
- `code/datums/status_effects/debuffs/speech_debuffs.dm`: `/datum/status_effect/speech/stutter/derpspeech/handle_message()`
- `code/game/machinery/status_display.dm`: `/obj/machinery/status_display/proc/set_messages()`
- `code/game/objects/effects/wanted_poster.dm`: `/obj/structure/sign/poster/wanted/proc/print_across_top()`
- `code/modules/mining/lavaland/mining_loot/megafauna/colossus.dm`: `/obj/item/organ/vocal_cords/colossus/speak_with()`
- `code/modules/mob/living/living_say.dm`: `/mob/living/say()`, `/mob/living/proc/treat_message()`
- `code/modules/spells/spell_types/self/voice_of_god.dm`: `/datum/action/cooldown/spell/voice_of_god/cast()`
- `code/modules/wiremod/components/string/textcase.dm`: `/obj/item/circuit_component/textcase/input_received()`

### Modüler Değişiklikler

- N/A

### Definelar ve Helperlar

- `code/__HELPERS/~psychonaut_helpers/text.dm`: `/proc/delocale_text()`, `/proc/locale_uppertext()`, `/proc/locale_lowertext()`
- `code/__DEFINES/~psychonaut_defines/text.dm`: `LOCALE_LOWER_TEXT`

### Bu Klasörde Bulunmayan Modüle Dahil Dosyalar

- N/A

### Katkıda Bulunanlar

cko1, Seefaaa
