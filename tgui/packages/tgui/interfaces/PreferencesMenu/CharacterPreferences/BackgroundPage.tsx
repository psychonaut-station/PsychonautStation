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

  const [numberOfCharacterDesc, setNumberOfCharacterDesc] = useState(
    character_desc?.length || 0,
  );
  const [numberOfMedicalRecords, setNumberOfMedicalRecords] = useState(
    medical_records?.length || 0,
  );
  const [numberOfSecurityRecords, setNumberOfSecurityRecords] = useState(
    employment_records?.length || 0,
  );
  const [numberOfEmploymentRecords, setNumberOfEmploymentRecords] = useState(
    security_records?.length || 0,
  );
  const [numberOfExploitsRecords, setNumberOfExploitsRecords] = useState(
    exploit_records?.length || 0,
  );

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
                  numberOfCharacterDesc > 192
                    ? numberOfCharacterDesc > 256
                      ? 'red'
                      : 'yellow'
                    : 'green'
                }
              >
                {numberOfCharacterDesc}/256
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
            style={{
              border: `1px solid ${numberOfCharacterDesc > 256 ? '#D4282B' : 'hsl(212.3, 100%, 76.7%)'}`,
            }}
            onChange={(e, value) => setCharacterDesc(value)}
            onInput={(e, value) => setNumberOfCharacterDesc(value.length)}
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
                      numberOfMedicalRecords > 192
                        ? numberOfMedicalRecords > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {numberOfMedicalRecords}/256
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
                style={{
                  border: `1px solid ${numberOfMedicalRecords > 256 ? '#D4282B' : 'hsl(212.3, 100%, 76.7%)'}`,
                }}
                onChange={(e, value) => setMedicalRecords(value)}
                onInput={(e, value) => setNumberOfMedicalRecords(value.length)}
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
                      numberOfSecurityRecords > 192
                        ? numberOfSecurityRecords > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {numberOfSecurityRecords}/256
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
                style={{
                  border: `1px solid ${numberOfSecurityRecords > 256 ? '#D4282B' : 'hsl(212.3, 100%, 76.7%)'}`,
                }}
                onChange={(e, value) => setSecurityRecords(value)}
                onInput={(e, value) => setNumberOfSecurityRecords(value.length)}
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
                      numberOfEmploymentRecords > 192
                        ? numberOfEmploymentRecords > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {numberOfEmploymentRecords}/256
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
                style={{
                  border: `1px solid ${numberOfEmploymentRecords > 256 ? '#D4282B' : 'hsl(212.3, 100%, 76.7%)'}`,
                }}
                onChange={(e, value) => setEmploymentRecords(value)}
                onInput={(e, value) =>
                  setNumberOfEmploymentRecords(value.length)
                }
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
                      numberOfExploitsRecords > 192
                        ? numberOfExploitsRecords > 256
                          ? 'red'
                          : 'yellow'
                        : 'green'
                    }
                  >
                    {numberOfExploitsRecords}/256
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
                style={{
                  border: `1px solid ${numberOfExploitsRecords > 256 ? '#D4282B' : 'hsl(212.3, 100%, 76.7%)'}`,
                }}
                onChange={(e, value) => setExploitsRecords(value)}
                onInput={(e, value) => setNumberOfExploitsRecords(value.length)}
                value={exploitsRecords}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
