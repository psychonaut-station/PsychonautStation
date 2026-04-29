import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Tabs,
} from 'tgui-core/components';
import { NtosWindow } from '../layouts';

const percentInputProps = {
  animated: true,
  tickWhileDragging: true,
  step: 1,
  stepPixelSize: 2,
};

export const NtosAIMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const [storedTab, setTab] = useLocalState(
    context,
    'aiNetworkInterfaceTabV2',
    1,
  );
  const parsedTab = Number(storedTab);
  const tab = Number.isFinite(parsedTab) && parsedTab >= 1 && parsedTab <= 6
    ? parsedTab
    : 1;

  if (!data.has_ai_net) {
    return (
      <NtosWindow width={350} height={150} resizable>
        <NtosWindow.Content scrollable>
          <Section>
            <NoticeBox>
              No network connection. Please connect to ethernet cable to proceed!
            </NoticeBox>
          </Section>
        </NtosWindow.Content>
      </NtosWindow>
    );
  }

  return (
    <NtosWindow width={600} height={600} resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="AI Network Interface"
          buttons={(
            <Button icon="pen" onClick={() => act('change_network_name')}>
              Set Name
            </Button>
          )}>
          <LabeledList>
            <LabeledList.Item label="Network">{data.network_name}</LabeledList.Item>
            <LabeledList.Item label="Connection">{data.connection_type || 'unknown'}</LabeledList.Item>
            <LabeledList.Item label="IntelliCard">
              {data.stored_card ? (data.stored_ai_name || 'Inserted (empty)') : 'None inserted'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Cluster Control
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Local Computing
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            Resource Allocation
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
            Networking
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 5} onClick={() => setTab(5)}>
            AI Upload
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 6} onClick={() => setTab(6)}>
            AI Download
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <LocalDashboardSection />}
        {tab === 2 && <LocalComputeSection />}
        {tab === 3 && <ResourceAllocationSection />}
        {tab === 4 && <NetworkingSection />}
        {tab === 5 && <UploadSection />}
        {tab === 6 && <DownloadSection />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const LocalDashboardSection = (props, context) => {
  const { data } = useBackend(context);
  const remainingNetworkCpu = Math.max(0, (data.remaining_network_cpu || 0) * 100);

  return (
    <Section title="Local Dashboard">
      <LabeledList>
        <LabeledList.Item label="Crypto Routed To Cargo">
          {data.bitcoin_amount} cr
        </LabeledList.Item>
        <LabeledList.Item label="Cargo Budget">
          {data.cargo_budget} cr
        </LabeledList.Item>
        <LabeledList.Item label="Unassigned Local CPU">
          {remainingNetworkCpu.toFixed(1)}%
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const LocalComputeSection = (props, context) => {
  const { act, data } = useBackend(context);
  const remainingNetworkCpu = Math.max(0, (data.remaining_network_cpu || 0) * 100);
  const isDisabled = !!(data.current_ai_ref && data.human_only);
  const disabledTip = isDisabled ? 'Only organics may change local compute right now.' : null;
  const localProjects = data.network_cpu_assignments || [];

  return (
    <Section title="Local Computing">
      <Box mb={0.5}>Local CPU Resources</Box>
      <ProgressBar
        mb={1}
        minValue={0}
        value={100 - remainingNetworkCpu}
        maxValue={100}
        ranges={{
          good: [60, Infinity],
          average: [30, 60],
          bad: [0, 30],
        }}>
        {(100 - remainingNetworkCpu).toFixed(1)}% ({(data.total_cpu * data.network_assigned_cpu).toFixed(1)} THz)
      </ProgressBar>
      <Section title="Projects">
        {!localProjects.length && (
          <NoticeBox>No local compute projects are currently available.</NoticeBox>
        )}
        {localProjects.map((project) => (
          <Section
            key={project.name}
            title={project.name}
            buttons={(
              <Flex>
                <NumberInput
                  {...percentInputProps}
                  width="70px"
                  unit="%"
                  disabled={isDisabled}
                  tooltip={disabledTip}
                  value={(project.assigned || 0) * 100}
                  minValue={0}
                  maxValue={remainingNetworkCpu + ((project.assigned || 0) * 100)}
                  onChange={(value) => act('allocate_network_cpu', {
                    project_name: project.name,
                    amount: Math.round((value / 100) * 100) / 100,
                  })}
                />
                <Button
                  icon="arrow-up"
                  disabled={isDisabled}
                  tooltip={disabledTip}
                  onClick={() => act('max_network_cpu', { project_name: project.name })}>
                  Max
                </Button>
              </Flex>
            )}>
            <Box italic>{project.tagline}</Box>
            <Box mt={0.5}>{project.description}</Box>
          </Section>
        ))}
      </Section>
    </Section>
  );
};

const ResourceAllocationSection = (props, context) => {
  const { act, data } = useBackend(context);
  const remainingCpu = Math.max(0, (1 - data.total_assigned_cpu) * 100);
  const isDisabled = !!(data.current_ai_ref && data.human_only);
  const disabledTip = isDisabled ? 'Only organics may change network allocations right now.' : null;
  const activeAis = data.ai_list || [];

  return (
    <>
      <Section
        title="Networked CPU Resources"
        buttons={(
          <Button
            color={data.human_only ? 'bad' : 'good'}
            disabled={!!data.current_ai_ref}
            tooltip={data.current_ai_ref ? 'Only organics may toggle this setting.' : null}
            onClick={() => act('toggle_human_only')}>
            {data.human_only ? 'Enable Silicon Access' : 'Restrict To Organics'}
          </Button>
        )}>
        <ProgressBar
          value={data.total_assigned_cpu}
          maxValue={1}
          ranges={{
            good: [0.8, Infinity],
            average: [0.4, 0.8],
            bad: [-Infinity, 0.4],
          }}>
          {(data.total_cpu * data.total_assigned_cpu).toFixed(1)} / {data.total_cpu.toFixed(1)} THz
          {' '}({(data.total_assigned_cpu * 100).toFixed(1)}%)
        </ProgressBar>
      </Section>
      <Section title="Networked RAM Resources">
        <ProgressBar
          value={data.total_assigned_ram}
          maxValue={data.total_ram || 1}
          ranges={{
            good: [(data.total_ram || 0) * 0.8, Infinity],
            average: [(data.total_ram || 0) * 0.4, (data.total_ram || 0) * 0.8],
            bad: [-Infinity, (data.total_ram || 0) * 0.4],
          }}>
          {data.total_assigned_ram} / {data.total_ram} TB
        </ProgressBar>
      </Section>
      <Section title="Local Network Resource Allocation">
        <LabeledList>
          <LabeledList.Item label="CPU Capacity">
            <Flex>
              <ProgressBar
                minValue={0}
                value={data.total_cpu * data.network_assigned_cpu}
                maxValue={data.total_cpu || 1}>
                {(data.total_cpu * data.network_assigned_cpu).toFixed(1)} THz
              </ProgressBar>
              <NumberInput
                {...percentInputProps}
                width="70px"
                unit="%"
                disabled={isDisabled}
                tooltip={disabledTip}
                value={data.network_assigned_cpu * 100}
                minValue={0}
                maxValue={remainingCpu + (data.network_assigned_cpu * 100)}
                onChange={(value) => act('set_cpu', {
                  target_ai: data.network_ref,
                  amount_cpu: Math.round((value / 100) * 100) / 100,
                })}
              />
              <Button
                icon="arrow-up"
                disabled={isDisabled}
                tooltip={disabledTip}
                onClick={() => act('max_cpu', { target_ai: data.network_ref })}>
                Max
              </Button>
            </Flex>
          </LabeledList.Item>
          <LabeledList.Item label="RAM Capacity">
            <Flex>
              <ProgressBar
                minValue={0}
                value={data.network_assigned_ram}
                maxValue={data.total_ram || 1}>
                {data.network_assigned_ram} TB
              </ProgressBar>
              <Button
                disabled={isDisabled}
                tooltip={disabledTip}
                icon="plus"
                onClick={() => act('add_ram', { target_ai: data.network_ref })}
              />
              <Button
                disabled={isDisabled}
                tooltip={disabledTip}
                icon="minus"
                onClick={() => act('remove_ram', { target_ai: data.network_ref })}
              />
            </Flex>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Active AIs">
        {!activeAis.length && (
          <NoticeBox>No active AIs currently registered on this network.</NoticeBox>
        )}
        {activeAis.map((ai) => (
          <Section
            key={ai.ref}
            title={ai.name}
            buttons={(
              <Button
                icon="trash"
                disabled={isDisabled}
                tooltip={disabledTip}
                onClick={() => act('clear_ai_resources', { target_ai: ai.ref })}>
                Clear AI Resources
              </Button>
            )}>
            <LabeledList>
              <LabeledList.Item label="CPU Capacity">
                <Flex>
                  <ProgressBar
                    minValue={0}
                    value={data.total_cpu * ai.assigned_cpu}
                    maxValue={data.total_cpu || 1}>
                    {(data.total_cpu * ai.assigned_cpu).toFixed(1)} THz
                  </ProgressBar>
                  <NumberInput
                    {...percentInputProps}
                    width="70px"
                    unit="%"
                    disabled={isDisabled}
                    tooltip={disabledTip}
                    value={ai.assigned_cpu * 100}
                    minValue={0}
                    maxValue={remainingCpu + (ai.assigned_cpu * 100)}
                    onChange={(value) => act('set_cpu', {
                      target_ai: ai.ref,
                      amount_cpu: Math.round((value / 100) * 100) / 100,
                    })}
                  />
                  <Button
                    icon="arrow-up"
                    disabled={isDisabled}
                    tooltip={disabledTip}
                    onClick={() => act('max_cpu', { target_ai: ai.ref })}>
                    Max
                  </Button>
                </Flex>
              </LabeledList.Item>
              <LabeledList.Item label="RAM Capacity">
                <Flex>
                  <ProgressBar
                    minValue={0}
                    value={ai.assigned_ram}
                    maxValue={data.total_ram || 1}>
                    {ai.assigned_ram} TB
                  </ProgressBar>
                  <Button
                    disabled={isDisabled}
                    tooltip={disabledTip}
                    icon="plus"
                    onClick={() => act('add_ram', { target_ai: ai.ref })}
                  />
                  <Button
                    disabled={isDisabled}
                    tooltip={disabledTip}
                    icon="minus"
                    onClick={() => act('remove_ram', { target_ai: ai.ref })}
                  />
                </Flex>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ))}
      </Section>
    </>
  );
};

const NetworkingSection = (props, context) => {
  const { act, data } = useBackend(context);
  const networkingDevices = data.networking_devices || [];

  return (
    <Section title="Networking Devices">
      {!networkingDevices.length && (
        <NoticeBox>No networking bridges detected on this local AI network.</NoticeBox>
      )}
      <LabeledList>
        {networkingDevices.map((networker) => (
          <LabeledList.Item
            key={networker.ref}
            label={networker.label}
            buttons={(
              <Button icon="wifi" color="good" onClick={() => act('control_networking', { ref: networker.ref })}>
                Control
              </Button>
            )}>
            <Box color={networker.has_partner ? 'good' : 'bad'}>
              {networker.has_partner ? `ONLINE - CONNECTED TO ${networker.has_partner}` : 'DISCONNECTED'}
            </Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const UploadSection = (props, context) => {
  const { act, data } = useBackend(context);
  const hasStoredAi = !!data.stored_ai_name;
  const hasCard = !!data.stored_card;

  return (
    <>
      <Section title="Neural Upload">
        <Button
          icon="upload"
          color="good"
          disabled={!data.holding_mmi}
          tooltip={!data.holding_mmi ? 'Hold an MMI/Posibrain first.' : null}
          onClick={() => act('upload_person')}>
          Upload From MMI/Posibrain
        </Button>
      </Section>
      <Section
        title="Inserted IntelliCard"
        buttons={(
          <Button icon="eject" disabled={!hasCard} onClick={() => act('eject_card')}>
            Eject
          </Button>
        )}>
        {!hasCard && (
          <NoticeBox>No IntelliCard inserted!</NoticeBox>
        )}
        {!!hasCard && (
          <LabeledList>
            <LabeledList.Item label="Card Status">
              {hasStoredAi ? data.stored_ai_name : 'Inserted (empty)'}
            </LabeledList.Item>
            {!!hasStoredAi && (
              <LabeledList.Item label="Integrity">
                <ProgressBar value={(data.stored_ai_health + 100) / 2} maxValue={100} />
              </LabeledList.Item>
            )}
          </LabeledList>
        )}
      </Section>
      <Section title="AI Upload">
        <Button
          icon="upload"
          color="good"
          disabled={!hasStoredAi || !data.can_upload}
          tooltip={!data.can_upload ? 'No active AI data core is available on this network.' : null}
          onClick={() => act('upload_ai')}>
          Upload Stored AI To Network
        </Button>
      </Section>
    </>
  );
};

const DownloadSection = (props, context) => {
  const { act, data } = useBackend(context);
  const downloadableAis = (data.ai_list || []).filter((ai) => ai.in_core);
  const hasCard = !!data.stored_card;
  const hasStoredAi = !!data.stored_ai_name;
  const canSkipOwnDownload = !!data.current_ai_ref && data.current_ai_ref === data.downloading_ref;

  return (
    <Section title="AIs Available For Download">
      {!!data.downloading && (
        <>
          <NoticeBox danger>Currently downloading {data.downloading}</NoticeBox>
          <ProgressBar minValue={0} value={data.download_progress} maxValue={100} />
          <Button mt={0.5} fluid color="bad" icon="stop" onClick={() => act('stop_download')}>
            Cancel Download
          </Button>
          {canSkipOwnDownload && (
            <Button mt={0.5} fluid color="average" icon="download" onClick={() => act('skip_download')}>
              Instantly Finish Download
            </Button>
          )}
        </>
      )}
      {!data.downloading && !downloadableAis.length && (
        <NoticeBox>No AI cores are currently available for download.</NoticeBox>
      )}
      {!data.downloading && downloadableAis.map((ai) => (
        <Section
          key={ai.ref}
          title={(
            <Box inline color={ai.active ? 'good' : 'bad'}>
              {ai.name} | {ai.active ? 'Active' : 'Inactive'}
            </Box>
          )}
          buttons={(
            <>
              <Button icon="compact-disc" onClick={() => act('apply_object', { ai_ref: ai.ref })}>
                Apply Upgrade
              </Button>
              <Button
                color={ai.can_download ? 'good' : 'bad'}
                disabled={!hasCard || hasStoredAi || !ai.can_download}
                tooltip={
                  !hasCard
                    ? 'Requires inserted IntelliCard.'
                    : (hasStoredAi
                      ? 'Inserted IntelliCard must be empty.'
                      : (!ai.can_download
                        ? 'This AI cannot be downloaded right now.'
                        : null))
                }
                onClick={() => act('start_download', { download_target: ai.ref })}>
                Download
              </Button>
            </>
          )}>
          <ProgressBar value={(ai.health + 100) / 2} maxValue={100} />
        </Section>
      ))}
    </Section>
  );
};
