/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { AudioPlayer } from './player';

export const audioMiddleware = (store) => {
  const player = new AudioPlayer();
  const jukeboxPlayers = {};
  let adminMusicVolume = 1;
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
        adminMusicVolume = volume;
        player.setVolume(volume);
        for (const player of Object.values(jukeboxPlayers)) {
          player.setVolume(volume);
        }
      }
      return next(action);
    }
    if (type === 'audio/jukebox/create') {
      const { jukeboxId } = payload;
      if (!jukeboxPlayers[jukeboxId]) {
        const player = new AudioPlayer();
        jukeboxPlayers[jukeboxId] = player;
        player.setVolume(adminMusicVolume);
        player.onPlay(() => store.dispatch({ type: 'audio/jukebox/playing' }));
        player.onStop(() =>
          store.dispatch({
            type: 'audio/jukebox/stopped',
            payload: { jukeboxId },
          })
        );
      }
      return next(action);
    }
    if (type === 'audio/jukebox/destroy') {
      const { jukeboxId } = payload;
      const player = jukeboxPlayers[jukeboxId];
      if (player) player.destroy();
      delete jukeboxPlayers[jukeboxId];
      return next(action);
    }
    if (type === 'audio/jukebox/destroyAll') {
      for (const jukeboxId of Object.keys(jukeboxPlayers)) {
        const player = jukeboxPlayers[jukeboxId];
        if (player) player.destroy();
        delete jukeboxPlayers[jukeboxId];
      }
      return next(action);
    }
    if (type === 'audio/jukebox/playMusic') {
      const { jukeboxId, url, volume, ...options } = payload;
      if (jukeboxPlayers[jukeboxId]) {
        jukeboxPlayers[jukeboxId].play(url, options, volume);
      } else {
        const player = new AudioPlayer();
        jukeboxPlayers[jukeboxId] = player;
        player.setVolume(adminMusicVolume);
        player.onPlay(() => store.dispatch({ type: 'audio/jukebox/playing' }));
        player.onStop(() =>
          store.dispatch({
            type: 'audio/jukebox/stopped',
            payload: { jukeboxId },
          })
        );
        player.play(url, options, volume);
      }
      return next(action);
    }
    if (type === 'audio/jukebox/stopMusic') {
      const { jukeboxId } = payload;
      jukeboxPlayers[jukeboxId]?.stop();
      return next(action);
    }
    if (type === 'audio/jukebox/setVolume') {
      const { jukeboxId, volume } = payload;
      if (typeof volume === 'number') {
        jukeboxPlayers[jukeboxId]?.setLocalVolume(volume);
      }
      return next(action);
    }
    return next(action);
  };
};
