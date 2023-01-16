import { NIcon } from 'naive-ui';
import { h } from 'vue';
import { Albums } from '@vicons/ionicons5';
import { CONSTANTS } from '../../../assets/constants';


export default class Option {
  constructor(favourite_id) {
    this.favourite_id = favourite_id;
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
        label: CONSTANTS.VIEW_CHANNEL_DETAILS,
        key: this.generateKey(CONSTANTS.VIEW_CHANNEL_DETAILS),
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
        label: CONSTANTS.MUTE_CHANNEL,
        key: this.generateKey(CONSTANTS.MUTE_CHANNEL),
      },
      {
        label: CONSTANTS.CHANGE_NOTIFICATIONS,
        key: this.generateKey(CONSTANTS.CHANGE_NOTIFICATIONS),
      },
      {
        type: CONSTANTS.DIVIDER,
        key: this.generateKey(`${CONSTANTS.DIVIDER} + 3`),
      },
      {
        label: CONSTANTS.STAR_CHANNEL,
        key: this.generateKey(CONSTANTS.STAR_CHANNEL),
        show: !this.favourite_id,
      },
      {
        label: CONSTANTS.UN_STAR_CHANNEL,
        key: this.generateKey(CONSTANTS.UN_STAR_CHANNEL),
        show: this.favourite_id,
      },
      {
        type: CONSTANTS.DIVIDER,
        key: this.generateKey(`${CONSTANTS.DIVIDER} + 4`),
      },
      {
        label: CONSTANTS.LEAVE_CHANNEL,
        key: this.generateKey(CONSTANTS.LEAVE_CHANNEL),
      },
    ];
  }
}
