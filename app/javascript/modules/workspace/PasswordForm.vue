<template>
  <form @submit.prevent="handleSubmit" class="password-form">
    <h1>Set your password</h1>
    <h4>Create a password for signing in</h4>
    <label>Password</label>
    <input
      v-model="password"
      type="text"
      placeholder="Password"
      required
    />
    <div v-if="passwordError" class="error">{{ passwordError }}</div>
    <h4>
      Password must be at least 6 characters long and can't be things like
      "password", "123456" or "abcdef"
    </h4>
    <div>
      <button>Save</button>
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
      this.passwordError =
        this.password.length > 6
          ? ''
          : 'Password must be at least 6 chars long';
    },
  },
};
</script>

<style scoped>
.password-form {
  background: rgb(94, 92, 92);
  border-radius: 10px;
  margin: 30px auto;
  max-width: 500px;
  padding: 40px;
  text-align: left;
}

.error {
  color: rgb(151, 23, 23);
  font-size: 1.5em;
  font-weight: bold;
  margin-top: 10px;
}
</style>
