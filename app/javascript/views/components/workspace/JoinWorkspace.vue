<template>
  <div class="bg-primary h-screen">
    <div v-if="response" class="relative">
      <benchit-alert
        :errorMessage="response?.data?.message"
        :successMessage="response?.data?.message"
        :success="isResponseSuccess"
      />
    </div>
    <div class="flex items-center justify-center pt-10">
      <form class="max-w-md" @submit.prevent="handleSubmit">
        <h1 class="text-center text-2xl text-white">
          {{ $t('workspace.join_workspace') }}
        </h1>
        <h1 class="mb-5 text-center text-2xl text-white font-bold">
          {{ workspace_name }}
        </h1>
        <div class="flex flex-col">
          <input
            v-model="username"
            class="border rounded h-10 w-100 p-2 focus:outline-none mb-5"
            type="name"
            :placeholder="$t('workspace.username_placeholder')"
            required
          />
          <input
            v-model="description"
            class="border rounded h-10 w-100 p-2 focus:outline-none mb-8"
            type="text"
            :placeholder="$t('workspace.description_placehodler')"
            required
          />
          <button
            class="bg-success hover:bg-successHover w-full py-2 rounded text-white"
          >
            {{ $t('actions.join') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { NSpace, NAlert } from 'naive-ui';
import benchitAlert from '../../widgets/benchitAlert.vue';
import { joinWorkspace } from '../../../api/workspaces/joinWorkspace.js';
import { CONSTANTS } from '../../../assets/constants';
import { errorHandler } from '../../widgets/messageProvider';

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
      workspace_name: CONSTANTS.WORKSPACE_TITLE,
      response: '',
      workspace_id: '',
    };
  },
  mounted() {
    this.workspace_id = window.location.pathname.split('/')[2];
  },
  beforeUnmount() {
    this.username = this.description = this.response = this.workspace_id = null;
  },
  computed: {
    isResponseSuccess() {
      return this.response?.data?.message.includes(CONSTANTS.PROFILE_ADDED);
    },
  },
  methods: {
    async handleSubmit() {
      try {
        await joinWorkspace(
          this.workspace_id,
          this.username,
          this.description
        ).then(response => {
          this.response = response;
          if (response.status == 200) {
            this.$router.push('/workspace_dashboard');
          }
        });
      } catch (e) {
        errorHandler(e.response.data.message);
      }
    },
  },
};
</script>
