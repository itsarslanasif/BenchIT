<template>
  <form class="form" @submit.prevent="handleSubmit()">
    <WorkspaceInfo v-if="workspaceStore.activePhase === 1" />
    <CompanyInfo v-else-if="workspaceStore.activePhase === 2" />
    <WorkspaceURL v-else-if="workspaceStore.activePhase === 3" />
    <div class="btn-div">
      <button v-if="workspaceStore.activePhase === 1" class="form-btn">
        Continue to Company Name
      </button>
      <button v-else-if="workspaceStore.activePhase === 2" class="form-btn">
        Continue to Workspace URL
      </button>
      <button v-else-if="workspaceStore.activePhase === 3" class="form-btn">
        Create Workspace
      </button>
    </div>
  </form>
</template>

<script>
import axios from './axios';
import WorkspaceInfo from './WorkspaceInfo.vue';
import CompanyInfo from './CompanyInfo.vue';
import WorkspaceURL from './WorkspaceURL.vue';
import { WorkspaceStore } from '../../stores/workspace_store';
import './style.css';
export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
  methods: {
    handleSubmit() {
      if (this.workspaceStore.activePhase === 3) {
        axios
          .post('api/workspaces', this.workspaceStore.workspace)
          .then(response => {
            return response.data;
          })
          .catch(error => {
            return error;
          });
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



