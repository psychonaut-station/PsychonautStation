import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const MALF_AI_MECHANICAL_DESCRIPTION = multiline`
    Her ne pahasına olursa olsun hedeflerinizi tamamlamak için sıfır
	yasasıyla, istasyonda hasara yol açmak için her şeye kadir gücünüzü ve
	arızalanmış mödüllerinizi birleştirin. İstasyonu ve size karşı çıkan
	herkesi yok etmek için deltaya ilerleyin.
  `;

const MalfAI: Antagonist = {
  key: 'malfai',
  name: 'Malfunctioning AI',
  description: [MALF_AI_MECHANICAL_DESCRIPTION],
  category: Category.Roundstart,
};

export default MalfAI;
