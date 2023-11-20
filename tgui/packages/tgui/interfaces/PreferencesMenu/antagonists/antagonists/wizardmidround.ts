import { Antagonist, Category } from '../base';
import { WIZARD_MECHANICAL_DESCRIPTION } from './wizard';

const WizardMidround: Antagonist = {
  key: 'wizardmidround',
  name: 'Wizard (Midround)',
  description: [
    'Vardiyanın ortasında hayaletlere sunulan bir çeşit büyücü.',
    WIZARD_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default WizardMidround;
