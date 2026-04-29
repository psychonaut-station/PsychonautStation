import { useState } from 'react';

import {
  Box,
  Button,
  Divider,
  Flex,
  Input,
  LabeledControls,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Tabs,
} from 'tgui-core/components';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

const percentInputProps = {
  animated: true,
  tickWhileDragging: true,
  step: 1,
  stepPixelSize: 2,
};

export const AiDashboard = (props, context) => {
  const { data } = useBackend(context);
  const [storedTab, setStoredTab] = useLocalState(context, 'tab', 1);
  const normalizedTab = Number(storedTab);
  const tab = [1, 2, 3, 4].includes(normalizedTab) ? normalizedTab : 1;
  const setTab = (nextTab) => setStoredTab(nextTab);
  const amountOfCpu = (data.current_cpu || 0) * (data.max_cpu || 0);

  return (
    <Window width={800} height={600} resizable title="Dashboard">
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledControls>
            <LabeledControls.Item>
              <ProgressBar
                ranges={{
                  good: [50, 100],
                  average: [25, 50],
                  bad: [0, 25],
                }}
                value={((data.integrity || 0) + 100) * 0.5}
                maxValue={100}>
                {(((data.integrity || 0) + 100) * 0.5).toFixed(1)}%
              </ProgressBar>
              System Integrity
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Box bold color="average">
                {data.location_name || 'Unknown'}
                <Box>({data.location_coords || 'N/A'})</Box>
              </Box>
              Current Uplink Location
            </LabeledControls.Item>
            <LabeledControls.Item>
              <ProgressBar
                ranges={{
                  good: [-Infinity, 250],
                  average: [250, 750],
                  bad: [750, Infinity],
                }}
                value={data.temperature || 0}
                maxValue={750}>
                {(data.temperature || 0).toFixed(1)}K
              </ProgressBar>
              Uplink Temperature
            </LabeledControls.Item>
          </LabeledControls>
          <Divider />
          <LabeledControls>
            <LabeledControls.Item>
              <ProgressBar
                ranges={{
                  good: [(data.used_cpu || 0) * 0.7, Infinity],
                  average: [(data.used_cpu || 0) * 0.3, (data.used_cpu || 0) * 0.7],
                  bad: [0, (data.used_cpu || 0) * 0.3],
                }}
                value={(data.used_cpu || 0) * amountOfCpu}
                maxValue={Math.max(amountOfCpu, 1)}>
                {((data.used_cpu || 0) * 100).toFixed(1)}%
                {' '}
                ({((data.used_cpu || 0) * amountOfCpu).toFixed(1)}/{amountOfCpu.toFixed(1)} THz)
              </ProgressBar>
              Utilized CPU Power
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Box minHeight="1.65em" />
            </LabeledControls.Item>
            <LabeledControls.Item>
              <ProgressBar
                ranges={{
                  good: [(data.current_ram || 0) * 0.7, Infinity],
                  average: [(data.current_ram || 0) * 0.3, (data.current_ram || 0) * 0.7],
                  bad: [0, (data.current_ram || 0) * 0.3],
                }}
                value={data.used_ram || 0}
                maxValue={Math.max(data.current_ram || 0, 1)}>
                {(data.used_ram || 0)} / {data.current_ram || 0} TB
              </ProgressBar>
              Utilized RAM Capacity
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Divider />
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Available Projects
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Completed Projects
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            Ability Charging
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
            Cloud Resources
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <AvailableProjects context={context} />}
        {tab === 2 && <CompletedProjects context={context} />}
        {tab === 3 && <AbilityCharging context={context} />}
        {tab === 4 && <NetworkingResources context={context} />}
      </Window.Content>
    </Window>
  );
};

