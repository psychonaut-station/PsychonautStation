import { Antagonist, Category } from '../base';
import { TRAITOR_MECHANICAL_DESCRIPTION } from './traitor';
import { multiline } from 'common/string';

const SyndicateSleeperAgent: Antagonist = {
  key: 'syndicatesleeperagent',
  name: 'Syndicate Sleeper Agent',
  description: [
    multiline`
      Vardiyanın herhangi bir noktasında aktif
	  hale gelebilen bir tür hain.
    `,
    TRAITOR_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
  priority: -1,
};

export default SyndicateSleeperAgent;
