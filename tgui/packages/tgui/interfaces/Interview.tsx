import { ReactNode, useState } from 'react';

import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  NoticeBox,
  Section,
  TextArea,
} from '../components';
import { Window } from '../layouts';

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
    questions = [],
    queue_pos,
    read_only,
    status,
    welcome_message = '',
  } = data;

  const allAnswered = questions.every((q) => q.response);
  const numAnswered = questions.filter((q) => q.response)?.length;

  return (
    <Window
      width={500}
      height={600}
      canClose={is_admin || status === 'interview_approved'}
    >
      <Window.Content scrollable>
        {(!read_only && (
          // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
          // <Section title="Welcome!">
          <Section title="Hoş Geldin!">
            {/* PSYCHONAUT EDIT CHANGE END */}
            <p>{linkifyText(welcome_message)}</p>
          </Section>
        )) || <RenderedStatus status={status} queue_pos={queue_pos} />}
        <Section
          // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
          // title="Questionnaire"
          title="Başvuru"
          // PSYCHONAUT EDIT CHANGE END
          buttons={
            <span>
              <Button
                onClick={() => act('submit')}
                disabled={read_only || !allAnswered || !questions.length}
                icon="envelope"
                tooltip={
                  !allAnswered &&
                  // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
                  // `Please answer all questions.
                  //    ${numAnswered} / ${questions.length}`
                  `Lütfen bütün soruları cevapla.
                     ${numAnswered} / ${questions.length}`
                  // PSYCHONAUT EDIT CHANGE END
                }
              >
                {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                {/* {read_only ? 'Submitted' : 'Submit'} */}
                {read_only ? 'Gönderildi' : 'Gönder'}
                {/* PSYCHONAUT EDIT CHANGE END */}
              </Button>
              {!!is_admin && status === 'interview_pending' && (
                <span>
                  <Button disabled={!connected} onClick={() => act('adminpm')}>
                    Admin PM
                  </Button>
                  <Button color="good" onClick={() => act('approve')}>
                    {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                    {/* Approve */}
                    Onayla
                    {/* PSYCHONAUT EDIT CHANGE END */}
                  </Button>
                  <Button color="bad" onClick={() => act('deny')}>
                    {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                    {/* Deny */}
                    Reddet
                    {/* PSYCHONAUT EDIT CHANGE END */}
                  </Button>
                </span>
              )}
            </span>
          }
        >
          {!read_only && (
            <>
              <Box as="p" color="label">
                {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                {/* Please answer the following questions. */}
                Lütfen aşağıdaki soruları yanıtla.
                {/* PSYCHONAUT EDIT CHANGE END */}
                <ul>
                  <li>
                    {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                    {/* You can press enter key or the save button to save an */}
                    {/* answer. */}
                    Bir yanıtı kaydetmek için enter tuşuna veya kaydet düğmesine
                    basabilirsin.
                    {/* PSYCHONAUT EDIT CHANGE END */}
                  </li>
                  <li>
                    {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                    {/* You can edit your answers until you press the submit button. */}
                    Gönder düğmesine basana kadar cevaplarını düzenleyebilirsin.
                    {/* PSYCHONAUT EDIT CHANGE END */}
                  </li>
                  {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                  {/* <li>Press SUBMIT when you are done.</li> */}
                  <li>İşin bittiğinde GÖNDER düğmesine bas.</li>
                  {/* PSYCHONAUT EDIT CHANGE END */}
                </ul>
              </Box>
              <NoticeBox info align="center">
                {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
                {/* You will not be able to edit your answers after submitting. */}
                Başvuruyu gönderdikten sonra cevaplarını düzenleyemezsin.
                {/* PSYCHONAUT EDIT CHANGE END */}
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
};

const RenderedStatus = (props: { status: string; queue_pos: number }) => {
  const { status, queue_pos } = props;

  switch (status) {
    case STATUS.Approved:
      // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
      // return <NoticeBox success>This interview was approved.</NoticeBox>;
      return <NoticeBox success>Başvurun onaylanmıştır.</NoticeBox>;
    // PSYCHONAUT EDIT CHANGE END
    case STATUS.Denied:
      // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
      // return <NoticeBox danger>This interview was denied.</NoticeBox>;
      return <NoticeBox danger>Başvurun reddedilmiştir.</NoticeBox>;
    // PSYCHONAUT EDIT CHANGE END
    default:
      return (
        <NoticeBox info>
          {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
          {/* Your answers have been submitted. You are position {queue_pos} in */}
          {/* queue. */}
          Cevapların gönderildi. Başvurular arasında {queue_pos}. sıradasın.
          {/* PSYCHONAUT EDIT CHANGE END */}
        </NoticeBox>
      );
  }
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

  return (
    <Section
      // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
      // title={`Question ${qidx}`}
      title={`Soru ${qidx}`}
      // PSYCHONAUT EDIT CHANGE END
      buttons={
        <Button
          disabled={!saveAvailable}
          onClick={saveResponse}
          icon={isSaved ? 'check' : 'save'}
        >
          {/* PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL: */}
          {/* {isSaved ? 'Saved' : 'Save'} */}
          {isSaved ? 'Kaydedildi' : 'Kaydet'}
          {/* PSYCHONAUT EDIT CHANGE END */}
        </Button>
      }
    >
      <p>{linkifyText(question)}</p>
      {((read_only || is_admin) && (
        // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
        // <BlockQuote>{response || 'No response.'}</BlockQuote>
        <BlockQuote>{response || 'Cevap yok.'}</BlockQuote>
        // PSYCHONAUT EDIT CHANGE END
      )) || (
        <TextArea
          fluid
          height={10}
          maxLength={500}
          onChange={(e, input) => setUserInput(input)}
          onEnter={saveResponse}
          // PSYCHONAUT EDIT CHANGE START - LOCALIZATION - ORIGINAL:
          // placeholder="Write your response here, max of 500 characters. Press enter to submit."
          placeholder="Cevabını buraya yaz, en fazla 500 karakter. Göndermek için enter tuşuna bas."
          // PSYCHONAUT EDIT CHANGE END
          value={response || undefined}
        />
      )}
    </Section>
  );
};
