import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';
import { OPERATIVE_MECHANICAL_DESCRIPTION } from './operative';

const OperativeMidround: Antagonist = {
  key: 'operativemidround',
  name: 'Nuclear Assailant',
  description: [
    multiline`
      Vardiyanın ortasında hayaletlere sunulan
	  bir tür nükleer operatör.
    `,
    OPERATIVE_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default OperativeMidround;
