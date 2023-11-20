import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const ParadoxClone: Antagonist = {
  key: 'paradoxclone',
  name: 'Paradox Clone',
  description: [
    multiline`
    Garip bir uzay-zaman anomalisi sizi başka bir gerçekliğe ışınladı!
	Şimdi kendinizin klonunu bulmalı ve onu öldürüp yerine geçmelisiniz!
    `,
  ],
  category: Category.Midround,
};

export default ParadoxClone;
