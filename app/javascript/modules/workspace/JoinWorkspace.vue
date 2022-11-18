<template>
  <div v-show="response" class="relative">
    <div class="absolute top-0 right-0 mr-4">
      <n-space vertical :size="12">
        <n-alert v-if="response.status === 200" title="Success" type="success">
          {{ response.data }}
        </n-alert>
        <n-alert v-else title="Error" type="error">
          {{ response }}
        </n-alert>
      </n-space>
    </div>
  </div>
  <div class="flex flex-col items-center justify-center">
    <form class="max-w-md" @submit.prevent="handleSubmit">
      <h1 class="text-center text-2xl">Join Workspace</h1>
      <h1 class="mb-5 text-center text-2xl">
        <b>{{ workspace_name }}</b>
      </h1>
      <input v-model="username" type="name" placeholder="Username" required />
      <input
        v-model="description"
        type="text"
        placeholder="Description"
        required
      />
      <div>
        <button
          class="bg-green-900 border-0 h-10 hover:bg-green-800 text-zinc-500"
        >
          Join
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from '../axios';
import { NSpace, NAlert } from 'naive-ui';
export default {
  components: {
    NSpace,
    NAlert,
  },
  data() {
    return {
      username: '',
      description: '',
      workspace_name: 'Devsinc',
      response: '',
      workspace_id: '',
    };
  },
  mounted() {
    this.workspace_id = window.location.pathname.split('/')[2];
  },
  methods: {
    handleSubmit() {
      axios
        .post(
          `api/workspaces/${this.workspace_id}/profiles`,

          {
            username: this.username,
            description: this.description,
            workspace_id: this.workspace_id,
          }
        )
        .then(response => {
          this.response = response;
        })
        .catch(error => {
          this.response = error;
        });
    },
  },
};
</script>
