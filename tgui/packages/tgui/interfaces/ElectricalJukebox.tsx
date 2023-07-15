import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  playing_sound_data: SoundData | null;
  timeleft: string;
  active: boolean;
  busy: boolean;
};

type SoundData = {
  title: string;
  duration: string;
  link: string;
  artist: string;
  upload_date: string;
  album: string;
};

export const ElectricalJukebox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { playing_sound_data, timeleft, active, busy } = data;

  return (
    <Window width={370} height={313}>
      <Window.Content>
        <Section
          title="Current Track"
          buttons={
            <Button
              icon={active ? 'pause' : 'play'}
              content={active ? 'Stop' : 'Play'}
              selected={!!active}
              disabled={!!busy}
              onClick={() => act('toggle')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Title">
              {playing_sound_data?.title}
            </LabeledList.Item>
            <LabeledList.Item label="Duration">
              {playing_sound_data?.duration}
            </LabeledList.Item>
            <LabeledList.Item label="Time elapsed">
              {timeleft === 'right now' ? '' : timeleft}
            </LabeledList.Item>
            {playing_sound_data?.upload_date && (
              <LabeledList.Item label="Upload date">
                {playing_sound_data.upload_date}
              </LabeledList.Item>
            )}
            {playing_sound_data?.artist && (
              <LabeledList.Item label="Artist">
                {playing_sound_data.artist}
              </LabeledList.Item>
            )}
            {playing_sound_data?.album && (
              <LabeledList.Item label="Album">
                {playing_sound_data.album}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
