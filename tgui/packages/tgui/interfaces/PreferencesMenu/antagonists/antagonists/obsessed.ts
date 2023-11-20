import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Obsessed: Antagonist = {
  key: 'obsessed',
  name: 'Obsessed',
  description: [
    multiline`
    Birine kafayı taktın! Takıntın, kişisel eşyaların
	çalındığını ve iş arkadaşlarının kaybolduğunu gören
	arkadaşlarınız tarafından fark edilebilir, ancak bir
	sonraki kurbanınız olduğunu zamanında fark edecekler mi?
    `,
  ],
  category: Category.Midround,
};

export default Obsessed;
