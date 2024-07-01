// THIS IS A PSYCHONAUT UI FILE
import React from 'react';

import { Box, Button, Section, Stack, Table } from '../../components';
import { Window } from '../../layouts';
import { Law, laws } from './laws';

const tableHeaderStyle = {
  background: `#262626`,
  border: `1px solid #bfbfbf`,
  padding: `3px`,
  color: `#bfbfbf`,
  'text-align': `center`,
};

const tableCellStyle = {
  background: `#313131`,
  border: `1px solid #c9c9c9`,
  padding: `3px`,
  color: `#c9c9c9`,
  'text-align': `center`,
  'vertical-align': `middle`,
};

const scrollTo = (id: string) => {
  let element = document.getElementById(id);
  if (element) {
    element.scrollIntoView();
  }
};

export const SpaceLaw = () => {
  return (
    <Window width={1100} height={565} title="Yasalar">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section fill scrollable>
              <Section title="Tüm Yasalar">
                <Table mb={5}>
                  <Table.Row style={{ border: `4px outset grey` }} header>
                    <Table.Cell style={tableHeaderStyle}>
                      <Box>Kod</Box>
                    </Table.Cell>
                    <Table.Cell style={tableHeaderStyle}>
                      <Box>Yaramazlık - 1XX</Box>
                    </Table.Cell>
                    <Table.Cell style={tableHeaderStyle}>
                      <Box>Kötü davranış - 2XX</Box>
                    </Table.Cell>
                    <Table.Cell style={tableHeaderStyle}>
                      <Box>Suç - 3XX</Box>
                    </Table.Cell>
                    <Table.Cell style={tableHeaderStyle}>
                      <Box>Ağır Suç - 4XX</Box>
                    </Table.Cell>
                    <Table.Cell style={tableHeaderStyle}>
                      <Box>İdam Suçu - 5XX</Box>
                    </Table.Cell>
                  </Table.Row>
                  {laws.map((columns, row) => (
                    <Table.Row key={row}>
                      <Table.Cell style={tableCellStyle}>
                        <Box>X{(row + 1).toString().padStart(2, '0')}</Box>
                      </Table.Cell>
                      {columns.map((law, column) => (
                        <Table.Cell key={column} style={tableCellStyle}>
                          {!!law && (
                            <LawCell
                              code={(column + 1) * 100 + row + 1}
                              law={law}
                            />
                          )}
                        </Table.Cell>
                      ))}
                    </Table.Row>
                  ))}
                  <Table.Row>
                    <Table.Cell style={tableCellStyle}>
                      <Button
                        opacity={1}
                        backgroundColor={tableCellStyle.background}
                        color={tableCellStyle.color}
                      >
                        Cezalar
                      </Button>
                    </Table.Cell>
                    <Table.Cell style={tableCellStyle}>
                      <Button
                        opacity={1}
                        backgroundColor={tableCellStyle.background}
                        color={tableCellStyle.color}
                      >
                        <b>Hapis</b> - 3 dakika
                        <br />
                        <b>Labor</b> - 1 puan
                        <br />
                        <b>Para Cezası</b> - 100 kredi
                      </Button>
                    </Table.Cell>
                    <Table.Cell style={tableCellStyle}>
                      <Button
                        opacity={1}
                        backgroundColor={tableCellStyle.background}
                        color={tableCellStyle.color}
                      >
                        <b>Hapis</b> - 5 dakika
                        <br />
                        <b>Labor</b> - 300-500 puan
                        <br />
                        <b>Para Cezası</b> - 300 kredi
                      </Button>
                    </Table.Cell>
                    <Table.Cell style={tableCellStyle}>
                      <Button
                        opacity={1}
                        backgroundColor={tableCellStyle.background}
                        color={tableCellStyle.color}
                      >
                        <b>Hapis</b> - 8 dakika
                        <br />
                        <b>Labor</b> - 500-800 puan
                      </Button>
                    </Table.Cell>
                    <Table.Cell style={tableCellStyle}>
                      <Button
                        opacity={1}
                        backgroundColor={tableCellStyle.background}
                        color={tableCellStyle.color}
                      >
                        Müebbet
                        <br />
                        Sürgün
                        <br />
                        İmplantlama
                      </Button>
                    </Table.Cell>
                    <Table.Cell style={tableCellStyle}>
                      <Button
                        opacity={1}
                        backgroundColor={tableCellStyle.background}
                        color={tableCellStyle.color}
                      >
                        Müebbet
                        <br />
                        Sürgün
                        <br />
                        İmplantlama
                        <br />
                        Cyborglaştırma
                        <br />
                        İnfaz
                      </Button>
                    </Table.Cell>
                  </Table.Row>
                </Table>
              </Section>
              {laws.map((columns, row) =>
                columns.map((law, column) => {
                  if (law) {
                    const code = (column + 1) * 100 + row + 1;
                    return <LawSection key={code} code={code} law={law} />;
                  }
                }),
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const LawCell = ({ code, law }: { code: number; law: Law }) => {
  return (
    <Button
      opacity={1}
      backgroundColor={tableCellStyle.background}
      color={tableCellStyle.color}
      tooltip={law.description}
      tooltipPosition={'bottom'}
      onClick={() => scrollTo(code.toString())}
    >
      {law.name}
    </Button>
  );
};

const LawSection = ({ code, law }: { code: number; law: Law }) => {
  const title = (
    <h1>
      {code} - {law.name}
    </h1>
  );

  return (
    <Section
      // @ts-ignore
      id={code.toString()}
      title={title}
    >
      <Box>
        <h3>Açıklama</h3>
        <p>{law.description}</p>
        <h3>Notlar</h3>
        <p>{law.notes}</p>
      </Box>
    </Section>
  );
};
