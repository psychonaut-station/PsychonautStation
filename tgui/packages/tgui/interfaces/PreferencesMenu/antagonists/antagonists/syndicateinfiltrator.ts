import { Antagonist, Category } from '../base';
import { TRAITOR_MECHANICAL_DESCRIPTION } from './traitor';

const SyndicateInfiltrator: Antagonist = {
  key: 'syndicateinfiltrator',
  name: 'Syndicate Infiltrator',
  description: [
    'Devam eden vardiyaya katılırken etkinleştirilebilen bir tür hain',
    TRAITOR_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Latejoin,
  priority: -1,
};

export default SyndicateInfiltrator;
