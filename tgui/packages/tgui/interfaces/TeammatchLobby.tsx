import {
  Box,
  Button,
  Divider,
  Dropdown,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Player = {
  host: number;
  key: string;
  loadout: string;
  ready: BooleanLike;
  mob: string;
  team: string;
};

type Modifier = {
  desc: string;
  modpath: string;
  name: string;
  player_selectable: BooleanLike;
  player_selected: BooleanLike;
  selectable: BooleanLike;
  selected: BooleanLike;
};

type Map = {
  desc: string;
  name: string;
};

type Scenerio = {
  name: string;
  desc: string;
};

type Team = {
  name: string;
  color: string;
  loadouts: string[];
  min_players: number;
  max_players: number;
  is_active: BooleanLike;
}

const enum PlayingStatus {
  NonPlaying,
  PrePlaying,
  Playing
}

type Data = {
  admin: BooleanLike;
  host: BooleanLike;
  scenerio: Scenerio;
  scenerios: string[];
  map: Map;
  maps: string[];
  modifiers: Modifier[];
  observers: Player[];
  players: Player[];
  playing: PlayingStatus;
  self: string;
  my_team?: string;

  can_respawn: BooleanLike;
  respawn_timeleft: number;

  teams: Record<string, Team>;
};

export function TeammatchLobby(props) {
  const { act, data } = useBackend<Data>();
  const {
    admin,
    host,
    observers = [],
    players = [],
    self,
    teams,
    can_respawn,
    respawn_timeleft,
  } = data;

  const allReady = players.every((player) => player.ready);
  const fullAccess = !!host || !!admin;
  const isObserver = observers.find((observer) => observer.key === self);

  const teamEntries = Object.entries(teams).slice(0, 4);
  const leftSideTeams = teamEntries.filter((_, index) => index % 2 === 0);
  const rightSideTeams = teamEntries.filter((_, index) => index % 2 !== 0);

  return (
    <Window title="Teammatch Lobby" width={900} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow={1} width="35%">
                {leftSideTeams.map(([teamKey, teamData]) => {
                  const teamPlayers = players.filter((p) => p.team === teamKey);
                  return (
                    <TeamColumn
                      team={teamData}
                      teamId={teamKey}
                      players={teamPlayers}
                      key={teamKey}
                    />
                  )
                })}
              </Stack.Item>

              <Stack.Item grow={1} width="30%">
                <Stack fill vertical>
                  <Stack.Item>
                    <HostControls />
                  </Stack.Item>
                  <Stack.Item grow>
                    <ObserverColumn observers={observers} />
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item grow={1} width="35%">
                {rightSideTeams.map(([teamKey, teamData]) => {
                  const teamPlayers = players.filter((p) => p.team === teamKey);
                  return (
                    <TeamColumn
                      team={teamData}
                      teamId={teamKey}
                      players={teamPlayers}
                      key={teamKey}
                    />
                  )
                })}
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Stack fill>
                <Stack.Item grow>
                  {!!admin && (
                    <Button
                      icon="exclamation"
                      color="caution"
                      onClick={() => act('admin', { func: 'Force start' })}
                    >
                      Force Start
                    </Button>
                  )}
                  <Button
                    icon="exclamation"
                    color="good"
                    onClick={() => act('respawn')}
                    disabled={!can_respawn}
                  >
                    Respawn {respawn_timeleft > 0 && `(${respawn_timeleft})`}
                  </Button>

                </Stack.Item>
                <Stack.Item>
                  <Button color="bad" onClick={() => act('leave_game')}>
                    Leave Game
                  </Button>
                  <Button
                    color="good"
                    disabled={!allReady}
                    onClick={() => act('start_game')}
                  >
                    Start Game
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}

type TeamColumnProps = {
  team: Team;
  teamId: string;
  players: Player[];
}

function TeamColumn(props: TeamColumnProps) {
  const { teamId, team, players } = props;
  const { act, data } = useBackend<Data>();

  const { admin, host, self, playing, observers, players: allPlayers = [], teams } = data;

  const fullAccess = !!host || !!admin;

  const myPlayerObj = allPlayers.find((p) => p.key === self);
  const isMyTeam = myPlayerObj?.team === teamId;
  const isObserver = observers.find((observer) => observer.key === self);

  return (
    <Section
      title={`${team.name} (${players.length}${team.max_players != -1 ? `/${team.max_players}` : ''})`}
      fill
      scrollable={players.length > 20}
    >
      {players.length === 0 ? (
        <NoticeBox align="center">There is no player in this team</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell collapsing />
            <Table.Cell>Name</Table.Cell>
            <Table.Cell collapsing align="center">
              <Icon name="check" />
            </Table.Cell>
          </Table.Row>
          {players.map((player) => {
            const isHost = !!player.host;
            const isSelf = player.key === self;
            const canBoot = fullAccess && !isSelf;

            const dropdownMoveOptions: Record<string, string> = {};

            Object.entries(teams).forEach(([teamId, teamData]) => {
              if (teamId !== player.team) {
                const moveText = `Move To ${teamData.name}`;
                dropdownMoveOptions[moveText] = teamId;
              }
            });
            const dropdownBaseOptions = ['Kick', 'Transfer host', 'Observer'];
            const dropdownOptions = [...dropdownBaseOptions, ...Object.keys(dropdownMoveOptions)];

            return (
              <Table.Row className="candystripe" key={player.key}>
                <Table.Cell align="center" collapsing verticalAlign="top">
                  {isHost && (
                    <Tooltip content="Host">
                      <Icon color="gold" name="star" pt={isSelf && 0.5} />
                    </Tooltip>
                  )}
                  {!host && isSelf && (
                    <Tooltip content="You">
                      <Icon color="green" name="arrow-right" pt={0.9} />
                    </Tooltip>
                  )}
                </Table.Cell>

                <Table.Cell verticalAlign="top" pt={!isHost && '2px'}>
                  {!canBoot ? (
                    <Box color={isSelf ? 'good' : 'label'}>{player.key}</Box>
                  ) : (
                    <Dropdown
                      width={10}
                      selected={player.key}
                      options={dropdownOptions}
                      onSelected={(value) => {
                        const options: {id: string, func: string, team?: string} = {
                          id: player.key,
                          func: value
                        }
                        if (dropdownMoveOptions[value]) {
                          const targetTeamId = dropdownMoveOptions[value]
                          options.func = 'change_team'
                          options.team = targetTeamId
                        }
                        act('host', options);
                      }}
                    />
                  )}
                </Table.Cell>

                <Table.Cell>
                {!isSelf ? (
                  <Box color="label">{player.loadout}</Box>
                ) : (
                  <Dropdown
                    width={10}
                    selected={player.loadout}
                    disabled={!host && !isSelf}
                    options={team.loadouts}
                    onSelected={(value) =>
                      act('change_loadout', {
                        player: player.key,
                        loadout: value,
                      })
                    }
                  />
                )}
              </Table.Cell>

                <Table.Cell align="center" verticalAlign="middle">
                  {isSelf ? (
                    <Button.Checkbox
                      disabled={!isSelf}
                      checked={player.ready}
                      onClick={() => act('ready')}
                    />
                  ) : (
                    !!player.ready && <Icon name="check" color="green" />
                  )}
                </Table.Cell>
              </Table.Row>
            );
          })}
        </Table>
      )}

      {((!isMyTeam) || isObserver) && playing != PlayingStatus.PrePlaying && (
        <>
          <Divider />
          <Button
            fluid
            color={team.color}
            icon="arrow-right"
            onClick={() => act('join_team', { team: teamId })}
          >
            Join {team.name}
          </Button>
        </>
      )}
    </Section>
  );
}

function ObserverColumn(props) {
  const { observers } = props;
  const { act, data } = useBackend<Data>();
  const { admin, host, self, teams } = data;
  const fullAccess = !!host || !!admin;
  const isObserver = observers.find((observer) => observer.key === self);

  return (
    <Section title={`Observers (${observers.length})`} fill scrollable>
      {observers.length === 0 ? (
        <Box color="label" textAlign="center">No observers</Box>
      ) : (
        <Table>
          {observers.map((observer) => {
            const isHost = !!observer.host;
            const isSelf = observer.key === self;
            const canBoot = fullAccess && !isSelf;

            const dropdownMoveOptions: Record<string, string> = {};

            Object.entries(teams).forEach(([teamId, teamData]) => {
              const moveText = `Add To ${teamData.name}`;
              dropdownMoveOptions[moveText] = teamId;
            });
            const dropdownBaseOptions = ['Kick', 'Transfer host'];
            const dropdownOptions = [...dropdownBaseOptions, ...Object.keys(dropdownMoveOptions)];

            return (
              <Table.Row key={observer.key}>
                <Table.Cell collapsing verticalAlign="top" pt={fullAccess && '2px'}>
                  {isHost ? (
                    <Icon name="star" color="gold" />
                  ) : (
                    <Icon name="eye" color="label" />
                  )}
                </Table.Cell>
                <Table.Cell>
                  {!canBoot ? (
                    <Box color="label">{observer.key}</Box>
                  ) : (
                    <Dropdown
                      width={9}
                      selected={observer.key}
                      options={dropdownOptions}
                      onSelected={(value) => {
                        const options: {id: string, func: string, team?: string} = {
                          id: observer.key,
                          func: value
                        }
                        if (dropdownMoveOptions[value]) {
                          const targetTeamId = dropdownMoveOptions[value]
                          options.func = 'change_team'
                          options.team = targetTeamId
                        }
                        act('host', options);
                      }}
                    />
                  )}
                </Table.Cell>
              </Table.Row>
            );
          })}
        </Table>
      )}
      {!isObserver && (
        <>
          <Divider />
          <Button
            fluid
            icon="arrow-right"
            onClick={() => act('observe')}
          >
            Observe
          </Button>
        </>
      )}
    </Section>
  );
}

function HostControls(props) {
  const { act, data } = useBackend<Data>();
  const { admin, host, playing } = data;
  const fullAccess = !!host || !!admin;

  return (
    <Section title="Game Info">
      <MapInfo />
      {playing == PlayingStatus.PrePlaying && (
        <>
          <Divider />
          <NoticeBox align="center" color="blue">
            Game is loading.
          </NoticeBox>
        </>
      )}
    </Section>
  );
}

function MapInfo(props) {
  const { act, data } = useBackend<Data>();
  const { host, maps = [], map, scenerios, scenerio, players } = data;

  if (!host && !map?.name) {
    return <NoticeBox align="center">No map selected</NoticeBox>;
  }

  return (
    <>
      {!host ? (
        <Box bold textAlign="center" mb={1}>{scenerio.name}</Box>
      ) : (
        <Box mb={1}>
          <Dropdown
            color="default"
            width="100%"
            selected={scenerio.name}
            options={scenerios}
            onSelected={(value) =>
              act('host', {
                func: 'change_scenerio',
                scenerio: value,
              })
            }
          />
        </Box>
      )}
      <Box color="label" fontSize="12px" mb={1} textAlign="center">{scenerio.desc}</Box>
      {!host ? (
        <Box bold textAlign="center" mb={1}>{map.name}</Box>
      ) : (
        <Box mb={1}>
          <Dropdown
            color="default"
            width="100%"
            selected={map.name}
            options={maps}
            onSelected={(value) =>
              act('host', {
                func: 'change_map',
                map: value,
              })
            }
          />
        </Box>
      )}
      <Box color="label" fontSize="12px" mb={1} textAlign="center">{map.desc}</Box>
    </>
  );
}
