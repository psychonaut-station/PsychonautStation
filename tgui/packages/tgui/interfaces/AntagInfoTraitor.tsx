import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { BlockQuote, Button, Dimmer, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Objective, ObjectivePrintout } from './common/Objectives';

const allystyle = {
  fontWeight: 'bold',
  color: 'yellow',
};

const badstyle = {
  color: 'red',
  fontWeight: 'bold',
};

const goalstyle = {
  color: 'lightblue',
  fontWeight: 'bold',
};

type Info = {
  has_codewords: BooleanLike;
  phrases: string;
  responses: string;
  theme: string;
  allies: string;
  goal: string;
  intro: string;
  code: string;
  failsafe_code: string;
  replacement_code: string;
  replacement_frequency: string;
  has_uplink: BooleanLike;
  uplink_intro: string;
  uplink_unlock_info: string;
  given_uplink: BooleanLike;
  objectives: Objective[];
};

const IntroductionSection = (props) => {
  const { act, data } = useBackend<Info>();
  const { intro, objectives } = data;
  return (
    <Section fill title="Intro" scrollable>
      <Stack vertical fill>
        <Stack.Item fontSize="25px">{intro}</Stack.Item>
        <Stack.Item grow>
          <ObjectivePrintout objectives={objectives} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const EmployerSection = (props) => {
  const { data } = useBackend<Info>();
  const { allies, goal } = data;
  return (
    <Section
      fill
      title="İşveren"
      scrollable
      buttons={
        <Button
          icon="hammer"
          tooltip={`
            This is a gameplay suggestion for bored traitors.
            You don't have to follow it, unless you want some
            ideas for how to spend the round.`}
          tooltipPosition="bottom-start"
        >
          Policy
        </Button>
      }
    >
      <Stack vertical fill>
        <Stack.Item grow>
          <Stack vertical>
            <Stack.Item>
              <span style={allystyle}>
                Bağlılıkların:
                <br />
              </span>
              <BlockQuote>{allies}</BlockQuote>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              <span style={goalstyle}>
                İşverenin amacı:
                <br />
              </span>
              <BlockQuote>{goal}</BlockQuote>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const UplinkSection = (props) => {
  const { data } = useBackend<Info>();
  const {
    has_uplink,
    uplink_intro,
    uplink_unlock_info,
    code,
    failsafe_code,
    replacement_code,
    replacement_frequency,
  } = data;
  return (
    <Section title="Uplink" mb={!has_uplink && -1}>
      <Stack fill>
        {(!has_uplink && (
          <Dimmer>
            <Stack.Item fontSize="16px">
              <Section textAlign="Center">
                Your uplink is missing or destroyed. <br />
                Craft a Syndicate Uplink Beacon and then speak
                <br />
                <span style={goalstyle}>
                  <b>{replacement_code}</b>
                </span>{' '}
                on frequency{' '}
                <span style={goalstyle}>
                  <b>{replacement_frequency}</b>
                </span>{' '}
                after synchronizing with the beacon.
              </Section>
            </Stack.Item>
          </Dimmer>
        )) || (
          <>
            <Stack.Item bold>
              {uplink_intro}
              <br />
              {code && <span style={goalstyle}>Şifre: {code}</span>}
              <br />
              {failsafe_code && (
                <span style={badstyle}>Failsafe: {failsafe_code}</span>
              )}
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item mt="1%">
              <BlockQuote>{uplink_unlock_info}</BlockQuote>
            </Stack.Item>
          </>
        )}
      </Stack>
      <br />
      {(has_uplink && (
        <Section textAlign="Center">
          Eğer uplinkini kaybedersen, Syndicate Uplink Beacon aracılığı ile{' '}
          <span style={goalstyle}>
            <b>{replacement_frequency}</b>
          </span>{' '}
          frekansına,{' '}
          <span style={goalstyle}>
            <b>{replacement_code}</b>
          </span>{' '}
          kelimesini fısıldayarak yeni bir uplink elde edebilirsin.
        </Section>
      )) || (
        <Section>
          {' '}
          <br />
          <br />
        </Section>
      )}
    </Section>
  );
};

const CodewordsSection = (props) => {
  const { data } = useBackend<Info>();
  const { has_codewords, phrases, responses } = data;
  return (
    <Section title="Şifre Kelimeler" mb={!has_codewords && -1}>
      <Stack fill>
        {(!has_codewords && (
          <BlockQuote>
            You have not been supplied with codewords. You will have to use
            alternative methods to find potential allies. Proceed with caution,
            however, as everyone is a potential foe.
          </BlockQuote>
        )) || (
          <>
            <Stack.Item grow basis={0}>
              <BlockQuote>
                İşverenin, yandaş ajanları tanımlaman için sana şifreli
                kelimeler verdi. Normal konuşma esnasında, ajanları tanımlamak
                için şifreli kelimeleri kullan.
                <span style={badstyle}>
                  &ensp;Şifreli kelimeleri ezberledin, böylece duyduğunda
                  tanıyabileceksin.
                </span>
              </BlockQuote>
            </Stack.Item>
            <Stack.Divider mr={1} />
            <Stack.Item grow basis={0}>
              <Stack vertical>
                <Stack.Item>Sorular:</Stack.Item>
                <Stack.Item bold textColor="blue">
                  {phrases}
                </Stack.Item>
                <Stack.Item>Cevaplar:</Stack.Item>
                <Stack.Item bold textColor="red">
                  {responses}
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </>
        )}
      </Stack>
    </Section>
  );
};

export const AntagInfoTraitor = (props) => {
  const { data } = useBackend<Info>();
  const { theme, given_uplink } = data;
  return (
    <Window width={620} height={580} theme={theme}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item width="70%">
                <IntroductionSection />
              </Stack.Item>
              <Stack.Item width="30%">
                <EmployerSection />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          {!!given_uplink && (
            <Stack.Item>
              <UplinkSection />
            </Stack.Item>
          )}
          <Stack.Item>
            <CodewordsSection />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
