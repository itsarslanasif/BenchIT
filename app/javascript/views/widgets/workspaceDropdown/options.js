import { h } from 'vue';
import { NText, NAvatar } from 'naive-ui';
import { CONSTANTS } from '../../../assets/constants';

const generateKey = label => {
  return label.toLowerCase().replace(/ /g, '-');
};

function renderCustomHeader() {
  return h(
    'div',
    {
      class: 'flex items-center p-4',
    },
    [
      h(NAvatar, {
        size: 'large',
        class: 'mr-3',
        src: '../../../assets/images/user.png',
      }),
      h('div', null, [
        h('div', { class: 'text-md font-bold' }, [
          h(NText, { depth: 2 }, { default: () => 'BenchIT' }),
        ]),
        h('div', { class: 'text-xs flex' }, [
          h(NText, { depth: 3 }, { default: () => 'workspace.benchit.com' }),
        ]),
      ]),
    ]
  );
};

export default [
  {
    key: 'header',
    type: 'render',
    render: renderCustomHeader,
  },
  {
    type: 'divider',
    key: 'd1',
  },
  {
    label: CONSTANTS.INVITE_PEOPLE,
    key: generateKey(CONSTANTS.INVITE_PEOPLE),
  },
  {
    label: CONSTANTS.CREATE_CHANNEL,
    key: generateKey(CONSTANTS.CREATE_CHANNEL),
  },
  {
    type: 'divider',
    key: 'd2',
  },
  {
    label: CONSTANTS.PREFERENCES,
    key: generateKey(CONSTANTS.PREFERENCES),
  },
  {
    label: CONSTANTS.ADMINISTRATION,
    key: generateKey(CONSTANTS.ADMINISTRATION),
  },
  {
    type: 'divider',
    key: 'd3',
  },
  {
    label: CONSTANTS.TOOLS,
    key: generateKey(CONSTANTS.TOOLS),
  },
  {
    type: 'divider',
    key: 'd4',
  },
  {
    label: CONSTANTS.SIGN_IN_MOBILE,
    key: generateKey(CONSTANTS.SIGN_IN_MOBILE),
  },
  {
    label: CONSTANTS.SIGN_OUT,
    key: generateKey(CONSTANTS.SIGN_OUT),
  },
  {
    type: 'divider',
    key: 'd5',
  },
  {
    label: CONSTANTS.ADD_WORKSPACE,
    key: generateKey(CONSTANTS.ADD_WORKSPACE),
  },
];
