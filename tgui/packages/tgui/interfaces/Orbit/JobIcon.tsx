import { DmIcon, Icon } from 'tgui-core/components';

import { JOB2ICON } from '../common/JobToIcon';
import type { Antagonist, Observable } from './types';

type Props = {
  item: Observable | Antagonist;
  realNameDisplay: boolean;
};

type IconSettings = {
  transform: string;
};

const normalIcon: IconSettings = {
  transform: 'scale(2.3) translateX(9px) translateY(1px)',
};

const antagIcon: IconSettings = {
  transform: 'scale(2) translateX(-15px) translateY(8px)',
};

export function JobIcon(props: Props) {
  const { item, realNameDisplay } = props;

  // We don't need to cast here but typescript isn't smart enough to know that
<<<<<<< HEAD
  const { icon = '', job = '', mind_icon = '', mind_job = '', icon_file = '', mind_icon_file = '' } = item;
  let usedIconState = realNameDisplay ? mind_icon || icon : icon;
  let usedIcon = realNameDisplay ? mind_icon_file || icon_file : icon_file;
  let usedJob = realNameDisplay ? mind_job || job : job;
=======
  const {
    icon = '',
    icon_state = '',
    job = '',
    mind_icon = '',
    mind_icon_state = '',
  } = item;
  const usedIcon = realNameDisplay ? mind_icon || icon : icon;
  const usedIconState = realNameDisplay
    ? mind_icon_state || icon_state
    : icon_state;
  let usedJob = realNameDisplay ? mind_icon || job : job;
>>>>>>> c40e5f1f6e8247937e91ad9469d6552a3db0a9ae

  let iconSettings: IconSettings;
  if ('antag' in item && !realNameDisplay) {
    iconSettings = antagIcon;
    usedJob = item.antag;
<<<<<<< HEAD
    usedIconState = item.antag_icon;
=======
>>>>>>> c40e5f1f6e8247937e91ad9469d6552a3db0a9ae
  } else {
    iconSettings = normalIcon;
  }

  return (
    <div className="JobIcon">
      {icon_state === 'borg' ? (
        <Icon color="lightblue" name={JOB2ICON[usedJob]} ml={0.3} mt={0.4} />
      ) : (
        <DmIcon
<<<<<<< HEAD
          icon={usedIcon || iconSettings.dmi}
=======
          icon={usedIcon}
>>>>>>> c40e5f1f6e8247937e91ad9469d6552a3db0a9ae
          icon_state={usedIconState}
          style={{
            transform: iconSettings.transform,
          }}
        />
      )}
    </div>
  );
}
