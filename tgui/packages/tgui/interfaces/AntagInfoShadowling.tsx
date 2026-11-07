import { useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  type Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';

type RosterMember = {
  name: string;
  role: string;
  stat: string;
  is_user: boolean;
};

type Ability = {
  name: string;
  desc: string;
  icon: string;
  cooldown: number;
  channel: number;
  required_thralls: number;
  required_percent: number;
  unlocked: boolean;
  category: 'Innate' | 'Threshold' | 'Ascended';
  requires_dark: boolean;
};

type ShadowlingData = {
  name: string;
  role: string;
  role_type: 'ascended' | 'thrall' | 'lesser' | 'master';
  is_ascended: BooleanLike;
  is_thrall: BooleanLike;
  is_hatched: BooleanLike;
  hive_name: string;
  thrall_count: number;
  thralls_needed: number;
  ascension_progress: number;
  is_hive_ascended: BooleanLike;
  leader_name: string | null;
  objectives: Objective[];
  can_change_objective: BooleanLike;
  roster: RosterMember[];
  abilities: Ability[];
};

function getRoleColor(role_type: string): string {
  switch (role_type) {
    case 'ascended':
      return 'gold';
    case 'master':
      return 'purple';
    case 'lesser':
      return 'magenta';
    default:
      return 'grey';
  }
}

function getRoleIcon(role_type: string): string {
  switch (role_type) {
    case 'ascended':
      return 'sun';
    case 'master':
      return 'eye';
    case 'lesser':
      return 'ghost';
    default:
      return 'user-lock';
  }
}

function getRoleTypeFromRole(role: string): string {
  const lower = role.toLowerCase();
  if (lower.includes('ascended')) return 'ascended';
  if (lower.includes('lesser')) return 'lesser';
  if (lower.includes('thrall')) return 'thrall';
  return 'master';
}

function StatusBadge({ stat }: { stat: string }) {
  let color = 'good';
  let icon = 'heart';
  switch (stat) {
    case 'Phased':
      color = 'blue';
      icon = 'ghost';
      break;
    case 'Critical':
      color = 'average';
      icon = 'heartbeat';
      break;
    case 'Dead':
      color = 'bad';
      icon = 'skull';
      break;
    default:
      color = 'good';
      icon = 'heart';
      break;
  }
  return (
    <Button compact disabled color={color} icon={icon}>
      {stat}
    </Button>
  );
}

export const AntagInfoShadowling = () => {
  const { act, data } = useBackend<ShadowlingData>();
  const {
    name,
    role,
    role_type,
    is_ascended,
    is_thrall,
    is_hatched,
    hive_name,
    thrall_count,
    thralls_needed,
    ascension_progress,
    is_hive_ascended,
    leader_name,
    objectives = [],
    can_change_objective,
    roster = [],
    abilities = [],
  } = data;

  const [activeTab, setActiveTab] = useState<'directives' | 'abilities' | 'doctrine'>('directives');
  const [categoryFilter, setCategoryFilter] = useState<'all' | 'Innate' | 'Threshold' | 'Ascended'>('all');

  const progressVal = thralls_needed > 0 ? Math.min(1, thrall_count / thralls_needed) : 0;
  let barColor = 'purple';
  if (is_ascended || is_hive_ascended) {
    barColor = 'gold';
  } else if (thralls_needed > 0 && thrall_count >= thralls_needed) {
    barColor = 'crimson';
  }

  const filteredAbilities = abilities.filter((a) => {
    if (categoryFilter === 'all') return true;
    return a.category === categoryFilter;
  });

  return (
    <Window width={780} height={660} theme="dark">
      <Window.Content
        style={{
          backgroundColor: '#090615',
          color: '#e2e8f0',
        }}
      >
        <Stack fill vertical>
          {/* Top Banner */}
          <Stack.Item>
            <Section
              style={{
                backgroundColor: 'rgba(18, 12, 36, 0.85)',
                border: '1px solid #3b1d60',
              }}
            >
              <Stack vertical>
                <Stack.Item>
                  <Stack align="center" justify="space-between">
                    <Stack.Item grow>
                      <Stack align="center">
                        <Stack.Item>
                          <Icon name="moon" size={2} color="#a855f7" />
                        </Stack.Item>
                        <Stack.Item>
                          <Box bold fontSize="17px" style={{ letterSpacing: '1px', color: '#f3e8ff' }}>
                            SHADOWLING BROODMIND
                          </Box>
                          <Box fontSize="12px" color="#a78bfa">
                            {hive_name} &bull; Host: <Box as="span" bold color="#e9d5ff">{name}</Box>
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                    <Stack.Item>
                      <Stack align="center">
                        {!!leader_name && (
                          <Stack.Item>
                            <Button compact disabled icon="crown" color="gold">
                              Leader: {leader_name}
                            </Button>
                          </Stack.Item>
                        )}
                        <Stack.Item>
                          <Button
                            compact
                            disabled
                            icon={getRoleIcon(role_type)}
                            color={getRoleColor(role_type)}
                          >
                            {role}
                          </Button>
                        </Stack.Item>
                        {!is_hatched && role_type === 'master' && (
                          <Stack.Item>
                            <Button compact disabled color="warning" icon="exclamation-circle">
                              Incubating
                            </Button>
                          </Stack.Item>
                        )}
                        <Stack.Item>
                          <Button
                            icon="sync"
                            color="purple"
                            tooltip="Synchronize alive thrall count and refresh unlocked abilities"
                            onClick={() => act('sync')}
                          >
                            Hive Sync
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="comments"
                            color="violet"
                            tooltip="Broadcast a telepathic message to all brood members"
                            onClick={() => act('commune')}
                          >
                            Commune
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                {/* Thrall Harvest Bar */}
                <Stack.Item>
                  <Box mb={0.5} bold fontSize="11px" color="#c084fc">
                    THRALL HARVEST & ASCENSION PROGRESS
                  </Box>
                  <ProgressBar value={progressVal} color={barColor}>
                    <Box bold textAlign="center" fontSize="12px">
                      {is_ascended || is_hive_ascended
                        ? `BROOD ASCENDED (${thrall_count} Living Thralls)`
                        : `${thrall_count} / ${thralls_needed} Thralls Harvested (${ascension_progress}%)`}
                    </Box>
                  </ProgressBar>
                </Stack.Item>

                {/* Incubation Notice */}
                {!is_hatched && role_type === 'master' && (
                  <Stack.Item>
                    <NoticeBox color="yellow">
                      <Stack align="center">
                        <Stack.Item>
                          <Icon name="exclamation-circle" size={2} color="yellow" />
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box bold fontSize="13px" color="yellow">
                            INCUBATION PHASE &mdash; HATCH REQUIRED
                          </Box>
                          <Box fontSize="11px">
                            You are still confined within your human facade. Seek out absolute darkness and use your <strong>Hatch</strong> ability to emerge into your true shadow form and awaken your brood powers.
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </NoticeBox>
                  </Stack.Item>
                )}

                {/* Ascension Notices */}
                {thrall_count >= thralls_needed && thralls_needed > 0 && !is_ascended && !is_hive_ascended && (
                  <Stack.Item>
                    <NoticeBox danger>
                      <Stack align="center">
                        <Stack.Item>
                          <Icon name="exclamation-triangle" size={2} />
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box bold fontSize="13px">
                            ASCENSION THRESHOLD REACHED
                          </Box>
                          <Box fontSize="11px">
                            The required harvest of thralls is complete! Retreat into absolute darkness and unleash Ascension to shed your mortal vessel and claim your supreme form.
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </NoticeBox>
                  </Stack.Item>
                )}

                {(is_ascended || is_hive_ascended) && (
                  <Stack.Item>
                    <NoticeBox success>
                      <Stack align="center">
                        <Stack.Item>
                          <Icon name="crown" size={2} color="gold" />
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box bold fontSize="13px" color="gold">
                            TRANSCENDED MORTALITY
                          </Box>
                          <Box fontSize="11px">
                            You have cast aside your mortal shell. The cosmic darkness flows through your veins. Purge the vessel, shatter all resistance, and claim the station.
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </NoticeBox>
                  </Stack.Item>
                )}
              </Stack>
            </Section>
          </Stack.Item>

          {/* Navigation Tabs */}
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={activeTab === 'directives'}
                onClick={() => setActiveTab('directives')}
                icon="scroll"
              >
                Directives & Hive
              </Tabs.Tab>
              <Tabs.Tab
                selected={activeTab === 'abilities'}
                onClick={() => setActiveTab('abilities')}
                icon="bolt"
              >
                Evolution & Abilities ({abilities.filter((a) => a.unlocked).length}/{abilities.length})
              </Tabs.Tab>
              <Tabs.Tab
                selected={activeTab === 'doctrine'}
                onClick={() => setActiveTab('doctrine')}
                icon="book"
              >
                Brood Doctrine
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>

          {/* Tab Content */}
          <Stack.Item grow>
            {activeTab === 'directives' && (
              <Stack fill vertical>
                <Stack.Item>
                  <Section
                    title="Brood Directives"
                    buttons={
                      <ReplaceObjectivesButton
                        can_change_objective={can_change_objective}
                        button_title="Replace Objectives"
                        button_colour="purple"
                      />
                    }
                  >
                    <ObjectivePrintout
                      objectives={objectives}
                      titleMessage={is_thrall ? 'Thrall Directives' : 'Primary Brood Directives'}
                    />
                  </Section>
                </Stack.Item>
                <Stack.Item grow>
                  <Section
                    fill
                    scrollable
                    title={`Hive Brood Roster (${roster.length} Members)`}
                  >
                    <Table>
                      <Table.Row header>
                        <Table.Cell>Member Name</Table.Cell>
                        <Table.Cell>Brood Role</Table.Cell>
                        <Table.Cell collapsing textAlign="center">
                          Status
                        </Table.Cell>
                      </Table.Row>
                      {roster.map((member, index) => {
                        const mRoleType = getRoleTypeFromRole(member.role);
                        return (
                          <Table.Row
                            key={`${member.name}-${index}`}
                            style={{
                              backgroundColor: member.is_user
                                ? 'rgba(168, 85, 247, 0.12)'
                                : undefined,
                            }}
                          >
                            <Table.Cell bold={member.is_user}>
                              {member.name}
                              {member.is_user && (
                                <Box as="span" color="violet" bold ml={1}>
                                  (You)
                                </Box>
                              )}
                            </Table.Cell>
                            <Table.Cell>
                              <Button
                                compact
                                disabled
                                icon={getRoleIcon(mRoleType)}
                                color={getRoleColor(mRoleType)}
                              >
                                {member.role}
                              </Button>
                            </Table.Cell>
                            <Table.Cell collapsing textAlign="center">
                              <StatusBadge stat={member.stat} />
                            </Table.Cell>
                          </Table.Row>
                        );
                      })}
                    </Table>
                  </Section>
                </Stack.Item>
              </Stack>
            )}

            {activeTab === 'abilities' && (
              <Stack fill vertical>
                {!!is_thrall && (
                  <Stack.Item>
                    <NoticeBox info>
                      <Stack align="center">
                        <Stack.Item>
                          <Icon name="info-circle" size={2} />
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box bold fontSize="12px">
                            Thrall Brood Restrictions
                          </Box>
                          <Box fontSize="11px">
                            As an enslaved Thrall, Master and Ascended shadow abilities are unavailable to you. Thralls only have access to Brood Commune and Night Vision.
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </NoticeBox>
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Stack>
                    <Stack.Item>
                      <Button
                        selected={categoryFilter === 'all'}
                        onClick={() => setCategoryFilter('all')}
                      >
                        All ({abilities.length})
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        selected={categoryFilter === 'Innate'}
                        onClick={() => setCategoryFilter('Innate')}
                      >
                        Innate ({abilities.filter((a) => a.category === 'Innate').length})
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        selected={categoryFilter === 'Threshold'}
                        onClick={() => setCategoryFilter('Threshold')}
                      >
                        Threshold Unlocks ({abilities.filter((a) => a.category === 'Threshold').length})
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        selected={categoryFilter === 'Ascended'}
                        onClick={() => setCategoryFilter('Ascended')}
                      >
                        Ascended Powers ({abilities.filter((a) => a.category === 'Ascended').length})
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item grow>
                  <Section fill scrollable>
                    {filteredAbilities.map((ability) => {
                      const isLocked = !ability.unlocked;
                      const remaining = Math.max(0, ability.required_thralls - thrall_count);
                      return (
                        <Box
                          key={ability.name}
                          p={1}
                          mb={1}
                          style={{
                            backgroundColor: ability.unlocked
                              ? 'rgba(46, 16, 80, 0.35)'
                              : 'rgba(20, 16, 35, 0.45)',
                            border: ability.unlocked ? '1px solid #7c3aed' : '1px solid #2e1e47',
                            borderRadius: '4px',
                          }}
                        >
                          <Stack align="center" mb={0.5} justify="space-between">
                            <Stack.Item grow>
                              <Stack align="center">
                                <Stack.Item mr={1}>
                                  <DmIcon
                                    icon="icons/mob/antagonists/shadowling/shadowling_actions.dmi"
                                    icon_state={ability.icon}
                                    height="32px"
                                    width="32px"
                                    fallback={
                                      <Icon
                                        name="bolt"
                                        size={2}
                                        color={ability.unlocked ? 'violet' : 'grey'}
                                      />
                                    }
                                  />
                                </Stack.Item>
                                <Stack.Item>
                                  <Box
                                    bold
                                    fontSize="14px"
                                    color={ability.unlocked ? '#f3e8ff' : '#94a3b8'}
                                  >
                                    {ability.name}
                                  </Box>
                                  <Stack mt={0.5}>
                                    <Stack.Item>
                                      <Button
                                        compact
                                        disabled
                                        color={
                                          ability.category === 'Ascended'
                                            ? 'gold'
                                            : ability.category === 'Threshold'
                                              ? 'blue'
                                              : 'purple'
                                        }
                                      >
                                        {ability.category === 'Threshold'
                                          ? `${ability.required_percent}% Unlock`
                                          : ability.category}
                                      </Button>
                                    </Stack.Item>
                                    <Stack.Item>
                                      <Button
                                        compact
                                        disabled
                                        icon="stopwatch"
                                        color="transparent"
                                      >
                                        {ability.cooldown > 0 ? `${ability.cooldown}s CD` : 'Instant'}
                                      </Button>
                                    </Stack.Item>
                                    {ability.channel > 0 && (
                                      <Stack.Item>
                                        <Button
                                          compact
                                          disabled
                                          icon="hourglass-half"
                                          color="transparent"
                                        >
                                          {ability.channel}s Cast
                                        </Button>
                                      </Stack.Item>
                                    )}
                                    <Stack.Item>
                                      {ability.requires_dark ? (
                                        <Button compact disabled icon="moon" color="purple">
                                          Requires Darkness
                                        </Button>
                                      ) : (
                                        <Button compact disabled icon="sun" color="grey">
                                          Any Light
                                        </Button>
                                      )}
                                    </Stack.Item>
                                  </Stack>
                                </Stack.Item>
                              </Stack>
                            </Stack.Item>
                            <Stack.Item>
                              {ability.unlocked ? (
                                <Button compact disabled color="good" icon="check">
                                  UNLOCKED
                                </Button>
                              ) : is_thrall ? (
                                <Button compact disabled color="bad" icon="lock">
                                  UNAVAILABLE TO THRALLS
                                </Button>
                              ) : (
                                <Button compact disabled color="bad" icon="lock">
                                  LOCKED: {ability.required_thralls} Thralls Required
                                  {isLocked && remaining > 0 ? ` (${remaining} more needed)` : ''}
                                </Button>
                              )}
                            </Stack.Item>
                          </Stack>
                          <Box
                            fontSize="12px"
                            color="#cbd5e1"
                            mt={0.5}
                            style={{ lineHeight: '1.4' }}
                          >
                            {ability.desc}
                          </Box>
                        </Box>
                      );
                    })}
                  </Section>
                </Stack.Item>
              </Stack>
            )}

            {activeTab === 'doctrine' && (
              <Section fill scrollable title="Brood Doctrine & Mechanics">
                <Stack vertical>
                  {/* Nyxosynthesis */}
                  <Stack.Item>
                    <Box
                      p={1.5}
                      style={{
                        backgroundColor: 'rgba(30, 20, 60, 0.4)',
                        border: '1px solid #4c1d95',
                        borderRadius: '4px',
                      }}
                    >
                      <Stack align="center" mb={1}>
                        <Stack.Item>
                          <Icon name="moon" size={2} color="#a855f7" />
                        </Stack.Item>
                        <Stack.Item>
                          <Box bold fontSize="15px" color="#c084fc">
                            1. Nyxosynthesis (Shadow Healing & Agility)
                          </Box>
                        </Stack.Item>
                      </Stack>
                      <Box fontSize="12px" color="#e2e8f0" style={{ lineHeight: '1.5' }}>
                        Darkness is the lifeblood of the Shadowling species. In the absence of light, your body undergoes constant accelerated cellular regeneration:
                      </Box>
                      <Box mt={1} pl={2} fontSize="12px" color="#cbd5e1" style={{ lineHeight: '1.6' }}>
                        <div>&bull; <strong>Deep Darkness (&lt; 0.2 lumcount):</strong> Heals <strong>4 brute and 4 burn</strong> damage per limb every second, alongside recovering <strong>2 stamina</strong> per second.</div>
                        <div>&bull; <strong>Dim Light (0.2 &ndash; 0.4 lumcount):</strong> Heals <strong>0.75 brute and 0.75 burn</strong> damage per limb, with <strong>1 stamina</strong> regen per second.</div>
                        <div>&bull; <strong>Shadow Speed:</strong> Dark tiles grant increased movement speed, allowing you to easily outrun illuminated prey.</div>
                        <div>&bull; <strong>Post-Mortem Restoration:</strong> Slain shadowling bodies left undisturbed in pitch darkness slowly mend over time, enabling revival once sufficient tissue integrity is restored.</div>
                      </Box>
                    </Box>
                  </Stack.Item>

                  {/* Light Hazards */}
                  <Stack.Item>
                    <Box
                      p={1.5}
                      style={{
                        backgroundColor: 'rgba(50, 20, 30, 0.4)',
                        border: '1px solid #991b1b',
                        borderRadius: '4px',
                      }}
                    >
                      <Stack align="center" mb={1}>
                        <Stack.Item>
                          <Icon name="sun" size={2} color="#f87171" />
                        </Stack.Item>
                        <Stack.Item>
                          <Box bold fontSize="15px" color="#fca5a5">
                            2. Photophobia & Intense Light Hazards
                          </Box>
                        </Stack.Item>
                      </Stack>
                      <Box fontSize="12px" color="#e2e8f0" style={{ lineHeight: '1.5' }}>
                        Bright light directly scorches and dissolves shadowling biological tissue. Illumination is your deadliest enemy:
                      </Box>
                      <Box mt={1} pl={2} fontSize="12px" color="#cbd5e1" style={{ lineHeight: '1.6' }}>
                        <div>&bull; <strong>Searing Damage (&gt; 0.4 lumcount):</strong> Inflicts <strong>3.5 brute and 3.5 burn</strong> damage per limb every second you remain in illuminated tiles.</div>
                        <div>&bull; <strong>Phase Collapse:</strong> Entering bright light while in <em>Shadow Phase</em> will violently disrupt the incorporeal state after 5 seconds, forcibly ejecting you into the physical plane.</div>
                        <div>&bull; <strong>Area Denial:</strong> Use <strong>Shadow Veil</strong> to extinguish lights and drain APCs, or shatter light bulbs across entire hallways with <strong>Sonic Shriek</strong>. Flashlights, flares, and lasers pose extreme danger.</div>
                      </Box>
                    </Box>
                  </Stack.Item>

                  {/* Enthrallment & Surgery */}
                  <Stack.Item>
                    <Box
                      p={1.5}
                      style={{
                        backgroundColor: 'rgba(20, 30, 50, 0.4)',
                        border: '1px solid #1e40af',
                        borderRadius: '4px',
                      }}
                    >
                      <Stack align="center" mb={1}>
                        <Stack.Item>
                          <Icon name="brain" size={2} color="#60a5fa" />
                        </Stack.Item>
                        <Stack.Item>
                          <Box bold fontSize="15px" color="#93c5fd">
                            3. Enthrallment & Thrall Surgery Guidelines
                          </Box>
                        </Stack.Item>
                      </Stack>
                      <Box fontSize="12px" color="#e2e8f0" style={{ lineHeight: '1.5' }}>
                        Subjugating crew members into thralls swells the brood and unlocks higher dimensional shadow powers:
                      </Box>
                      <Box mt={1} pl={2} fontSize="12px" color="#cbd5e1" style={{ lineHeight: '1.6' }}>
                        <div>&bull; <strong>Enthrall Conditions:</strong> Target must be facing you within 2 tiles. Both you and the victim <strong>must remain in darkness</strong> for the entire 30-second channel.</div>
                        <div>&bull; <strong>Subjugation Process:</strong> Channeling drains 35 oxygen every 10 seconds (105 total) from the victim, implanting a <em>Shadow Thrall Tumor</em> directly into their brain.</div>
                        <div>&bull; <strong>Crew Neurosurgery Countermeasure:</strong> Medical personnel can cure thralls via brain surgery. They must incise the scalp, saw the skull, and shine a lit flashlight into the cranial cavity to dissolve the tumor. Guard captured thralls and eliminate medical staff carrying surgical tools.</div>
                      </Box>
                    </Box>
                  </Stack.Item>
                </Stack>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
