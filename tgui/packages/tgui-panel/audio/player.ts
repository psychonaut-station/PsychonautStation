/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createLogger } from 'tgui/logging';
import { store } from '../events/store';
import { jukeboxMutedAtom } from './atoms';
import { settingsAtom } from '../settings/atoms';

const logger = createLogger('AudioPlayer');

type AudioOptions = {
  pitch?: number;
  start?: number;
  end?: number;
};

function isProtectedError(error: ErrorEvent): boolean {
  return (
    typeof error === 'object' &&
    error !== null &&
    'isTrusted' in error &&
    error.isTrusted
  );
}

export class AudioPlayer {
  element: HTMLAudioElement | null;
  options: AudioOptions;
  volume: number;
  localVolume: number;
  muted: boolean;

  onPlaySubscribers: (() => void)[];
  onStopSubscribers: (() => void)[];

  constructor() {
    this.element = null;

    this.volume = store.get(settingsAtom).adminMusicVolume;
    this.localVolume = 1;
    this.muted = false;

    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
  }

  destroy(): void {
    this.element = null;
  }

  play(url: string, options: AudioOptions = {}, volume: number = 1): void {
    if (this.element) {
      this.stop();
    }

    this.options = options;
    this.localVolume = volume;

    const audio = new Audio(url);
    if (!audio) {
      logger.log('failed to create audio element');
      return;
    }
    this.element = audio;

    audio.volume = this.muted ? 0 : this.volume * this.localVolume;
    audio.playbackRate = this.options.pitch || 1;
    audio.currentTime = this.options.start || 0;

    logger.log('playing', url, options);

    audio.addEventListener('ended', () => {
      logger.log('ended');
      this.stop();
    });

    audio.addEventListener('error', (error) => {
      if (isProtectedError(error)) {
        Byond.sendMessage('audio/protected');
      }
      logger.log('playback error:', JSON.stringify(error));
      this.stop();
    });

    if (this.options.end) {
      audio.addEventListener('timeupdate', () => {
        if (
          this.options.end &&
          this.options.end > 0 &&
          audio.currentTime >= this.options.end
        ) {
          this.stop();
        }
      });
    }

    audio.play()?.catch(() => {
      // no error is passed here, it's sent to the event listener
      logger.log('playback failed');
    });

    this.onPlaySubscribers.forEach((subscriber) => {
      subscriber();
    });
  }

  stop(): void {
    if (!this.element) return;

    logger.log('stopping');

    this.element.pause();
    this.destroy();

    this.onStopSubscribers.forEach((subscriber) => {
      subscriber();
    });
  }

  setVolume(volume: number): void {
    this.volume = volume;

    if (!this.element) return;

    if (!this.muted) this.element.volume = volume * this.localVolume;
  }

  setLocalVolume(volume: number): void {
    this.localVolume = volume;

    if (!this.element) return;

    if (!this.muted) this.element.volume = this.volume * volume;
  }

  toggleMute(): void {
    this.muted = !this.muted;

    if (!this.element) return;

    this.element.volume = this.muted ? 0 : this.volume * this.localVolume;
  }

  onPlay(subscriber: () => void): void {
    this.onPlaySubscribers.push(subscriber);
  }

  onStop(subscriber: () => void): void {
    this.onStopSubscribers.push(subscriber);
  }
}
// PSYCHONAUT ADDITION BEGIN - ELECTRICAL_JUKEBOX
export class JukeboxPlayer {
  players: Map<string, AudioPlayer>;

  onPlaySubscribers: (() => void)[];
  onStopSubscribers: ((jukeboxId: string) => void)[];

  constructor() {
    this.players = new Map();
    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
  }

  play(
    jukeboxId: string,
    url: string,
    options: AudioOptions = {},
    volume: number = 1,
  ): void {
    let player = this.players.get(jukeboxId);
    if (player) {
      player.play(url, options, volume);
    } else {
      player = new AudioPlayer();
      this.players.set(jukeboxId, player);
      player.muted = store.get(jukeboxMutedAtom).includes(jukeboxId);
      player.onPlay(() => {
        this.onPlaySubscribers.forEach((subscriber) => {
          subscriber();
        });
      });
      player.onStop(() => {
        this.onStopSubscribers.forEach((subscriber) => {
          subscriber(jukeboxId);
        });
      });
      player.play(url, options, volume);
    }
  }

  stop(jukeboxId: string): void {
    this.players.get(jukeboxId)?.stop();
  }

  setVolume(volume: number): void {
    this.players.forEach((player) => {
      player.setVolume(volume);
    });
  }

  setLocalVolume(jukeboxId: string, volume: number): void {
    this.players.get(jukeboxId)?.setLocalVolume(volume);
  }

  toggleMute(jukeboxId: string): void {
    this.players.get(jukeboxId)?.toggleMute();
    store.set(jukeboxMutedAtom, (prev) => {
      const isMuted = this.isMuted(jukeboxId);
      if (isMuted) {
        return [...prev, jukeboxId];
      } else {
        return prev.filter((id) => id !== jukeboxId);
      }
    });
  }

  isMuted(jukeboxId: string): boolean {
    return this.players.get(jukeboxId)?.muted || false;
  }

  destroy(jukeboxId: string): void {
    const player = this.players.get(jukeboxId);
    if (player) {
      player.stop();
      player.destroy();
    }
    this.players.delete(jukeboxId);
  }

  destroyAll(): void {
    this.players.forEach((player) => {
      player.stop();
      player.destroy();
    });
    this.players.clear();
  }

  onPlay(subscriber: () => void): void {
    this.onPlaySubscribers.push(subscriber);
  }

  onStop(subscriber: (jukeboxId: string) => void): void {
    this.onStopSubscribers.push(subscriber);
  }
}
// PSYCHONAUT ADDITION END - ELECTRICAL_JUKEBOX
