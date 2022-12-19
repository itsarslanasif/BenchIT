<template>
  <n-dropdown
    trigger="click"
    size="medium"
    :options="options"
    @select="handleSelect"
    class="bg-gray-100 border rounded-md border-slate-100 absolute dropdown w-80"
  >
    <n-button>
      <div class="flex avatar absolute">
        <n-avatar
          class="self-baseline"
          size="medium"
          src="../../../assets/images/user.png"
        />
      </div>
      <div
        class="flex absolute icon"
        :class="
          userStatus.active
            ? 'active text-green-700 border-2 border-black-900 rounded-xl'
            : 'away text-black border-2 border-white rounded-xl'
        "
      >
        <i class="fa-solid fa-circle"></i>
      </div>
    </n-button>
  </n-dropdown>
</template>

<script>
import { NDropdown, NAvatar, NText } from 'naive-ui';
import { h } from 'vue';
import userStatusStore from '../../stores/useUserStatusStore';
import { CONSTANTS } from '../../assets/constants';
export default {
  components: { NDropdown, NAvatar },
  data() {
    return {
      status: 'Away',
      prevStatus: 'active',
      statusIcon: '⚫',
      userStatus: userStatusStore(),
      options: [
        {
          key: 'header',
          type: 'render',
          render: this.renderCustomHeader,
        },
        {
          key: 'button',
          type: 'render',
          render: this.renderCustomButton,
        },
        {
          type: 'render',
          render: this.renderCustomOption,
          props: {
            onClick: () => {
              this.updateStatus();
            },
          },
          key: this.generateKey(CONSTANTS.SET_STATUS),
        },
        {
          label: CONSTANTS.PAUSE_NOTIFICATIONS,
          key: this.generateKey(CONSTANTS.PAUSE_NOTIFICATIONS),
          children: [
            {
              type: 'group',
              label: CONSTANTS.GROUP_PAUSE_NOTIFICATIONS,
              key: 'main',
              children: [
                {
                  label: CONSTANTS.FOR_30_MINUTES,
                  key: this.generateKey(CONSTANTS.FOR_30_MINUTES),
                },
                {
                  label: CONSTANTS.FOR_1_HOUR,
                  key: this.generateKey(CONSTANTS.FOR_1_HOUR),
                },
                {
                  label: CONSTANTS.FOR_2_HOURS,
                  key: this.generateKey(CONSTANTS.FOR_2_HOURS),
                },
                {
                  label: CONSTANTS.UNTIL_TOMORROW,
                  key: this.generateKey(CONSTANTS.UNTIL_TOMORROW),
                },
                {
                  label: CONSTANTS.CUSTOM,
                  key: this.generateKey(CONSTANTS.CUSTOM),
                },
                {
                  type: 'divider',
                  key: 'd1',
                },
                {
                  label: CONSTANTS.SET_A_NOTIFICATION_SCHEDULE,
                  key: this.generateKey(CONSTANTS.SET_A_NOTIFICATION_SCHEDULE),
                },
              ],
            },
          ],
        },
        {
          type: 'divider',
          key: 'd2',
        },
        {
          label: CONSTANTS.PROFILE,
          key: this.generateKey(CONSTANTS.PROFILE),
        },
        {
          label: CONSTANTS.PREFERENCES,
          key: this.generateKey(CONSTANTS.PREFERENCES),
        },
        {
          type: 'divider',
          key: 'd3',
        },
        {
          label: CONSTANTS.DOWNLOADS,
          key: this.generateKey(CONSTANTS.DOWNLOADS),
        },
        {
          type: 'divider',
          key: 'd4',
        },
        {
          label: CONSTANTS.SIGN_OUT_OF_DEVSINC,
          key: this.generateKey(CONSTANTS.SIGN_OUT_OF_DEVSINC),
        },
      ],
    };
  },
  methods: {
    handleSelect(key) {},
    renderCustomHeader() {
      return h(
        'div',
        {
          class: 'flex items-center py-2 px-3',
        },
        [
          h(NAvatar, {
            size: 'large',
            class: 'mr-3',
            src: '../../../assets/images/user.png',
          }),
          h('div', null, [
            h('div', { class: 'text-base font-bold' }, [
              h(NText, { depth: 2 }, { default: () => 'Alva' }),
            ]),
            h(
              'div',
              { style: 'font-size: 7px; float: left; margin-top: 6px;' },
              [h(NText, { depth: 3 }, { default: () => `${this.statusIcon}` })]
            ),
            h('div', { class: 'text-sm flex ml-4' }, [
              h(NText, { depth: 3 }, { default: () => `${this.status}` }),
            ]),
          ]),
        ]
      );
    },
    renderCustomButton() {
      return h(
        'div',
        {
          class:
            'hover:border-black-600 border rounded border-black-300 flex items-center px-3 pt-1 pb-1 cursor-pointer my-px mx-3',
        },
        [
          h('div', [h(NText, { class: 'text-xl' }, { default: () => '🙂' })]),
          h('div', { class: 'w-full' }, [
            h(
              NText,
              { class: 'ml-12 text-black-800' },
              { default: () => 'Update your status' }
            ),
          ]),
        ]
      );
    },
    renderCustomOption() {
      return h(
        'div',
        {
          class:
            'hover:bg-gray-50 m-1 cursor-pointer border rounded border-gray-100 mt-2',
        },
        [
          h('div', { class: 'w-full h-9 items-center flex' }, [
            h(
              NText,
              { class: 'ml-2 text-black-800' },
              { default: () => `Set yourself as ${this.prevStatus}` }
            ),
          ]),
        ]
      );
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
    updateStatus() {
      if (!this.userStatus.active) {
        this.userStatus.active = true;
        this.status = 'Active';
        this.prevStatus = 'away';
        this.statusIcon = '🟢';
      } else {
        this.userStatus.active = false;
        this.status = 'Away';
        this.prevStatus = 'active';
        this.statusIcon = '⚫';
      }
    },
  },
};
</script>

<style>
.avatar {
  right: 20px;
  top: 8px;
}
.dropdown {
  right: -97vw;
}
.icon {
  right: 14px;
  top: 33px;
}
.active {
  font-size: 9px;
}
.away {
  font-size: 6px;
  outline: 3px solid rgb(28, 29, 28);
}
</style>
