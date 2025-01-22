import { useState } from 'react';
import { Button, ProgressBar, Section, Table } from 'tgui-core/components';
import { capitalizeAll } from 'tgui-core/string';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';
import {
  SingularityContent,
  SingularityTeslaData,
  TeslaContent,
} from './SingularityTesla';
import { SupermatterContent, SupermatterData } from './Supermatter';

type NtosSupermatterData = SupermatterData &
  SingularityTeslaData & {
    focus_uid?: string;
    eball_gas_metadata;
    all_data;
  };

export const NtosSupermatter = (props) => {
  const { act, data } = useBackend<NtosSupermatterData>();

  const {
    sm_data,
    anomaly_data,
    all_data,
    gas_metadata,
    eball_gas_metadata,
    focus_uid,
  } = data;
  const [activeUID, setActiveUID] = useState('0');
  const activeScreen = all_data.find((sm) => sm.uid === activeUID);

  return (
    <NtosWindow height={400} width={700}>
      <NtosWindow.Content>
        {activeScreen ? (
          <MonitorContent
            {...activeScreen}
            sm_gas_metadata={gas_metadata}
            eball_gas_metadata={eball_gas_metadata}
            setActiveUID={setActiveUID}
          />
        ) : (
          <>
            <Section
              title="Detected Supermatters"
              buttons={
                <Button
                  icon="sync"
                  content="Refresh"
                  onClick={() => act('PRG_refresh')}
                />
              }
            >
              <Table>
                {sm_data.map((sm) => (
                  <Table.Row key={sm.uid}>
                    <Table.Cell>{sm.id + '. ' + sm.area_name}</Table.Cell>
                    <Table.Cell collapsing color="label">
                      Integrity:
                    </Table.Cell>
                    <Table.Cell collapsing width="120px">
                      <ProgressBar
                        value={sm.integrity / 100}
                        ranges={{
                          good: [0.9, Infinity],
                          average: [0.5, 0.9],
                          bad: [-Infinity, 0.5],
                        }}
                      />
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        icon="bell"
                        color={focus_uid === sm.uid && 'yellow'}
                        onClick={() => act('PRG_focus', { focus_uid: sm.uid })}
                      />
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        content="Details"
                        onClick={() => setActiveUID(sm.uid)}
                      />
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
            {!!anomaly_data.length && (
              <Section
                title="Detected Anomalies"
                buttons={
                  <Button
                    icon="sync"
                    content="Refresh"
                    onClick={() => act('PRG_refresh')}
                  />
                }
              >
                <Table>
                  {anomaly_data.map((anomaly) => (
                    <Table.Row key={anomaly.uid}>
                      <Table.Cell>
                        {anomaly.id}. {capitalizeAll(anomaly.name)}
                      </Table.Cell>

                      <Table.Cell collapsing>
                        <Button
                          content="Details"
                          onClick={() => setActiveUID(anomaly.uid)}
                        />
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Section>
            )}
          </>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const MonitorContent = (props) => {
  const { type, sm_gas_metadata, eball_gas_metadata, setActiveUID } = props;

  return type === 'supermatter' ? (
    <SupermatterContent
      {...props}
      gas_metadata={sm_gas_metadata}
      sectionButton={
        <Button icon="arrow-left" onClick={() => setActiveUID(0)}>
          Back
        </Button>
      }
    />
  ) : type === 'energyball' ? (
    <TeslaContent
      {...props}
      gas_metadata={eball_gas_metadata}
      sectionButton={
        <Button icon="arrow-left" onClick={() => setActiveUID(0)}>
          Back
        </Button>
      }
    />
  ) : (
    <SingularityContent
      {...props}
      sectionButton={
        <Button icon="arrow-left" onClick={() => setActiveUID(0)}>
          Back
        </Button>
      }
    />
  );
};
