/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { AudioPlayer } from './player';
import { selectAudio } from './selectors'; // PSYCHONAUT EDIT ADDITION - JUKEBOX

export const audioMiddleware = (store) => {
  const player = new AudioPlayer();
  // PSYCHONAUT EDIT ADDITION START - JUKEBOX
  const jukeboxPlayers = {};
  let adminMusicVolume = 1;
  // PSYCHONAUT EDIT ADDITION END
  player.onPlay(() => {
    store.dispatch({ type: 'audio/playing' });
  });
  player.onStop(() => {
    store.dispatch({ type: 'audio/stopped' });
  });
  return (next) => (action) => {
    const { type, payload } = action;
    if (type === 'audio/playMusic') {
      const { url, ...options } = payload;
      player.play(url, options);
      return next(action);
    }
    if (type === 'audio/stopMusic') {
      player.stop();
      return next(action);
    }
    if (type === 'settings/update' || type === 'settings/load') {
      const volume = payload?.adminMusicVolume;
      if (typeof volume === 'number') {
        player.setVolume(volume);
        // PSYCHONAUT EDIT ADDITION START - JUKEBOX
        adminMusicVolume = volume;
        for (const player of Object.values(jukeboxPlayers)) {
          player.setVolume(volume);
        }
        // PSYCHONAUT EDIT ADDITION END
      }
      return next(action);
    }
    // PSYCHONAUT EDIT ADDITION START - JUKEBOX
    if (type === 'audio/jukebox/destroy') {
      jukeboxPlayers[payload.jukeboxId]?.destroy();
      delete jukeboxPlayers[payload.jukeboxId];
      return next(action);
    }
    if (type === 'audio/jukebox/destroyAll') {
      for (const jukeboxId of Object.keys(jukeboxPlayers)) {
        jukeboxPlayers[jukeboxId]?.destroy();
        delete jukeboxPlayers[jukeboxId];
      }
      return next(action);
    }
    if (type === 'audio/jukebox/playMusic') {
      const { jukeboxId, url, volume, ...options } = payload;
      if (jukeboxPlayers[jukeboxId]) {
        jukeboxPlayers[jukeboxId].play(url, options, volume);
      } else {
        const audio = selectAudio(store.getState());
        const player = new AudioPlayer();
        jukeboxPlayers[jukeboxId] = player;
        player.muted = audio.muted.includes(payload.jukeboxId);
        player.setVolume(adminMusicVolume);
        player.onPlay(() => store.dispatch({ type: 'audio/jukebox/playing' }));
        player.onStop(() =>
          store.dispatch({
            type: 'audio/jukebox/stopped',
            payload: { jukeboxId },
          }),
        );
        player.play(url, options, volume);
      }
      return next(action);
    }
    if (type === 'audio/jukebox/stopMusic') {
      jukeboxPlayers[payload.jukeboxId]?.stop();
      return next(action);
    }
    if (type === 'audio/jukebox/setVolume') {
      const { jukeboxId, volume } = payload;
      if (typeof volume === 'number') {
        jukeboxPlayers[jukeboxId]?.setLocalVolume(volume);
      }
      return next(action);
    }
    if (type === 'audio/jukebox/toggleMute') {
      jukeboxPlayers[payload.jukeboxId]?.toggleMute();
      return next(action);
    }
    // PSYCHONAUT EDIT ADDITION END
    return next(action);
  };
};
