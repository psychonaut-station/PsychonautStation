import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';
import { REVOLUTIONARY_MECHANICAL_DESCRIPTION } from './headrevolutionary';

const Provocateur: Antagonist = {
  key: 'provocateur',
  name: 'Provocateur',
  description: [
    multiline`
      Devam eden bir vardiyaya katılırken 
	  etkinleştirilebilen bir tür baş devrimci!
    `,

    REVOLUTIONARY_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Latejoin,
};

export default Provocateur;
