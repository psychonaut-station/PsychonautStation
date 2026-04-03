import { CheckboxInput, type FeatureToggle } from '../base';

export const round_start_always_join_current_slot: FeatureToggle = {
  name: 'Ignore assigned character job slot at round start',
  category: 'GAMEPLAY',
  description:
    'Round start ignores the assigned character job slot and always uses the currently selected slot.',
  component: CheckboxInput,
};

export const late_join_always_current_slot: FeatureToggle = {
  name: 'Ignore assigned character job slot at late join',

  category: 'GAMEPLAY',
  description:
    'Late join ignores the assigned character job slot and always uses the currently selected slot.',
  component: CheckboxInput,
};
