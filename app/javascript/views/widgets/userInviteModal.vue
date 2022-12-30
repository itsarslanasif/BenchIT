<template>
  <n-modal
    v-model:show="showModal"
    class="custom-card rounded-lg w-180"
    preset="card"
    :bordered="false"
    size="huge"
  >
    <div class="mb-3" v-if="errorMessage">
      <n-alert type="error">
        <span>{{ $t('request.error_message') }}</span>
      </n-alert>
    </div>
    <div class="mb-3" v-if="successMessage">
      <n-alert type="success">
        <span>{{ $t('request.success_message') }}</span>
      </n-alert>
    </div>
    <template #header
      >{{ $t('request.requesting_invitation') }}
      {{ workspace.company_name }}</template
    >
    <form @submit.prevent="handleSubmit">
      <label class="flex font-semibold">{{ $t('request.to') }}</label>
      <input
        v-model="userStore.workspace_invite.email"
        type="email"
        :placeholder="$t('placeholder.email')"
        required
        class="border border-black-400 rounded w-150 h-12 text-black-900 mt-2 p-3"
      />
      <label class="flex mt-6 font-semibold">{{
        $t('request.reason_for_request')
      }}</label>
      <input
        type="text"
        :placeholder="$t('request.request_reason_placeholder')"
        class="border border-black-400 rounded w-150 text-black-900 mt-2 h-12 p-3"
      />
      <button
        class="bg-green-800 text-white mt-8 float-right border w-20 h-9 rounded-md"
      >
        {{ $t('request.send_request') }}
      </button>
    </form>
  </n-modal>
</template>

<script>
import { NModal, NAlert } from 'naive-ui';
import { useUserInviteStore } from '../../stores/useUserInviteStore.js';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { invite_user } from '../../api/workspaces/workspacesApi.js';
import { storeToRefs } from 'pinia';

export default {
  data() {
    return {
      userStore: useUserInviteStore(),
      errorMessage: false,
      successMessage: false,
      workspace: null,
    };
  },
  components: {
    NModal,
    NAlert,
  },
  setup() {
    const workspaceStore = useCurrentWorkspaceStore();
    const { currentWorkspace } = storeToRefs(workspaceStore);
    return {
      workspace: currentWorkspace,
    };
  },
  updated() {
    this.errorMessage = false;
    this.successMessage = false;
  },
  methods: {
    async handleSubmit() {
      await invite_user(
        this.workspace.id,
        this.userStore.workspace_invite
      ).then(
        response => {
          this.successMessage = true;
          this.errorMessage = false;
        },
        error => {
          this.errorMessage = true;
          this.successMessage = false;
        }
      );
      this.userStore.workspace_invite.email = null;
    },
  },
};
</script>
