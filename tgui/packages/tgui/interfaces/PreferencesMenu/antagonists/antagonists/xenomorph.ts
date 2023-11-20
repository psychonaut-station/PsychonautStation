import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Xenomorph: Antagonist = {
  key: 'xenomorph',
  name: 'Xenomorph',
  description: [
    multiline`
      Dünya dışı xenomorph olun. Bir larva olarak
	  başlayın ve kraliçe de dahil olmak üzere kasta ilerleyin!
    `,
  ],
  category: Category.Midround,
};

export default Xenomorph;
