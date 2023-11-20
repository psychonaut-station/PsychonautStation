import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const REVOLUTIONARY_MECHANICAL_DESCRIPTION = multiline`
      Bir flaşla donanarak, olabildiğince çok insanı devrimci yapın.
	  İstasyondaki tüm personel şeflerini öldürün ya da sürgüne yollayın.
   `;

const HeadRevolutionary: Antagonist = {
  key: 'headrevolutionary',
  name: 'Head Revolutionary',
  description: ['VIVA LA REVOLUTION!', REVOLUTIONARY_MECHANICAL_DESCRIPTION],
  category: Category.Roundstart,
};

export default HeadRevolutionary;
