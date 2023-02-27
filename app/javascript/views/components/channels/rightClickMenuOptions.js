import { NIcon } from 'naive-ui';
import { h } from 'vue';
import { Albums } from '@vicons/ionicons5';
import { CONSTANTS } from '../../../assets/constants';
export default class Option {
  constructor(favourite_id, unread_message_exist, is_channel) {
    this.favourite_id = favourite_id;
    this.unread_message_exist = unread_message_exist;
    this.is_channel = is_channel;
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
        label: CONSTANTS.OPEN_IN_SPLIT_VIEW,
        key: this.generateKey(CONSTANTS.OPEN_IN_SPLIT_VIEW),
        icon: this.renderIcon(Albums),
      },
      {
        type: CONSTANTS.DIVIDER,
        key: this.generateKey(`${CONSTANTS.DIVIDER} + 1`),
      },
      {
        label: this.is_channel
          ? CONSTANTS.VIEW_CHANNEL_DETAILS
          : CONSTANTS.VIEW_CONVERSATION_DETAILS,
        key: this.generateKey(
          this.is_channel
            ? CONSTANTS.VIEW_CHANNEL_DETAILS
            : CONSTANTS.VIEW_CONVERSATION_DETAILS
        ),
      },
      {
        label: CONSTANTS.COPY,
        key: this.generateKey(CONSTANTS.COPY),
        children: [
          {
            label: CONSTANTS.COPY_NAME,
            key: this.generateKey(CONSTANTS.COPY_NAME),
          },
          {
            label: CONSTANTS.COPY_LINK,
            key: this.generateKey(CONSTANTS.COPY_LINK),
          },
          {
            label: CONSTANTS.COPY_HUDDLE_LINK,
            key: this.generateKey(CONSTANTS.COPY_HUDDLE_LINK),
          },
        ],
      },
      {
        type: CONSTANTS.DIVIDER,
        key: this.generateKey(`${CONSTANTS.DIVIDER} + 2`),
      },
      {
        label: this.is_channel
          ? CONSTANTS.MUTE_CHANNEL
          : CONSTANTS.MUTE_CONVERSATION,
        key: this.generateKey(
          this.is_channel ? CONSTANTS.MUTE_CHANNEL : CONSTANTS.MUTE_CONVERSATION
        ),
      },
      {
        label: CONSTANTS.MARK_AS_READ,
        key: this.generateKey(CONSTANTS.MARK_AS_READ),
        show: this.unread_message_exist,
      },
      {
        label: CONSTANTS.CHANGE_NOTIFICATIONS,
        key: this.generateKey(CONSTANTS.CHANGE_NOTIFICATIONS),
        show: this.is_channel,
      },
      {
        type: CONSTANTS.DIVIDER,
        key: this.generateKey(`${CONSTANTS.DIVIDER} + 3`),
      },
      {
        label: this.is_channel
          ? CONSTANTS.STAR_CHANNEL
          : CONSTANTS.STAR_CONVERSATION,
        key: this.generateKey(
          this.is_channel ? CONSTANTS.STAR_CHANNEL : CONSTANTS.STAR_CONVERSATION
        ),
        show: !this.favourite_id,
      },
      {
        label: this.is_channel
          ? CONSTANTS.UN_STAR_CHANNEL
          : CONSTANTS.UN_STAR_CONVERSATION,
        key: this.generateKey(
          this.is_channel
            ? CONSTANTS.UN_STAR_CHANNEL
            : CONSTANTS.UN_STAR_CONVERSATION
        ),
        show: this.favourite_id,
      },
      {
        type: CONSTANTS.DIVIDER,
        key: this.generateKey(`${CONSTANTS.DIVIDER} + 4`),
      },
      {
        label: this.is_channel
          ? CONSTANTS.LEAVE_CHANNEL
          : CONSTANTS.CLOSE_CONVERSATION,
        key: this.generateKey(
          this.is_channel
            ? CONSTANTS.LEAVE_CHANNEL
            : CONSTANTS.CLOSE_CONVERSATION
        ),
      },
    ];
  }
}
