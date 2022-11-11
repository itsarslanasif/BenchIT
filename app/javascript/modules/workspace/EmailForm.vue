<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">What's your email?</h3>
    <label>Email</label>
    <input
      v-model="email"
      type="email"
      placeholder="Email"
      required
      class="form-input-select"
    />
    <div class="btn-div">
      <button class="form-btn">Send Invitation</button>
    </div>
  </form>
</template>

<script>
import './style.css';
import axios from './axios';
export default {
  data() {
    return {
     email: ''
    };
  },
  methods: {
    handleSubmit() {
      axios
        .post('users/invitation', this.email)
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
