import { useState } from 'react';
import { Button, Section, Stack } from 'tgui-core/components';
import type { Emote } from './atom';
import { useEmotes } from './hooks';

const TGUI_PANEL_EMOTE_TYPE_DEFAULT = 1;
const TGUI_PANEL_EMOTE_TYPE_CUSTOM = 2;
const TGUI_PANEL_EMOTE_TYPE_ME = 3;

export const EmotePanel = () => {
  const emotes = useEmotes();
  const [isCreateHovered, setIsCreateHovered] = useState(false);

  const emoteList: (Emote & { name: string; usable: boolean })[] = [];
  for (const name in emotes) {
    const emote = emotes[name];
    const usable = emote.usable ?? true;

    switch (emote.type) {
      case TGUI_PANEL_EMOTE_TYPE_DEFAULT:
        emoteList.push({
          type: emote.type,
          name,
          key: emote.key,
          usable,
        });
        break;
      case TGUI_PANEL_EMOTE_TYPE_CUSTOM:
        emoteList.push({
          type: emote.type,
          name,
          key: emote.key,
          message_override: emote.message_override,
          usable,
        });
        break;
      case TGUI_PANEL_EMOTE_TYPE_ME:
        emoteList.push({
          type: emote.type,
          name,
          message: emote.message,
          usable,
        });
        break;
      default:
        continue;
    }
  }

  const emoteCreate = () => Byond.sendMessage('emotes/create');
  const emoteExecute = (name: string) => Byond.sendMessage('emotes/execute', { name });
  const emoteContextAction = (name: string) => Byond.sendMessage('emotes/contextAction', { name });

  return (
    <Section>
      <Stack wrap align="center">
        {emoteList
          .sort((a, b) => a.name.localeCompare(b.name))
          .map((emote) => {
            let color = 'blue';
            let tooltip = '';

            if (!emote.usable) {
              color = 'grey';
            } else {
              switch (emote.type) {
                case TGUI_PANEL_EMOTE_TYPE_DEFAULT:
                  color = 'blue';
                  tooltip = `*${emote.key}`;
                  break;
                case TGUI_PANEL_EMOTE_TYPE_CUSTOM:
                  color = 'purple';
                  tooltip = `*${emote.key} | "${emote.message_override}"`;
                  break;
                case TGUI_PANEL_EMOTE_TYPE_ME:
                  color = 'orange';
                  tooltip = `"${emote.message}"`;
                  break;
                default:
                  tooltip = 'UNKNOWN EMOTE';
                  break;
              }
            }

            return (
              <Stack.Item key={emote.name}>
                <Button
                  color={color}
                  tooltip={tooltip}
                  disabled={!emote.usable}
                  onClick={() => emoteExecute(emote.name)}
                  onContextMenu={(e) => {
                    e.preventDefault();
                    emoteContextAction(emote.name);
                  }}
                >
                  {emote.name}
                </Button>
              </Stack.Item>
            );
          })}
        <Stack.Item>
          <div
            onMouseEnter={() => setIsCreateHovered(true)}
            onMouseLeave={() => setIsCreateHovered(false)}
          >
            <Button
              icon="plus"
              color="transparent"
              style={{ opacity: isCreateHovered ? 1 : 0.8 }}
              onClick={() => emoteCreate()}
            />
          </div>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
