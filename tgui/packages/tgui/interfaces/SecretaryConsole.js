import { useBackend } from '../backend';
import { Box, NoticeBox, Button } from '../components';
import { Window } from '../layouts';

export const SecretaryConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const { emagged, canRequestSupervisor, canSendMessage } = data;

  return (
    <Window width={375} height={125} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content>
        <Box>
          <Button
            icon="comment-o"
            fluid
            disabled={!canSendMessage}
            onClick={() => act('send_centcomMessage')}
            content="Send Message To Centcom"
          />
          <Button
            icon="user-group"
            fluid
            disabled={!canRequestSupervisor}
            onClick={() => act('requestSupervisor')}
            content="Request Supervisor"
          />
        </Box>
        <Box>
          <NoticeBox info>
            Müfettiş göndermek zahmetli ve pahali bir iştir, lütfen çağirirken
            durumu tekrar gözden geçiriniz.
          </NoticeBox>
        </Box>
      </Window.Content>
    </Window>
  );
};
