import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  LabeledList,
  Modal,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { formatPower } from 'tgui-core/format';
import { Window } from '../layouts';

export const AiRackCreator = (props, context) => {
  const { act, data } = useBackend(context);
  const [showRamModal, setShowRamModal] = useLocalState(
    context,
    'showRamModal',
    false
  );

  const cpus = data.cpus || [];
  const ram = data.ram || [];
  const unlockedCpu = data.unlocked_cpu || 1;
  const unlockedRam = data.unlocked_ram || 1;

  const cpuLocks = {
    2: 'Requires tech Improved CPU Sockets',
    3: 'Requires tech Advanced CPU Sockets',
    4: 'Requires tech Bluespace CPU Sockets',
  };

  const ramLocks = {
    2: 'Requires tech Improved Memory Bus',
    3: 'Requires tech Advanced Memory Bus',
    4: 'Requires tech Bluespace Memory Bus',
  };

  return (
    <Window width={700} height={878} resizable>
      <Window.Content scrollable>
        <Section title="Materials">
          {!data.materials?.length ? (
            <NoticeBox>
              No materials available.
            </NoticeBox>
          ) : (
            <LabeledList>
              {data.materials.map((material, index) => (
                <LabeledList.Item
                  key={index}
                  label={material.name}>
                  {material.amount}
                </LabeledList.Item>
              ))}
            </LabeledList>
          )}
        </Section>

        <Section title="Central Processing Units">
          <Stack vertical fill>
            <Stack.Item>
              <Stack>
                {[0, 1].map((cpuIndex) => {
                  const slot = cpuIndex + 1;
                  const cpu = cpus[cpuIndex];
                  const locked = slot > unlockedCpu;
                  return (
                    <Stack.Item key={slot} grow>
                      <Section title={`CPU #${slot}`}>
                        {!cpu ? (
                          <Button
                            fluid
                            color="transparent"
                            icon="microchip"
                            iconSize="4"
                            disabled={locked}
                            onClick={() => act('insert_cpu')}
                          />
                        ) : (
                          <>
                            <Button
                              fluid
                              color="transparent"
                              icon="microchip"
                              iconSize="4"
                              onClick={() =>
                                act('remove_cpu', { cpu_index: slot })
                              }
                            />
                            <LabeledList>
                              <LabeledList.Item label="Clock Speed">
                                {cpu.speed} THz
                              </LabeledList.Item>
                              <LabeledList.Item label="Power Usage">
                                {cpu.power_usage} W
                              </LabeledList.Item>
                              <LabeledList.Item label="Efficiency">
                                {cpu.efficiency}%
                              </LabeledList.Item>
                            </LabeledList>
                          </>
                        )}
                        {locked && (
                          <Dimmer>
                            <Box color="average">{cpuLocks[slot]}</Box>
                          </Dimmer>
                        )}
                      </Section>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                {[2, 3].map((cpuIndex) => {
                  const slot = cpuIndex + 1;
                  const cpu = cpus[cpuIndex];
                  const locked = slot > unlockedCpu;
                  return (
                    <Stack.Item key={slot} grow>
                      <Section title={`CPU #${slot}`}>
                        {!cpu ? (
                          <Button
                            fluid
                            color="transparent"
                            icon="microchip"
                            iconSize="4"
                            disabled={locked}
                            onClick={() => act('insert_cpu')}
                          />
                        ) : (
                          <>
                            <Button
                              fluid
                              color="transparent"
                              icon="microchip"
                              iconSize="4"
                              onClick={() =>
                                act('remove_cpu', { cpu_index: slot })
                              }
                            />
                            <LabeledList>
                              <LabeledList.Item label="Clock Speed">
                                {cpu.speed} THz
                              </LabeledList.Item>
                              <LabeledList.Item label="Power Usage">
                                {cpu.power_usage} W
                              </LabeledList.Item>
                              <LabeledList.Item label="Efficiency">
                                {cpu.efficiency}%
                              </LabeledList.Item>
                            </LabeledList>
                          </>
                        )}
                        {locked && (
                          <Dimmer>
                            <Box color="average">{cpuLocks[slot]}</Box>
                          </Dimmer>
                        )}
                      </Section>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
          </Stack>
          <Section title="Rack Statistics">
            <LabeledList>
              <LabeledList.Item label="Total CPU">
                {data.total_cpu} THz
              </LabeledList.Item>
              <LabeledList.Item label="Total RAM">
                {data.total_ram} TB
              </LabeledList.Item>
              <LabeledList.Item label="Power Usage">
                {formatPower(data.power_usage || 0)}
              </LabeledList.Item>
              <LabeledList.Item label="Weighted Efficiency">
                {data.efficiency}%
              </LabeledList.Item>
              <LabeledList.Item label="Rack Shell Cost">
                {data.rack_shell_cost || 'None'}
              </LabeledList.Item>
              <LabeledList.Item label="Finalize Cost">
                {data.total_material_cost || 'None'}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Section>

        <Section title="Random Access Memory">
          {[0, 1, 2, 3].map((ramIndex) => {
            const slot = ramIndex + 1;
            const ramStick = ram[ramIndex];
            const locked = slot > unlockedRam;
            return (
              <Section key={slot} title={`Stick #${slot}`}>
                {!ramStick ? (
                  <Button
                    fluid
                    icon="memory"
                    iconSize="3"
                    color="transparent"
                    disabled={locked}
                    onClick={() => setShowRamModal(true)}
                  />
                ) : (
                  <>
                    <Button
                      fluid
                      icon="memory"
                      iconSize="3"
                      color="transparent"
                      onClick={() =>
                        act('remove_ram', { ram_index: slot })
                      }
                    />
                    <LabeledList>
                      <LabeledList.Item label="Type">
                        {ramStick.name}
                      </LabeledList.Item>
                      <LabeledList.Item label="Capacity">
                        {ramStick.capacity} TB
                      </LabeledList.Item>
                      <LabeledList.Item label="Cost">
                        {ramStick.cost}
                      </LabeledList.Item>
                    </LabeledList>
                  </>
                )}
                {locked && (
                  <Dimmer>
                    <Box color="average">{ramLocks[slot]}</Box>
                  </Dimmer>
                )}
              </Section>
            );
          })}
        </Section>

        <Button.Confirm
          fluid
          icon="arrow-right"
          color="good"
          disabled={!data.can_finalize}
          onClick={() => act('finalize')}>
          Finalize
        </Button.Confirm>
      </Window.Content>
      {showRamModal && (
        <Modal width="600px">
          <Section title="Select RAM">
            {!(data.possible_ram || []).length && (
              <NoticeBox>No RAM designs available.</NoticeBox>
            )}
            {(data.possible_ram || []).map((ramOption, index) => (
              <Section
                key={index}
                title={ramOption.name}
                buttons={(
                  <Button
                    color="good"
                    disabled={!ramOption.unlocked}
                    tooltip={!ramOption.unlocked ? 'Not unlocked yet.' : null}
                    onClick={() => {
                      act('insert_ram', { ram_type: ramOption.id });
                      setShowRamModal(false);
                    }}>
                    Select
                  </Button>
                )}>
                <LabeledList>
                  <LabeledList.Item label="Capacity">
                    {ramOption.capacity} TB
                  </LabeledList.Item>
                  <LabeledList.Item label="Cost">
                    {ramOption.cost}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            ))}
            <Button
              fluid
              color="bad"
              icon="times"
              onClick={() => setShowRamModal(false)}>
              Cancel
            </Button>
          </Section>
        </Modal>
      )}
    </Window>
  );
};
