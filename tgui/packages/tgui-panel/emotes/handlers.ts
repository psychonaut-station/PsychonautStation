import { store } from '../events/store';
import { emotesListAtom, emotesVisibleAtom } from './atom';
import type { Emote } from './atom';

export function setEmotesList(payload: Record<string, Emote>) {
  store.set(emotesListAtom, payload);
}

export function toggleEmotes() {
  store.set(emotesVisibleAtom, (state) => !state);
}
