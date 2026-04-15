import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { Window } from '../layouts';

export const AiOverclocking = () => {
  const { act, data } = useBackend();
  const [increment, setIncrement] = useLocalState('increment', 0.1);
  const hasCpu = !!data.has_cpu;
  const lastValues = data.last_values || [];

  const applyResult = (result) => {
    act('set_speed', { new_speed: result.speed });
    act('set_power', { new_power: result.power });
  };

  return (
    <Window width={600} height={550} resizable>
      <Window.Content scrollable>
        {!data.overclock_progress ? (
          <Section
            title="Overclocking"
            buttons={(
              <Button color="bad" icon="eject" onClick={() => act('eject_cpu')}>
                Eject CPU
              </Button>
            )}>
            {hasCpu ? (
              <>
                <Collapsible title="Past Results">
                  {!lastValues.length && (
                    <NoticeBox>
                      No previous overclock results recorded.
                    </NoticeBox>
                  )}
                  {lastValues.map((result, index) => (
                    <Section
                      key={index}
                      title={`Result #${index + 1}`}
                      buttons={(
                        <Button icon="check" onClick={() => applyResult(result)}>
                          Apply
                        </Button>
                      )}>
                      <LabeledList>
                        <LabeledList.Item label="Clock Speed">
                          {result.speed} THz
                        </LabeledList.Item>
                        <LabeledList.Item label="Power Multiplier">
                          {result.power}x
                        </LabeledList.Item>
                        <LabeledList.Item label="Valid Overclock">
                          <Box color={result.valid ? 'good' : 'bad'}>
                            {result.valid ? 'Valid' : 'Invalid'}
                          </Box>
                        </LabeledList.Item>
                      </LabeledList>
                    </Section>
                  ))}
                </Collapsible>

                <Section
                  title="Settings"
                  buttons={(
                    <Button color="good" icon="vial" onClick={() => act('test_overclock')}>
                      Test Overclock
                    </Button>
                  )}>
                  <LabeledList>
                    <LabeledList.Item label="Increment">
                      <NumberInput
                        value={increment}
                        minValue={0.1}
                        maxValue={1}
                        step={0.1}
                        onChange={(value) => setIncrement(value)} />
                    </LabeledList.Item>
                    <LabeledList.Item label="Clock Speed">
                      {data.speed} THz{' '}
                      <Button icon="minus" onClick={() => act('set_speed', { new_speed: data.speed - increment })} />
                      <NumberInput
                        value={data.speed}
                        minValue={1}
                        maxValue={10}
                        onChange={(value) => act('set_speed', { new_speed: value })} />
                      <Button icon="plus" onClick={() => act('set_speed', { new_speed: data.speed + increment })} />
                    </LabeledList.Item>
                    <LabeledList.Item label="Power Multiplier">
                      {data.power_multiplier}x ({data.power_usage} W){' '}
                      <Button
                        icon="minus"
                        onClick={() => act('set_power', {
                          new_power: Math.max(data.power_multiplier - increment, 0.5),
                        })} />
                      <NumberInput
                        value={data.power_multiplier}
                        minValue={0.5}
                        maxValue={5}
                        onChange={(value) => act('set_power', { new_power: value })} />
                      <Button icon="plus" onClick={() => act('set_power', { new_power: data.power_multiplier + increment })} />
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </>
            ) : (
              <NoticeBox>
                Please insert a CPU.
              </NoticeBox>
            )}
          </Section>
        ) : (
          <Section title="Overclocking in Progress">
            <NoticeBox>
              Overclocking...
            </NoticeBox>
            <ProgressBar value={data.overclock_progress} maxValue={1} />
            <Button
              mt={1}
              fluid
              color="bad"
              icon="trash"
              onClick={() => act('stop_overclock')}>
              Cancel
            </Button>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
