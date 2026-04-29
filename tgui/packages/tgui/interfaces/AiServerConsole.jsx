import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const AiServerConsole = (props) => {
  const { act, data } = useBackend();
  const servers = data.servers || [];
  const revivalJobs = data.revival_jobs || [];

  return (
    <Window width={560} height={560} resizable>
      <Window.Content scrollable>
        <Section
          title="AI Network Control"
          buttons={(
            <>
              <Button
                icon="heart-pulse"
                color="good"
                disabled={!data.has_ai_net || !revivalJobs.length}
                onClick={() => act('enable_revival')}>
                Prioritize Revival
              </Button>
              <Button
                icon="ban"
                disabled={!data.has_ai_net || !data.revival_cpu}
                onClick={() => act('disable_revival')}>
                Stop Revival
              </Button>
            </>
          )}>
          {!data.has_ai_net && (
            <NoticeBox>
              No AI network connection. Place this console on an ethernet cable
              connected to the AI hardware network.
            </NoticeBox>
          )}
          {!!data.has_ai_net && (
            <LabeledList>
              <LabeledList.Item label="Network">{data.network_name}</LabeledList.Item>
              <LabeledList.Item label="Network CPU">
                {((data.network_assigned_cpu || 0) * 100).toFixed(1)}%
                {' '}({((data.total_cpu || 0) * (data.network_assigned_cpu || 0)).toFixed(1)} THz)
              </LabeledList.Item>
              <LabeledList.Item label="Revival CPU">
                {((data.revival_cpu || 0) * 100).toFixed(1)}%
              </LabeledList.Item>
            </LabeledList>
          )}
        </Section>
        <Section title="Volatile Neural Core Recovery">
          {!revivalJobs.length && (
            <NoticeBox>
              No volatile neural cores are inserted into connected AI data cores.
            </NoticeBox>
          )}
          {revivalJobs.map((job, index) => (
            <Section key={index} title={job.name}>
              <Box>
                Location: <Box inline bold>{job.area}</Box> ({job.coords})
              </Box>
              <ProgressBar
                value={job.progress}
                maxValue={job.required || 1}
                ranges={{
                  good: [(job.required || 1) * 0.75, Infinity],
                  average: [(job.required || 1) * 0.35, (job.required || 1) * 0.75],
                  bad: [-Infinity, (job.required || 1) * 0.35],
                }}>
                {job.progress.toFixed(1)} / {job.required} reconstruction
              </ProgressBar>
              <ProgressBar
                value={job.integrity}
                maxValue={100}
                ranges={{
                  good: [50, Infinity],
                  average: [20, 50],
                  bad: [-Infinity, 20],
                }}>
                {job.integrity}% neural integrity
              </ProgressBar>
            </Section>
          ))}
        </Section>
        <Section title="Server Overview">
          {!servers.length && (
            <NoticeBox>
              No server cabinets detected on the AI network.
            </NoticeBox>
          )}
          {servers.map((server, index) => (
            <Section key={index}>
              <Box textAlign="center">
                Location: <Box inline bold>{server.area}</Box>
              </Box>
              <Box textAlign="center">
                Status:{' '}
                <Box inline bold color={server.working ? 'good' : 'bad'}>
                  {server.working ? 'ONLINE' : 'OFFLINE'}
                </Box>
              </Box>
              <ProgressBar
                ranges={{
                  good: [-Infinity, 250],
                  average: [250, 750],
                  bad: [750, Infinity],
                }}
                value={server.temp}
                maxValue={750}>
                Core: {server.temp} K / Room: {server.ambient_temp} K
              </ProgressBar>
              <Box textAlign="center">
                Capacity: <Box inline bold>{server.card_capacity} racks</Box>
              </Box>
              <Box textAlign="center">
                CPU Power: <Box inline bold>{server.total_cpu} THz</Box>
              </Box>
              <Box textAlign="center">
                RAM Capacity: <Box inline bold>{server.ram} TB</Box>
              </Box>
            </Section>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
