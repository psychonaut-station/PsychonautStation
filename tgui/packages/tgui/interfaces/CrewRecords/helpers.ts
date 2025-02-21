import { useBackend, useLocalState } from 'tgui/backend';

import { CrewRecord, CrewRecordData } from './types';

/** Splits a medical string on <br> into a string array */
export const getQuirkStrings = (string: string) => {
  return string?.split('<br>') || [];
};

/** We need an active reference and this a pain to rewrite */
export const getCrewRecord = () => {
  const [selectedRecord] = useLocalState<CrewRecord | undefined>(
    'medicalRecord',
    undefined,
  );
  if (!selectedRecord) return;
  const { data } = useBackend<CrewRecordData>();
  const { records = [] } = data;
  const foundRecord = records.find(
    (record) => record.crew_ref === selectedRecord.crew_ref,
  );
  if (!foundRecord) return;

  return foundRecord;
};
