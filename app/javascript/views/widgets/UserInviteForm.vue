<template>
  <div class="fixed top-0 bottom-0 right-0 left-0 bg-backgroundTransparent flex justify-center items-center z-10">
    <form class="bg-slate-50 rounded-md my-8 mx-auto opacity-100 p-10 fixed text-left w-2/4 z-10" @submit.prevent="handleSubmit">
      <button type="button" class="border-0 cursor-pointer text-base w-12 m-0 p-0 right-0 bg-backgroundTransparent" @click="closeModal">x</button>
      <h3>{{ $t(CONSTANTS.REQUESTING_INVITATION) }}</h3>
      <label>{{ $t(CONSTANTS.TO) }}</label>
      <input v-model="userStore.workspace_invite.email" type="email" placeholder="Email" required      
        class="bg-slate-50 border border-primary w-auto text-black-900" />
      <label>{{ $t(CONSTANTS.REASON_FOR_REQUEST) }}</label>
      <input type="text" placeholder="Add a note for your admin" class="bg-slate-50 border border-primary w-auto text-black-900" />
      <div>
        <button>{{ $t(CONSTANTS.SEND_REQUEST) }}</button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from '../../modules/axios';
import { UserStore } from '../../stores/user_store.js';
import { CONSTANTS } from '../../assets/constants';
export default {
  name: 'UserInviteForm',
  props: ['closeModal'],
  data() {
    return {
      userStore: UserStore(),
      CONSTANTS: CONSTANTS,
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

.form-background {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.3);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1;
}
</style>
