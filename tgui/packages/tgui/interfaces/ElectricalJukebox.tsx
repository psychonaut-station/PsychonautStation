import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, Section, Stack, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  current_track: SoundData | null;
  elapsed: string;
  active: boolean;
  busy: boolean;
  queue: SoundData[];
  loop: boolean;
};

type SoundData = {
  title: string;
  duration: string;
  link: string;
  artist: string;
  upload_date: string;
  album: string;
  timestamp: number;
};

export const ElectricalJukebox = () => {
  return (
    <Window width={370} height={440}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <TrackDetails />
          </Stack.Item>
          <Stack.Item grow>
            <QueueDisplay />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const TrackDetails = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { current_track, elapsed, active, busy, loop } = data;

  return (
    <Section
      title="Current Track"
      buttons={
        <>
          <Button
            icon={active ? 'pause' : 'play'}
            tooltip={active ? 'Stop' : 'Play'}
            tooltipPosition="bottom"
            selected={!!active}
            disabled={!!busy}
            onClick={() => act('toggle')}
          />
          <Button
            icon="forward"
            tooltip="Skip"
            tooltipPosition="bottom"
            disabled={!!busy || !active}
            onClick={() => act('skip')}
          />
          <Button
            icon="sync"
            tooltip="Loop"
            tooltipPosition="bottom"
            selected={!!loop}
            disabled={!!busy}
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
  const { busy, queue } = data;

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
            disabled={!!busy}
            onClick={() => act('add_queue')}
          />
          <Button
            icon="trash"
            tooltip="Clear"
            tooltipPosition="bottom"
            textAlign="center"
            disabled={!!busy}
            onClick={() => act('clear_queue')}
          />
        </>
      }>
      <Table>
        {queue.map((sound, index) => (
          <SoundRow key={sound.timestamp} sound={sound} index={index} />
        )) || <Box>&nbsp;</Box>}
      </Table>
    </Section>
  );
};

export const SoundRow = (
  props: { sound: SoundData; index: number },
  context
) => {
  const { act } = useBackend<Data>(context);
  const { sound, index } = props;

  const [removed, setRemoved] = useLocalState(
    context,
    'removed-' + sound.timestamp,
    false
  );

  return (
    <Table.Row key={sound.timestamp} my={1}>
      <Table.Cell>{sound.title}</Table.Cell>
      <Table.Cell collaping>{sound.duration}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Button
          icon="minus"
          tooltipPosition="left"
          tooltip="Remove"
          textAlign="center"
          disabled={removed}
          onClick={() => {
            setRemoved(true);
            act('remove_queue', {
              index: index + 1,
            });
          }}
        />
      </Table.Cell>
    </Table.Row>
  );
};
