import { NIcon } from 'naive-ui';
import { h } from 'vue';
import {
  RocketOutline as PollyIcon,
  CardOutline as CardOutlineIcon,
  PersonAddOutline as PersonAddIcon,
} from '@vicons/ionicons5';
import { CONSTANTS } from '../../assets/constants';

export default class Options {
  constructor(isPinned,isMyMessage) {
    this.isPinned = isPinned;
    this.isMyMessage=isMyMessage
  }

  renderIcon = icon => {
    return () => {
      return h(NIcon, null, {
        default: () => h(icon),
      });
    };
  };

  generateKey = label => {
    return label.toLowerCase().replace(/ /g, '-');
  };

  getOptions() {
    return [
      {
        label: CONSTANTS.OFF_NOTIFICATIONS,
        key: this.generateKey(CONSTANTS.OFF_NOTIFICATIONS),
      },
      {
        type: 'divider',
        key: 'd1',
      },
      {
        label: CONSTANTS.MARK_UNREAD,
        key: this.generateKey(CONSTANTS.MARK_UNREAD),
      },
      {
        label: CONSTANTS.REMIND_LATER,
        key: this.generateKey(CONSTANTS.REMIND_LATER),
        children: [
          {
            label: CONSTANTS.TWENTY_MINUTES,
            key: this.generateKey(CONSTANTS.TWENTY_MINUTES),
          },
          {
            label: CONSTANTS.ONE_HOUR,
            key: this.generateKey(CONSTANTS.ONE_HOUR),
          },
          {
            label: CONSTANTS.THREE_HOURS,
            key: this.generateKey(CONSTANTS.THREE_HOURS),
          },
          {
            label: CONSTANTS.TOMORROW,
            key: this.generateKey(CONSTANTS.TOMORROW),
          },
          {
            label: CONSTANTS.NEXT_WEEK,
            key: this.generateKey(CONSTANTS.NEXT_WEEK),
          },
          {
            label: CONSTANTS.CUSTOM,
            key: this.generateKey(CONSTANTS.CUSTOM),
          },
        ],
      },
      {
        type: 'divider',
        key: 'd2',
      },
      {
        label: CONSTANTS.COPY_LINK,
        key: this.generateKey(CONSTANTS.COPY_LINK),
      },
      {
        type: 'divider',
        key: 'd3',
      },
      {
        label: CONSTANTS.PIN_TO_CONVERSATION,
        key: this.generateKey(CONSTANTS.PIN_TO_CONVERSATION),
        show: !this.isPinned,
      },
      {
        label: CONSTANTS.UNPIN_FROM_CONVERSATION,
        key: this.generateKey(CONSTANTS.UNPIN_FROM_CONVERSATION),
        show: this.isPinned,
      },
      {
        type: 'divider',
        key: 'd4',
      },
      {
        label: CONSTANTS.EDIT,
        key: this.generateKey(CONSTANTS.EDIT),
        show:this.isMyMessage,
      },
      {
        label: CONSTANTS.DELETE,
        key: this.generateKey(CONSTANTS.DELETE),
        show:this.isMyMessage,
      },
      {
        type: 'divider',
        key: 'd5',
      },
      {
        label: CONSTANTS.POLLY,
        key: this.generateKey(CONSTANTS.POLLY),
        icon: this.renderIcon(PollyIcon),
      },
      {
        label: CONSTANTS.CARD_FROM_MESSAGE,
        key: this.generateKey(CONSTANTS.CARD_FROM_MESSAGE),
        icon: this.renderIcon(CardOutlineIcon),
      },
      {
        label: CONSTANTS.ASSIGN_AS_TASK,
        key: this.generateKey(CONSTANTS.ASSIGN_AS_TASK),
        icon: this.renderIcon(PersonAddIcon),
      },
      {
        label: CONSTANTS.MORE_SHORTCUTS,
        key: this.generateKey(CONSTANTS.MORE_SHORTCUTS),
      },
    ];
  }
}
