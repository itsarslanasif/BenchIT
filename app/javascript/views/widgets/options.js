import { NIcon } from 'naive-ui'
import { h,  } from 'vue'
import { RocketOutline as PollyIcon, CardOutline as CardOutlineIcon, PersonAddOutline as PersonAddIcon } from '@vicons/ionicons5'
import { CONSTANTS } from '../../assets/constants';

const renderIcon = (icon) => {
  return () => {
    return h(NIcon, null, {
      default: () => h(icon)
    })
  }
}

export default [
  {
    label: CONSTANTS.OFF_NOTIFICATIONS,
    key: 'turn-off-notifications-for-replies',
  },
  {
    type: 'divider',
    key: 'd1',
  },
  {
    label: CONSTANTS.MARK_UNREAD,
    key: 'mark-unread',
  },
  {
    label: CONSTANTS.REMIND_LATER,
    key: 'remind-me-about-this',
    children: [
      {
        label: CONSTANTS.TWENTY_MINUTES,
        key: 'in-20-minutes',
      },
      {
        label: CONSTANTS.ONE_HOUR,
        key: 'in-1-hour',
      },
      {
        label: CONSTANTS.THREE_HOURS,
        key: 'in-3-hours',
      },
      {
        label: CONSTANTS.TOMORROW,
        key: '8',
      },
      {
        label: CONSTANTS.NEXT_WEEK,
        key: 'tommorow',
      },
      {
        label: CONSTANTS.CUSTOM,
        key: 'custom',
      },
    ],
  },
  {
    type: 'divider',
    key: 'd2',
  },
  {
    label: CONSTANTS.COPY_LINK,
    key: 'copy-link',
  },
  {
    type: 'divider',
    key: 'd3',
  },
  {
    label: CONSTANTS.PIN_TO_CONVERSATION,
    key: 'pin-to-this-conversation',
  },
  {
    type: 'divider',
    key: 'd4',
  },
  {
    label: CONSTANTS.EDIT,
    key: 'edit-message',
  },
  {
    label: CONSTANTS.DELETE,
    key: 'delete-message',
  },
  {
    type: 'divider',
    key: 'd5',
  },
  {
    label: CONSTANTS.POLLY,
    key: 'create-a-polly',
    icon: renderIcon(PollyIcon)
  },
  {
    label: CONSTANTS.CARD_FROM_MESSAGE,
    key: 'create-card-from-message',
    icon: renderIcon(CardOutlineIcon)
  },
  {
    label: CONSTANTS.ASSIGN_AS_TASK,
    key: 'self-assign-as-task',
    icon: renderIcon(PersonAddIcon)
  },
  {
    label: CONSTANTS.MORE_SHORTCUTS,
    key: 'more-shortcuts',
  },
];

