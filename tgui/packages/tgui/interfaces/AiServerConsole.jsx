import {
  Box,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const AiServerConsole = (props) => {
  const { data } = useBackend();
  const servers = data.servers || [];

  return (
    <Window width={500} height={450} resizable>
      <Window.Content scrollable>
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
                {server.temp} K
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
