<template>
  <n-modal
    v-model:show="showModal"
    class="custom-card rounded-lg w-180"
    preset="card"
    :bordered="false"
    size="huge"
  >
    <div class="mb-3" v-if="error !== null">
      <n-alert
        :show-icon="false"
        :class="
          errorAlert
            ? 'border border-red-100 bg-red-50'
            : 'border border-green-200 bg-green-100'
        "
      >
        <span>{{ getResponse }}</span>
      </n-alert>
    </div>
    <template #header
      >{{ $t('request.requesting_invitation') }}
      {{ workspace.company_name }}</template
    >
    <form @submit.prevent="handleSubmit">
      <label class="flex font-semibold">{{ $t('request.to') }}</label>
      <input
        v-model="email"
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
        class="bg-green-800 text-white mt-8 float-right border px-4 h-9 rounded-md"
      >
        {{ $t('request.send_request') }}
      </button>
    </form>
  </n-modal>
</template>

<script>
import { NModal, NAlert } from 'naive-ui';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { invite_user } from '../../api/workspaces/workspacesApi.js';
import { CONSTANTS } from '../../assets/constants.js';
import { storeToRefs } from 'pinia';

export default {
  data() {
    return {
      error: null,
      workspace: null,
      errorAlert: null,
      email: null,
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
  computed: {
    getResponse() {
      if (this.error) {
        this.alertMessage = CONSTANTS.ERROR_MESSAGE;
        this.errorAlert = true;
      } else {
        this.alertMessage = CONSTANTS.SUCCESS_MESSAGE;
        this.errorAlert = false;
      }
      return this.alertMessage;
    },
  },
  updated() {
    this.error = null;
    this.email = null;
  },
  beforeUnmount() {
    this.workspace = null;
    this.error = null;
    this.errorAlert = null;
    this.email = null;
  },
  methods: {
    async handleSubmit() {
      try {
        await invite_user(this.workspace.id, this.email).then(response => {
          this.error = false;
        });
      } catch (e) {
        this.error = true;
      }
      this.email = null;
    },
  },
};
</script>
