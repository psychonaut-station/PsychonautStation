// THIS IS A PSYCHONAUT UI FILE
import {
  Box,
  Button,
  Icon,
  Section
} from 'tgui-core/components';

import { useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  storytellers: Storyteller[];
  current_storyteller: string;
  next_storyteller: string | null;
};

type Storyteller = {
  name: string;
  desc: string;
  restricted: BooleanLike;
};

export const StorytellerAdmin = (props) => {
  const { act, data } = useBackend<Data>();
  const { storytellers, current_storyteller, next_storyteller } = data;
  const [ currentStoryteller, setCurrentStoryteller] = useState<string>(current_storyteller);
  const [ nextStoryteller, setNextStoryteller] = useState<string | null>(next_storyteller);
  const [ forCurrentRound, setForCurrentRound ] = useState<BooleanLike>(true);

  return (
    <Window title="Storyteller Panel" width={768} height={723}>
      <Window.Content scrollable>
        <Section
          title="Storytellers"
          buttons={
            <Box>
              <Button.Checkbox
                checked={forCurrentRound}
                onClick={() => setForCurrentRound(!forCurrentRound)}
              >
                {forCurrentRound ? 'Set For Current Round' : 'Set For Next Round'}
              </Button.Checkbox>
              <Button
                onClick={() => act('storyteller_vv')}
              >
                VV
              </Button>
            </Box>
          }
        >
          {storytellers.map((storyteller, index) => (
            <Section
              key={index}
            >
              <Button
                selected={forCurrentRound ? (storyteller.name === currentStoryteller) : (storyteller.name === nextStoryteller) }
                onClick={() => {
                  if(forCurrentRound) setCurrentStoryteller(storyteller.name)
                  else setNextStoryteller(storyteller.name)
                  act('set_storyteller', {
                    storyteller_name: storyteller.name,
                    current_round: forCurrentRound
                  });
                }}
                style={{
                  display: 'flex',
                  width: '%100',
                  flexDirection: 'column',
                  justifyContent: 'center',
                  padding: '4px 4px',
                  whiteSpace: 'normal',
                  wordWrap: 'break-word'
                }}
              >
                <Box inline bold mr={1}>
                  {storyteller.name} {!!storyteller.restricted && (<Icon name={"lock"}/>)}
                </Box>
                <Box mr={1}>
                  {storyteller.desc}
                </Box>
              </Button>
            </Section>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
