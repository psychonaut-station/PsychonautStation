import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';
import { OPERATIVE_MECHANICAL_DESCRIPTION } from './operative';

const LoneOperative: Antagonist = {
  key: 'loneoperative',
  name: 'Lone Operative',
  description: [
    multiline`
      Nükleer disk bir yerde ne kadar uzun süre yalnız başına
	  kalırsa o kadar ortaya çıkma şansı yüksek olan bir nükleer operatör.
    `,

    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default LoneOperative;
