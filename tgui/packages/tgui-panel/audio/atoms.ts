import { atom } from 'jotai';

export type Meta = {
  album: string;
  artist: string;
  duration: string;
  link: string;
  title: string;
  upload_date: string;
};

export const playingAtom = atom(false);
export const visibleAtom = atom(false);
export const metaAtom = atom<Meta | null>(null);

// ------ Jukebox ----------------------------------------------------------------//

export type JukeboxMeta = Meta & {
  sourceName: string;
};

export const jukeboxMetaAtom = atom<Record<string, JukeboxMeta>>({});
export const jukeboxMutedAtom = atom<string[]>([]);

export const jukeboxAtom = atom((get) => ({
  meta: get(jukeboxMetaAtom),
  muted: get(jukeboxMutedAtom),
}));
