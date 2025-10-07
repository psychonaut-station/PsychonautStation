import React from 'react';

import { Box, Button, Section, Stack, Table } from 'tgui-core/components';
import { Window } from '../../layouts';
import { spaceLawDescriptions } from './SpaceLawDescription';
import { spaceLawTable } from './SpaceLawTable';

export const SpaceLaw = () => {
  return (
    <Window width={1000} height={565} title="Yasalar">
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

// Tablo başlıkları için css

const tableHeaderStyle = {
  background: `#262626`,
  border: `1px solid #bfbfbf`,
  'border-radius': `4px`,
  padding: `3px`,
  color: `#bfbfbf`,
  'text-align': `center`,
};

// Tablo hücreleri için css
const tableItemStyle = {
  background: `#313131`,
  border: `1px solid #c9c9c9`,
  'border-radius': `4px`,
  padding: `3px`,
  color: `#c9c9c9`,
  'text-align': `center`,
  'vertical-align': `middle`,
};

// Tablo içerisindeki yasalar için prop

const tableButonStyle = (value) => {
  return (
    <Button
      opacity={1}
      backgroundColor={tableItemStyle.background}
      color={tableItemStyle.color}
      tooltip={value[1]}
      tooltipPosition={'bottom'}
      onClick={(e) => scrollHandler(e, value[0])}
    >
      {value[0]}
    </Button>
  );
};

export const LawTexts = () => {
  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <Section fill scrollable>
          <Section title="Tüm Yasalar">
            <Table mb={5} cellpadding="3">
              <Table.Row style={{ border: `4px outset grey` }} header>
                {/* Tablo Başlık Alanı */}
                <Table.Cell style={tableHeaderStyle}>
                  <Box>Kod</Box>
                </Table.Cell>
                <Table.Cell style={tableHeaderStyle}>
                  <Box>Haylazlıklar - 1XX</Box>
                </Table.Cell>
                <Table.Cell style={tableHeaderStyle}>
                  <Box>Kabahatler - 2XX</Box>
                </Table.Cell>
                <Table.Cell style={tableHeaderStyle}>
                  <Box>Suçlar - 3XX</Box>
                </Table.Cell>
                <Table.Cell style={tableHeaderStyle}>
                  <Box>Ağır Suçlar - 4XX</Box>
                </Table.Cell>
                <Table.Cell style={tableHeaderStyle}>
                  <Box>İdam Suçları - 5XX</Box>
                </Table.Cell>
              </Table.Row>
              {/* Yasa Alanı */}
              {spaceLawTable.map((v) => {
                return (
                  <Table.Row key={v}>
                    <Table.Cell style={tableItemStyle}>
                      <Box>{v.code}</Box>
                    </Table.Cell>
                    <Table.Cell style={tableItemStyle}>
                      {tableButonStyle(v.Mischief)}
                    </Table.Cell>
                    <Table.Cell style={tableItemStyle}>
                      {tableButonStyle(v.Misdemeanor)}
                    </Table.Cell>
                    <Table.Cell style={tableItemStyle}>
                      {tableButonStyle(v.Felony)}
                    </Table.Cell>
                    <Table.Cell style={tableItemStyle}>
                      {tableButonStyle(v.GrandFelony)}
                    </Table.Cell>
                    <Table.Cell style={tableItemStyle}>
                      {tableButonStyle(v.CapitalCrime)}
                    </Table.Cell>
                  </Table.Row>
                );
              })}
              {/* Ceza Alanı */}
              <Table.Row>
                <Table.Cell style={tableItemStyle}>
                  <Button
                    opacity={1}
                    backgroundColor={tableItemStyle.background}
                    color={tableItemStyle.color}
                  >
                    Cezalar
                  </Button>
                </Table.Cell>
                <Table.Cell style={tableItemStyle}>
                  <Button
                    opacity={1}
                    backgroundColor={tableItemStyle.background}
                    color={tableItemStyle.color}
                  >
                    <b>Hapis</b> - 3 Dakika
                    <br />
                    <b>Labor</b> - 1 Puan
                    <br />
                    <b>Para Cezası</b> - 100 Kredi
                  </Button>
                </Table.Cell>
                <Table.Cell style={tableItemStyle}>
                  <Button
                    opacity={1}
                    backgroundColor={tableItemStyle.background}
                    color={tableItemStyle.color}
                  >
                    <b>Hapis</b> - 5 Dakika
                    <br />
                    <b>Labor</b> - 300-500 Puan
                    <br />
                    <b>Para Cezası</b> - 300 Kredi
                  </Button>
                </Table.Cell>
                <Table.Cell style={tableItemStyle}>
                  <Button
                    opacity={1}
                    backgroundColor={tableItemStyle.background}
                    color={tableItemStyle.color}
                  >
                    <b>Hapis</b> - 8 Dakika
                    <br />
                    <b>Labor</b> - 500-800 Puan
                  </Button>
                </Table.Cell>
                <Table.Cell style={tableItemStyle}>
                  <Button
                    opacity={1}
                    backgroundColor={tableItemStyle.background}
                    color={tableItemStyle.color}
                  >
                    Müebbet
                    <br />
                    Sürgün
                    <br />
                    İmplant
                  </Button>
                </Table.Cell>
                <Table.Cell style={tableItemStyle}>
                  <Button
                    opacity={1}
                    backgroundColor={tableItemStyle.background}
                    color={tableItemStyle.color}
                  >
                    Müebbet
                    <br />
                    Sürgün
                    <br />
                    İmplant
                    <br />
                    Cyborglaştırma, İnfaz
                  </Button>
                </Table.Cell>
              </Table.Row>
            </Table>
          </Section>
          {/* Yasalar için Açıklama Alanı */}
          {spaceLawDescriptions.map((v) => {
            return (
              <Section
                mb={5}
                key={v}
                id={v.title}
                title={
                  <h1>
                    {v.code} - {v.title}
                  </h1>
                }
              >
                {v.desc}
              </Section>
            );
          })}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
