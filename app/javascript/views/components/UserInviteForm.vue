<template>
  <form @submit.prevent="handleSubmit" class="form">
    <h3 class="form-h3">Requesting invitations to BenchIT</h3>
    <label>To</label>
     <br>
    <input
      v-model="userStore.workspace_invite.email"
      type="email"
      placeholder="Email"
      required
      class="form-input-select"
    />
    <br>
    <label>Reason for request (optional)</label>
     <br>
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
import axios from '../../modules/axios';
import { UserStore } from '../../stores/user_store.js';

export default {
  name: 'UserInviteForm',
  data() {
    return {
      userStore: UserStore(),
    };
  },
  methods: {
    handleSubmit() {
      axios
        .post(
          `api/workspaces/${this.$route.params.id}/invite`,
          this.userStore.workspace_invite
        )
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
.form {
  background-color: white;
  border-radius: 10px;
  color: black;
  font-family: 'inherit';
  margin: 30px auto;
  max-width: 500px;
  opacity: 1;
  padding: 40px;
  position: fixed;
  text-align: left;
  width: 800px;
  z-index: 1;
}

.form-input-select {
  background-color: rgb(208, 202, 202);
  border: 1px solid black;
  color: black;
  width: 400px;
}
</style>
