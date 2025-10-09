import {
  Box,
  Button,
  LabeledList,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  current_track: TrackData | null;
  elapsed: string;
  active: BooleanLike;
  busy: BooleanLike;
  loop: BooleanLike;
  can_use: BooleanLike;
  banned: BooleanLike;
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
  mob_name: string;
  mob_ckey: string;
  mob_key_name: string;
  track_id: string;
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

const TrackDetails = (props) => {
  const { act, data } = useBackend<Data>();
  const { current_track, elapsed, active, busy, loop, can_use, banned } = data;

  return (
    <Section
      title="Current Track"
      buttons={
        <>
          {!!banned && (
            <Button
              color="transparent"
              icon="info"
              tooltipPosition="bottom"
              tooltip="You are banned form using electrical jukebox."
            />
          )}
          {!can_use && !banned && (
            <Button
              color="transparent"
              icon="info"
              tooltipPosition="bottom"
              tooltip={`
                You are not allowed to directly use electrical jukebox,
                instead you can make music requests down below for their
                approval by the owner of the jukebox.
              `}
            />
          )}
          <Button
            icon={active ? 'pause' : 'play'}
            tooltip={active ? 'Stop' : 'Play'}
            tooltipPosition="bottom"
            selected={active}
            disabled={busy || !can_use || banned}
            onClick={() => act('toggle')}
          />
          <Button
            icon="forward"
            tooltip="Skip"
            tooltipPosition="bottom"
            disabled={busy || !active || !can_use || banned}
            onClick={() => act('skip')}
          />
          <Button
            icon="sync"
            tooltip="Loop"
            tooltipPosition="bottom"
            selected={loop}
            disabled={busy || !can_use || banned}
            onClick={() => act('loop')}
          />
        </>
      }
    >
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

const QueueDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { busy, queue, can_use, banned } = data;

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
            disabled={busy || !can_use || banned}
            onClick={() => act('add_queue')}
          />
          <Button
            icon="trash"
            tooltip="Clear"
            tooltipPosition="bottom"
            textAlign="center"
            disabled={busy || !can_use || banned}
            onClick={() => act('clear_queue')}
          />
        </>
      }
    >
      <Table>
        {queue.map((track) => (
          <QueueRow key={track.track_id} track={track} />
        ))}
      </Table>
    </Section>
  );
};

const RequestsDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { busy, can_use, requests, banned } = data;

  return (
    <Section
      title="Requests"
      buttons={
        <>
          {!!can_use && !banned && (
            <Button
              color="transparent"
              icon="info"
              tooltipPosition="bottom"
              tooltip="You are allowed to approve or deny the requests."
            />
          )}
          <Button
            icon="plus"
            tooltip="New Request"
            tooltipPosition="bottom"
            textAlign="center"
            disabled={busy || banned}
            onClick={() => act('new_request')}
          />
        </>
      }
    >
      {requests.length > 0 ? (
        <Table>
          {requests.map((track) => (
            <RequestRow key={track.track_id} track={track} />
          ))}
        </Table>
      ) : (
        <Box>&nbsp;</Box>
      )}
    </Section>
  );
};

const QueueRow = (props: { track: TrackData }) => {
  const { act, data } = useBackend<Data>();
  const { track } = props;
  const { can_use, banned } = data;

  return (
    <Table.Row key={track.track_id} my={1}>
      <Table.Cell>{track.title}</Table.Cell>
      <Table.Cell collapsing>{track.duration}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Button
          icon="minus"
          color="red"
          tooltipPosition="left"
          tooltip="Remove"
          textAlign="center"
          disabled={!can_use || banned}
          onClick={() => {
            act('remove_queue', {
              track_id: track.track_id,
            });
          }}
        />
      </Table.Cell>
    </Table.Row>
  );
};

const RequestRow = (props: { track: TrackData }) => {
  const { act, data } = useBackend<Data>();
  const { track } = props;
  const { can_use, user_key_name, banned } = data;

  return (
    <Table.Row key={track.track_id} my={1}>
      <Table.Cell>{track.title}</Table.Cell>
      <Table.Cell collapsing>{track.duration}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        {!!can_use && !banned && (
          <Button
            icon="check"
            selected
            tooltipPosition="left"
            tooltip="Approve"
            textAlign="center"
            onClick={() => {
              act('approve_request', {
                track_id: track.track_id,
              });
            }}
          />
        )}
        <Button
          icon="times"
          color="red"
          tooltipPosition="left"
          tooltip={can_use && !banned ? 'Deny' : 'Discard'}
          textAlign="center"
          disabled={
            track.mob_key_name === user_key_name || can_use ? false : true
          }
          onClick={() => {
            act('discard_request', {
              track_id: track.track_id,
            });
          }}
        />
      </Table.Cell>
    </Table.Row>
  );
};
