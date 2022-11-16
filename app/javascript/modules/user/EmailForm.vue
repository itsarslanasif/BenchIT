<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">{{ $t('invite.title') }}</h3>
    <label>{{ $t('invite.email') }}</label>
    <input
      v-model="userStore.user_email.email"
      type="email"
      placeholder="Email"
      required
      class="form-input-select"
    />
    <div class="btn-div">
      <button class="form-btn">{{ $t('invite.send_button') }}</button>
    </div>
  </form>
</template>

<script>
import axios from '../axios';
import { UserStore } from '../../stores/user_store.js';
import '../workspace/style.css';

export default {
  data() {
    return {
      userStore: UserStore(),
    };
  },
  methods: {
    handleSubmit() {
      axios
        .post('users/invite', this.userStore.user_email)
        .then(response => {
          return response.data;
        })
        .catch(error => {
          return error;
        });
    },
  },
};
</script>
