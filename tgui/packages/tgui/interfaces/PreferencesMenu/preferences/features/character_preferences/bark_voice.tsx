import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import {
  type FeatureChoiced,
  type FeatureChoicedServerData,
  type FeatureNumeric,
  FeatureSliderInput,
  type FeatureValueProps,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

function FeatureBarkVoiceDropdownInput(
  props: FeatureValueProps<string, string, FeatureChoicedServerData>,
) {
  const { act } = useBackend();

  return (
    <Stack>
      <Stack.Item grow>
        <FeatureDropdownInput {...props} />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_bark');
          }}
          icon="play"
          tooltip="Preview Voice"
        />
      </Stack.Item>
    </Stack>
  );
}

export const bark_speech_speed: FeatureNumeric = {
  name: 'Bark Speed',
  component: FeatureSliderInput,
};

export const voice_pack: FeatureChoiced = {
  name: 'Bark Voice Pack',
  component: FeatureBarkVoiceDropdownInput,
};

export const bark_speech_pitch: FeatureNumeric = {
  name: 'Bark Pitch',
  component: FeatureSliderInput,
};

export const bark_pitch_range: FeatureNumeric = {
  name: 'Bark Pitch Variance',
  component: FeatureSliderInput,
};
