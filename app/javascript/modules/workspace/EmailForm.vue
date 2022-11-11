<template>
  <form @submit.prevent="handleSubmit" class='email-form'>
    <h1>What's your email?</h1>
    <label>Email</label>
    <input v-model="user.email" type="email" placeholder="Email" required />
    <div>
      <button>Send Invitation</button>
    </div>
  </form>
</template>

<script>
import axios from './axios';
export default {
  data() {
    return {
      user: {
        email: '',
      },
    };
  },
  methods: {
    handleSubmit() {
      axios
        .post('users/invitation', this.user)
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

<style scoped>
.email-form {
  background: rgb(94, 92, 92);
  border-radius: 10px;
  margin: 30px auto;
  max-width: 500px;
  padding: 40px;
  text-align: left;
}
</style>
