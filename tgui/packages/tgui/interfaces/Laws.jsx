import React from 'react';

import { Section } from '../components';
import { Window } from '../layouts';

export const Laws = () => {
  return (
    <Window width={765} height={565} title="Yasalar">
      <Window.Content>
        <LawTexts />
      </Window.Content>
    </Window>
  );
};

export const LawTexts = () => {
  return (
    <Section title="Laws">
      Lorem ipsum dolor sit amet consectetur adipisicing elit. Maiores, sunt.
    </Section>
  );
};
