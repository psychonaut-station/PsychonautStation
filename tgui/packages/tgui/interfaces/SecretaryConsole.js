import { useBackend } from '../backend';
import { Box, NoticeBox, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const SecretaryConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const { emagged, canRequestSupervisor, canSendMessage } = data;

  return (
    <Window width={375} height={145} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Section>
                  <Box>
                    <Button
                      icon="comment-o"
                      fluid
                      disabled={!canSendMessage}
                      onClick={() => act('send_Message')}
                      content="Send Message To Centcom"
                    />
                  </Box>
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section>
                  <Box>
                    <Button
                      icon="user-group"
                      fluid
                      disabled={!canRequestSupervisor}
                      onClick={() => act('requestSupervisor')}
                      content="Request Supervisor"
                    />
                  </Box>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section>
              <Box>
                <Box>
                  <NoticeBox info>
                    Müfettiş göndermek zahmetli ve pahali bir iştir, lütfen
                    çağirirken durumu tekrar gözden geçiriniz.
                  </NoticeBox>
                </Box>
              </Box>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
