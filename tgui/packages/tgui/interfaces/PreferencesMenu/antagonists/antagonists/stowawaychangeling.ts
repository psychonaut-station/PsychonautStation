import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';
import { CHANGELING_MECHANICAL_DESCRIPTION } from './changeling';

const Stowaway_Changeling: Antagonist = {
  key: 'stowawaychangeling',
  name: 'Stowaway Changeling',
  description: [
    multiline`
      Gemideki mürettebatın haberi olmadan shuttle'a
	  girmeyi başaran bir Changeling.
    `,
    CHANGELING_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Latejoin,
};

export default Stowaway_Changeling;
