import {
  Button,
  Dropdown,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Lobby = {
  name: string;
  players: number;
  map: string;
  playing: BooleanLike;
};

type Data = {
  hosting: BooleanLike;
  admin: BooleanLike;
  playing: string;
  lobbies: Lobby[];
};

export function TeammatchPanel(props) {
  const { act, data } = useBackend<Data>();
  const { hosting } = data;

  return (
    <Window title="Teammatch Lobbies" width={450} height={400}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <NoticeBox danger>
              If you play, you can still possibly be returned to your body (No
              Guarantees)!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item grow>
            <LobbyPane />
          </Stack.Item>
          <Stack.Item>
            <Button
              disabled={!!hosting}
              fluid
              textAlign="center"
              color="good"
              onClick={() => act('host')}
            >
              Create Lobby
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}

function LobbyPane(props) {
  const { data } = useBackend<Data>();
  const { lobbies = [] } = data;

  return (
    <Section fill scrollable>
      <Table>
        <Table.Row header>
          <Table.Cell>Host</Table.Cell>
          <Table.Cell>Scenerio</Table.Cell>
          <Table.Cell>Map</Table.Cell>
          <Table.Cell>
            <Tooltip content="Players">
              <Icon name="users" />
            </Tooltip>
          </Table.Cell>
          <Table.Cell align="center">
            <Icon name="hammer" />
          </Table.Cell>
        </Table.Row>

        {lobbies.length === 0 && (
          <Table.Row>
            <Table.Cell colSpan={5}>
              <NoticeBox textAlign="center">
                No lobbies found. Start one!
              </NoticeBox>
            </Table.Cell>
          </Table.Row>
        )}

        {lobbies.map((lobby, index) => (
          <LobbyDisplay key={index} lobby={lobby} />
        ))}
      </Table>
    </Section>
  );
}

function LobbyDisplay(props) {
  const { act, data } = useBackend<Data>();
  const { admin, playing, hosting } = data;
  const { lobby } = props;

  return (
    <Table.Row className="candystripe" key={lobby.name}>
      <Table.Cell>
        {!admin ? (
          lobby.name
        ) : (
          <Dropdown
            width={10}
            noChevron
            selected={lobby.name}
            options={['Close', 'View']}
            onSelected={(value) =>
              act('admin', {
                id: lobby.name,
                func: value,
              })
            }
          />
        )}
      </Table.Cell>
      <Table.Cell>{lobby.scenerio}</Table.Cell>
      <Table.Cell>{lobby.map}</Table.Cell>
      <Table.Cell collapsing>{lobby.players}</Table.Cell>
      <Table.Cell collapsing>
        <Button
          color="good"
          onClick={() => act('view', { id: lobby.name })}
          width="100%"
          textAlign="center"
        >
          View
        </Button>
      </Table.Cell>
    </Table.Row>
  );
}
