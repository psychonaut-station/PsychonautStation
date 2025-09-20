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
};

type Storyteller = {
  name: string;
  desc: string;
  restricted: BooleanLike;
};

export const StorytellerAdmin = (props) => {
  const { act, data } = useBackend<Data>();
  const { storytellers, current_storyteller } = data;
  const [ currentStoryteller, setCurrentStoryteller] = useState<string>(current_storyteller);

  return (
    <Window title="Storyteller Panel" width={768} height={512}>
      <Window.Content scrollable>
        {storytellers.map((storyteller, index) => (
          <Section
            key={index}
          >
            <Button
              selected={storyteller.name === currentStoryteller}
              onClick={() => {
                setCurrentStoryteller(storyteller.name)
                act('set_storyteller', {
                  storyteller_name: storyteller.name,
                });
              }}
              style={{
                display: 'flex',
                width: '%100',
                height: '48px',
                flexDirection: 'column',
                justifyContent: 'center'
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
      </Window.Content>
    </Window>
  );
};