const AvailableProjects = (props, context) => {
  const { act, data } = useBackend(context);
  const [search, setSearch] = useState('');
  const fallbackCategories = Array.from(
    new Set((data.available_projects || []).map((project) => project.category).filter(Boolean))
  );
  const categories = (data.categories && data.categories.length) ? data.categories : fallbackCategories;
  const defaultCategory = fallbackCategories[0] || categories?.[0];
  const [selectedCategory, setCategory] = useState(defaultCategory);
  const activeCategory = (selectedCategory && (categories || []).includes(selectedCategory))
    ? selectedCategory
    : defaultCategory;
  const hasActiveCategoryProjects = !!(data.available_projects || []).some(
    (project) => project.category === activeCategory
  );
  const remainingCpu = Math.max(0, (1 - (data.used_cpu || 0)) * 100);
  const filteredProjects = (data.available_projects || []).filter((project) => {
    if (search) {
      const searchableString = String(project.name).toLowerCase();
      return searchableString.includes(search.toLowerCase());
    }
    if (!activeCategory || !hasActiveCategoryProjects) {
      return true;
    }
    return project.category === activeCategory;
  });

  return (
    <Section title="Available Projects" buttons={(
      <Input
        value={search}
        placeholder="Search.."
        onChange={(value) => setSearch(typeof value === 'string' ? value : '')}
      />
    )}>
      <Tabs>
        {(categories || []).map((category, index) => (
          <Tabs.Tab
            key={index}
            selected={!search ? activeCategory === category : null}
            onClick={() => setCategory(category)}>
            {category}
          </Tabs.Tab>
        ))}
      </Tabs>
      {!filteredProjects.length && (
        <Box color="average" bold>
          No upgrades found for the current filter.
        </Box>
      )}
      {!filteredProjects.length && (data.project_type_count || 0) > 0 && (data.loaded_project_count || 0) === 0 && (
        <Box color="bad" bold>
          Upgrade registry failed to load project definitions.
        </Box>
      )}
      {filteredProjects.map((project, index) => (
        <Section
          key={index}
          title={(
            <Box inline color={project.available ? 'lightgreen' : 'bad'}>
              {project.name} | {project.available ? 'Available' : 'Unavailable'}
            </Box>
          )}
          buttons={(
            <>
              <Box inline bold>Assigned CPU:&nbsp;</Box>
              <NumberInput
                {...percentInputProps}
                unit="%"
                value={(project.assigned_cpu || 0) * 100}
                minValue={0}
                maxValue={remainingCpu + ((project.assigned_cpu || 0) * 100)}
                onChange={(value) => act('allocate_cpu', {
                  project_name: project.name,
                  amount: Math.round((value / 100) * 100) / 100,
                })}
              />
              <Button
                icon="arrow-up"
                disabled={(data.used_cpu || 0) === 1}
                onClick={() => act('max_cpu', {
                  project_name: project.name,
                })}>
                Max
              </Button>
            </>
          )}>
          <Box inline bold>Research Cost:&nbsp;</Box>
          <Box inline>{project.research_cost} THz</Box>
          <br />
          <Box inline bold>RAM Requirement:&nbsp;</Box>
          <Box inline>{project.ram_required} TB</Box>
          <br />
          <Box inline bold>Research Requirements:&nbsp;</Box>
          <Box inline>{project.research_requirements}</Box>
          <Box mb={1}>
            {project.description}
          </Box>
          <ProgressBar
            value={(project.research_progress || 0) / Math.max(project.research_cost || 1, 1)}>
            {Math.round((((project.research_progress || 0) / Math.max(project.research_cost || 1, 1)) * 100) * 100) / 100}%
            {' '}
            ({Math.round((project.research_progress || 0) * 100) / 100}/{project.research_cost} THz)
          </ProgressBar>
        </Section>
      ))}
    </Section>
  );
};

const CompletedProjects = (props, context) => {
  const { act, data } = useBackend(context);
  const [searchCompleted, setSearchCompleted] = useState('');
  const [activeProjectsOnly, setActiveProjectsOnly] = useState(false);
  const fallbackCategories = Array.from(
    new Set((data.completed_projects || []).map((project) => project.category).filter(Boolean))
  );
  const categories = (data.categories && data.categories.length) ? data.categories : fallbackCategories;
  const defaultCategory = fallbackCategories[0] || categories?.[0];
  const [selectedCategory, setCategory] = useState(defaultCategory);
  const activeCategory = (selectedCategory && (categories || []).includes(selectedCategory))
    ? selectedCategory
    : defaultCategory;
  const hasActiveCategoryProjects = !!(data.completed_projects || []).some(
    (project) => project.category === activeCategory
  );
  const filteredCompletedProjects = (data.completed_projects || []).filter((project) => {
    if (searchCompleted) {
      const searchableString = String(project.name).toLowerCase();
      return searchableString.includes(searchCompleted.toLowerCase());
    }
    if (activeProjectsOnly && !project.can_be_run) {
      return false;
    }
    if (!activeCategory || !hasActiveCategoryProjects) {
      return true;
    }
    return project.category === activeCategory;
  });

  return (
    <Section title="Completed Projects" buttons={(
      <>
        <Button.Checkbox
          checked={activeProjectsOnly}
          onClick={() => setActiveProjectsOnly(!activeProjectsOnly)}>
          See Runnable Projects Only
        </Button.Checkbox>
        <Input
          value={searchCompleted}
          placeholder="Search.."
          onChange={(value) => setSearchCompleted(typeof value === 'string' ? value : '')}
        />
      </>
    )}>
      <Tabs>
        {(categories || []).map((category, index) => (
          <Tabs.Tab
            key={index}
            selected={!searchCompleted ? activeCategory === category : null}
            onClick={() => setCategory(category)}>
            {category}
          </Tabs.Tab>
        ))}
      </Tabs>
      {!filteredCompletedProjects.length && (
        <Box color="average" bold>
          No completed upgrades found for the current filter.
        </Box>
      )}
      {filteredCompletedProjects.map((project, index) => (
        <Section
          key={index}
          title={(
            <Box inline color={project.can_be_run ? (project.running ? 'lightgreen' : 'bad') : 'lightgreen'}>
              {project.name} | {project.can_be_run ? (project.running ? 'Running' : 'Not Running') : 'Passive'}
            </Box>
          )}
          buttons={!!project.can_be_run && (
            <Button
              icon={project.running ? 'stop' : 'play'}
              color={project.running ? 'bad' : 'good'}
              onClick={() => act(project.running ? 'stop_project' : 'run_project', {
                project_name: project.name,
              })}>
              {project.running ? 'Stop' : 'Run'}
            </Button>
          )}>
          {!!project.can_be_run && (
            <Box bold>RAM Requirement: {project.ram_required} TB</Box>
          )}
          <Box mb={1}>
            {project.description}
          </Box>
        </Section>
      ))}
    </Section>
  );
};

