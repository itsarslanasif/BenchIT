<template>
  <form class="form" @submit.prevent="handleSubmit()">
    <WorkspaceInfo v-if="workspaceStore.activePhase === 1" />
    <CompanyInfo v-else-if="workspaceStore.activePhase === 2" />
    <WorkspaceURL v-else-if="workspaceStore.activePhase === 3" />
    <div class="btn-div">
      <button v-if="workspaceStore.activePhase === 1" class="form-btn">
        {{ $t('workspaces.continue_company_button') }}
      </button>
      <button v-else-if="workspaceStore.activePhase === 2" class="form-btn">
        {{ $t('company.continue_url_button') }}
      </button>
      <button v-else-if="workspaceStore.activePhase === 3" class="form-btn">
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

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
  methods: {
    async handleSubmit() {
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
    },
  },
  components: {
    WorkspaceInfo,
    CompanyInfo,
    WorkspaceURL,
  },
};
</script>
