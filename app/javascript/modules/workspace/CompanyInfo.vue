<template>
  <div>
    <h4 class="form-h">What's your company called?</h4>
    <label>Company name</label>
    <input
      v-model="workspaceStore.workspace.company_name"
      type="text"
      class="form-input-select"
      placeholder="Ex. Acme or Acme Marketing"
      required
    />
    <p class="form-h">
      We'll use this to name your workspace, which you can always change later.
    </p>
  </div>
</template>

<script>
import { WorkspaceStore } from '../../stores/workspace_store';
import './style.css';

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
};
</script>
