import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Revenant: Antagonist = {
  key: 'revenant',
  name: 'Revenant',
  description: [
    multiline`
      Gizemli bir hortlak olun. Camları kırın ışıkları aşırı yüklenin
	  ve mürettebatın hayat enerjisini yiyin, tüm bunları yaparken de
	  hoşnutsuz hayaletlerden oluşan eski topluluğunuzla konuşun.
    `,
  ],
  category: Category.Midround,
};

export default Revenant;
