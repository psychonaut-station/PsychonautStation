/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createLogger } from 'tgui/logging';

const logger = createLogger('AudioPlayer');

type AudioOptions = {
  pitch?: number;
  start?: number;
  end?: number;
};

export class AudioPlayer {
  element: HTMLAudioElement | null;
  options: AudioOptions;
  volume: number;
  localVolume: number;
  muted: boolean;

  onPlaySubscribers: { (): void }[];
  onStopSubscribers: { (): void }[];

  constructor() {
    this.element = null;

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

    const audio = (this.element = new Audio(url));
    audio.volume = this.muted ? 0 : this.volume * this.localVolume;
    audio.playbackRate = this.options.pitch || 1;
    audio.currentTime = this.options.start || 0;

    logger.log('playing', url, options);

    audio.addEventListener('ended', () => {
      logger.log('ended');
      this.stop();
    });

    audio.addEventListener('error', (error) => {
      logger.log('playback error', error);
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

    audio.play()?.catch((error) => logger.log('playback error', error));

    this.onPlaySubscribers.forEach((subscriber) => subscriber());
  }

  stop(): void {
    if (!this.element) return;

    logger.log('stopping');

    this.element.pause();
    this.element = null;

    this.onStopSubscribers.forEach((subscriber) => subscriber());
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
