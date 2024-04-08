/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createLogger } from 'tgui/logging';

const logger = createLogger('AudioPlayer');

export class AudioPlayer {
  constructor() {
    // Set up the HTMLAudioElement node
    this.node = document.createElement('audio');
    this.node.style.setProperty('display', 'none');
    document.body.appendChild(this.node);
    // Set up other properties
    this.playing = false;
    this.muted = false; // PSYCHONAUT EDIT ADDITION - JUKEBOX
    this.volume = 1;
    this.localVolume = 1; // PSYCHONAUT EDIT ADDITION - JUKEBOX
    this.options = {};
    this.onPlaySubscribers = [];
    this.onStopSubscribers = [];
    // Listen for playback start events
    this.node.addEventListener('canplaythrough', () => {
      if (this.node && this.node instanceof HTMLAudioElement) { // PSYCHONAUT EDIT ADDITION - JUKEBOX
        logger.log('canplaythrough');
        this.playing = true;
        this.node.playbackRate = this.options.pitch || 1;
        this.node.currentTime = this.options.start || 0;
        // PSYCHONAUT EDIT CHANGE START - JUKEBOX
        // this.node.volume = this.volume; - PSYCHONAUT EDIT - ORIGINAL
        this.node.volume = this.muted ? 0 : this.volume * this.localVolume;
        // PSYCHONAUT EDIT CHANGE END
        this.node.play();
        for (let subscriber of this.onPlaySubscribers) {
          subscriber();
        }
      } // PSYCHONAUT EDIT ADDITION - JUKEBOX
    });
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
    if (!this.node) {
      return;
    }
    // PSYCHONAUT EDIT CHANGE START - JUKEBOX - ORIGINAL:
    // this.node.stop();
    // document.removeChild(this.node);
    // clearInterval(this.playbackInterval);
    this.stop();
    logger.log('destroyed');
    clearInterval(this.playbackInterval);
    try {
      document.body.removeChild(this.node);
    } catch {}
    this.node = null;
    // PSYCHONAUT EDIT CHANGE END
  }

  play(url, options = {}, volume = 1) { // PSYCHONAUT EDIT CHANGE - JUKEBOX - ORIGINAL: play(url, options = {})
    if (!this.node) {
      return;
    }
    logger.log('playing', url, options);
    this.options = options;
    this.node.src = url;
    this.localVolume = volume; // PSYCHONAUT EDIT ADDITION - JUKEBOX
  }

  stop() {
    if (!this.node) {
      return;
    }
    // PSYCHONAUT EDIT CHANGE START - JUKEBOX - ORIGINAL:
    // if (this.playing) {
    //   for (let subscriber of this.onStopSubscribers) {
    //     subscriber();
    //   }
    // }
    // logger.log('stopping');
    // this.playing = false;
    // this.node.src = '';
    if (this.playing) {
      for (const subscriber of this.onStopSubscribers) {
        subscriber();
      }
      logger.log('stopping');
      this.playing = false;
      this.node.src = '';
    }
    // PSYCHONAUT EDIT CHANGE END
  }

  setVolume(volume) {
    if (!this.node) {
      return;
    }
    this.volume = volume;
    // PSYCHONAUT EDIT CHANGE START - JUKEBOX
    // this.node.volume = volume; - PSYCHONAUT EDIT - ORIGINAL
    if (!this.muted) {
      this.node.volume = this.localVolume * volume;
    }
    // PSYCHONAUT EDIT CHANGE END
  }

  // PSYCHONAUT EDIT ADDITION START - JUKEBOX
  setLocalVolume(volume) {
    if (!this.node) {
      return;
    }
    this.localVolume = volume;
    if (!this.muted) {
      this.node.volume = this.volume * volume;
    }
  }

  toggleMute() {
    if (!this.node) {
      return;
    }
    this.muted = !this.muted;
    this.node.volume = this.muted ? 0 : this.volume * this.localVolume;
  }
  // PSYCHONAUT EDIT ADDITION END

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
