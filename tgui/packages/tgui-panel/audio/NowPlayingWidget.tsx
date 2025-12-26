/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useAtomValue } from 'jotai';
import { Button, Collapsible, Flex, Knob, Section } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { useSettings } from '../settings/use-settings';
import { metaAtom, playingAtom } from './atoms';
import { player } from './handlers';

export function NowPlayingWidget(props) {
  const { settings, updateSettings } = useSettings();
  const meta = useAtomValue(metaAtom);
  const {
    album = 'Unknown Album',
    artist = 'Unknown Artist',
    duration,
    link,
    title,
    upload_date = 'Unknown Data',
  } = meta || {};

  const playing = useAtomValue(playingAtom);

  const date = !Number.isNaN(upload_date)
    ? upload_date?.substring(0, 4) +
      '-' +
      upload_date?.substring(4, 6) +
      '-' +
      upload_date?.substring(6, 8)
    : upload_date;

  return (
<<<<<<< HEAD
    <Flex>
      <Flex.Item grow={1}>
        <Flex direction="column">
          {audio.playing && (
            <Flex.Item>
              <Flex align="center">
                <Flex.Item
                  mx={0.5}
                  grow={1}
                  style={{
                    whiteSpace: 'nowrap',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                  }}
                >
                  <Collapsible title={title || 'Unknown Track'} color={'blue'}>
                    <Section>
                      {URL !== 'Song Link Hidden' && (
                        <Flex.Item grow={1} color="label">
                          URL: <a href={URL}>{URL}</a>
                        </Flex.Item>
                      )}
                      <Flex.Item grow={1} color="label">
                        Duration: {duration}
                      </Flex.Item>
                      {Artist !== 'Song Artist Hidden' &&
                        Artist !== 'Unknown Artist' && (
                          <Flex.Item grow={1} color="label">
                            Artist: {Artist}
                          </Flex.Item>
                        )}
                      {album !== 'Song Album Hidden' &&
                        album !== 'Unknown Album' && (
                          <Flex.Item grow={1} color="label">
                            Album: {album}
                          </Flex.Item>
                        )}
                      {upload_date !== 'Song Upload Date Hidden' &&
                        upload_date !== 'Unknown Date' && (
                          <Flex.Item grow={1} color="label">
                            Uploaded: {date}
                          </Flex.Item>
                        )}
                    </Section>
                  </Collapsible>
                </Flex.Item>
                <Flex.Item mx={0.5} fontSize="0.9em">
                  <Button
                    tooltip="Stop"
                    icon="stop"
                    onClick={() =>
                      dispatch({
                        type: 'audio/stopMusic',
                      })
                    }
                  />
                </Flex.Item>
              </Flex>
            </Flex.Item>
          )}
          {Object.keys(audio.jukebox).map((jukeboxId) => {
            const title = audio.jukebox[jukeboxId]?.title,
              url = audio.jukebox[jukeboxId]?.link,
              artist = audio.jukebox[jukeboxId]?.artist,
              album = audio.jukebox[jukeboxId]?.album,
              duration = audio.jukebox[jukeboxId]?.duration,
              source = audio.jukebox[jukeboxId]?.sourceName,
              muted = audio.muted.includes(jukeboxId);

            return (
              <Flex.Item key={jukeboxId}>
                <Flex align="center">
                  {!!audio.jukebox[jukeboxId] && (
                    <>
                      <Flex.Item
                        mx={0.5}
                        grow={1}
                        style={{
                          whiteSpace: 'nowrap',
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                        }}
                      >
                        <Collapsible title={title} color={'blue'}>
                          <Section>
                            <Flex.Item grow={1} color="label">
                              URL: {url}
                            </Flex.Item>
                            <Flex.Item grow={1} color="label">
                              Duration: {duration}
                            </Flex.Item>
                            {!!artist && (
                              <Flex.Item grow={1} color="label">
                                Artist: {artist}
                              </Flex.Item>
                            )}
                            {!!album && (
                              <Flex.Item grow={1} color="label">
                                Album: {album}
                              </Flex.Item>
                            )}
                            <Flex.Item grow={1} color="label">
                              Source: {source}
                            </Flex.Item>
                          </Section>
                        </Collapsible>
                      </Flex.Item>
                      <Flex.Item mx={0.5} fontSize="0.9em">
                        <Button
                          tooltip="Stop"
                          icon="stop"
                          onClick={() =>
                            dispatch({
                              type: 'audio/jukebox/stopMusic',
                              payload: { jukeboxId },
                            })
                          }
                        />
                      </Flex.Item>
                      <Flex.Item mx={0.5} fontSize="0.9em">
                        <Button
                          tooltip={muted ? 'Unmute' : 'Mute'}
                          icon={muted ? 'volume-off' : 'volume-up'}
                          onClick={() =>
                            dispatch({
                              type: 'audio/jukebox/toggleMute',
                              payload: { jukeboxId },
                            })
                          }
                        />
                      </Flex.Item>
                    </>
                  )}
                </Flex>
              </Flex.Item>
            );
          })}
          {!audio.playing &&
            Object.values(audio.jukebox).filter((i) => !!i).length === 0 && (
              <Flex.Item grow={1} color="label" my={0.5}>
                Nothing to play.
              </Flex.Item>
            )}
        </Flex>
      </Flex.Item>
      <Flex.Item mx={0.5} fontSize="0.9em" align="end">
=======
    <Flex align="center">
      {playing ? (
        <Flex.Item
          mx={0.5}
          grow={1}
          style={{
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {
            <Collapsible title={title || 'Unknown Track'} color="blue">
              <Section>
                {link !== 'Song Link Hidden' && (
                  <Flex.Item grow={1} color="label">
                    URL: <a href={link}>{link}</a>
                  </Flex.Item>
                )}
                <Flex.Item grow={1} color="label">
                  Duration: {duration}
                </Flex.Item>
                {artist !== 'Song Artist Hidden' &&
                  artist !== 'Unknown Artist' && (
                    <Flex.Item grow={1} color="label">
                      Artist: {artist}
                    </Flex.Item>
                  )}
                {album !== 'Song Album Hidden' && album !== 'Unknown Album' && (
                  <Flex.Item grow={1} color="label">
                    Album: {album}
                  </Flex.Item>
                )}
                {upload_date !== 'Song Upload Date Hidden' &&
                  upload_date !== 'Unknown Date' && (
                    <Flex.Item grow={1} color="label">
                      Uploaded: {date}
                    </Flex.Item>
                  )}
              </Section>
            </Collapsible>
          }
        </Flex.Item>
      ) : (
        <Flex.Item grow={1} color="label">
          Nothing to play.
        </Flex.Item>
      )}
      {playing && (
        <Flex.Item mx={0.5} fontSize="0.9em">
          <Button tooltip="Stop" icon="stop" onClick={() => player.stop()} />
        </Flex.Item>
      )}
      <Flex.Item mx={0.5} fontSize="0.9em">
>>>>>>> 8b5cb8f2ddc13bbc07035fb450816cda59c67ace
        <Knob
          minValue={0}
          maxValue={1}
          value={settings.adminMusicVolume}
          step={0.0025}
          stepPixelSize={1}
          format={(value) => `${toFixed(value * 100)}%`}
          onChange={(e, value) => {
            updateSettings({
              adminMusicVolume: value,
            });
            player.setVolume(value);
          }}
        />
      </Flex.Item>
    </Flex>
  );
}
