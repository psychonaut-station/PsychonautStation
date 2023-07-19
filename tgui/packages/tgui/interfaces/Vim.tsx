import { Window } from '../layouts';
import { useBackend } from '../backend';
import { ByondUi, Stack, Section, Box, Button, NumberInput, ProgressBar, LabeledList } from '../components';
import { toFixed } from 'common/math';


type MainData = {
  name: string;
  integrity: number;
  circuit: boolean;
  power_level: number | null;
  power_max: number | null;
  microphone: boolean;
  speaker: boolean;
  frequency: number;
  minfreq: number;
  maxfreq: number;
  mech_view: string;
};


export const Vim = (props, context) => {
  const { act, data } = useBackend<MainData>(context);
  return (
    <Window theme={'ntos'} width={500} height={400}>
      <Window.Content>
        <OperatorMode />
      </Window.Content>
    </Window>
  );
};

const OperatorMode = (props, context) => {
  const { act, data } = useBackend<MainData>(context);
  const { mech_view } = data;
  return (
    <Stack fill>
      <Stack.Item grow>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Vim View">
              <ByondUi
                height="125px"
                params={{
                  id: mech_view,
                  zoom: 5,
                  type: 'map',
                }}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Radio Control">
              <RadioPane />
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill vertical>
          <Stack.Item grow>
            <Section fill>
              <VimStatPane />
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const RadioPane = (props, context) => {
  const { act, data } = useBackend<MainData>(context);
  const { microphone, speaker, minfreq, maxfreq, frequency } = data;
  return (
    <LabeledList>
      <LabeledList.Item label="Microphone">
        <Button
          onClick={() => act('toggle_microphone')}
          selected={microphone}
          icon={microphone ? 'microphone' : 'microphone-slash'}>
          {(microphone ? 'En' : 'Dis') + 'abled'}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Speaker">
        <Button
          onClick={() => act('toggle_speaker')}
          selected={speaker}
          icon={speaker ? 'volume-up' : 'volume-mute'}>
          {(speaker ? 'En' : 'Dis') + 'abled'}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Frequency">
        <NumberInput
          animate
          unit="kHz"
          step={0.2}
          stepPixelSize={6}
          minValue={minfreq / 10}
          maxValue={maxfreq / 10}
          value={frequency / 10}
          format={(value) => toFixed(value, 1)}
          width="80px"
          onDrag={(e, value) =>
            act('set_frequency', {
              new_frequency: value,
            })
          }
        />
      </LabeledList.Item>
    </LabeledList>
  );

};

const VimStatPane = (props, context) => {
  const { act, data } = useBackend<MainData>(context);
  const { integrity } = data;
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Integrity">
              <ProgressBar
                ranges={{
                  good: [0.5, Infinity],
                  average: [0.25, 0.5],
                  bad: [-Infinity, 0.25],
                }}
                value={integrity}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Power">
              <PowerBar />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const PowerBar = (props, context) => {
  const { act, data } = useBackend<MainData>(context);
  const { power_level, power_max, circuit } = data;
    if(circuit === false) {

      return <Box content={'No Circuit board installed!'} />;

    } else if (power_max === null) {

      return <Box content={'No Power cell installed to circuit board!'} />;

    } else {
     return (
       <ProgressBar
         ranges={{
           good: [0.75 * power_max, Infinity],
           average: [0.25 * power_max, 0.75 * power_max],
           bad: [-Infinity, 0.25 * power_max],
         }}
          maxValue={power_max}
          value={power_level}
       />
     );
   }
};

