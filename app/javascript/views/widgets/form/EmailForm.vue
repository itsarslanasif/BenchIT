<template>
  <form
    @submit.prevent="handleSubmit"
    class="bg-slate-50 rounded-xl my-8 mx-auto text-left p-64"
  >
    <h3>{{ $t('invite.title') }}</h3>
    <label>{{ $t('invite.email') }}</label>
    <input
      v-model="userStore.user_email.email"
      type="email"
      placeholder="Email"
      required
      class="border"
    />
    <div class="flex justify-center">
      <button class="border-0 mt-5 py-3 px-5 w-3/4">
        {{ $t('invite.send_button') }}
      </button>
    </div>
  </form>
</template>

<script>
import axios from '../../../modules/axios';
import { useUserInviteStore } from '../../../stores/useUserInviteStore.js';
import '../../components/workspace/style.css';

export default {
  data() {
    return {
      userStore: useUserInviteStore(),
    };
  },
  methods: {
    handleSubmit() {
      axios
        .post('users/invitation', this.userStore.user_email)
        .then(response => {
          return response.data;
        })
        .catch(e => {
          return e;
        });
    },
  },
};
</script>
