import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Fugitive: Antagonist = {
  key: 'fugitive',
  name: 'Fugitive',
  description: [
    multiline`
    Nereden gelirsen gel avlanacaksın. Fugitive Hunter'ları sizi ve
	arkadaşlarınızı avlamaya başlamadan hazırlanmak için 10 dakikanız var!
    `,
  ],
  category: Category.Midround,
};

export default Fugitive;
