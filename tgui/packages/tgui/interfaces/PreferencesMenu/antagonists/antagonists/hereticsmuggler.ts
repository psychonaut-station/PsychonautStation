import { Antagonist, Category } from '../base';
import { HERETIC_MECHANICAL_DESCRIPTION } from './heretic';

const HereticSmuggler: Antagonist = {
  key: 'hereticsmuggler',
  name: 'Heretic Smuggler',
  description: [
    'Devam eden bir vardiyaya katılırken etkinleştirilebilen bir sapkınlık biçimi.',
    HERETIC_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Latejoin,
};

export default HereticSmuggler;
