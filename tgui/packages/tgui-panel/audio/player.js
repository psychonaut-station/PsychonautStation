/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createLogger } from 'tgui/logging';

const logger = createLogger('AudioPlayer');

export class AudioPlayer {
  constructor() {
    // Doesn't support HTMLAudioElement
    if (Byond.IS_LTE_IE9) {
      return;
    }
    // Set up the HTMLAudioElement node
    this.node = document.createElement('audio');
    this.node.style.setProperty('display', 'none');
    document.body.appendChild(this.node);
    // Set up other properties
    this.playing = false;
    this.volume = 1;
    this.localVolume = 1;
    this.options = {};
    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
    // Listen for playback start events
    this.playthroughListener = () => {
      if (this.node && this.node.playbackRate) {
        logger.log('canplaythrough');
        this.playing = true;
        this.node.playbackRate = this.options.pitch || 1;
        this.node.currentTime = this.options.start || 0;
        this.node.volume = this.volume * this.localVolume;
        this.node.play();
        for (let subscriber of this.onPlaySubscribers) {
          subscriber();
        }
      }
    };
    this.node.addEventListener('canplaythrough', this.playthroughListener);
    // Listen for playback stop events
    this.node.addEventListener('ended', () => {
      logger.log('ended');
      this.stop();
    });
    // Listen for playback errors
    this.node.addEventListener('error', (e) => {
      if (this.playing) {
        logger.log('playback error', e.error);
        this.stop();
      }
    });
    // Check every second to stop the playback at the right time
    this.playbackInterval = setInterval(() => {
      if (!this.playing) {
        return;
      }
      const shouldStop =
        this.options.end > 0 && this.node.currentTime >= this.options.end;
      if (shouldStop) {
        this.stop();
      }
    }, 1000);
  }

  destroy() {
    try {
      clearInterval(this.playbackInterval);
      if (this.node && this.node.stop) {
        this.stop();
        this.node.stop();
        this.node.removeEventListener(
          'canplaythrough',
          this.playthroughListener
        );
        document.body.removeChild(this.node);
        delete this.node;
      }
    } catch {}
  }

  play(url, options = {}, volume = 1) {
    if (!this.node) {
      return;
    }
    logger.log('playing', url, options);
    this.options = options;
    this.localVolume = volume;
    this.node.src = url;
  }

  stop() {
    if (!this.node) {
      return;
    }
    if (this.playing) {
      for (const subscriber of this.onStopSubscribers) {
        subscriber();
      }
    }
    logger.log('stopping');
    this.playing = false;
    this.node.src = '';
  }

  setVolume(volume) {
    if (!this.node) {
      return;
    }
    this.volume = volume;
    this.node.volume = this.localVolume * volume;
  }

  setLocalVolume(volume) {
    if (!this.node) {
      return;
    }
    this.localVolume = volume;
    this.node.volume = this.volume * volume;
  }

  onPlay(subscriber) {
    if (!this.node) {
      return;
    }
    this.onPlaySubscribers.push(subscriber);
  }

  onStop(subscriber) {
    if (!this.node) {
      return;
    }
    this.onStopSubscribers.push(subscriber);
  }
}
