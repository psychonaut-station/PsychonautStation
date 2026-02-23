import { atom } from 'jotai';

export type Emote = {
  type: number;
  key?: string;
  message_override?: string;
  message?: string;
  usable?: boolean;
};

export const emotesVisibleAtom = atom(false);
export const emotesListAtom = atom({} as Record<string, Emote>);
