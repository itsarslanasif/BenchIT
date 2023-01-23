<template>
  <div>
    <n-dropdown
      trigger="click"
      size="medium"
      :options="options"
      @select="handleSelect"
      class="bg-gray-100 border rounded-md border-slate-100 absolute dropdown w-80"
    >
      <n-button>
        <div class="flex avatar absolute">
          <n-tooltip v-if="profileStatus" trigger="hover">
            <template #trigger>
              <div
                class="flex justify-center items-center bg-slate-700 rounded-l-lg w-8 h-9 hover:bg-transparent self-baseline text-sm"
              >
                <p>{{ profileStatus.emoji }}</p>
              </div>
            </template>
            <span
              >{{ profileStatus.emoji }} {{ profileStatus.text }}
              <span class="text-black-500">
                {{ $t('profilestatus.until') }}
              </span>
              {{ statusClearAfterTime(profileStatus.clear_after) }}
            </span>
          </n-tooltip>
          <n-avatar class="self-baseline" size="medium" :src="profileAvatar" />
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
    <DownloadModal v-model:show="showModal" />
    <SetProfileStatusModal v-if="profileStatusStore.showProfileStatusPopUp" />
  </div>
</template>

<script>
import { NDropdown, NAvatar, NText, NTooltip } from 'naive-ui';
import { h } from 'vue';
import userStatusStore from '../../stores/useUserStatusStore';
import { CONSTANTS } from '../../assets/constants';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import SetProfileStatusModal from '../components/profileStatus/setProfileStatusModal.vue';
import { useProfileStatusStore } from '../../stores/useProfileStatusStore.js';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import DownloadModal from './downloadModal.vue';
import { storeToRefs } from 'pinia';
import moment from 'moment';
import { ref, watch } from 'vue';
import { clearStatus } from '../../api/profiles/profileStatus';

export default {
  components: {
    NDropdown,
    NAvatar,
    DownloadModal,
    SetProfileStatusModal,
    NTooltip,
  },
  setup() {
    const profileStatusStore = useProfileStatusStore();
    const profileStore = useCurrentProfileStore();
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const { currentProfile } = storeToRefs(profileStore);
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    const { status } = storeToRefs(profileStore);

    return {
      profile: currentProfile,
      currentProfile,
      currentWorkspace,
      profileStatusStore: profileStatusStore,
      profileCurrentStatus: status,
    };
  },

  beforeUnmount() {
    this.status = this.userStatus = null;
    this.prevStatus = this.profile = null;
    this.statusIcon = this.options = null;
  },

  data() {
    return {
      myStatus: ref(this.profile.status),
      status: 'Away',
      prevStatus: 'active',
      statusIcon: '⚫',
      userStatus: userStatusStore(),
      showModal: false,

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
          render: this.renderClearStatusOption,
          show: this.hasStatus(),
          props: {
            onClick: () => {
              this.clearProfileStatus();
            },
          },
          key: this.generateKey(CONSTANTS.CLEAR_STATUS),
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
          label: `${CONSTANTS.SIGN_OUT_OF} ${this.currentWorkspace.company_name}`,
          key: this.generateKey(`${CONSTANTS.SIGN_OUT_OF_WORKSPACE}`),
        },
      ],
    };
  },
  watch: {
    profileCurrentStatus(newValue) {
      if (newValue === null) {
        this.options[2].show = false;
      } else {
        this.options[2].show = true;
      }
    },
  },
  computed: {
    profileAvatar() {
      return this.profile.image_url;
    },
    profileStatus() {
      return this.profile?.status;
    },
  },
  methods: {
    hasStatus() {
      if (this.profile.status) return true;
      return false;
    },
    initializeOptions() {
      this.options[0].show = this.profile.status ? true : false;
    },
    handleStatusSelect() {
      this.profileStatusStore.toggleProfileStatusPopUp();
    },
    statusClearAfterTime(time) {
      return !time
        ? moment().endOf('month').fromNow()
        : moment(time).calendar();
    },
    clearProfileStatus() {
      clearStatus(this.currentWorkspace.id, this.profile.id)
        .then(response => {
          this.currentProfile.setProfileStatus(null);
        })
        .catch(err => {
          console.log(err);
        });
    },
    handleSelect(key) {
      switch (key) {
        case 'sign-out-of-workspace':
          sessionStorage.removeItem('currentWorkspace');
          sessionStorage.removeItem('currentProfile');
          this.$router.push('/workspace_dashboard');
          break;
        case 'downloads':
          this.showModal = true;
          break;
      }
    },

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
            src: this.profile?.image_url,
          }),
          h('div', null, [
            h('div', { class: 'text-base font-bold' }, [
              h(NText, { depth: 2 }, { default: () => this.profile.username }),
            ]),
            h(
              'div',
              { style: 'font-size: 7px; float: left; margin-top: 6px;' },
              [h(NText, { depth: 3 }, { default: () => `${this.statusIcon}` })]
            ),
            h('div', { class: 'text-sm  flex ml-4' }, [
              h(NText, { depth: 3 }, { default: () => `${this.status}` }),
            ]),
          ]),
        ]
      );
    },
    renderClearStatusOption() {
      return h(
        'div',
        {
          class:
            'hover:bg-gray-50 m-1 cursor-pointer border rounded border-gray-100 mt-2 ',
        },
        [
          h('div', { class: 'w-full  h-9 items-center flex' }, [
            h(
              NText,
              { class: 'ml-2 text-black-800' },
              { default: () => CONSTANTS.CLEAR_STATUS }
            ),
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
          onClick: this.handleStatusSelect,
        },
        [
          h('div', [
            h(
              NText,
              { class: 'text-xl' },
              {
                default: () =>
                  this.profile.status ? this.profile.status?.emoji : '🙂',
              }
            ),
          ]),
          h('div', { class: 'w-full' }, [
            h(
              NText,
              { class: 'ml-12 text-black-800' },
              {
                default: () =>
                  this.profile.status
                    ? this.profile.status?.text
                    : 'Update your status',
              }
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
        this.userStatus.active = !this.userStatus.active;
        this.status = 'Active';
        this.prevStatus = 'away';
        this.statusIcon = '🟢';
      } else {
        this.userStatus.active = !this.userStatus.active;
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
