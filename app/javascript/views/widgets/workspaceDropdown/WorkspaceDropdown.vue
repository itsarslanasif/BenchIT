<template>
  <n-dropdown
    trigger="click"
    :options="options"
    @select="handleSelect($event)"
    size="large"
    class="w-80 rounded-md"
  >
    <n-text text color="white">
      <div class="mx-3 my-2 flex text-white">
        <strong class="text-xl">{{ $t('project.title') }}</strong>
        <i class="fa-solid fa-chevron-down self-center fa-xs ml-1 mb-2" /></div
    ></n-text>
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
      options,
      showModal: false,
    };
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case 'sign-out-of-benchit':
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
