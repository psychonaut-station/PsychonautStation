import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  prefix: string;
  refresh: BooleanLike;
  token?: string;
  linked?: BooleanLike;
  display_name?: string;
  username?: string;
  discriminator?: string;
};

export const DiscordVerification = () => {
  const { data } = useBackend<Data>();
  const { prefix, token, linked, display_name, username, discriminator } = data;

  return (
    <Window title="Discord Verification" width={440} height={550}>
      <Window.Content>
        {linked ? (
          <>
            <NoticeBox info>Your account is linked to Discord.</NoticeBox>
            <Section title="Linked Account" buttons={<RefreshButton />}>
              <LabeledList>
                <LabeledList.Item label="Display name">
                  {display_name ?? 'Failed'}
                </LabeledList.Item>
                <LabeledList.Item label="Username">
                  {username ?? 'Failed'}
                </LabeledList.Item>
                <LabeledList.Item label="Discriminator">
                  {discriminator ? `#${discriminator}` : 'Failed'}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </>
        ) : (
          <>
            <NoticeBox danger>Your account is not linked to Discord.</NoticeBox>
            <Section title="Verification" buttons={<RefreshButton />}>
              <Box mb={1}>
                Your one time token is: {token}. You can verify yourself on
                Discord by using the command:
              </Box>
              <BlockQuote mb={1}>
                {prefix}verify {token}
              </BlockQuote>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const RefreshButton = () => {
  const { act, data } = useBackend<Data>();
  const { refresh } = data;

  return (
    <Button
      icon="sync"
      tooltip="Refresh"
      tooltipPosition="bottom"
      disabled={!refresh}
      onClick={() => act('refresh')}
    />
  );
};
