<template>
  <div>
    <div v-show="response" class="relative">
      <benchit-alert
        :errorMessage="response"
        :successMessage="response?.data"
        :success="response.status === 200"
      />
    </div>
    <div class="flex flex-col items-center justify-center">
      <form class="max-w-md" @submit.prevent="handleSubmit">
        <h1 class="text-center text-2xl">{{ $t('workspace.join_workspace') }}</h1>
        <h1 class="mb-5 text-center text-2xl">
          <b>{{ workspace_name }}</b>
        </h1>
        <input v-model="username" type="name" :placeholder="$t('workspace.username_placeholder')" required />
        <input v-model="description" type="text" :placeholder="$t('workspace.description_placehodler')" required />
        <div>
          <button class="bg-success border-0 h-10 hover:bg-successHover text-zinc-500">
            {{ $t('actions.join') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import axios from '../../../modules/axios';
import { NSpace, NAlert } from 'naive-ui';
import benchitAlert from '../../widgets/benchitAlert.vue';
export default {
  components: {
    NSpace,
    NAlert,
    benchitAlert,
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
