import { loadStyleSheet } from 'common/assets';
import { EventBus } from 'tgui-core/eventbus';
import {
  jukeboxDestroy,
  jukeboxDestroyAll,
  jukeboxPlayMusic,
  jukeboxSetVolume,
  jukeboxStopMusic,
  playMusic,
  stopMusic,
} from '../audio/handlers';
import { chatMessage } from '../chat/handlers';
import { pingReply, pingSoft } from '../ping/handlers';
import {
  handleTelemetryData,
  telemetryRequest,
  testTelemetryCommand,
} from '../telemetry/handlers';
import { handleLoadAssets } from './handlers/assets';
import { roundrestart } from './handlers/roundrestart';

const listeners = {
  'asset/stylesheet': loadStyleSheet,
  'asset/mappings': handleLoadAssets,
  'audio/playMusic': playMusic,
  'audio/stopMusic': stopMusic,
  'audio/jukebox/playMusic': jukeboxPlayMusic, // PSYCHONAUT ADDITION - ELECTRICAL_JUKEBOX
  'audio/jukebox/stopMusic': jukeboxStopMusic, // PSYCHONAUT ADDITION - ELECTRICAL_JUKEBOX
  'audio/jukebox/setVolume': jukeboxSetVolume, // PSYCHONAUT ADDITION - ELECTRICAL_JUKEBOX
  'audio/jukebox/destroy': jukeboxDestroy, // PSYCHONAUT ADDITION - ELECTRICAL_JUKEBOX
  'audio/jukebox/destroyAll': jukeboxDestroyAll, // PSYCHONAUT ADDITION - ELECTRICAL_JUKEBOX
  'chat/message': chatMessage,
  'ping/reply': pingReply,
  'ping/soft': pingSoft,
  roundrestart,
  'telemetry/request': telemetryRequest,
  testTelemetryCommand,
  update: handleTelemetryData,
} as const;

export const bus = new EventBus(listeners);
