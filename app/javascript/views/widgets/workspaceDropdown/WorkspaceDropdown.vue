<template>
  <n-dropdown
    trigger="click"
    :options="options"
    @select="handleSelect($event)"
    size="large"
    class="w-80 rounded-md bg-white"
  >
    <n-text text color="white">
      <div class="mx-3 my-2 flex text-white">
        <strong class="text-xl">{{ currentWorkspace?.company_name }}</strong>
        <i class="fa-solid fa-chevron-down self-center fa-xs ml-1 mb-2" />
      </div>
    </n-text>
  </n-dropdown>
  <UserInviteModal v-model:show="showModal" />
</template>

<script>
import { NDropdown, NButton } from 'naive-ui';
import options from './options.js';
import UserInviteModal from '../userInviteModal.vue';
import { userSignOut } from '../../../api/user_auth/user_sign_out_api';
import { decryption } from '../../../modules/crypto/crypto';

export default {
  components: { NButton, NDropdown, UserInviteModal },
  data() {
    return {
      options: [],
      showModal: false,
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
      }
    },
  },
};
</script>
