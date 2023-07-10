import { Feature, FeatureChoiced, FeatureDropdownInput, FeatureShortTextInput } from '../base';

export const pettype: FeatureChoiced = {
  name: 'Pet Type',
  category: 'GAMEPLAY',
  description: 'What is your pet type',
  component: FeatureDropdownInput,
};
