<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">Requesting invitations to BenchIT</h3>
    <label>To:</label>
    <input
      v-model="userStore.workspace_invite.email"
      type="email"
      placeholder="Email"
      required
      class="form-input-select"
    />
    <label>Reason for request(optional)</label>
    <input
      type="text"
      placeholder="Add a note for your admin"
      class="form-input-select"
    />
    <div class="btn-div">
      <button class="form-btn">Send Request</button>
    </div>
  </form>
</template>

<script>
// import axios from '../axios';
import { UserStore } from '../../stores/user_store.js';
import '../../modules/workspace/style.css';

export default {
  data() {
    return {
      userStore: UserStore(),
    };
  },
  methods: {
    handleSubmit() {
      axios
        .post('users/invitation', this.userStore.user_email)
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
