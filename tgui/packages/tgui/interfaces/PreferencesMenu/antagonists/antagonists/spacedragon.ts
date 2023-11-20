import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const SpaceDragon: Antagonist = {
  key: 'spacedragon',
  name: 'Space Dragon',
  description: [
    multiline`
      Vahşi bir uzay ejderhası olun. Ateş püskürtün,
	  carplardan oluşan ordu çağırın ve istasyona terör estirin.
    `,
  ],
  category: Category.Midround,
};

export default SpaceDragon;
