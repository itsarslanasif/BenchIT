<template>
  <div>
    <n-dropdown
      v-if="currentWorkspace"
      trigger="click"
      :options="options"
      @select="handleSelect($event)"
      size="large"
      class="w-80 rounded-md bg-white"
    >
      <div class="mx-3 my-2 flex text-white cursor-pointer">
        <strong class="text-xl">{{ currentWorkspace.company_name }}</strong>
        <i class="fa-solid fa-chevron-down self-center fa-lg ml-1" />
      </div>
    </n-dropdown>
    <UserInviteModal v-model:show="showModal" />
    <div v-if="showChannelModal">
      <CreateChannel :close-modal="toggleCreateChannelModal" />
    </div>
    <div v-if="showWorkspaceModal">
      <CreateWorkspace :close-modal="toggleWorkspaceModal" />
    </div>
  </div>
</template>

<script>
import { NDropdown, NButton } from 'naive-ui';
import options from './options.js';
import UserInviteModal from '../userInviteModal.vue';
import { userSignOut } from '../../../api/user_auth/user_sign_out_api';
import { decryption } from '../../../modules/crypto/crypto';
import CreateChannel from '../../components/channels/CreateChannel.vue';
import CreateWorkspace from '../../components/workspace/CreateWorkspace.vue';
import { removeActiveStatus } from '../../../api/profiles/profileStatus';

export default {
  components: {
    NButton,
    NDropdown,
    UserInviteModal,
    CreateChannel,
    CreateWorkspace,
  },
  data() {
    return {
      options: [],
      showModal: false,
      showChannelModal: false,
      showWorkspaceModal: false,
    };
  },
  beforeUnmount() {
    this.options = null;
  },
  setup() {
    const currentWorkspace = decryption(sessionStorage, 'currentWorkspace');
    const currentProfile = decryption(sessionStorage, 'currentProfile');
    return { currentWorkspace, options, currentProfile };
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'sign-out-of-your-account':
          this.signOut();
          break;
        case 'invite-people':
          this.showModal = true;
          break;
        case 'create-a-channel':
          this.showChannelModal = true;
          break;
        case 'add-workspaces':
          this.showWorkspaceModal = true;
          break;
      }
    },
    async signOut() {
      try {
        let token = decryption(localStorage, 'token');
        await removeActiveStatus(
          this.currentWorkspace.id,
          this.currentProfile.id
        );
        const res = await userSignOut(token);
        this.response = res;
        this.$router.push('/sign_in');
      } catch (error) {
        console.error(error);
      }
    },
    toggleCreateChannelModal() {
      this.showChannelModal = !this.showChannelModal;
    },
    toggleWorkspaceModal() {
      this.showWorkspaceModal = !this.showWorkspaceModal;
    },
  },
};
</script>
