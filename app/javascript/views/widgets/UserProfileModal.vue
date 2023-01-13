<template>
  <n-dropdown
    trigger="hover"
    placement="bottom-start"
    class="rounded-lg border border-black-400"
    :options="options"
  >
    <div
      @click="showUserProfile"
      class="min-w-fit self-start ml-1 cursor-pointer"
    >
      <n-avatar
        class="mr-1"
        size="large"
        :src="sender_avatar"
        @mouseover="setUserProfileForModal"
      />
    </div>
  </n-dropdown>
</template>

<script>
import { NDropdown, NAvatar, NText, NButton } from 'naive-ui';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import { useUserProfileStore } from '../../stores/useUserProfileStore';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { h } from 'vue';
import { CONSTANTS } from '../../assets/constants';
import { useProfileStore } from '../../stores/useProfileStore';

export default {
  name: 'UserProfileModal',
  components: { NDropdown, NAvatar, NText, NButton },
  props: {
    profile_id: {
      type: Number,
      default: undefined,
    },
    sender_avatar: {
      type: String,
      default: undefined,
    },
  },
  setup() {
    const userProfileStore = useUserProfileStore();
    const currentProfileStore = useCurrentProfileStore();
    const rightPaneStore = useRightPaneStore();
    const profilesStore = useProfileStore();
    return {
      userProfileStore,
      currentProfileStore,
      rightPaneStore,
      profilesStore,
    };
  },
  beforeUnmount() {
    this.options = null;
  },
  data() {
    return {
      modal_profile: null,
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
  computed: {
    ownProfile() {
      return (
        this.currentProfileStore.currentProfile.id === this.modal_profile?.id
      );
    },
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
            src: this.modal_profile?.image_url,
          }),
          h('div', { class: 'text-md' }, [
            h(
              'div',
              {
                class: 'font-bold',
              },
              [
                h(
                  NText,
                  {
                    depth: 2,
                    onClick: () => {
                      this.showUserProfile();
                    },
                    class: 'cursor-pointer hover:underline',
                  },
                  { default: () => `${this.modal_profile?.username}` }
                ),
                h(
                  NText,
                  { depth: 2 },
                  { default: () => (this.ownProfile ? ' (you)' : '') }
                ),
                h(
                  NText,
                  { depth: 2 },
                  {
                    default: () =>
                      this.modal_profile?.isActive ? ' 🟢' : ' ⚫',
                  }
                ),
              ]
            ),
            h('div', null, [
              h(
                NText,
                { depth: 3 },
                { default: () => `${this.modal_profile?.description}` }
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
              { default: () => this.modal_profile?.status?.emoji }
            ),
            h(
              NText,
              {
                class: 'text-black-800 text-md self-center',
              },
              { default: () => this.modal_profile?.status?.text }
            ),
          ]),
          h('div', [
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
              { default: () => `${this.modal_profile?.local_time} local time` }
            ),
          ]),
        ]
      );
    },
    renderCustomFooter() {
      if (this.ownProfile) {
        return h(
          'div',
          {
            class: 'flex items-center justify-center w-95 p-4',
          },
          [
            h('div', [
              h(
                NText,
                {
                  class:
                    'text-black-800 border rounded cursor-pointer px-20 py-1 hover:bg-transparent',
                },
                { default: () => 'Set a status' }
              ),
            ]),
          ]
        );
      } else {
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
                    'text-black-800 border rounded cursor-pointer px-10 py-1 hover:bg-transparent',
                },
                { default: () => 'Message' }
              ),
            ]),
            h('div', [
              h(
                NText,
                {
                  class:
                    'text-black-800 border rounded cursor-pointer px-10 py-1 hover:bg-transparent',
                },
                { default: () => 'Huddle' }
              ),
            ]),
          ]
        );
      }
    },
    showUserProfile() {
      this.setUserProfileForPane();
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    setUserProfileForPane() {
      const profile = this.profilesStore.profiles.find(
        profile => profile?.id === this.profile_id
      );
      this.userProfileStore.setUserProfile(profile);
    },
    setUserProfileForModal() {
      this.modal_profile = this.profilesStore.profiles.find(
        profile => profile.id === this.profile_id
      );
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
