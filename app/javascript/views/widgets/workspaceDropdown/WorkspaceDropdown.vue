<template>
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
</template>

<script>
import { NDropdown, NButton } from 'naive-ui';
import options from './options.js';
import UserInviteModal from '../userInviteModal.vue';
import { userSignOut } from '../../../api/user_auth/user_sign_out_api';
import { decryption } from '../../../modules/crypto/crypto';
import CreateChannel from '../../components/channels/CreateChannel.vue';

export default {
  components: { NButton, NDropdown, UserInviteModal, CreateChannel },
  data() {
    return {
      options: [],
      showModal: false,
      showChannelModal: false,
    };
  },
  beforeUnmount() {
    this.options = null;
  },
  setup() {
    const currentWorkspace = decryption(sessionStorage, 'currentWorkspace');
    return { currentWorkspace, options };
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'sign-out-of-your-account':
          let token = decryption(localStorage, 'token');
          userSignOut(token).then(res => {
            this.response = res;
            this.$router.push('/sign_in');
          });
          break;
        case 'invite-people':
          this.showModal = true;
          break;
        case 'create-a-channel':
          this.showChannelModal = true;
          break;
      }
    },
    toggleCreateChannelModal() {
      this.showChannelModal = !this.showChannelModal;
    },
  },
};
</script>
