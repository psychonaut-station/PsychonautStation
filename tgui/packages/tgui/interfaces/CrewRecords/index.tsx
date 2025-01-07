import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Icon, NoticeBox, Stack } from 'tgui-core/components';

import { CrewRecordTabs } from './RecordTabs';
import { CrewRecordView } from './RecordView';
import { CrewRecordData } from './types';

export const CrewRecordsContent = (props) => {
  const { act, data } = useBackend<CrewRecordData>();
  const { authenticated } = data;

  return (
    <Stack fill>{!authenticated ? <UnauthorizedView /> : <AuthView />}</Stack>
  );
};

export const CrewRecords = (props) => {
  const { data } = useBackend<CrewRecordData>();
  const { authenticated } = data;

  return (
    <Window title="Crew Records" width={750} height={550}>
      <Window.Content>
        <CrewRecordsContent />
      </Window.Content>
    </Window>
  );
};

const UnauthorizedView = (props) => {
  const { act } = useBackend<CrewRecordData>();

  return (
    <Stack.Item grow>
      <Stack fill vertical>
        <Stack.Item grow />
        <Stack.Item align="center" grow={2}>
          <Icon color="blue" name="clipboard-user" size={15} />
        </Stack.Item>
        <Stack.Item align="center" grow>
          <Box color="good" fontSize="18px" bold mt={5}>
            Nanotrasen CrewPRO
          </Box>
        </Stack.Item>
        <Stack.Item>
          <NoticeBox align="right">
            You are not logged in.
            <Button ml={2} icon="lock-open" onClick={() => act('login')}>
              Login
            </Button>
          </NoticeBox>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const AuthView = (props) => {
  const { act } = useBackend<CrewRecordData>();

  return (
    <>
      <Stack.Item grow>
        <CrewRecordTabs />
      </Stack.Item>
      <Stack.Item grow={2}>
        <Stack fill vertical>
          <Stack.Item grow>
            <CrewRecordView />
          </Stack.Item>
          <Stack.Item>
            <NoticeBox align="right" info>
              Secure Your Workspace.
              <Button
                align="right"
                icon="lock"
                color="good"
                ml={2}
                onClick={() => act('logout')}
              >
                Log Out
              </Button>
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
};
