import { SyntheticEvent } from 'react';
import { Box, Section, Stack, TextArea } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { PreferencesMenuData } from './data';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

export const BackgroundPage = () => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const setBackgroundInfo = (
    event: SyntheticEvent<HTMLInputElement>,
    key: string,
  ) => {
    act('set_background_data', {
      key,
      value: event.target.value,
    });
  };
  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (serverData) {
          return (
            <Stack vertical>
              <Stack.Item>
                <Section title="Character Description">
                  <TextArea
                    width="100%"
                    height="100px"
                    onChange={(e) => setBackgroundInfo(e, 'character_desc')}
                    value={data.background_info['character_desc'] || ''}
                  />
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Stack fill>
                  <Stack.Item width="100%">
                    <Section title="Medical Records">
                      <TextArea
                        width="100%"
                        height="100px"
                        onChange={(e) =>
                          setBackgroundInfo(e, 'medical_records')
                        }
                        value={data.background_info['medical_records'] || ''}
                      />
                    </Section>
                  </Stack.Item>
                  <Stack.Item width="100%">
                    <Section title="Security Records">
                      <TextArea
                        width="100%"
                        height="100px"
                        onChange={(e) =>
                          setBackgroundInfo(e, 'security_records')
                        }
                        value={data.background_info['security_records'] || ''}
                      />
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Stack fill>
                  <Stack.Item width="100%">
                    <Section title="Employment Records">
                      <TextArea
                        width="100%"
                        height="100px"
                        onChange={(e) =>
                          setBackgroundInfo(e, 'employment_records')
                        }
                        value={data.background_info['employment_records'] || ''}
                      />
                    </Section>
                  </Stack.Item>
                  <Stack.Item width="100%">
                    <Section title="Exploit Records">
                      <TextArea
                        width="100%"
                        height="100px"
                        onChange={(e) =>
                          setBackgroundInfo(e, 'exploit_records')
                        }
                        value={data.background_info['exploit_records'] || ''}
                      />
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          );
        } else {
          return <Box>Loading background information...</Box>;
        }
      }}
    />
  );
};
