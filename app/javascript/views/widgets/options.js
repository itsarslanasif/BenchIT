import { NIcon } from 'naive-ui';
import { h } from 'vue';
import { RocketOutline as PollyIcon, CardOutline as CardOutlineIcon, PersonAddOutline as PersonAddIcon } from '@vicons/ionicons5';
import { CONSTANTS } from '../../assets/constants';

const renderIcon = icon => {
  return () => {
    return h(NIcon, null, {
      default: () => h(icon),
    });
  };
};

const generateKey = label => {
  return label.toLowerCase().replace(/ /g, '-');
};

export default [
  {
    label: CONSTANTS.OFF_NOTIFICATIONS,
    key: generateKey(CONSTANTS.OFF_NOTIFICATIONS),
  },
  {
    type: 'divider',
    key: 'd1',
  },
  {
    label: CONSTANTS.MARK_UNREAD,
    key: generateKey(CONSTANTS.MARK_UNREAD),
  },
  {
    label: CONSTANTS.REMIND_LATER,
    key: generateKey(CONSTANTS.REMIND_LATER),
    children: [
      {
        label: CONSTANTS.TWENTY_MINUTES,
        key: generateKey(CONSTANTS.TWENTY_MINUTES),
      },
      {
        label: CONSTANTS.ONE_HOUR,
        key: generateKey(CONSTANTS.ONE_HOUR),
      },
      {
        label: CONSTANTS.THREE_HOURS,
        key: generateKey(CONSTANTS.THREE_HOURS),
      },
      {
        label: CONSTANTS.TOMORROW,
        key: generateKey(CONSTANTS.TOMORROW),
      },
      {
        label: CONSTANTS.NEXT_WEEK,
        key: generateKey(CONSTANTS.NEXT_WEEK),
      },
      {
        label: CONSTANTS.CUSTOM,
        key: generateKey(CONSTANTS.CUSTOM),
      },
    ],
  },
  {
    type: 'divider',
    key: 'd2',
  },
  {
    label: CONSTANTS.COPY_LINK,
    key: generateKey(CONSTANTS.COPY_LINK),
  },
  {
    type: 'divider',
    key: 'd3',
  },
  {
    label: CONSTANTS.PIN_TO_CONVERSATION,
    key: generateKey(CONSTANTS.PIN_TO_CONVERSATION),
  },
  {
    type: 'divider',
    key: 'd4',
  },
  {
    label: CONSTANTS.EDIT,
    key: generateKey(CONSTANTS.EDIT),
  },
  {
    label: CONSTANTS.DELETE,
    key: generateKey(CONSTANTS.DELETE),
  },
  {
    type: 'divider',
    key: 'd5',
  },
  {
    label: CONSTANTS.POLLY,
    key: generateKey(CONSTANTS.POLLY),
    icon: renderIcon(PollyIcon),
  },
  {
    label: CONSTANTS.CARD_FROM_MESSAGE,
    key: generateKey(CONSTANTS.CARD_FROM_MESSAGE),
    icon: renderIcon(CardOutlineIcon),
  },
  {
    label: CONSTANTS.ASSIGN_AS_TASK,
    key: generateKey(CONSTANTS.ASSIGN_AS_TASK),
    icon: renderIcon(PersonAddIcon),
  },
  {
    label: CONSTANTS.MORE_SHORTCUTS,
    key: generateKey(CONSTANTS.MORE_SHORTCUTS),
  },
];
