import { NIcon } from 'naive-ui';
import { h } from 'vue';
import { Albums } from '@vicons/ionicons5';

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
    label: 'Open in split view',
    key: generateKey('channel_options.open_in_split_view'),
    icon: renderIcon(Albums),
  },
  {
    type: 'divider',
    key: 'd1',
  },
  {
    label: 'View channel details',
    key: generateKey('channel_options.view_channel_details'),
  },
  {
    label: 'Copy',
    key: generateKey('channel_options.copy'),
    children: [
      {
        label: 'Copy name',
        key: generateKey('channel_options.copy_name'),
      },
      {
        label: 'Copy link',
        key: generateKey('channel_options.copy_link'),
      },
      {
        label: 'Copy huddle link',
        key: generateKey('channel_options.copy_huddle_link'),
      },
    ],
  },
  {
    type: 'divider',
    key: 'd2',
  },
  {
    label: 'Mute channel',
    key: generateKey('channel_options.mute_channel'),
  },
  {
    label: 'Change notifications',
    key: generateKey('channel_options.change_notifications'),
  },
  {
    type: 'divider',
    key: 'd3',
  },
  {
    label: 'Star channel',
    key: generateKey('channel_options.star_channel'),
  },
  {
    type: 'divider',
    key: 'd4',
  },
  {
    label: 'Leave channel',
    key: generateKey('channel_options.leave_channel'),
  },
];
