import {
  type FeatureChoiced,
  type FeatureNumeric,
  FeatureSliderInput,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const voice_pack: FeatureChoiced = {
  name: 'Voice Pack',
  component: FeatureDropdownInput,
};

export const bark_speech_speed: FeatureNumeric = {
  name: 'Bark Speed',
  component: FeatureSliderInput,
};

export const bark_speech_pitch: FeatureNumeric = {
  name: 'Bark Pitch',
  component: FeatureSliderInput,
};

export const bark_pitch_range: FeatureNumeric = {
  name: 'Bark Pitch Variance',
  component: FeatureSliderInput,
};
