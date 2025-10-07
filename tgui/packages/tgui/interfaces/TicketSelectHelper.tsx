import { Box, Button, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const TicketSelectHelper = (props) => {
  const { act } = useBackend();

  return (
    <Window title="Adminhelp..." theme="ntos_darkmode" height={300} width={500}>
      <Window.Content
        style={{
          backgroundImage: 'none',
        }}
      >
        <Stack vertical fill>
          <Stack.Item>
            <Box textAlign="center" mt={1} fontSize="16px">
              Herhangi bir meslek, oyun mekaniği gibi şeylerden yardım almak
              için;
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Button
              color="good"
              fluid
              lineHeight="46px"
              fontSize="30px"
              content="Mentor Ticket"
              textAlign="center"
              onClick={() => act('ticket_mentor')}
            />
          </Stack.Item>
          <Stack.Item className="TicketSelectHelper__seperator" />
          <Stack.Item>
            <Box textAlign="center" mt={1} fontSize="16px">
              Bir konu hakkında şikayetçi olmak için;
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Button
              color="bad"
              fluid
              lineHeight="46px"
              fontSize="30px"
              content="Admin Ticket"
              textAlign="center"
              onClick={() => act('ticket_admin')}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
