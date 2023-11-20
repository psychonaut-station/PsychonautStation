import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Nightmare: Antagonist = {
  key: 'nightmare',
  name: 'Nightmare',
  description: [
    multiline`
      Hayatta kalmak ve gelişmek için ışık kaynkalarını
	  ışık yiyiciniz ile kırın. Karanlıkta ilerlerken gece
	  görüşünüz ile avınızı arayın.
    `,
  ],
  category: Category.Midround,
};

export default Nightmare;
