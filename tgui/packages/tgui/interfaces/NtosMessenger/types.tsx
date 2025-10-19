import type { BooleanLike } from 'tgui-core/react';

export type NtMessage = {
  message: string;
  outgoing: BooleanLike;
  photo_path?: string;
  everyone: BooleanLike;
  timestamp: string;
};

export type NtPicture = {
  uid: number;
  path: string;
};

export type NtMessenger = {
  name: string;
  job: string;
  ref?: string;
  // PSYCHONAUT ADDITION BEGIN - ALTERNATIVE_JOB_TITLES
  job_trim: string;
  // PSYCHONAUT ADDITION END - ALTERNATIVE_JOB_TITLES
};

export type NtChat = {
  ref: string;
  recipient: NtMessenger;
  messages: NtMessage[];
  visible: BooleanLike;
  owner_deleted: BooleanLike;
  can_reply: BooleanLike;
  message_draft: string;
  unread_messages: number;
};
