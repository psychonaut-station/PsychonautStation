import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack, TextArea } from 'tgui-core/components';

import { PreferencesMenuData } from '../types';
import { useServerPrefs } from '../useServerPrefs';

export const BackgroundPage = () => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const {
    character_desc,
    medical_records,
    security_records,
    employment_records,
    exploit_records,
  } = data;

  const [characterDesc, setCharacterDesc] = useState(character_desc);
  const [medicalRecords, setMedicalRecords] = useState(medical_records);
  const [securityRecords, setSecurityRecords] = useState(security_records);
  const [employmentRecords, setEmploymentRecords] =
    useState(employment_records);
  const [exploitsRecords, setExploitsRecords] = useState(exploit_records);

  const serverData = useServerPrefs();
  if (!serverData) return;

  return (
    <Stack vertical>
      <Stack.Item>
        <Section
          title="Character Description"
          buttons={
            <Box>
              <Box
                as="span"
                m={1}
                color={
                  characterDesc.length > 192
                    ? characterDesc.length > 256
                      ? 'red'
                      : 'yellow'
                    : 'green'
                }
              >
                {characterDesc.length}/256
              </Box>

              <Button
                icon="save"
                disabled={characterDesc === character_desc}
                onClick={() =>
                  act('set_background_data', {
                    preference: 'character_desc',
                    value: characterDesc,
                  })
                }
              >
                Save
              </Button>
              <Button
                icon="times"
                onClick={() => setCharacterDesc(character_desc)}
              >
                Reset
              </Button>
            </Box>
          }
        >
          <TextArea
            width="100%"
            height="100px"
            style={
              characterDesc.length > 256
                ? { borderColor: '#D4282B' }
                : undefined
            }
            onChange={setCharacterDesc}
            value={characterDesc}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Stack fill>
          <Stack.Item width="100%">
            <Section
              title="Medical Records"
              buttons={
                <Box>
                  <Box
                    as="span"
                    m={1}
                    color={
                      medicalRecords.length > 192
                        ? medicalRecords.length > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {medicalRecords.length}/256
                  </Box>
                  <Button
                    icon="save"
                    disabled={medicalRecords === medical_records}
                    onClick={() =>
                      act('set_background_data', {
                        preference: 'medical_records',
                        value: medicalRecords,
                      })
                    }
                  >
                    Save
                  </Button>
                  <Button
                    icon="times"
                    onClick={() => setMedicalRecords(medical_records)}
                  >
                    Reset
                  </Button>
                </Box>
              }
            >
              <TextArea
                width="100%"
                height="100px"
                style={
                  medicalRecords.length > 256
                    ? { borderColor: '#D4282B' }
                    : undefined
                }
                onChange={setMedicalRecords}
                value={medicalRecords}
              />
            </Section>
          </Stack.Item>

          <Stack.Item width="100%">
            <Section
              title="Security Records"
              buttons={
                <Box>
                  <Box
                    as="span"
                    m={1}
                    color={
                      securityRecords.length > 192
                        ? securityRecords.length > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {securityRecords.length}/256
                  </Box>
                  <Button
                    icon="save"
                    disabled={securityRecords === security_records}
                    onClick={() =>
                      act('set_background_data', {
                        preference: 'security_records',
                        value: securityRecords,
                      })
                    }
                  >
                    Save
                  </Button>
                  <Button
                    icon="times"
                    onClick={() => setSecurityRecords(security_records)}
                  >
                    Reset
                  </Button>
                </Box>
              }
            >
              <TextArea
                width="100%"
                height="100px"
                style={
                  securityRecords.length > 256
                    ? { borderColor: '#D4282B' }
                    : undefined
                }
                onChange={setSecurityRecords}
                value={securityRecords}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <Stack fill>
          <Stack.Item width="100%">
            <Section
              title="Employment Records"
              buttons={
                <Box>
                  <Box
                    as="span"
                    m={1}
                    color={
                      employmentRecords.length > 192
                        ? employmentRecords.length > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {employmentRecords.length}/256
                  </Box>
                  <Button
                    icon="save"
                    disabled={employmentRecords === employment_records}
                    onClick={() =>
                      act('set_background_data', {
                        preference: 'employment_records',
                        value: employmentRecords,
                      })
                    }
                  >
                    Save
                  </Button>
                  <Button
                    icon="times"
                    onClick={() => setEmploymentRecords(employment_records)}
                  >
                    Reset
                  </Button>
                </Box>
              }
            >
              <TextArea
                width="100%"
                height="100px"
                style={
                  employmentRecords.length > 256
                    ? { borderColor: '#D4282B' }
                    : undefined
                }
                onChange={setEmploymentRecords}
                value={employmentRecords}
              />
            </Section>
          </Stack.Item>

          <Stack.Item width="100%">
            <Section
              title="Exploit Records"
              buttons={
                <Box>
                  <Box
                    as="span"
                    m={1}
                    color={
                      exploitsRecords.length > 192
                        ? exploitsRecords.length > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {exploitsRecords.length}/256
                  </Box>
                  <Button
                    icon="save"
                    disabled={exploitsRecords === exploit_records}
                    onClick={() =>
                      act('set_background_data', {
                        preference: 'exploit_records',
                        value: exploitsRecords,
                      })
                    }
                  >
                    Save
                  </Button>
                  <Button
                    icon="times"
                    onClick={() => setExploitsRecords(exploit_records)}
                  >
                    Reset
                  </Button>
                </Box>
              }
            >
              <TextArea
                width="100%"
                height="100px"
                style={
                  exploitsRecords.length > 256
                    ? { borderColor: '#D4282B' }
                    : undefined
                }
                onChange={setExploitsRecords}
                value={exploitsRecords}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
