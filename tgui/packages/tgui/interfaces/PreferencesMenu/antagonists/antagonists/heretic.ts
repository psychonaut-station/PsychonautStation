import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const HERETIC_MECHANICAL_DESCRIPTION = multiline`
      Gizli etkileri bulun ve mürettebat üyelerini feda ederek
	  çeşitli büyülü güçler kazanın ve seçtiğiniz bir yoldan ilerleyin.
   `;

const Heretic: Antagonist = {
  key: 'heretic',
  name: 'Heretic',
  description: [
    multiline`
      Unutulmuş, yutulmuş, içi boşaltılmış. İnsanlık çürümenin
	  kadim güçlerini unuttu ama  Mansus perdesi zayıfladı.
	  Onlara korkuyu tekrar taddıracağız...
    `,
    HERETIC_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Heretic;
