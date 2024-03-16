import React from 'react';

import { Box, Section, Stack, Table } from '../../components';
import { Window } from '../../layouts';
import { spaceLawDescriptions } from './SpaceLawDescription';
import { spaceLawTable } from './SpaceLawTable';

export const SpaceLaw = () => {
  return (
    <Window width={950} height={565} title="Yasalar">
      <Window.Content>
        <LawTexts />
      </Window.Content>
    </Window>
  );
};

const scrollHandler = (e, value) => {
  let element = document.getElementById(value);
  if (element) {
    element.scrollIntoView();
  }
};

export const LawTexts = () => {
  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <Section fill scrollable>
          <Section title="Tüm Yasalar">
            <Table>
              <Table.Row>
                <Table.Cell><Box>Code</Box></Table.Cell>
                <Table.Cell><Box>Mischief - 1XX</Box></Table.Cell>
                <Table.Cell><Box>Misdemeanor - 2XX</Box></Table.Cell>
                <Table.Cell><Box>Felony - 3XX</Box></Table.Cell>
                <Table.Cell><Box>Grand Felony - 4XX</Box></Table.Cell>
                <Table.Cell><Box>Capital Crime - 5XX</Box></Table.Cell>
              </Table.Row>
              {spaceLawTable.map((v) => {
                return (
                  <Table.Row key={v}>
                    <Table.Cell><Box onClick={(e) => scrollHandler(e, v.code)}>{v.code}</Box></Table.Cell>
                    <Table.Cell><Box onClick={(e) => scrollHandler(e, v.Mischief)}>{v.Mischief}</Box></Table.Cell>
                    <Table.Cell><Box onClick={(e) => scrollHandler(e, v.Misdemeanor)}>{v.Misdemeanor}</Box></Table.Cell>
                    <Table.Cell><Box onClick={(e) => scrollHandler(e, v.Felony)}>{v.Felony}</Box></Table.Cell>
                    <Table.Cell><Box onClick={(e) => scrollHandler(e, v.GrandFelony)}>{v.GrandFelony}</Box></Table.Cell>
                    <Table.Cell><Box onClick={(e) => scrollHandler(e, v.CapitalCrime)}>{v.CapitalCrime}</Box></Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          </Section>
          {spaceLawDescriptions.map((v) => {
            return (
              <Section key={v} id={v.title} title={v.title}>{v.desc}</Section>
            );
          })}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
