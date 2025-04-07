import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  assembled: BooleanLike;
  power: BooleanLike;
  strength_limit: number;
  strength: number;
};

export const ParticleAccelerator = (props) => {
  const { act, data } = useBackend<Data>();
  const { assembled, power, strength_limit, strength } = data;
  return (
    <Window width={350} height={185}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Status"
              buttons={
                assembled ? (
                  <Button
                    icon={'sync'}
                    content={'Disassemble'}
                    color="red"
                    onClick={() => act('disassemble')}
                  />
                ) : (
                  <Button
                    icon={'sync'}
                    content={'Assemble'}
                    color="blue"
                    onClick={() => act('assemble')}
                  />
                )
              }
            >
              <Box color={assembled ? 'good' : 'bad'}>
                {assembled
                  ? 'Particle Accelerator is assembled'
                  : 'Particle Accelerator is not assembled'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Particle Accelerator Controls">
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={power ? 'power-off' : 'times'}
                content={power ? 'On' : 'Off'}
                selected={power}
                disabled={!assembled}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Particle Strength">
              <Button
                icon="backward"
                disabled={!assembled}
                onClick={() => act('remove_strength')}
              />{' '}
              {String(strength).padStart(1, '0')}{' '}
              <Button
                icon="forward"
                disabled={!assembled}
                onClick={() => act('add_strength')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
