import { store } from '../events/store';
import {
  jukeboxMetaAtom,
  type Meta,
  metaAtom,
  playingAtom,
  visibleAtom,
} from './atoms';
import { AudioPlayer, JukeboxPlayer } from './player';

export const player = new AudioPlayer();

player.onPlay(() => {
  store.set(playingAtom, true);
  store.set(visibleAtom, true);
});

player.onStop(() => {
  store.set(playingAtom, false);
  store.set(visibleAtom, visible());
  store.set(metaAtom, null);
});

type PlayPayload = {
  url: string;
  pitch: number;
  start: number;
  end: number;
} & Meta;

export function playMusic(payload: PlayPayload): void {
  const { url, ...options } = payload;

  player.play(url, options);
  store.set(metaAtom, options);
}

export function stopMusic(): void {
  player.stop();
}

// settings/update and settings/load
export function setMusicVolume(volume: number): void {
  player.setVolume(volume);
  jukeboxPlayer.setVolume(volume); // PSYCHONAUT ADDITION - JUKEBOX
}
// PSYCHONAUT ADDITION BEGIN - JUKEBOX
// jukebox

export const jukeboxPlayer = new JukeboxPlayer();

jukeboxPlayer.onPlay(() => {
  store.set(visibleAtom, true);
});
jukeboxPlayer.onStop((jukeboxId: string) => {
  store.set(visibleAtom, visible());
  store.set(jukeboxMetaAtom, (prev) => {
    const meta = { ...prev };
    delete meta[jukeboxId];
    return meta;
  });
});

type JukeboxPlayPayload = PlayPayload & {
  jukeboxId: string;
  volume: number;
  sourceName: string;
};

export function jukeboxPlayMusic(payload: JukeboxPlayPayload): void {
  const { jukeboxId, url, volume, ...options } = payload;

  jukeboxPlayer.play(jukeboxId, url, options, volume);
  store.set(jukeboxMetaAtom, (prev) => ({
    ...prev,
    [jukeboxId]: options,
  }));
}

type JukeboxStopPayload = {
  jukeboxId: string;
};

export function jukeboxStopMusic(payload: JukeboxStopPayload): void {
  const { jukeboxId } = payload;
  jukeboxPlayer.stop(jukeboxId);
}

type JukeboxSetVolumePayload = {
  jukeboxId: string;
  volume: number;
};

export function jukeboxSetVolume(payload: JukeboxSetVolumePayload): void {
  const { jukeboxId, volume } = payload;
  jukeboxPlayer.setLocalVolume(jukeboxId, volume);
}

type JukeboxDestroyPayload = {
  jukeboxId: string;
};

export function jukeboxDestroy(payload: JukeboxDestroyPayload): void {
  const { jukeboxId } = payload;
  jukeboxPlayer.destroy(jukeboxId);
}

export function jukeboxDestroyAll(): void {
  jukeboxPlayer.destroyAll();
}

// helper to determine visibility
const visible = (): boolean => {
  const playing = store.get(playingAtom);
  if (!playing) {
    for (const jukebox of jukeboxPlayer.players.values()) {
      if (jukebox.element) return true;
    }
  }
  return playing;
}
// PSYCHONAUT ADDITION END - JUKEBOX
