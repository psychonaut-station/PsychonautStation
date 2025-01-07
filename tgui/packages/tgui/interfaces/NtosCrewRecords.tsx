import { useBackend } from 'tgui/backend';

import { NtosWindow } from '../layouts';
import { CrewRecordsContent } from './CrewRecords';
import { CrewRecordData } from './CrewRecords/types';

export const NtosCrewRecords = (props) => {
  const { act, data } = useBackend<CrewRecordData>();
  const { authenticated } = data;

  return (
    <NtosWindow width={750} height={550}>
      <NtosWindow.Content>
        <CrewRecordsContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
