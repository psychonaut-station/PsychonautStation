import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { TextArea, Stack, Button, NoticeBox, Input, Box } from '../components';
import { Window } from '../layouts';

type MentorhelpData = {
  adminCount: number;
};

export const Mentorhelp = (props, context) => {
  const { act, data } = useBackend<MentorhelpData>(context);
  const {
    adminCount,
  } = data;
  const [mhelpMessage, setMhelpMessage] = useLocalState(
    context,
    'ahelp_message',
    ''
  );

  return (
    <Window title="Create Ticket" theme="admin" height={300} width={500}>
      <Window.Content
        style={{
          'background-image': 'none',
        }}>
        <Stack vertical fill>
          <Stack.Item grow>
            <TextArea
              autoFocus
              height="100%"
              value={mhelpMessage}
              placeholder="Mentor help"
              onChange={(e, value) => setMhelpMessage(value)}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              color="good"
              fluid
              content="Submit"
              textAlign="center"
              onClick={() =>
                act('mhelp', {
                  message: mhelpMessage,
                })
              }
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
