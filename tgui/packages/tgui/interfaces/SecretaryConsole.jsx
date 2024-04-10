import { useBackend } from '../backend';
import { Box, Button, NoticeBox } from '../components';
import { Window } from '../layouts';

export const SecretaryConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    emagged,
    canRequestSupervisor,
    canSendMessage,
    SupervisorRequestCooldown,
    MessageSendCooldown,
  } = data;

  return (
    <Window width={375} height={130} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content>
        <Box>
          <Button
            icon="comment-o"
            fluid
            disabled={!canSendMessage}
            onClick={() => act('send_message')}
            content={
              canSendMessage
                ? `Send Message To Centcom`
                : `Send Message To Centcom - ${MessageSendCooldown}`
            }
          />
          <Button
            icon="user-group"
            fluid
            disabled={!canRequestSupervisor}
            onClick={() => act('request_supervisor')}
            content={
              canRequestSupervisor
                ? `Request Supervisor`
                : `Request Supervisor - ${SupervisorRequestCooldown}`
            }
          />
        </Box>
        <Box style={{ margin: '5px 0px 0px 0px' }}>
          <NoticeBox info>
            Müfettiş göndermek zahmetli ve pahali bir iştir, lütfen çağirirken
            durumu tekrar gözden geçiriniz.
          </NoticeBox>
        </Box>
      </Window.Content>
    </Window>
  );
};
