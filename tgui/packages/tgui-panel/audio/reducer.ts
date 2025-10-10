/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

// PSYCHONAUT ADDITION BEGIN - JUKEBOX
type State = {
  visible: boolean;
  playing: boolean;
  meta: Meta | null;
  track: unknown | null;
  jukebox: Record<string, Meta>;
  muted: string[];
};

type Meta = {
  title: string;
  link: string;
  artist?: string;
  upload_date?: string;
  album?: string;
  duration: string;
};

const visible = (state: State, payload?: any): State => {
  let visible = state.playing;
  if (!visible) {
    for (const key of Object.keys(state.jukebox)) {
      if (payload && key === payload.jukeboxId) continue;
      if (state.jukebox[key]) {
        visible = true;
        break;
      }
    }
  }
  state.visible = visible;
  return state;
};
// PSYCHONAUT ADDITION END - JUKEBOX

const initialState: State = {
  visible: false,
  playing: false,
  track: null,
  meta: null, // PSYCHONAUT ADDITION - JUKEBOX
  jukebox: {}, // PSYCHONAUT ADDITION - JUKEBOX
  muted: [], // PSYCHONAUT ADDITION - JUKEBOX
};

export const audioReducer = (state = initialState, action) => {
  const { type, payload } = action;
  if (type === 'audio/playing') {
    return {
      ...state,
      visible: true,
      playing: true,
    };
  }
  if (type === 'audio/stopped') {
// PSYCHONAUT EDIT ADDITION BEGIN - JUKEBOX
//    return {
//      ...state,
//       visible: false,
//      playing: false,
//    };
    return visible({
      ...state,
      playing: false,
    });
// PSYCHONAUT EDIT ADDITION END - JUKEBOX
  }
  if (type === 'audio/playMusic') {
    return {
      ...state,
      meta: payload,
    };
  }
  if (type === 'audio/stopMusic') {
// PSYCHONAUT EDIT ADDITION BEGIN - JUKEBOX
//    return {
//      ...state,
//      visible: false,
//      playing: false,
//      meta: null,
//    };
    return visible({
      ...state,
      playing: false,
      meta: null,
    });
// PSYCHONAUT EDIT ADDITION END - JUKEBOX
  }
  if (type === 'audio/toggle') {
    return {
      ...state,
      visible: !state.visible,
    };
  }
  // PSYCHONAUT ADDITION BEGIN - JUKEBOX
  if (type === 'audio/jukebox/playing') {
    return {
      ...state,
      visible: true,
    };
  }
  if (type === 'audio/jukebox/stopped') {
    return visible(
      {
        ...state,
        jukebox: {
          ...state.jukebox,
          [payload.jukeboxId]: null,
        },
      },
      payload,
    );
  }
  if (type === 'audio/jukebox/destroy') {
    const jukebox = { ...state.jukebox };
    delete jukebox[payload.jukeboxId];

    return visible(
      {
        ...state,
        jukebox,
      },
      payload,
    );
  }
  if (type === 'audio/jukebox/playMusic') {
    return {
      ...state,
      jukebox: {
        ...state.jukebox,
        [payload.jukeboxId]: payload,
      },
    };
  }
  if (type === 'audio/jukebox/toggleMute') {
    const muted = state.muted;

    if (muted.includes(payload.jukeboxId)) {
      muted.splice(muted.indexOf(payload.jukebox), 1);
    } else {
      muted.push(payload.jukeboxId);
    }

    return {
      ...state,
      muted,
    };
  }
  // PSYCHONAUT ADDITION END - JUKEBOX
  return state;
};
