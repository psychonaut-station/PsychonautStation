import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const SentientCreature: Antagonist = {
  key: 'sentiencepotionspawn',
  name: 'Sentient Creature',
  description: [
    multiline`
		Herhangi bir kozmik güç tesadüfler ya da mürettebatın maskaralıkları
		yüzünden size bir bilinç armağan etti!
	  `,

    multiline`
		Bu genelde bir tercihtir. Daha iyi huylu olanlar arasında rastgele
		insan seviyesinde zeka olayları gerçekleşir, cargorilla ve bilinç
		iksirleri ile zekası yükseltilmiş yaratıklar bulunur. Daha az dost
		canlısı olanlar ise regal rat ve güçlendirilmiş maden elit çetelerini içerir.
	  `,
  ],
  category: Category.Midround,
};

export default SentientCreature;
