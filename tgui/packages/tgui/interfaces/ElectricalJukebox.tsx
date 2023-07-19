import { multiline } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  current_track: TrackData | null;
  elapsed: string;
  // requested: 0 | 1;
  active: 0 | 1;
  busy: 0 | 1;
  loop: 0 | 1;
  can_mob_use: 0 | 1;
  user_key_name: string;
  queue: TrackData[];
  requests: TrackData[];
};

type TrackData = {
  title: string;
  duration: string;
  link: string;
  webpage_url: string;
  webpage_url_html: string;
  upload_date: string;
  artist: string;
  album: string;
  timestamp: number;
  mob_name: string;
  mob_ckey: string;
  mob_key_name: string;
};

export const ElectricalJukebox = () => {
  return (
    <Window width={440} height={550}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <TrackDetails />
          </Stack.Item>
          <Stack.Item grow>
            <QueueDisplay />
          </Stack.Item>
          <Stack.Item>
            <RequestsDisplay />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const TrackDetails = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { current_track, elapsed, active, busy, loop, can_mob_use } = data;

  return (
    <Section
      title="Current Track"
      buttons={
        <>
          {!can_mob_use && (
            <Button
              color="transparent"
              icon="info"
              tooltipPosition="bottom"
              tooltip={multiline`
              You are not allowed to directly use machine, you can
              make music requests down below for their approval by the
              Bartender or the admins. When the request gets approved,
              It will be auto-played if there is nothing playing.
            `}
            />
          )}
          <Button
            icon={active ? 'pause' : 'play'}
            tooltip={active ? 'Stop' : 'Play'}
            tooltipPosition="bottom"
            selected={active}
            // disabled={busy || (requested ? false : !can_mob_use)}
            disabled={busy || !can_mob_use}
            onClick={() => act('toggle')}
          />
          <Button
            icon="forward"
            tooltip="Skip"
            tooltipPosition="bottom"
            // disabled={busy || !active || (requested ? false : !can_mob_use)}
            disabled={busy || !active || !can_mob_use}
            onClick={() => act('skip')}
          />
          <Button
            icon="sync"
            tooltip="Loop"
            tooltipPosition="bottom"
            selected={loop}
            // disabled={busy || (requested ? false : !can_mob_use)}
            disabled={busy || !can_mob_use}
            onClick={() => act('loop')}
          />
        </>
      }>
      {current_track ? (
        <LabeledList>
          <LabeledList.Item label="Title">
            {current_track.title}
          </LabeledList.Item>
          <LabeledList.Item label="Duration">
            {current_track.duration}
          </LabeledList.Item>
          <LabeledList.Item label="Time elapsed">
            {elapsed === 'right now' ? 'started now' : elapsed}
          </LabeledList.Item>
          {current_track?.upload_date && (
            <LabeledList.Item label="Upload date">
              {current_track.upload_date}
            </LabeledList.Item>
          )}
          {current_track?.artist && (
            <LabeledList.Item label="Artist">
              {current_track.artist}
            </LabeledList.Item>
          )}
          {current_track?.album && (
            <LabeledList.Item label="Album">
              {current_track.album}
            </LabeledList.Item>
          )}
        </LabeledList>
      ) : (
        <Box>&nbsp;</Box>
      )}
    </Section>
  );
};

export const QueueDisplay = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { busy, queue, can_mob_use } = data;

  return (
    <Section
      fill
      scrollable
      title="Queue"
      buttons={
        <>
          <Button
            icon="plus"
            tooltip="Add"
            tooltipPosition="bottom"
            textAlign="center"
            disabled={busy || !can_mob_use}
            onClick={() => act('add_queue')}
          />
          <Button
            icon="trash"
            tooltip="Clear"
            tooltipPosition="bottom"
            textAlign="center"
            disabled={busy || !can_mob_use}
            onClick={() => act('clear_queue')}
          />
        </>
      }>
      <Table>
        {queue.map((track) => (
          <QueueRow key={track.timestamp} track={track} />
        ))}
      </Table>
    </Section>
  );
};

export const RequestsDisplay = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { busy, can_mob_use, requests } = data;

  return (
    <Section
      title="Requests"
      buttons={
        <>
          {!!can_mob_use && (
            <Button
              color="transparent"
              icon="info"
              tooltipPosition="bottom"
              tooltip={multiline`
              You are allowed to approve or deny the requests.
            `}
            />
          )}
          <Button
            icon="plus"
            tooltip="New Request"
            tooltipPosition="bottom"
            textAlign="center"
            disabled={busy}
            onClick={() => act('new_request')}
          />
        </>
      }>
      {requests.length > 0 ? (
        <Table>
          {requests.map((track) => (
            <RequestRow key={track.timestamp} track={track} />
          ))}
        </Table>
      ) : (
        <Box>&nbsp;</Box>
      )}
    </Section>
  );
};

export const QueueRow = (props: { track: TrackData }, context) => {
  const { act, data } = useBackend<Data>(context);
  const { track } = props;
  const { can_mob_use } = data;

  return (
    <Table.Row key={track.timestamp} my={1}>
      <Table.Cell>{track.title}</Table.Cell>
      <Table.Cell collaping>{track.duration}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Button
          icon="minus"
          color="red"
          tooltipPosition="left"
          tooltip="Remove"
          textAlign="center"
          disabled={!can_mob_use}
          onClick={() => {
            act('remove_queue', {
              timestamp: track.timestamp,
            });
          }}
        />
      </Table.Cell>
    </Table.Row>
  );
};

export const RequestRow = (props: { track: TrackData }, context) => {
  const { act, data } = useBackend<Data>(context);
  const { track } = props;
  const { can_mob_use, user_key_name } = data;

  return (
    <Table.Row key={track.timestamp} my={1}>
      <Table.Cell>{track.title}</Table.Cell>
      <Table.Cell collaping>{track.duration}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        {!!can_mob_use && (
          <Button
            icon="check"
            selected
            tooltipPosition="left"
            tooltip="Approve"
            textAlign="center"
            onClick={() => {
              act('approve_request', {
                timestamp: track.timestamp,
              });
            }}
          />
        )}
        <Button
          icon="times"
          color="red"
          tooltipPosition="left"
          tooltip={can_mob_use ? 'Deny' : 'Discard'}
          textAlign="center"
          disabled={
            track.mob_key_name === user_key_name || can_mob_use ? false : true
          }
          onClick={() => {
            act('discard_request', {
              timestamp: track.timestamp,
            });
          }}
        />
      </Table.Cell>
    </Table.Row>
  );
};
