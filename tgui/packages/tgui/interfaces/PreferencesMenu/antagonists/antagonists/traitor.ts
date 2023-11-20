import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const TRAITOR_MECHANICAL_DESCRIPTION = multiline`
      Teçhizatınızı satın almak ve uğursuz hedeflerinize ulaşmak için
	  bir uplink ile başlayın. Rütbelerinizi yükseltin ve kötü şöhretli
	  bir efsane olun.
   `;

const Traitor: Antagonist = {
  key: 'traitor',
  name: 'Traitor',
  description: [
    multiline`
      Ödenmemiş bir borç, kapatılması gereken bir hesap.
	  Belki de yanlış zamanda yanlış yerdeydiniz, Sebep ne
	  olursa olsun Space Station 13'e sızmak için seçildiniz.
    `,
    TRAITOR_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
  priority: -1,
};

export default Traitor;
