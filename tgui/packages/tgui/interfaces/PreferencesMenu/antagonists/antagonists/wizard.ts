import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const WIZARD_MECHANICAL_DESCRIPTION = multiline`
      Space Station 13'e kaosa sebebiyet vermek için çeşitli
	  büyüler arasından bir seçim yapın!
    `;

const Wizard: Antagonist = {
  key: 'wizard',
  name: 'Wizard',
  description: [
    `"SELAMLAR. BİZ BÜYÜCÜLER FEDERASYONUNUN BÜYÜCÜLERİYİZ."`,
    WIZARD_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Wizard;
