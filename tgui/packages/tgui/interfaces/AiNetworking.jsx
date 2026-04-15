import { Fragment } from 'react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from 'tgui-core/components';
import { Window } from '../layouts';

export const AiNetworking = (props, context) => {
  const { act, data } = useBackend(context);

  if (data.locked) {
    return (
      <Window width={500} height={450} resizable>
        <Window.Content scrollable>
          <Section title="Lockscreen">
            <NoticeBox textAlign="center" danger>
              Machine locked
            </NoticeBox>
            <Box textAlign="center">
              <Button
                icon="lock-open"
                color="good"
                onClick={() => act('toggle_lock')}>
                Unlock
              </Button>
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={500} height={450} resizable>
      <Window.Content scrollable>
        <Section
          title={`Networking | ${data.label}`}
          buttons={(
            <>
              <Button
                icon="lock"
                color="bad"
                onClick={() => act('toggle_lock')}>
                Lock
              </Button>
              <Button icon="pen" onClick={() => act('switch_label')}>
                Set Label
              </Button>
            </>
          )}>
          <LabeledList>
            {data.possible_targets.map((target, index) => (
              data.is_connected === target ? (
                <Fragment key={index}>
                  <LabeledList.Item
                    label={target}
                    buttons={(
                      <Button
                        icon="eject"
                        color="bad"
                        disabled={!data.is_connected}
                        onClick={() => act('disconnect')}>
                        Disconnect
                      </Button>
                    )}
                  />
                  <LabeledList.Divider />
                </Fragment>
              ) : (
                <Fragment key={index}>
                  <LabeledList.Item
                    label={target}
                    buttons={(
                      <Button
                        icon="wifi"
                        disabled={!!data.is_connected}
                        onClick={() => act('connect', { target_label: target })}>
                        Connect
                      </Button>
                    )}
                  />
                  <LabeledList.Divider />
                </Fragment>
              )
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
