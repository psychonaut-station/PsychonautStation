import { useState } from 'react';
import { Button, Stack, TextArea } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const Mentorhelp = (props) => {
  const { act } = useBackend();
  const [mhelpMessage, setMhelpMessage] = useState('');

  return (
    <Window title="Create Mentorhelp" theme="admin" height={300} width={500}>
      <Window.Content
        style={{
          backgroundImage: 'none',
        }}
      >
        <Stack vertical fill>
          <Stack.Item grow>
            <TextArea
              autoFocus
              height="100%"
              value={mhelpMessage}
              placeholder="Mentor help"
              onChange={setMhelpMessage}
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
