import { h } from 'vue';
import { NText, NAvatar } from 'naive-ui';
import { CONSTANTS } from '../../../assets/constants';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { storeToRefs } from 'pinia';

const generateKey = label => {
  return label.toLowerCase().replace(/ /g, '-');
};

const renderCustomHeader = () => {
  const currentWorkspaceStore = useCurrentWorkspaceStore();
  const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
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
          h(
            NText,
            { depth: 2 },
            { default: () => currentWorkspace.value.company_name }
          ),
        ]),
        h('div', { class: 'text-xs flex' }, [
          h(
            NText,
            { depth: 3 },
            { default: () => currentWorkspace.value.bench_it_url }
          ),
        ]),
      ]),
    ]
  );
};

const renderMobile = () => {
  const currentWorkspaceStore = useCurrentWorkspaceStore();
  const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
  return h(
    'div',
    {
      class:
        'flex items-center px-4 py-3 cursor-pointer hover:bg-transparent duration-300',
    },
    [
      h('div', null, [
        h('div', { class: 'text-md' }, [
          h(
            NText,
            { depth: 2 },
            {
              default: () =>
                `${CONSTANTS.SIGN_IN_TO} ${currentWorkspace.value.company_name} ${CONSTANTS.MOBILE}`,
            }
          ),
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
    key: 'header',
    type: 'render',
    render: renderMobile,
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
