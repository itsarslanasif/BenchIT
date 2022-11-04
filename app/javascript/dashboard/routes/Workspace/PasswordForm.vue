<template>
  <form @submit.prevent="handleSubmit">
    <h1>Set your password</h1>
    <h4>Create a password for signing in to Slack</h4>
    <label>Password</label>
    <input v-model="password" type="text" placeholder="Password" required />
    <h4>
      Password must be at least 6 characters long and can't be things like
      "password", "123456" or "abcdef"
    </h4>
    <div class="next">
      <button>Continue to Workspace Info</button>
    </div>
  </form>
</template>

<script>
export default {
  data() {
    return {
      password: '',
      passwordError: '',
    };
  },
  methods: {
    handleSubmit() {
      this.$router.push('/app/workspace_info');
    },
  },
};
</script>
