import { NIcon } from 'naive-ui'
import { h, defineComponent } from 'vue'
import {
  RocketOutline as PollyIcon,
  CardOutline as CardOutlineIcon,
  PersonAddOutline as PersonAddIcon
} from '@vicons/ionicons5'
const renderIcon = (icon) => {
  return () => {
    return h(NIcon, null, {
      default: () => h(icon)
    })
  }
}

export default [
  {
    label: 'Turn off notifications for replies',
    key: 'turn-off-notifications-for-replies',
  },
  {
    type: 'divider',
    key: 'd1',
  },
  {
    label: 'Mark unread',
    key: 'mark-unread',
  },
  {
    label: 'Remind me about this',
    key: 'remind-me-about-this',
    children: [
      {
        label: 'In 20 minutes',
        key: 'in-20-minutes',
      },
      {
        label: 'In 1 hour',
        key: 'in-1-hour',
      },
      {
        label: 'In 3 hours',
        key: 'in-3-hours',
      },
      {
        label: 'Tommorow',
        key: '8',
      },
      {
        label: 'Next week',
        key: 'tommorow',
      },
      {
        label: 'Custom',
        key: 'custom',
      },
    ],
  },
  {
    type: 'divider',
    key: 'd2',
  },
  {
    label: 'Copy link',
    key: 'copy-link',
  },
  {
    type: 'divider',
    key: 'd3',
  },
  {
    label: 'Pin to this conversation',
    key: 'pin-to-this-conversation',
  },
  {
    type: 'divider',
    key: 'd4',
  },
  {
    label: 'Edit message',
    key: 'edit-message',
  },
  {
    label: 'Delete message',
    key: 'delete-message',
  },
  {
    type: 'divider',
    key: 'd5',
  },
  {
    label: 'Create a polly',
    key: 'create-a-polly',
    icon: renderIcon(PollyIcon)
  },
  {
    label: 'Create card from message',
    key: 'create-card-from-message',
    icon: renderIcon(CardOutlineIcon)
  },
  {
    label: 'Self assign as task',
    key: 'self-assign-as-task',
    icon: renderIcon(PersonAddIcon)
  },
  {
    label: 'More messages shortcuts...',
    key: 'more-shortcuts',
  },
];

