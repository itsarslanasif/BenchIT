<template>
  <form @submit.prevent="handleSubmit" class="bg-slate-50 rounded-xl my-8 mx-auto text-left p-64">
    <h3>{{ $t('confirmation.title') }}</h3>
    <label>{{ $t('confirmation.password') }}</label>
    <input
      v-model="userStore.user_password.password"
      class="border"
      type="password"
      placeholder="Password"
      required
    />
    <div v-if="userStore.passwordError" class="text-danger font-bold mt-2 text-sm">
      {{ userStore.passwordError }}
    </div>
    <p>{{ $t('confirmation.description') }}</p>
    <label>{{ $t('confirmation.confirm_password') }}</label>
    <input
      v-model="userStore.user_password.password_confirmation"
      class="border"
      type="password"
      placeholder="Confirm Password"
      required
    />
    <div v-if="userStore.confirmPasswordError" class="error">
      {{ userStore.confirmPasswordError }}
    </div>
    <div class="flex justify-center">
      <button class="border-0 mt-5 py-3 px-5 w-3/4">{{ $t('confirmation.password_save') }}</button>
    </div>
  </form>
</template>

<script>
import axios from '../../../modules/axios';
import { UserStore } from '../../../stores/user_store.js';
import '../../components/workspace/style.css'

export default {
  data() {
    return {
      userStore: UserStore(),
    };
  },
  methods: {
    handleSubmit() {
      if (
        this.userStore.user_password.password ===
        this.userStore.user_password.password_confirmation
      ) {
        (this.userStore.confirmPasswordError = ''),
          (this.userStore.user_password.invitation_token =
            this.$route.query.invitation_token),
          axios
            .patch('users/invitation', this.userStore.user_password)
            .then(response => {
              return response.data;
            })
            .catch(error => {
              return error;
            });
        this.$router.push('/workspace_dashboard');
      } else {
        this.userStore.confirmPasswordError = 'Passwords do not match';
      }
    },
  },
};
</script>
