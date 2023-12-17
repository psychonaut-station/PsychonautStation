import {
  Button,
  TextArea,
  Section,
  BlockQuote,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';
import { useBackend } from '../backend';
import { ReactNode } from 'react';

type Data = {
  connected: boolean;
  is_admin: boolean;
  questions: Question[];
  queue_pos: number;
  read_only: boolean;
  status: string;
  welcome_message: string;
};

type Question = {
  qidx: number;
  question: string;
  response: string;
};

enum STATUS {
  Approved = 'interview_approved',
  Denied = 'interview_denied',
}

// Matches a complete markdown-style link, capturing the whole [...](...)
const linkRegex = /(\[[^[]+\]\([^)]+\))/;
// Decomposes a markdown-style link into the link and display text
const linkDecomposeRegex = /\[([^[]+)\]\(([^)]+)\)/;

// Renders any markdown-style links within a provided body of text
const linkifyText = (text: string) => {
  let parts: ReactNode[] = text.split(linkRegex);
  for (let i = 1; i < parts.length; i += 2) {
    const match = linkDecomposeRegex.exec(parts[i] as string);
    if (!match) continue;

    parts[i] = (
      <a key={'link' + i} href={match[2]}>
        {match[1]}
      </a>
    );
  }
  return parts;
};

export const Interview = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    connected,
    is_admin,
    questions = [], // TODO: Remove default
    queue_pos,
    read_only,
    status,
    welcome_message = '',
  } = data;

  return (
    <Window
      width={500}
      height={600}
      canClose={is_admin || status === 'interview_approved'}
    >
      <Window.Content scrollable>
        {(!read_only && (
          <Section title="Hoş Geldiniz!">
            <p>{linkifyText(welcome_message)}</p>
          </Section>
        )) || <RenderedStatus status={status} queue_pos={queue_pos} />}
        <Section
          title="Başvuru"
          buttons={
            <span>
              <Button
                content={read_only ? 'Gönderildi' : 'Gönder'}
                onClick={() => act('submit')}
                disabled={read_only}
              />
              {!!is_admin && status === 'interview_pending' && (
                <span>
                  <Button
                    content="Admin PM"
                    enabled={connected}
                    onClick={() => act('adminpm')}
                  />
                  <Button
                    content="Onayla"
                    color="good"
                    onClick={() => act('approve')}
                  />
                  <Button
                    content="Reddet"
                    color="bad"
                    onClick={() => act('deny')}
                  />
                </span>
              )}
            </span>
          }
        >
          {!read_only && (
            <p>
              Lütfen aşağıdaki soruların cevaplayıp Gönder tuşuna basın.
              <br />
              <br />
              <b>Gönderdiğiniz başvuruyu bir daha değiştiremezsiniz.</b>
            </p>
          )}
          {questions.map(({ qidx, question, response }) => (
            <Section key={qidx} title={`Soru ${qidx}`}>
              <p>{linkifyText(question)}</p>
              {((read_only || is_admin) && (
                <BlockQuote>{response || 'Cevap yok.'}</BlockQuote>
              )) || (
                <TextArea
                  value={response}
                  fluid
                  height={10}
                  maxLength={500}
                  placeholder="Cevabını buraya yaz."
                  onEnter={(e, input) =>
                    act('update_answer', {
                      qidx,
                      answer: input,
                    })
                  }
                />
              )}
            </Section>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

const RenderedStatus = (props: { status: string; queue_pos: number }) => {
  const { status, queue_pos } = props;

  switch (status) {
    case STATUS.Approved:
      return <NoticeBox success>Başvurunuz onaylandı.</NoticeBox>;
    case STATUS.Denied:
      return <NoticeBox danger>Başvurunuz reddedildi.</NoticeBox>;
    default:
      return (
        <NoticeBox info>
          Başvurunuz aktif olan adminlere gönderildi. {queue_pos}. sıradasınız.
        </NoticeBox>
      );
  }
};
