import { type ReactNode, useState } from 'react';
import {
  BlockQuote,
  Box,
  Button,
  NoticeBox,
  Section,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  connected: BooleanLike;
  is_admin: BooleanLike;
  questions: Question[];
  queue_pos: number;
  read_only: BooleanLike;
  status: string;
  welcome_message: string;
  centcom_connected: BooleanLike;
  has_permabans: BooleanLike;
};

type Question = {
  qidx: number;
  question: string;
  response: string | null;
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
  const parts: ReactNode[] = text.split(linkRegex);
  for (let i = 1; i < parts.length; i += 2) {
    const match = linkDecomposeRegex.exec(parts[i] as string);
    if (!match) continue;

    parts[i] = (
      <a key={`link${i}`} href={match[2]}>
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
    questions = [],
    queue_pos,
    read_only,
    status,
    welcome_message = '',
    centcom_connected,
    has_permabans,
  } = data;

  const allAnswered = questions.every((q) => q.response);
  const numAnswered = questions.filter((q) => q.response)?.length;

  // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
  /*
  return (
    <Window
      width={550}
      height={600}
      canClose={is_admin || status === 'interview_approved'}
    >
      <Window.Content scrollable>
        {(!read_only && (
          <Section title="Welcome!">
            <p>{linkifyText(welcome_message)}</p>
          </Section>
        )) || <RenderedStatus status={status} queue_pos={queue_pos} />}
        <Section
          title="Questionnaire"
          buttons={
            <span>
              <Button
                onClick={() => act('submit')}
                disabled={read_only || !allAnswered || !questions.length}
                icon="envelope"
                tooltip={
                  !allAnswered &&
                  `Please answer all questions.
                     ${numAnswered} / ${questions.length}`
                }
              >
                {read_only ? 'Submitted' : 'Submit'}
              </Button>
              {!!is_admin && status === 'interview_pending' && (
                <span>
                  <Button disabled={!connected} onClick={() => act('adminpm')}>
                    Admin PM
                  </Button>
                  <Button color="good" onClick={() => act('approve')}>
                    Approve
                  </Button>
                  <Button color="bad" onClick={() => act('deny')}>
                    Deny
                  </Button>
                  {!!centcom_connected && (
                    <Button
                      color={has_permabans ? 'bad' : 'average'}
                      tooltip={
                        has_permabans
                          ? 'This user has permabans in their history!'
                          : ''
                      }
                      onClick={() => act('check_centcom')}
                    >
                      Check Centcom
                    </Button>
                  )}
                </span>
              )}
            </span>
          }
        >
          {!read_only && (
            <>
              <Box as="p" color="label">
                Please answer the following questions.
                <ul>
                  <li>
                    You can press enter key or the save button to save an
                    answer.
                  </li>
                  <li>
                    You can edit your answers until you press the submit button.
                  </li>
                  <li>Press SUBMIT when you are done.</li>
                </ul>
              </Box>
              <NoticeBox info align="center">
                You will not be able to edit your answers after submitting.
              </NoticeBox>
            </>
          )}
          {questions.map((question) => (
            <QuestionArea key={question.qidx} {...question} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
  */
  return (
    <Window
      width={550}
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
                onClick={() => act('submit')}
                disabled={read_only || !allAnswered || !questions.length}
                icon="envelope"
                tooltip={
                  !allAnswered &&
                  `Lütfen bütün soruları cevapla.
                     ${numAnswered} / ${questions.length}`
                }
              >
                {read_only ? 'Gönderildi' : 'Gönder'}
              </Button>
              {!!is_admin && status === 'interview_pending' && (
                <span>
                  <Button disabled={!connected} onClick={() => act('adminpm')}>
                    Admin PM
                  </Button>
                  <Button color="good" onClick={() => act('approve')}>
                    Onayla
                  </Button>
                  <Button color="bad" onClick={() => act('deny')}>
                    Reddet
                  </Button>
                  {!!centcom_connected && (
                    <Button
                      color={has_permabans ? 'bad' : 'average'}
                      tooltip={
                        has_permabans
                          ? 'This user has permabans in their history!'
                          : ''
                      }
                      onClick={() => act('check_centcom')}
                    >
                      Check Centcom
                    </Button>
                  )}
                </span>
              )}
            </span>
          }
        >
          {!read_only && (
            <>
              <Box as="p" color="label">
                Lütfen soruları yanıtlayın.
                <ul>
                  <li>
                    Enter ya da Gönder butonuna basarak formunu çevrimiçi
                    adminlere gönderebilirsin.
                  </li>
                  <li>
                    Gönder butonuna basmadığın sürece cevaplarını
                    düzenleyebilirsin.
                  </li>
                  <li>Formu doldurduğunda GÖNDER tuşuna bas.</li>
                </ul>
              </Box>
              <NoticeBox info align="center">
                Formu gönderdikten sonra cevaplarını düzenleyemezsin
              </NoticeBox>
            </>
          )}
          {questions.map((question) => (
            <QuestionArea key={question.qidx} {...question} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
  // PSYCHONAUT EDIT CHANGE END
};

const RenderedStatus = (props: { status: string; queue_pos: number }) => {
  const { status, queue_pos } = props;

  // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
  /*
  switch (status) {
    case STATUS.Approved:
      return <NoticeBox success>This interview was approved.</NoticeBox>;
    case STATUS.Denied:
      return <NoticeBox danger>This interview was denied.</NoticeBox>;
    default:
      return (
        <NoticeBox info>
          Your answers have been submitted. You are position {queue_pos} in
          queue.
        </NoticeBox>
      );
  }
  */
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
  // PSYCHONAUT EDIT CHANGE END
};

const QuestionArea = (props: Question) => {
  const { qidx, question, response } = props;
  const { act, data } = useBackend<Data>();
  const { is_admin, read_only } = data;

  const [userInput, setUserInput] = useState(response);

  const saveResponse = () => {
    act('update_answer', {
      qidx,
      answer: userInput,
    });
  };

  const changedResponse = userInput !== response;

  const saveAvailable = !read_only && !!userInput && changedResponse;

  const isSaved = !!response && !changedResponse;

  // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
  /*
  return (
    <Section
      title={`Question ${qidx}`}
      buttons={
        <Button
          disabled={!saveAvailable}
          onClick={saveResponse}
          icon={isSaved ? 'check' : 'save'}
        >
          {isSaved ? 'Saved' : 'Save'}
        </Button>
      }
    >
      <p>{linkifyText(question)}</p>
      {read_only || is_admin ? (
        <BlockQuote>{response || 'No response.'}</BlockQuote>
      ) : (
        <TextArea
          fluid
          height={10}
          maxLength={500}
          onChange={setUserInput}
          onEnter={saveResponse}
          placeholder="Write your response here, max of 500 characters. Press enter to submit."
          value={response || undefined}
        />
      )}
    </Section>
  );
  */
  return (
    <Section
      title={`Soru ${qidx}`}
      buttons={
        <Button
          disabled={!saveAvailable}
          onClick={saveResponse}
          icon={isSaved ? 'check' : 'save'}
        >
          {isSaved ? 'Kaydedildi' : 'kaydet'}
        </Button>
      }
    >
      <p>{linkifyText(question)}</p>
      {read_only || is_admin ? (
        <BlockQuote>{response || 'Cevap yok.'}</BlockQuote>
      ) : (
        <TextArea
          fluid
          height={10}
          maxLength={500}
          onChange={setUserInput}
          onEnter={saveResponse}
          placeholder="Cevabını buraya yaz. En fazla 500 karakter girebilirsin. Bittiğinde ENTER tuşuna bas."
          value={response || undefined}
        />
      )}
    </Section>
  );
  // PSYCHONAUT EDIT CHANGE END
};
