import { filter, sortBy } from 'common/collections';
import { ReactNode, useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';
import { capitalizeAll } from 'tgui-core/string';

import { getGasFromPath } from '../constants';

const logScale = (value) => Math.log2(16 + Math.max(0, value)) - 4;

type EballGasMetadata = {
  [key: string]: {
    desc?: string;
    numeric_data: {
      name: string;
      amount: number;
      unit: string;
      positive: BooleanLike;
    }[];
  };
};

type TeslaProps = {
  sectionButton?: ReactNode;
  name: string;
  type: string;
  id: number;
  uid: string;
  energy: number;
  energy_to_lower: number;
  energy_to_raise: number;
  orbiting_balls: number;
  zap_energy: number;
  absorbed_ratio: number;
  gas_composition: { [gas_path: string]: number };
  gas_temperature: number;
  gas_total_moles: number;
  gas_metadata: EballGasMetadata;
};

type SingularityProps = {
  sectionButton?: ReactNode;
  name: string;
  type: string;
  id: number;
  uid: string;
  current_size: number;
  energy: number;
  dissipate_delay: number;
  dissipate_strength: number;
  radiation_pulse: number;
  energy_to_lower: number;
  energy_to_raise: number;
};

// LabeledList but stack and with a chevron dropdown.
type EntryProps = {
  title: string;
  content: ReactNode;
  detail?: ReactNode;
  alwaysShowChevron?: boolean;
};

const EntryData = (props: EntryProps) => {
  const { title, content, detail, alwaysShowChevron } = props;
  if (!alwaysShowChevron && !detail) {
    return (
      <Stack.Item>
        <Stack align="center">
          <Stack.Item color="grey" width="125px">
            {title + ':'}
          </Stack.Item>
          <Stack.Item grow>{content}</Stack.Item>
        </Stack>
      </Stack.Item>
    );
  }

  const [activeDetail, setActiveDetail] = useState(false);

  return (
    <>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item color="grey" width="125px">
            {title + ':'}
          </Stack.Item>
          <Stack.Item grow>{content}</Stack.Item>
          <Stack.Item>
            <Button
              onClick={() => setActiveDetail(!activeDetail)}
              icon={activeDetail ? 'chevron-up' : 'chevron-down'}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {activeDetail && !!detail && <Stack.Item pl={3}>{detail}</Stack.Item>}
    </>
  );
};

export type SingularityTeslaData = {
  anomaly_data: Omit<
    TeslaProps & SingularityProps,
    'sectionButton' | 'gas_metadata'
  >[];
};

export const SingularityContent = (props: SingularityProps) => {
  const {
    sectionButton,
    name,
    type,
    id,
    uid,
    current_size,
    energy,
    dissipate_delay,
    dissipate_strength,
    radiation_pulse,
    energy_to_lower,
    energy_to_raise,
  } = props;

  return (
    <Stack height="100%">
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title={id + '. ' + capitalizeAll(name)}
          buttons={sectionButton}
        >
          <Stack vertical>
            <EntryData
              title="Energy"
              alwaysShowChevron
              content={
                <ProgressBar
                  value={
                    ((energy - energy_to_lower) /
                      (energy_to_raise - energy_to_lower)) *
                    100
                  }
                  minValue={0}
                  maxValue={100}
                >
                  {energy}
                </ProgressBar>
              }
              detail={
                <LabeledList>
                  <LabeledList.Item
                    key="energy_to_lower"
                    label="Energy To Lower"
                    labelWrap
                  >
                    <Box>{toFixed(energy_to_lower, 2)}</Box>
                  </LabeledList.Item>
                  <LabeledList.Item
                    key="energy_to_raise"
                    label="Energy To Raise"
                    labelWrap
                  >
                    <Box>{toFixed(energy_to_raise, 2)}</Box>
                  </LabeledList.Item>
                </LabeledList>
              }
            />
            <EntryData title="Current Size" content={current_size} />
            <EntryData title="Dissipate Delay" content={dissipate_delay} />
            <EntryData
              title="Dissipate Strength"
              content={dissipate_strength}
            />
            <EntryData
              title="Radiation Pulse"
              content={radiation_pulse + ' R'}
            />
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const TeslaContent = (props: TeslaProps) => {
  const {
    sectionButton,
    name,
    type,
    id,
    uid,
    energy,
    orbiting_balls,
    energy_to_lower,
    energy_to_raise,
    zap_energy,
    absorbed_ratio,
    gas_temperature,
    gas_total_moles,
    gas_metadata,
  } = props;
  const [allGasActive, setAllGasActive] = useState(false);
  let gas_composition = Object.entries(props.gas_composition);
  if (!allGasActive) {
    gas_composition = filter(
      gas_composition,
      ([gas_path, amount]) => amount !== 0,
    );
  }
  gas_composition = sortBy(gas_composition, ([gas_path, amount]) => -amount);

  return (
    <Stack height="100%">
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title={id + '. ' + capitalizeAll(name)}
          buttons={sectionButton}
        >
          <Stack vertical>
            <EntryData
              title="Energy"
              alwaysShowChevron
              content={
                <ProgressBar
                  value={
                    ((energy - energy_to_lower) /
                      (energy_to_raise - energy_to_lower)) *
                    100
                  }
                  minValue={0}
                  maxValue={100}
                >
                  {energy}
                </ProgressBar>
              }
              detail={
                <LabeledList>
                  <LabeledList.Item
                    key="energy_to_lower"
                    label="Energy To Lower"
                    labelWrap
                  >
                    <Box>{toFixed(energy_to_lower, 2)}</Box>
                  </LabeledList.Item>
                  <LabeledList.Item
                    key="energy_to_raise"
                    label="Energy To Raise"
                    labelWrap
                  >
                    <Box>{toFixed(energy_to_raise, 2)}</Box>
                  </LabeledList.Item>
                </LabeledList>
              }
            />
            <EntryData
              title="Zap Energy"
              content={
                zap_energy > 1000000
                  ? `${zap_energy / 1000000} MJ`
                  : `${zap_energy / 100000} KJ`
              }
            />
            <EntryData title="Orbiting Balls" content={orbiting_balls} />
            <EntryData
              title="Absorbed Moles"
              content={
                <ProgressBar
                  value={gas_total_moles}
                  minValue={0}
                  maxValue={2000}
                  ranges={{
                    good: [0, 900],
                    average: [900, 1800],
                    bad: [1800, Infinity],
                  }}
                >
                  {toFixed(gas_total_moles, 2) + ' Moles'}
                </ProgressBar>
              }
            />
            <EntryData
              title="Temperature"
              content={
                <ProgressBar
                  value={logScale(gas_temperature)}
                  minValue={0}
                  maxValue={logScale(10000)}
                >
                  {toFixed(gas_temperature, 2) + ' K'}
                </ProgressBar>
              }
            />
            <EntryData
              title="Absorption Ratio"
              content={absorbed_ratio * 100 + '%'}
            />
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="Gases"
          buttons={
            <Button
              icon={allGasActive ? 'times' : 'book-open'}
              onClick={() => setAllGasActive(!allGasActive)}
            >
              {allGasActive ? 'Hide Gases' : 'Show All Gases'}
            </Button>
          }
        >
          <Stack vertical>
            {gas_composition.map(([gas_path, amount]) => (
              <EntryData
                key={gas_path}
                title={getGasFromPath(gas_path)?.label || 'Unknown'}
                content={
                  <ProgressBar
                    color={getGasFromPath(gas_path)?.color}
                    value={amount}
                    minValue={0}
                    maxValue={1}
                  >
                    {toFixed(amount * 100, 2) + '%'}
                  </ProgressBar>
                }
                detail={
                  gas_metadata[gas_path] ? (
                    <>
                      {gas_metadata[gas_path].desc && <br />}
                      {gas_metadata[gas_path].numeric_data.length ? (
                        <>
                          <Box mb={1}>
                            At <b>100% Composition</b> gives:
                          </Box>
                          <LabeledList>
                            {gas_metadata[gas_path].numeric_data.map(
                              (effect) =>
                                effect.amount !== 0 && (
                                  <LabeledList.Item
                                    key={gas_path + effect.name}
                                    label={effect.name}
                                    color={
                                      effect.positive
                                        ? effect.amount > 0
                                          ? 'green'
                                          : 'red'
                                        : effect.amount < 0
                                          ? 'green'
                                          : 'red'
                                    }
                                  >
                                    {effect.amount > 0
                                      ? '+' + effect.amount + effect.unit
                                      : effect.amount + effect.unit}
                                  </LabeledList.Item>
                                ),
                            )}
                          </LabeledList>
                        </>
                      ) : (
                        'Has no composition effects'
                      )}
                    </>
                  ) : (
                    'Has no effects'
                  )
                }
              />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
