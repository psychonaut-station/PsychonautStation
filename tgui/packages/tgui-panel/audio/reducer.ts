/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

// PSYCHONAUT EDIT ADDITION START - JUKEBOX
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
// PSYCHONAUT EDIT ADDITION END

// PSYCHONAUT EDIT CHANGE START - JUKEBOX
// const initialState = { - PSYCHONAUT EDIT - ORIGINAL
const initialState: State = {
// PSYCHONAUT EDIT CHANGE END
  visible: false,
  playing: false,
  meta: null, // PSYCHONAUT EDIT ADDITION - JUKEBOX
  track: null,
  jukebox: {}, // PSYCHONAUT EDIT ADDITION - JUKEBOX
  muted: [], // PSYCHONAUT EDIT ADDITION - JUKEBOX
};

// PSYCHONAUT EDIT ADDITION START - JUKEBOX
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
// PSYCHONAUT EDIT ADDITION END

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
    // PSYCHONAUT EDIT CHANGE START - JUKEBOX - ORIGINAL:
    // return {
    //   ...state,
    //   visible: false,
    //   playing: false,
    // };
    return visible({
      ...state,
      playing: false,
    });
    // PSYCHONAUT EDIT CHANGE END
  }
  if (type === 'audio/playMusic') {
    return {
      ...state,
      meta: payload,
    };
  }
  if (type === 'audio/stopMusic') {
    // PSYCHONAUT EDIT CHANGE START - JUKEBOX - ORIGINAL:
    // return {
    //   ...state,
    //   visible: false,
    //   playing: false,
    //   meta: null,
    // };
    return visible({
      ...state,
      playing: false,
      meta: null,
    });
    // PSYCHONAUT EDIT CHANGE END
  }
  if (type === 'audio/toggle') {
    return {
      ...state,
      visible: !state.visible,
    };
  }
  // PSYCHONAUT EDIT ADDITION START - JUKEBOX
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
  // PSYCHONAUT EDIT ADDITION END
  return state;
};
