<template>
  <n-dropdown
    trigger="click"
    :options="options"
    @select="handleSelect($event)"
    size="large"
    class="w-80 rounded-md bg-white"
  >
    <div class="mx-3 my-2 flex text-white cursor-pointer">
      <strong class="text-xl">{{ currentWorkspace?.company_name }}</strong>
      <i class="fa-solid fa-chevron-down self-center fa-lg ml-1" />
    </div>
  </n-dropdown>
  <UserInviteModal v-model:show="showModal" />
</template>

<script>
import { NDropdown, NButton } from 'naive-ui';
import options from './options.js';
import UserInviteModal from '../userInviteModal.vue';
import { userSignOut } from '../../../api/user_auth/user_sign_out_api';

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
    const currentWorkspace = JSON.parse(
      sessionStorage.getItem('currentWorkspace')
    );
    return { currentWorkspace, options };
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'sign-out-of-your-account':
          let token = localStorage.getItem('token');
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
