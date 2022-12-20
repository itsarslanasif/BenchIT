<template>
  <n-dropdown trigger="hover" :options="options" @select="handleSelect">
    <div
      @click="showUserProfile"
      class="min-w-fit self-start ml-1 cursor-pointer"
    >
      <n-avatar
        v-show="!isSameUser || !isSameDayMessage"
        class="mr-1"
        size="large"
        src="../../../assets/images/user.png"
      />
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown, NAvatar, NText, NButton } from 'naive-ui';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import { h } from 'vue';
import { CONSTANTS } from '../../assets/constants';

export default {
  name: 'UserProfileModal',
  components: { NDropdown, NAvatar, NText, NButton },
  props: ['showModal', 'userProfile'],
  setup() {
    const rightPaneStore = useRightPaneStore();
    return { rightPaneStore };
  },
  data() {
    return {
      options: [
        {
          key: `${CONSTANTS.HEADER}`,
          type: 'render',
          render: this.renderCustomHeader,
        },
        {
          key: `${CONSTANTS.DIVIDER}`,
          type: 'divider',
        },
        {
          key: `${CONSTANTS.BODY}`,
          type: 'render',
          render: this.renderCustomBody,
        },
        {
          key: `${CONSTANTS.FOOTER}`,
          type: 'render',
          render: this.renderCustomFooter,
        },
      ],
    };
  },
  methods: {
    renderCustomHeader() {
      return h(
        'div',
        {
          class: 'flex items-center p-4',
        },
        [
          h(NAvatar, {
            onClick: () => {
              this.showUserProfile();
            },
            class: 'mr-2 w-20 h-20 cursor-pointer',
            src: '../../../assets/images/user.png',
          }),
          h('div', { class: 'text-md' }, [
            h('div', { class: 'font-bold' }, [
              h(NText, { depth: 2 }, { default: () => 'Asad Tariq' }),
              h(NText, { depth: 2 }, { default: () => ' (you)' }),
              h(NText, { depth: 2 }, { default: () => ' ⚫' }),
            ]),
            h('div', null, [
              h(
                NText,
                { depth: 3 },
                { default: () => 'Associate Software Engineer' }
              ),
            ]),
          ]),
        ]
      );
    },
    renderCustomBody() {
      return h(
        'div',
        {
          class: 'px-4 pt-2',
        },
        [
          h('div', { class: 'mr-6' }, [
            h(
              NText,
              {
                class: 'text-black-800 mr-2 text-md',
              },
              { default: () => '💬' }
            ),
            h(
              NText,
              {
                class: 'text-black-800 text-md self-center',
              },
              { default: () => 'AFK' }
            ),
          ]),
          h('div', { class: '' }, [
            h(
              NText,
              {
                class: 'text-black-800 mr-2 text-md',
              },
              { default: () => '🕒' }
            ),
            h(
              NText,
              {
                class: 'text-black-800',
              },
              { default: () => '5:47 PM local time' }
            ),
          ]),
        ]
      );
    },
    renderCustomFooter() {
      return h(
        'div',
        {
          class: 'flex items-center justify-center self-center p-4',
        },
        [
          h('div', { class: 'mr-6' }, [
            h(
              NText,
              {
                class:
                  'text-black-800 border rounded cursor-pointer px-10 py-2 hover:bg-transparent',
              },
              { default: () => 'Message' }
            ),
          ]),
          h('div', { class: '' }, [
            h(
              NText,
              {
                class:
                  'text-black-800 border rounded cursor-pointer px-10 py-2 hover:bg-transparent',
              },
              { default: () => 'Huddle' }
            ),
          ]),
        ]
      );
    },
    showUserProfile() {
      this.rightPaneStore.toggleUserProfileShow(true);
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
