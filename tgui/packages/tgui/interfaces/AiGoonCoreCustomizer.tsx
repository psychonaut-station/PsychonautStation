import { useState } from 'react';
import {
  Box,
  DmIcon,
  Flex,
  ImageButton,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type CoreOption = {
  name: string;
  state: string;
  description: string;
};

type BackgroundOption = {
  name: string;
  state: string;
};

type LightModeOption = {
  name: string;
  state: string;
  preview_state?: string;
};

type FaceOption = {
  name: string;
  state: string;
};

type Data = {
  icon: string;
  current_core_name: string;
  current_core_state: string;
  current_core_description: string;
  current_background_name: string;
  current_background_state: string;
  current_light_mode_name: string;
  current_light_mode: string;
  current_face_name: string;
  current_face_state: string;
  current_light_state?: string;
  core_count: number;
  background_count: number;
  light_mode_count: number;
  face_count: number;
  core_options: CoreOption[];
  background_options: BackgroundOption[];
  light_mode_options: LightModeOption[];
  face_options: FaceOption[];
};

const previewFrameStyle = {
  background: 'rgba(12, 16, 22, 0.95)',
  border: '1px solid rgba(90, 120, 155, 0.38)',
  borderRadius: '8px',
  boxShadow: 'none',
  padding: '8px',
};

const optionCardStyle = (selected: boolean) => ({
  background: selected ? 'rgba(31, 52, 78, 0.95)' : 'rgba(14, 18, 24, 0.95)',
  border: selected
    ? '1px solid rgba(124, 198, 255, 0.75)'
    : '1px solid rgba(80, 104, 133, 0.28)',
  borderRadius: '8px',
  display: 'inline-block',
  margin: '0 4px 4px 0',
  minHeight: '104px',
  padding: '5px',
  verticalAlign: 'top',
  width: '122px',
});

export const AiGoonCoreCustomizer = () => {
  return (
    <Window width={1220} height={760} title="Goon Core Matrix">
      <Window.Content scrollable>
        <AiGoonCoreCustomizerContent />
      </Window.Content>
    </Window>
  );
};

const AiGoonCoreCustomizerContent = () => {
  const { act, data } = useBackend<Data>();
  const {
    icon,
    current_core_name,
    current_core_state,
    current_core_description,
    current_background_name,
    current_background_state,
    current_light_mode_name,
    current_light_mode,
    current_face_name,
    current_face_state,
    current_light_state,
    core_count = 0,
    background_count = 0,
    light_mode_count = 0,
    face_count = 0,
    core_options = [],
    background_options = [],
    light_mode_options = [],
    face_options = [],
  } = data;

  const [coreSearch, setCoreSearch] = useState('');
  const [backgroundSearch, setBackgroundSearch] = useState('');
  const [lightSearch, setLightSearch] = useState('');
  const [faceSearch, setFaceSearch] = useState('');

  const filteredCores = core_options.filter((option) =>
    option.name.toLowerCase().includes(coreSearch.toLowerCase()),
  );
  const filteredBackgrounds = background_options.filter((option) =>
    option.name.toLowerCase().includes(backgroundSearch.toLowerCase()),
  );
  const filteredLightModes = light_mode_options.filter((option) =>
    option.name.toLowerCase().includes(lightSearch.toLowerCase()),
  );
  const filteredFaces = face_options.filter((option) =>
    option.name.toLowerCase().includes(faceSearch.toLowerCase()),
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Current Configuration">
          <Stack>
            <Stack.Item grow={2}>
              <Box style={previewFrameStyle}>
                <Flex align="center" justify="space-between">
                  <Flex.Item>
                    <Box color="label" mb={0.5} fontSize="0.9em">
                      Active core shell
                    </Box>
                    <Box bold color="good" fontSize="1.05em">
                      {current_core_name}
                    </Box>
                    <Box color="label" mt={0.5} fontSize="0.9em">
                      {current_core_description}
                    </Box>
                    <Box color="label" mt={1} fontSize="0.9em">
                      Active screen background
                    </Box>
                    <Box bold color="average" fontSize="0.95em">
                      {current_background_name}
                    </Box>
                    <Box color="label" mt={1} fontSize="0.9em">
                      Active light mode
                    </Box>
                    <Box bold color="average" fontSize="0.95em">
                      {current_light_mode_name}
                    </Box>
                    <Box color="label" mt={1} fontSize="0.9em">
                      Active face
                    </Box>
                    <Box bold color="average" fontSize="0.95em">
                      {current_face_name}
                    </Box>
                    <Box color="label" mt={1} fontSize="0.85em">
                      {core_count} core shells, {background_count} backgrounds, {light_mode_count} light modes, and {face_count} face screens available.
                    </Box>
                  </Flex.Item>
                  <Flex.Item>
                    <CompositePreview
                      icon={icon}
                      coreState={current_core_state}
                      backgroundState={current_background_state}
                      faceState={current_face_state}
                      lightState={current_light_state}
                      size={112}
                    />
                  </Flex.Item>
                </Flex>
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              <Stack fill vertical>
                <Stack.Item grow>
                  <PreviewPanel
                    title="Core Shell"
                    icon={icon}
                    state={current_core_state}
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <PreviewPanel
                    title="Screen Background"
                    icon={icon}
                    state={current_background_state}
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <PreviewPanel
                    title="Light Layer"
                    icon={icon}
                    state={current_light_state}
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <PreviewPanel
                    title="Face Screen"
                    icon={icon}
                    state={current_face_state}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Stack fill>
          <Stack.Item grow>
            <Section
              title={`Core Shells (${filteredCores.length}/${core_count})`}
              buttons={
                <Input
                  fluid
                  placeholder="Search core shells..."
                  value={coreSearch}
                  onChange={(value) =>
                    setCoreSearch(typeof value === 'string' ? value : '')
                  }
                />
              }
            >
              <OptionGrid
                icon={icon}
                currentState={current_core_state}
                options={filteredCores}
                onSelect={(state) => act('select_core', { state })}
                type="core"
              />
              {filteredCores.length === 0 && (
                <Box mt={2} textAlign="center" color="average">
                  No core shells match "{coreSearch}".
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              title={`Screen Backgrounds (${filteredBackgrounds.length}/${background_count})`}
              buttons={
                <Input
                  fluid
                  placeholder="Search backgrounds..."
                  value={backgroundSearch}
                  onChange={(value) =>
                    setBackgroundSearch(typeof value === 'string' ? value : '')
                  }
                />
              }
            >
              <OptionGrid
                icon={icon}
                currentState={current_background_state}
                options={filteredBackgrounds}
                onSelect={(state) => act('select_background', { state })}
                type="background"
              />
              {filteredBackgrounds.length === 0 && (
                <Box mt={2} textAlign="center" color="average">
                  No backgrounds match "{backgroundSearch}".
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              title={`Light Modes (${filteredLightModes.length}/${light_mode_count})`}
              buttons={
                <Input
                  fluid
                  placeholder="Search light modes..."
                  value={lightSearch}
                  onChange={(value) =>
                    setLightSearch(typeof value === 'string' ? value : '')
                  }
                />
              }
            >
              <OptionGrid
                icon={icon}
                currentState={current_light_mode}
                options={filteredLightModes}
                onSelect={(state) => act('select_light_mode', { state })}
                type="light"
              />
              {filteredLightModes.length === 0 && (
                <Box mt={2} textAlign="center" color="average">
                  No light modes match "{lightSearch}".
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              title={`Face Screens (${filteredFaces.length}/${face_count})`}
              buttons={
                <Input
                  fluid
                  placeholder="Search face screens..."
                  value={faceSearch}
                  onChange={(value) =>
                    setFaceSearch(typeof value === 'string' ? value : '')
                  }
                />
              }
            >
              <OptionGrid
                icon={icon}
                currentState={current_face_state}
                options={filteredFaces}
                onSelect={(state) => act('select_face', { state })}
                type="face"
              />
              {filteredFaces.length === 0 && (
                <Box mt={2} textAlign="center" color="average">
                  No face screens match "{faceSearch}".
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const PreviewPanel = ({
  title,
  icon,
  state,
}: {
  title: string;
  icon: string;
  state?: string;
}) => (
  <Box style={previewFrameStyle}>
    <Box bold mb={0.5} fontSize="0.9em">
      {title}
    </Box>
    {!!state ? (
      <DmIcon icon={icon} icon_state={state} width="72px" height="72px" />
    ) : (
      <Box color="label" fontSize="0.85em">
        No active layer
      </Box>
    )}
  </Box>
);

const CompositePreview = ({
  icon,
  coreState,
  backgroundState,
  faceState,
  lightState,
  size,
}: {
  icon: string;
  coreState: string;
  backgroundState: string;
  faceState: string;
  lightState?: string;
  size: number;
}) => (
  <Box
    style={{
      background: 'rgba(8, 10, 14, 0.65)',
      height: `${size}px`,
      margin: '0 auto',
      position: 'relative',
      width: `${size}px`,
    }}
  >
    <Box style={{ left: 0, position: 'absolute', top: 0 }}>
      <DmIcon icon={icon} icon_state={coreState} width={`${size}px`} height={`${size}px`} />
    </Box>
    <Box style={{ left: 0, position: 'absolute', top: 0 }}>
      <DmIcon icon={icon} icon_state={backgroundState} width={`${size}px`} height={`${size}px`} />
    </Box>
    <Box style={{ left: 0, position: 'absolute', top: 0 }}>
      <DmIcon icon={icon} icon_state={faceState} width={`${size}px`} height={`${size}px`} />
    </Box>
    {!!lightState && (
      <Box style={{ left: 0, position: 'absolute', top: 0 }}>
        <DmIcon icon={icon} icon_state={lightState} width={`${size}px`} height={`${size}px`} />
      </Box>
    )}
  </Box>
);

const OptionGrid = ({
  icon,
  currentState,
  onSelect,
  options,
  type,
}: {
  icon: string;
  currentState: string;
  onSelect: (state: string) => void;
  options: Array<CoreOption | BackgroundOption | LightModeOption | FaceOption>;
  type: 'core' | 'background' | 'light' | 'face';
}) => (
  <Box>
    {options.map((option) => {
      const selected = option.state === currentState;
      const activeLabel =
        type === 'core'
          ? 'Active shell'
          : type === 'background'
            ? 'Active background'
            : type === 'light'
              ? 'Active light mode'
              : 'Active face';
      const previewState =
        'preview_state' in option && option.preview_state
          ? option.preview_state
          : option.state;
      return (
        <Box key={option.state} style={optionCardStyle(selected)}>
          <ImageButton
            dmIcon={icon}
            dmIconState={previewState}
            imageSize={58}
            onClick={() => onSelect(option.state)}
            tooltip={option.name}
          >
            {option.name}
          </ImageButton>
          {'description' in option && !!option.description && (
            <Box color="label" fontSize="0.75em" mt={0.5}>
              {option.description}
            </Box>
          )}
          {selected && (
            <Box color="good" fontSize="0.75em" mt={0.5}>
              {activeLabel}
            </Box>
          )}
        </Box>
      );
    })}
  </Box>
);