const AbilityCharging = (props, context) => {
  const { act, data } = useBackend(context);
  const remainingCpu = Math.max(0, (1 - (data.used_cpu || 0)) * 100);

  return (
    <Section title="Ability Charging">
      {(data.chargeable_abilities || []).filter((ability) => ability.uses < ability.max_uses).map((ability, index) => (
        <Section
          key={index}
          title={(
            <Box inline>
              {ability.name} | Uses Remaining: {ability.uses}/{ability.max_uses}
            </Box>
          )}
          buttons={(
            <>
              <Box inline bold>Assigned CPU:&nbsp;</Box>
              <NumberInput
                {...percentInputProps}
                unit="%"
                value={(ability.assigned_cpu || 0) * 100}
                minValue={0}
                maxValue={remainingCpu + ((ability.assigned_cpu || 0) * 100)}
                onChange={(value) => act('allocate_recharge_cpu', {
                  project_name: ability.project_name,
                  amount: Math.round((value / 100) * 100) / 100,
                })}
              />
            </>
          )}>
          <ProgressBar value={(ability.progress || 0) / Math.max(ability.cost || 1, 1)}>
            {Math.round((((ability.progress || 0) / Math.max(ability.cost || 1, 1)) * 100) * 100) / 100}%
            {' '}
            ({Math.round((ability.progress || 0) * 100) / 100}/{ability.cost} THz)
          </ProgressBar>
        </Section>
      ))}
    </Section>
  );
};

const NetworkingResources = (props, context) => {
  const { act, data } = useBackend(context);
  const amountOfCpu = (data.current_cpu || 0) * (data.max_cpu || 0);
  const tooltipDisabled = data.human_only
    ? 'Locked by organics. Please request their assistance.'
    : '';

  return (
    <Section title="Computing Resources">
      <Section title="Networked Resources" buttons={(
        <Button
          icon="trash"
          onClick={() => act('clear_ai_resources')}
          disabled={data.human_only}
          tooltip={tooltipDisabled}>
          Clear AI Resources
        </Button>
      )}>
        <LabeledList.Item>
          CPU Capacity:
          <Flex>
            <ProgressBar
              minValue={0}
              value={data.current_cpu || 0}
              maxValue={1}>
              {amountOfCpu.toFixed(1)} THz
            </ProgressBar>
            <NumberInput
              {...percentInputProps}
              width="60px"
              unit="%"
              value={(data.current_cpu || 0) * 100}
              minValue={0}
              maxValue={100}
              onChange={(value) => act('set_cpu', {
                amount_cpu: Math.round((value / 100) * 100) / 100,
              })}
              disabled={data.human_only}
              tooltip={tooltipDisabled}
            />
            <Button
              height={1.75}
              icon="arrow-up"
              onClick={() => act('max_cpu_assign')}
              disabled={data.human_only}
              tooltip={tooltipDisabled}>
              Max
            </Button>
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item>
          RAM Capacity:
          <Flex>
            <ProgressBar
              minValue={0}
              value={data.current_ram || 0}
              maxValue={Math.max(data.max_ram || 0, 1)}>
              {data.current_ram || 0} TB
            </ProgressBar>
            <Button
              mr={1}
              ml={1}
              height={1.75}
              icon="plus"
              onClick={() => act('add_ram')}
              disabled={data.human_only}
              tooltip={tooltipDisabled}
            />
            <Button
              height={1.75}
              icon="minus"
              onClick={() => act('remove_ram')}
              disabled={data.human_only}
              tooltip={tooltipDisabled}
            />
          </Flex>
        </LabeledList.Item>
      </Section>
    </Section>
  );
};
