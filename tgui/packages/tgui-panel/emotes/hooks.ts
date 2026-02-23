import { useAtomValue } from 'jotai';
import { emotesListAtom } from './atom';

export const useEmotes = () => {
  return useAtomValue(emotesListAtom);
};
