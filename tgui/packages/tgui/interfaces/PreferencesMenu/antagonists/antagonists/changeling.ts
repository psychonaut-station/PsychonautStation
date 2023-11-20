import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const CHANGELING_MECHANICAL_DESCRIPTION = multiline`
Kendinizi veya başkalarını farklı kimliklere dönüştürün ve
topladığınız DNA ile cephaneliğinizden biyolojik araçlar, silahlar satın alın.
`;

const Changeling: Antagonist = {
  key: 'changeling',
  name: 'Changeling',
  description: [
    multiline`
      Şekilini kusursuz bir şekilde insana benzeyecek şekilde
	  değiştriebilen son derece zeki uzaylı yırtıcı.
    `,
    CHANGELING_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Changeling;
