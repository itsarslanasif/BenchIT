<template>
  <form
    class="bg-slate-50 rounded-md mx-auto my-6 form text-left p-10"
    @submit.prevent="handleSubmit()"
  >
    <WorkspaceInfo v-if="workspaceStore.activePhase === 1" />
    <CompanyInfo v-else-if="workspaceStore.activePhase === 2" />
    <WorkspaceURL v-else-if="workspaceStore.activePhase === 3" />
    <div class="btn-div">
      <button
        v-if="workspaceStore.activePhase === 1"
        class="bg-slate-50 px-4 py-2 mt-5 border-0"
      >
        {{ $t('workspaces.continue_company_button') }}
      </button>
      <button
        v-else-if="workspaceStore.activePhase === 2"
        class="bg-slate-50 px-4 py-2 mt-5 border-0"
      >
        {{ $t('company.continue_url_button') }}
      </button>
      <button
        v-else-if="workspaceStore.activePhase === 3"
        class="bg-slate-50 px-4 py-2 mt-5 border-0"
      >
        {{ $t('url.create_workspace_button') }}
      </button>
    </div>
  </form>
</template>

<script>
import WorkspaceInfo from './WorkspaceInfo.vue';
import CompanyInfo from './CompanyInfo.vue';
import WorkspaceURL from './WorkspaceURL.vue';
import { WorkspaceStore } from '../../../stores/workspace_store';
import { createWorkspace } from '../../../api/workspaces/workspacesApi';
import './style.css';
import { errorHandler } from '../../widgets/messageProvider';

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
  methods: {
    async handleSubmit() {
      try {
        if (this.workspaceStore.activePhase === 3) {
          await createWorkspace(this.workspaceStore.workspace);
        } else if (
          this.workspaceStore.workspace.capacity <= 0 ||
          this.workspaceStore.workspace.capacity > 5000
        ) {
          this.workspaceStore.capacityError =
            'Members should be greter than 0 and less than 5000';
        } else {
          this.workspaceStore.activePhase += 1;
          this.workspaceStore.capacityError = '';
        }
      } catch (e) {
        errorHandler(e.response.data.message);
      }
    },
  },
  components: {
    WorkspaceInfo,
    CompanyInfo,
    WorkspaceURL,
  },
};
</script>
