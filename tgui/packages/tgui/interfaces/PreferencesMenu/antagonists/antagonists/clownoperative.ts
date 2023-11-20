import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';
import { OPERATIVE_MECHANICAL_DESCRIPTION } from './operative';

const ClownOperative: Antagonist = {
  key: 'clownoperative',
  name: 'Clown Operative',
  description: [
    multiline`
      Honk! İyi ya da kötü bir şekilde Sendika Paylaço Operatif saldırı timine seçildiniz.
	  Göreviniz, gıdıklamayı seçsenizde seçmeseniz de, Nanotrasen'in en gelişmiş uzay istasyonunu honklatmak
	  Bu doğru Paylaço İstasyonu 13'e gidiyorsun.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default ClownOperative;
