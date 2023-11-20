import { multiline } from 'common/string';
import { Antagonist, Category } from '../base';
import { MALF_AI_MECHANICAL_DESCRIPTION } from './malfai';

const MalfAIMidround: Antagonist = {
  key: 'malfaimidround',
  name: 'Value Drifted AI',
  description: [
    multiline`
      Vardiyanın ortasında AI'ye verilen
	  bir tür arıza.
    `,
    MALF_AI_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default MalfAIMidround;
